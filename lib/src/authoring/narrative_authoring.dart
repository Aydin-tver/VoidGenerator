class NarrativeAuthoringContract {
  const NarrativeAuthoringContract({
    required this.schemaVersion,
    required this.contractVersion,
    required this.contentId,
    required this.storyId,
    required this.namespace,
    required this.version,
    required this.owner,
    required this.sourcePath,
    required this.nodeIdPrefix,
    required this.choiceIdPrefix,
    required this.localizationKeys,
    required this.eventDependencies,
    required this.consequenceDependencies,
    this.narrativeDependencies = const [],
  });

  final int schemaVersion;
  final int contractVersion;
  final String contentId;
  final String storyId;
  final String namespace;
  final int version;
  final String owner;
  final String sourcePath;
  final String nodeIdPrefix;
  final String choiceIdPrefix;
  final List<String> localizationKeys;
  final List<String> eventDependencies;
  final List<String> consequenceDependencies;
  final List<String> narrativeDependencies;

  Map<String, Object?> toJson() => {
    'schemaVersion': schemaVersion,
    'contractVersion': contractVersion,
    'contentId': contentId,
    'storyId': storyId,
    'namespace': namespace,
    'version': version,
    'owner': {'agentId': owner},
    'source': {'path': sourcePath},
    'stableIds': {'nodePrefix': nodeIdPrefix, 'choicePrefix': choiceIdPrefix},
    'localization': {'keys': localizationKeys},
    'dependencies': {
      'events': eventDependencies,
      'consequences': consequenceDependencies,
      'narratives': narrativeDependencies,
    },
  };
}

class NarrativeAuthoringContractLoader {
  const NarrativeAuthoringContractLoader();

  NarrativeAuthoringContract load(Map<String, dynamic> json) {
    final owner = Map<String, dynamic>.from((json['owner'] as Map?) ?? const {});
    final source = Map<String, dynamic>.from((json['source'] as Map?) ?? const {});
    final ids = Map<String, dynamic>.from((json['stableIds'] as Map?) ?? const {});
    final localization = Map<String, dynamic>.from((json['localization'] as Map?) ?? const {});
    final dependencies = Map<String, dynamic>.from((json['dependencies'] as Map?) ?? const {});
    List<String> strings(Object? value) => ((value as List?) ?? const []).cast<String>();
    return NarrativeAuthoringContract(
      schemaVersion: (json['schemaVersion'] as num?)?.toInt() ?? 0,
      contractVersion: (json['contractVersion'] as num?)?.toInt() ?? 0,
      contentId: json['contentId'] as String? ?? '',
      storyId: json['storyId'] as String? ?? '',
      namespace: json['namespace'] as String? ?? '',
      version: (json['version'] as num?)?.toInt() ?? 0,
      owner: owner['agentId'] as String? ?? '',
      sourcePath: source['path'] as String? ?? '',
      nodeIdPrefix: ids['nodePrefix'] as String? ?? '',
      choiceIdPrefix: ids['choicePrefix'] as String? ?? '',
      localizationKeys: strings(localization['keys']),
      eventDependencies: strings(dependencies['events']),
      consequenceDependencies: strings(dependencies['consequences']),
      narrativeDependencies: strings(dependencies['narratives']),
    );
  }
}
