import 'consequence.dart';

/// Host-owned example sink for deterministic tests. Real Wanderers integration
/// should implement ConsequenceSink against WorldState/FactionState/etc.
class InMemoryConsequenceState implements ConsequenceSink {
  final Map<String, num> numeric = {};
  final List<ConsequenceProposal> applied = [];

  @override
  void apply(ConsequenceProposal proposal) {
    applied.add(proposal);
    final key = proposal.payload['key']?.toString();
    final delta = proposal.payload['delta'];
    if (proposal.type == 'world.consequence' && key != null && delta is num) {
      numeric[key] = (numeric[key] ?? 0) + delta;
    }
  }
}
