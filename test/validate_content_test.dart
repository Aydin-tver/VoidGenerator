import 'dart:io';

import 'package:test/test.dart';
import '../bin/validate_content.dart' as v;

late Directory valid;
late Directory broken;

void write(String root, String file, String content) {
  final f = File('$root/$file')..createSync(recursive: true);
  f.writeAsStringSync(content);
}

void deleteTemp(Directory d) {
  for (var i = 0; i < 5; i++) {
    try {
      d.deleteSync(recursive: true);
      return;
    } on FileSystemException {
      sleep(const Duration(milliseconds: 50));
    }
  }
}

void main() {
  setUpAll(() {
    valid = Directory.systemTemp.createTempSync('vc_valid');
    broken = Directory.systemTemp.createTempSync('vc_broken');
  });
  tearDownAll(() {
    deleteTemp(valid);
    deleteTemp(broken);
  });

  test('valid content passes', () {
    write(valid.path, 'quest_ok.json', _validQuest);
    write(valid.path, 'encounter_ok.json', _validEncounter);
    write(valid.path, 'location_ok.json', _validLocation);
    final lines = <String>[];
    final errors = v.validateDirectory(valid.path, 'specs/schemas', lines.add);
    expect(errors, 0, reason: lines.join('\n'));
    expect(lines.last, contains('3 file(s), 0 error(s)'));
  });

  test('broken content fails with precise errors', () {
    write(broken.path, 'quest_bad.json', _badQuest);
    write(broken.path, 'no_kind.json', '{"quest_id": "q_x"}');
    write(broken.path, 'deep.json', _tooDeepDialogue);
    final lines = <String>[];
    final errors = v.validateDirectory(broken.path, 'specs/schemas', lines.add);
    expect(errors > 0, isTrue, reason: 'broken content must fail');
    final all = lines.join('\n');
    expect(all, contains('fails pattern'));
    expect(all, contains('not in enum'));
    expect(all, contains('missing required field'));
    expect(all, contains('nesting depth'));
    expect(all, contains('unknown or missing'));
  });

  test('dialogue enums and minItems are enforced', () {
    final d = Directory.systemTemp.createTempSync('vc_dlg');
    addTearDown(() => deleteTemp(d));
    write(d.path, 'dlg_x.json', _badDialogue);
    final lines = <String>[];
    final errors = v.validateDirectory(d.path, 'specs/schemas', lines.add);
    expect(errors, 3, reason: lines.join('\n'));
    final all = lines.join('\n');
    expect(all, contains('npc_archetype: "engineer" not in enum'));
    expect(all, contains('required_context: "peacetime" not in enum'));
    expect(all, contains('lines: 0 items < minItems 1'));
  });
}

const _validQuest = '''
{
  "\$schema": "quest",
  "quest_id": "q_deliver_fuel_complication_rival",
  "objective": "deliver_cargo",
  "complication": "rival_faction_interferes",
  "reward_type": "credits",
  "reward_amount": 500,
  "giver_archetype": "trader",
  "giver_context": "normal",
  "required_tags": [],
  "blocking_tags": ["completed_q_deliver_fuel_complication_rival"],
  "approaches": [
    {
      "type": "combat",
      "description": "Fight through Faction B ambush.",
      "required_skill": {"skill": "combat", "level": 2},
      "risk": "high",
      "consequences": {"faction_b_rep": -10}
    },
    {
      "type": "persuasion",
      "description": "Convince the ambush the cargo is not their business.",
      "required_skill": {"skill": "persuasion", "level": 3},
      "risk": "low",
      "consequences": {"faction_b_rep": -5},
      "failure_forward": {"fallback_approach": "combat", "penalty": {"faction_b_rep": -15}}
    }
  ],
  "delayed_effects": [
    {
      "after_quests_completed": 3,
      "state_changes": {"faction_b_rep": -10},
      "hint_dialogue_archetype": "informant",
      "hint_line": "Faction B found out who rerouted their fuel. They remember."
    }
  ]
}
''';

const _validEncounter = '''
{
  "\$schema": "encounter",
  "encounter_id": "enc_convoy_ambush",
  "opponent_archetype": "guard",
  "strength": "medium",
  "outcomes": {
    "win": {"state_changes": {"faction_b_rep": -10}},
    "wounded": {"state_changes": {"player_wounded": true}},
    "retreat": {"state_changes": {"station_ferrum_alert_level": 1}, "always_available": true}
  },
  "skill_alternatives": [
    {"skill": "persuasion", "level": 3, "description": "Talk the ambush down before it starts"}
  ]
}
''';

const _validLocation = '''
{
  "\$schema": "location",
  "location_id": "derelict_ship_sector_4",
  "zone": "solari_belt",
  "status": "hidden",
  "tags": ["derelict", "mid_danger"]
}
''';

const _badQuest = '''
{
  "\$schema": "quest",
  "quest_id": "BADID",
  "objective": "fetch_milk",
  "complication": "none",
  "reward_type": "credits",
  "reward_amount": 99999
}
''';

const _tooDeepDialogue = '''
{
  "\$schema": "dialogue",
  "dialogue_id": "dlg_too_deep",
  "type": "anchor",
  "npc_archetype": "informant",
  "lines": [
    {
      "player_options": [
        {
          "success": {
            "state_changes": {"next": {"deeper": {"even_deeper": {"too_deep": true}}}}
          }
        }
      ]
    }
  ]
}
''';

const _badDialogue = '''
{
  "\$schema": "dialogue",
  "dialogue_id": "dlg_informant_reactor",
  "type": "atmospheric",
  "npc_archetype": "engineer",
  "required_context": "peacetime",
  "lines": []
}
''';
