# LORE_IMPROVEMENT_PLAN — единый план улучшения лора и игры

> Составлен 2026-09-24 на основе Lore_Audit_1.md и Lore_Audit_2.md после
> file-level проверки по репозиторию (release-1-4, commit 22c186f).
> Из аудитов взяты только подтверждённые пробелы; опровергнутые клеймы
> (лор «пассивен», «нет наград», «нет диалогов/ветвления», «движок брошен»)
> исключены — они противоречат коду и осознанным спецификациям
> (спека 0.18, GDD-MVP §4, ADR-0004/0005/0006).

## Вердикты проверки аудитов (кратко)

**Реализовано (клеймы опровергнуты):**
- Лор: 54 записи в `lore.json` (10 категорий), кодекс `/lore`, `/identity`, `/journal`;
  раскрытие через бой/скан/salvage/journey/квесты (45× discoverLore, 12× discoverEvidence);
  `WorldConsequenceEngine` меняет цены/встречи/топливо; стадии лора гейтят квесты и финалы.
- Миссии: награды (money/xp/flags/evidence/worldConsequences), data-driven
  `gameplay_missions.json`, диалоговые деревья с гейтами, арки персонажей, 5 финалов.
- Shadow-режим void_event_engine — плановая миграция спеки 0.18 (нарративный gate закрыт тестами).

**Подтверждённые пробелы:** см. этапы ниже (пункты помечены источником: [A1] Lore_Audit_1,
[A2] Lore_Audit_2, [0.18] спецификация интеграции, [П] пробел, найденный при проверке).

---

## Этап 1 — Канон и карта сюжета (документы, без кода)

| # | Улучшение | Источник | Статус |
|---|---|---|---|
| 1.1 | LORE_CANON.md — реестр канон-фактов (CANON/RUMOR/FALSE_IN_WORLD), синхронизация с design/registry/entities.yaml | [A1 §31] | ✅ docs/lore/LORE_CANON.md |
| 1.2 | STORY_GRAPH.md — карта сюжета: main-квесты, миссии, арки, финалы, зависимости, тупики | [A1 §35] | ✅ docs/lore/STORY_GRAPH.md (10 найденных проблем графа) |
| 1.3 | TERMINOLOGY.md — канонические имена (Void/Нить/Реестр/СИГМА/Зазор), запрещённые варианты | [A1 §33] | ✅ docs/lore/TERMINOLOGY.md (7 нарушений на fix) |
| 1.4 | Инвентаризация 6 миссий по KEEP/REWRITE/MERGE/REMOVE | [A1 §38] | ✅ docs/lore/MISSION_INVENTORY.md (KEEP×3, REWRITE×3, desync денег ×3) |

## Этап 2 — Событийный мост 3.18.x (код, низкий риск, по спеке 0.18)

| # | Улучшение | Источник | Статус |
|---|---|---|---|
| 2.1 | Оживить мёртвые producers: `station.docked`, `trade.completed`, `flight.entered_region`, `combat.started`, `scan.completed` — параллельно с callback (legacy сначала, событие наблюдательное) | [0.18 роадмап] | ✅ dock→station.docked (runtime), trade.completed (trade_screen), flight.entered_region (flight_screen boundary), combat.started (_startCombat); scan уже эмитится через missionAction |
| 2.2 | Устранить асимметрию: dock → `station.docked`, convoy_* → `convoy.*`; синхронизировать условия LegacyMissionShadowAdapter | [A2] | ✅ runtime: dock/convoy_reach/convoy_escort/convoy_protect → канонические типы; условия адаптера теперь совпадают с эмитами |
| 2.3 | Миссионный shadow-harness: одни события в обе системы, тест «0 расхождений» → закрыть миссионный migration gate | [0.18] | ✅ test/integration/void_event_mission_live_test.dart — 6 миссий, паритет прогресса/завершения + тест на несовпадающие события |
| 2.4 | Персистентный journal-адаптер + shadow-телеметрия (mission_start/complete/abandon, choices) | [0.18, A1 §37] | ✅ HiveEventJournal (компактация KeepLastN 400, переземлирование с 1) + VoidEventRuntime.telemetry; тесты test/integration/hive_event_journal_test.dart |

## Этап 3 — Лор как награда за игру

| # | Улучшение | Источник | Статус |
|---|---|---|---|
| 3.1 | Оживить identity: писать `playerOriginHypothesis` из улик, вызывать `advanceIdentity()` на сюжетных вехах | [П] | ✅ гипотеза — derived от доминирующей улики (порог 25%); веха mainStoryStage = +1 стадия identity (clamp 5); тесты lore_foundation + narrative_live |
| 3.2 | Лор от стыковки: описания станций в stations.json + discovery `station_lore_<id>` при первом доке | [A1 §29, A2] | ✅ описания 4 станций + панель в меню станции + 4 лор-записи + discovery при первом доке |
| 3.3 | Лор от дереликтов: запись кодекса при salvage (категория derelict в lore.json) | [A2] | ✅ поле loreId в derelicts.json (5 шт) + 5 лор-записей + discovery при разборке |
| 3.4 | Попап/тост новой записи кодекса при discoverLore + маркеры непрочитанного + счётчик «N/54» | [A2 §5.3] | ✅ тост «Новая запись в Кодексе» (листенер flight_screen), readLoreIds в сейве, unread-иконки + счётчик «Открыто N/63» в кодексе |
| 3.5 | Задействовать minEvidence/prereqLore в quests.json: 2–3 квеста открываются только после улик (lore → gameplay) | [A1 §3] | ✅ quest_main_09 гейт на salvage_manifest_sys_solari (детерминированный: обломки Солари), quest_main_14 — на pirate_command_signature (капитаны/боссы) |
| 3.6 | Mystery Board в журнале: открытые вопросы (9 mystery-записей) со статусами «вопрос → улика → противоречие → раскрытие» | [A1 §23] | ✅ раздел «Загадки N/9» в журнале: найденное читается, неоткрытое — «Связь не установлена» (breadcrumbs, без спойлеров) |

## Этап 4 — Миссии: ясность и глубина (в рамках MVP)

| # | Улучшение | Источник | Статус |
|---|---|---|---|
| 4.1 | Mission Card: поле `risk` в данных; плашка отвечает WHY/WHAT/WHERE/RISK (одна строка риска, без GPS) | [A1 §13] | ✅ поле risk у всех 6 миссий; «Риск: …» в HUD-трекере и журнале; clarity-валидатор требует риск |
| 4.2 | Optional objectives: 1–2 необязательные цели + состояния целей AVAILABLE/ACTIVE/COMPLETED/SKIPPED | [A1 §14] | ✅ optional-objectives в silent_convoy (победа над перехватчиком) и frontier_patrol (salvage фронтира) с бонусом bonusXp 40; record() не блокируется опциональными; трекер/журнал показывают «(необязательно)»; тест mission_optional_objectives_test |
| 4.3 | Расширить feasibility-валидатор (mission_clarity.dart): существование id/станций/предметов, достижимость, follow-up | [A1 §15] | ✅ clarity: ≥1 обязательной цели + строка риска; mission_content_test: обратная связь quest→mission (gameplayMissionId == mission.id), риск у всех миссий |
| 4.4 | Переписать 2 слабейшие миссии по Mission Card (narrative_purpose + gameplay_purpose обязательны) | [A1 §10] | ✅ silent_convoy: конвой под наблюдением OmniCorp + «уход от перехвата»; grey_package: посылка = незарегистрированный чип идентичности, мост к Мира Сет + evidence grey_parcel_handoff; frontier_patrol: причина — «Хор Проклятых»; desync денег 3× исправлен (07: 160→240, 08: 220→260, 12: 320→220); «Система Соларис»→«Солари» |
| 4.5 | Choice point в 1 миссии: развилка с местными (не world-changing) последствиями | [A1 §20] | ✅ quest_main_07 n2: «отчитаться дословно» (rep omnicorp +5) vs «вычеркнуть координаты конвоя» (флаг silent_route_kept, доверие Купцов +2) — локальные последствия, мир не ломают |

## Этап 5 — Масштаб сюжета (после закрытия gate этапа 2)

| # | Улучшение | Источник | Статус |
|---|---|---|---|
| 5.1 | Mission authority migration (shadow → движок) по спеке 0.18 | [0.18] | ⏸ отложено по ADR-0011: спека требует этап 3.19 (полный shadow миссий) ДО authority flip (3.20+); миссионный gate (harness) уже закрыт — подготовка сделана |
| 5.2 | Параллельные миссии (1 основная + 1 побочная): activeMissions, координированный bump saveVersion 2 (нужен ADR) | [A2, A1 §17] | ✅ ADR-0011 Accepted: два слота (sideGameplayMissionId, additive без бампа — паттерн Фазы 1 ADR-0006); record() в оба слота; отказ по missionId; HUD/журнал показывают обе; 4 новых теста |
| 5.3 | Story arcs data-driven: story_arcs.json + pacing-координатор | [A1 §7, A2 §4] | ✅ story_arcs.json (6 глав: Прибытие → Разломы → Скрытый слой → Нить → Развилка → Последствия) + StoryArc entity + GameContent.storyArcForStage; журнал показывает главу и описание |
| 5.4 | Идентичность станций: локальные NPC/слухи/проблемы | [A1 §29] | ✅ поле rumor у 4 станций + отображение в меню станции (италика, violetUnknown); полные NPC-идентичности — контент-бэклог |
| 5.5 | Онбординг-как-история: сквозной вводный квест (Chapter 0) поверх сделанного identity-старта | [A1 §27] | ❌ отклонено: GDD-MVP §3.8 (базовый онбординг, не туториал-квест) — анти-пиллар; онбординг уже расширен identity-страницей + хинтом первого заказа |

## Анти-план (не делать)

- Полный rewrite StoryState/Mission model — миграция инкрементальная по спеке 0.18;
- Удаление `legacy_mission_bridge` — только после закрытия миссионного gate;
- GPS-маршруты, фракционные гильдии, процедурные миссии, моральный бар GOOD/EVIL —
  анти-пиллары GDD-MVP §4;
- Расширение движка void_event_engine — только использование (спека 0.18).

## Порядок

Этап 1 и Этап 2 — параллельно; этапы 3–4 опираются на оба; этап 5 — после gate.
