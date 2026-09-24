abstract interface class SnapshotStore<T> {
  void save(T snapshot);
  T? load(String aggregateId);
  void remove(String aggregateId);
}

class InMemorySnapshotStore<T> implements SnapshotStore<T> {
  final Map<String, T> _snapshots = {};
  final String Function(T snapshot) aggregateId;

  InMemorySnapshotStore({required this.aggregateId});

  @override
  void save(T snapshot) => _snapshots[aggregateId(snapshot)] = snapshot;

  @override
  T? load(String aggregateId) => _snapshots[aggregateId];

  @override
  void remove(String aggregateId) => _snapshots.remove(aggregateId);
}
