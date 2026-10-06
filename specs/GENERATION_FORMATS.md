# Generation Formats — исполняемые форматы контента v2.0

Дата: 2026-10-06. Дополнение к master spec §14/§16: какой ФАЙЛ и какой ФОРМАТ
потребляет существующий рантайм для каждого типа контента. Правила v2.0
(подходы, осложнения, failure forward) обязательны как СОДЕРЖАНИЕ в этих форматах.

Главный принцип (MIGRATION_AND_SCOPE.md): рантайм не расширяется. Контент пишется
в форматы, которые игра уже загружает и уже покрыты тестами.

## 1. Карта типов

| Тип контента | Файл (Wanderers) | Формат | Валидация |
|---|---|---|---|
| Квесты-заказы (anchor) | `assets/data/quests.json` (append) | nodes/choices/effects (runtime) | `check_quest_graph.dart` + flutter content tests |
| Геймплейные миссии | `assets/data/gameplay_missions.json` (append) | steps (event matchers) + outcomes (effects) | clarity-валидатор + parity-тесты |
| Anchor-диалоги | внутри узлов квестов (выбор с state_changes) | то же | то же |
| Атмосферные диалоги, слухи | `assets/data/npc_ambient.json` | реплики по архетипам | VOICE_GUIDE batch-правило |
| Ветвящийся нарратив | `assets/story_units/<act>/<place>.json` (envelopes 0.17) + локализация | node/choice graph | `validate_narratives` (движок) + golden-тесты |
| Предметы/модули | `assets/data/items.json` | capabilities + verbs | анти-стат ревью + контент-тесты |
| Локации/маршруты | `assets/data/universe.json` | systems/stations, `discoveryStatus` | — (это и есть реестр §11.3, НЕ заводить locations.json) |
| Улики | реестр в `story.json` + выдача discoverEvidence | потребители: mysteries.json evidenceIds, endings minEvidence | проверка 5 в `check_quest_graph.dart` |
| Лор | `assets/data/lore.json` | факты с known_by | TERMINOLOGY grep |
| Коммы-лиды | `assets/data/comm_pools.json` | leads (faction, minRep, questId) | проверка dead gate в `check_quest_graph.dart` |

## 2. Маппинг правил v2.0 на рантайм-формат

**Подходы (approaches)** — в узле квеста: выборы, ведущие к РАЗНЫМ типам решения.
Метадата: у choice добавляется опциональное поле `"approach": "combat|stealth|persuasion|hacking|engineering|trade"`.
Рантайм игнорирует неизвестные поля, скрипт — проверяет.
Правило: квест с reward ≥ 300 имеет ≥ 3 choices с разными `approach`; ≥1 choice обязан быть без боевого навыка (HB-08).

**Осложнения (complications)** — опциональное поле `"complication": "<enum>"` на квесте (верхний уровень). Твисты (betrayal_after_delivery, double_employer) — кап 2+2, скрипт считает.

**Failure forward** — у невыгодного choice обязателен `next` на узел-развитие или compensating effects (тег/реплика). Dead end = ошибка скрипта (в будущем) / плейтест §21.2.

**Delayed effects** — опциональное `"delayed_effects"` на квесте (как в §7.5); до реализации в коде НЕ использовать в контенте (жёлтый флаг в ревью). Хранение настроено §20, применение — после первого реального кейса.

**Специализации (§8.4)** — в `required_skill` допускается `"specialization"`; до реализации чеков в коде — только в story units (движок 0.17 поддерживает произвольные conditions по тегам).

**Слухи (§11.4–11.6)** — rumor = запись в npc_ambient + опциональная привязка discovery через universe/discoveryStatus. Ключи: `rumor_<id>` / `knows_<id>` / `debunked_<id>` (§2.3).

## 3. Конвейер для батча (порядок строго)

1. Промпт из PROMPT_PACK.md (один тип, ≤ 50 юнитов).
2. Сгенерированный JSON: валидная структура (schema/энтити) → `dart analyze` + `flutter test test/domain/ content*` в Wanderers.
3. `dart run bin/check_quest_graph.dart` — граф цел.
4. Golden-тесты движка (если затронуты story units) — `dart test` в `packages/void_event_engine`.
5. Аппенд в файл, коммит.
6. Плейтест §21.2 в конце недели; голосовой чек по батчам.
