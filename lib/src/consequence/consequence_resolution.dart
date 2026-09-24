import 'consequence.dart';

class ConsequenceResolutionDecision {
  const ConsequenceResolutionDecision({required this.proposal, required this.accepted, this.reason = ''});
  final ConsequenceProposal proposal;
  final bool accepted;
  final String reason;

  Map<String, Object?> toJson() => {
        'proposalId': proposal.id,
        'ruleId': proposal.ruleId,
        'accepted': accepted,
        if (reason.isNotEmpty) 'reason': reason,
      };
}

class ConsequenceResolution {
  const ConsequenceResolution(this.decisions);
  final List<ConsequenceResolutionDecision> decisions;

  List<ConsequenceProposal> get accepted =>
      List.unmodifiable(decisions.where((d) => d.accepted).map((d) => d.proposal));

  List<ConsequenceProposal> get rejected =>
      List.unmodifiable(decisions.where((d) => !d.accepted).map((d) => d.proposal));

  Map<String, Object?> toJson() => {
        'decisions': decisions.map((d) => d.toJson()).toList(growable: false),
      };
}

/// Resolves proposals without mutating authoritative state.
///
/// Ordering is deterministic: priority descending, then rule id, then proposal id.
/// This makes dry-runs and replays stable across processes.
class ConsequenceResolver {
  const ConsequenceResolver();

  ConsequenceResolution resolve(Iterable<ConsequenceProposal> proposals) {
    final ordered = proposals.toList(growable: false)
      ..sort((a, b) {
        final priority = b.priority.compareTo(a.priority);
        if (priority != 0) return priority;
        final rule = a.ruleId.compareTo(b.ruleId);
        if (rule != 0) return rule;
        return a.id.compareTo(b.id);
      });

    final winners = <String, ConsequenceProposal>{};
    final decisions = <ConsequenceResolutionDecision>[];
    for (final proposal in ordered) {
      final key = _key(proposal);
      if (proposal.conflictPolicy == ConsequenceConflictPolicy.additive || key == null) {
        decisions.add(ConsequenceResolutionDecision(proposal: proposal, accepted: true));
        continue;
      }
      final winner = winners[key];
      if (winner == null) {
        winners[key] = proposal;
        decisions.add(ConsequenceResolutionDecision(proposal: proposal, accepted: true));
      } else {
        decisions.add(ConsequenceResolutionDecision(
          proposal: proposal,
          accepted: false,
          reason: proposal.conflictPolicy == ConsequenceConflictPolicy.rejectDuplicate
              ? 'conflict_duplicate'
              : 'conflict_lower_priority',
        ));
      }
    }
    return ConsequenceResolution(List.unmodifiable(decisions));
  }

  String? _key(ConsequenceProposal proposal) {
    if (proposal.conflictKey != null && proposal.conflictKey!.isNotEmpty) return proposal.conflictKey;
    final payload = proposal.payload;
    final identity = payload['key'] ?? payload['factionId'] ?? payload['characterId'] ?? payload['flag'];
    if (identity == null) return proposal.type;
    return '${proposal.type}:$identity';
  }
}
