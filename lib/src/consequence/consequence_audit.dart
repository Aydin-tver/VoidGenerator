import 'dart:convert';

import '../event.dart';
import 'consequence.dart';
import 'consequence_resolution.dart';

/// Lifecycle stage captured by the consequence audit trail.
enum ConsequenceAuditStage { proposed, resolved, applied }

/// Immutable, append-only explanation of one consequence proposal lifecycle.
/// The audit record is diagnostic history; it does not mutate authoritative state.
class ConsequenceAuditEntry {
  const ConsequenceAuditEntry({
    required this.auditId,
    required this.sequence,
    required this.runtimeVersion,
    required this.stage,
    required this.proposal,
    required this.accepted,
    this.reason = '',
    this.applied = false,
    this.eventSequence,
    this.recordedAt,
  });

  final String auditId;
  final int sequence;
  final String runtimeVersion;
  final ConsequenceAuditStage stage;
  final ConsequenceProposal proposal;
  final bool accepted;
  final String reason;
  final bool applied;
  final int? eventSequence;
  final DateTime? recordedAt;

  Map<String, Object?> toJson() => {
        'auditId': auditId,
        'sequence': sequence,
        'runtimeVersion': runtimeVersion,
        'stage': stage.name,
        'eventSequence': eventSequence,
        'eventId': proposal.event.id,
        'eventType': proposal.event.type,
        'proposal': proposal.toJson(),
        'accepted': accepted,
        if (reason.isNotEmpty) 'reason': reason,
        'applied': applied,
        'recordedAt': recordedAt?.toIso8601String(),
      };

  String toJsonLine() => jsonEncode(toJson());
}

abstract interface class ConsequenceAuditJournal {
  ConsequenceAuditEntry append(ConsequenceAuditEntry entry);
  List<ConsequenceAuditEntry> read({int? afterSequence, int? beforeOrAtSequence});
  List<ConsequenceAuditEntry> readForEvent(String eventId);
  List<ConsequenceAuditEntry> readForProposal(String proposalId);
  ConsequenceAuditEntry? byId(String auditId);
  int get latestSequence;
  int get length;
}

class InMemoryConsequenceAuditJournal implements ConsequenceAuditJournal {
  final List<ConsequenceAuditEntry> _entries = [];
  final Set<String> _ids = {};
  int _nextSequence = 1;

  @override
  ConsequenceAuditEntry append(ConsequenceAuditEntry entry) {
    final existing = byId(entry.auditId);
    if (existing != null) return existing;
    final persisted = _withSequence(entry, _nextSequence);
    _entries.add(persisted);
    _ids.add(persisted.auditId);
    _nextSequence++;
    return persisted;
  }

  @override
  List<ConsequenceAuditEntry> read({int? afterSequence, int? beforeOrAtSequence}) =>
      List.unmodifiable(_entries.where((entry) =>
          (afterSequence == null || entry.sequence > afterSequence) &&
          (beforeOrAtSequence == null || entry.sequence <= beforeOrAtSequence)));

  @override
  List<ConsequenceAuditEntry> readForEvent(String eventId) =>
      List.unmodifiable(_entries.where((entry) => entry.proposal.event.id == eventId));

  @override
  List<ConsequenceAuditEntry> readForProposal(String proposalId) =>
      List.unmodifiable(_entries.where((entry) => entry.proposal.id == proposalId));

  @override
  ConsequenceAuditEntry? byId(String auditId) => _entries.where((e) => e.auditId == auditId).firstOrNull;

  @override
  int get latestSequence => _nextSequence - 1;

  @override
  int get length => _entries.length;

  static ConsequenceAuditEntry _withSequence(ConsequenceAuditEntry entry, int sequence) => ConsequenceAuditEntry(
        auditId: entry.auditId,
        sequence: sequence,
        runtimeVersion: entry.runtimeVersion,
        stage: entry.stage,
        proposal: entry.proposal,
        accepted: entry.accepted,
        reason: entry.reason,
        applied: entry.applied,
        eventSequence: entry.eventSequence,
        recordedAt: entry.recordedAt,
      );
}

/// JSON-lines persistence adapter for audit tooling and deterministic diagnostics.
class JsonLinesConsequenceAuditJournal implements ConsequenceAuditJournal {
  JsonLinesConsequenceAuditJournal(this._lines);

  final List<String> _lines;
  final List<ConsequenceAuditEntry> _entries = [];
  final Set<String> _ids = {};
  int _nextSequence = 1;

  void load(ConsequenceAuditEntry Function(Map<String, dynamic>) decoder) {
    _entries.clear();
    _ids.clear();
    _nextSequence = 1;
    for (final line in _lines.where((line) => line.trim().isNotEmpty)) {
      final entry = decoder(jsonDecode(line) as Map<String, dynamic>);
      if (entry.sequence != _nextSequence) {
        throw StateError('Audit sequence is not contiguous at ${entry.auditId}');
      }
      if (!_ids.add(entry.auditId)) throw StateError('Duplicate audit id: ${entry.auditId}');
      _entries.add(entry);
      _nextSequence++;
    }
  }

  @override
  ConsequenceAuditEntry append(ConsequenceAuditEntry entry) {
    final existing = byId(entry.auditId);
    if (existing != null) return existing;
    final persisted = InMemoryConsequenceAuditJournal._withSequence(entry, _nextSequence);
    _lines.add(persisted.toJsonLine());
    _entries.add(persisted);
    _ids.add(persisted.auditId);
    _nextSequence++;
    return persisted;
  }

  @override
  List<ConsequenceAuditEntry> read({int? afterSequence, int? beforeOrAtSequence}) =>
      List.unmodifiable(_entries.where((entry) =>
          (afterSequence == null || entry.sequence > afterSequence) &&
          (beforeOrAtSequence == null || entry.sequence <= beforeOrAtSequence)));

  @override
  List<ConsequenceAuditEntry> readForEvent(String eventId) =>
      List.unmodifiable(_entries.where((entry) => entry.proposal.event.id == eventId));

  @override
  List<ConsequenceAuditEntry> readForProposal(String proposalId) =>
      List.unmodifiable(_entries.where((entry) => entry.proposal.id == proposalId));

  @override
  ConsequenceAuditEntry? byId(String auditId) => _entries.where((e) => e.auditId == auditId).firstOrNull;

  @override
  int get latestSequence => _nextSequence - 1;

  @override
  int get length => _entries.length;
}

/// Creates deterministic audit records from proposal/resolution information.
class ConsequenceAuditRecorder {
  const ConsequenceAuditRecorder({required this.journal, required this.runtimeVersion});

  final ConsequenceAuditJournal journal;
  final String runtimeVersion;

  ConsequenceAuditEntry recordProposal(ConsequenceProposal proposal) => journal.append(
        ConsequenceAuditEntry(
          auditId: _id(proposal, ConsequenceAuditStage.proposed),
          sequence: 0,
          runtimeVersion: runtimeVersion,
          stage: ConsequenceAuditStage.proposed,
          proposal: proposal,
          accepted: true,
          eventSequence: proposal.event.sequence,
        ),
      );

  ConsequenceAuditEntry recordResolution(ConsequenceResolutionDecision decision) => journal.append(
        ConsequenceAuditEntry(
          auditId: _id(decision.proposal, ConsequenceAuditStage.resolved),
          sequence: 0,
          runtimeVersion: runtimeVersion,
          stage: ConsequenceAuditStage.resolved,
          proposal: decision.proposal,
          accepted: decision.accepted,
          reason: decision.reason,
          eventSequence: decision.proposal.event.sequence,
        ),
      );

  ConsequenceAuditEntry recordApplied(ConsequenceProposal proposal) => journal.append(
        ConsequenceAuditEntry(
          auditId: _id(proposal, ConsequenceAuditStage.applied),
          sequence: 0,
          runtimeVersion: runtimeVersion,
          stage: ConsequenceAuditStage.applied,
          proposal: proposal,
          accepted: true,
          applied: true,
          eventSequence: proposal.event.sequence,
        ),
      );

  static String _id(ConsequenceProposal proposal, ConsequenceAuditStage stage) =>
      '${proposal.event.id}:${proposal.ruleId}:${proposal.id}:${stage.name}';
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
