import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'package:void_event_engine/void_event_engine.dart';

NarrativeDefinition _loadStory(String path) {
  final raw = jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;
  return NarrativeJsonLoader().load(Map<String, dynamic>.from(raw['narrative'] as Map));
}

NarrativeSimulationResult _run(String path, List<String> choices) {
  final definition = _loadStory(path);
  final result = NarrativeSimulator().followChoices(definition, choices);
  expect(result.completed, isTrue, reason: '$path must complete via $choices');
  return result;
}

void main() {
  const stories = 'stories/act_01';

  test('golden: speedrun mainline reaches all 7 stages', () {
    final stages = <NarrativeSimulationResult>[
      _run('$stories/solaris/route.json', ['act01.solaris.route.choice.follow', 'act01.solaris.route.choice.record']),
      _run('$stories/solaris/corridor.json', ['act01.solaris.corridor.choice.trust_registry', 'act01.solaris.corridor.choice.save_coordinates']),
      _run('$stories/solaris/packet.json', ['act01.solaris.packet.choice.reply']),
      _run('$stories/solaris/mining.json', ['act01.solaris.mining.choice.give_tidari', 'act01.solaris.mining.choice.save_mark']),
      _run('$stories/solaris/impulse.json', ['act01.solaris.impulse.choice.answer']),
      _run('$stories/ferum/mine.json', ['act01.ferum.mine.choice.save_ore', 'act01.ferum.mine.choice.conceal']),
      _run('$stories/nova/karmacore.json', ['act01.nova.karmacore.choice.check_exception', 'act01.nova.karmacore.choice.honest_answer']),
    ];
    expect(stages.map((r) => r.consequences.where((c) => c == 'story.stage').length).reduce((a, b) => a + b), 7);
    expect(stages[6].consequences.where((c) => c == 'evidence.add').length, 2, reason: 'thread_reply on reply node + sigma_architecture on honest answer');
  });

  test('golden: industrial compromise route keeps self-preservation path', () {
    final route = _run('$stories/solaris/route.json', ['act01.solaris.route.choice.follow', 'act01.solaris.route.choice.erase']);
    final mine = _run('$stories/ferum/mine.json', ['act01.ferum.mine.choice.save_ore', 'act01.ferum.mine.choice.conceal']);
    expect(mine.consequences, contains('evidence.add'), reason: 'evidence_nexite_thread path');
    expect(route.consequences.where((c) => c == 'trait.add').length, 1, reason: 'erase is the self-preservation trait point');
  });

  test('golden: thread guardian needs evidence via mine and sera concealment', () {
    final mine = _run('$stories/ferum/mine.json', ['act01.ferum.mine.choice.save_ore', 'act01.ferum.mine.choice.conceal']);
    final sera = _run('$stories/haven/char_sera.json', ['act01.haven.char_sera.choice.conceal_identity']);
    expect(mine.consequences, contains('evidence.add'));
    expect(sera.consequences, containsAll(['story.flag', 'evidence.add']));
  });

  test('golden: kairos without registry needs autonomy route and sera flag', () {
    final route = _run('$stories/solaris/route.json', ['act01.solaris.route.choice.deviate', 'act01.solaris.route.choice.record']);
    final sera = _run('$stories/haven/char_sera.json', ['act01.haven.char_sera.choice.conceal_identity']);
    expect(route.consequences.where((c) => c == 'trait.add').length, 2, reason: 'deviate autonomy + record curiosity');
    expect(sera.consequences, contains('story.flag'), reason: 'zazor_identity_protected');
  });

  test('golden: sigma contour requires full sigma line and honest answer', () {
    final sigma = [
      _run('$stories/solaris/sigma_01.json', ['act01.solaris.sigma_01.choice.open_channel']),
      _run('$stories/nova/sigma_02.json', ['act01.nova.sigma_02.choice.probe_protocol']),
      _run('$stories/solaris/sigma_03.json', ['act01.solaris.sigma_03.choice.deep_scan']),
      _run('$stories/nova/sigma_04.json', ['act01.nova.sigma_04.choice.share_logs']),
      _run('$stories/haven/sigma_05.json', ['act01.haven.sigma_05.choice.close_loop']),
    ];
    final karmacore = _run('$stories/nova/karmacore.json', ['act01.nova.karmacore.choice.check_exception', 'act01.nova.karmacore.choice.honest_answer']);
    expect(sigma.map((r) => r.consequences.where((c) => c == 'story.stage').length).reduce((a, b) => a + b), 5);
    expect(karmacore.consequences.where((c) => c == 'evidence.add').length, 2);
  });

  test('golden: unknown answer is reachable through sera and any karmacore finale', () {
    final sera = _run('$stories/haven/char_sera.json', ['act01.haven.char_sera.choice.conceal_identity']);
    final karmacore = _run('$stories/nova/karmacore.json', ['act01.nova.karmacore.choice.follow_protocol', 'act01.nova.karmacore.choice.no_answer']);
    expect(sera.consequences, containsAll(['story.flag', 'evidence.add']));
    expect(karmacore.consequences, contains('evidence.add'), reason: 'thread_reply is emitted for both finials');
  });
}
