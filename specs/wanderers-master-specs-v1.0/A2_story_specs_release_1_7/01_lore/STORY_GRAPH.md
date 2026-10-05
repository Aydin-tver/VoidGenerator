# STORY_GRAPH — карта сюжета Wanderers (release-1-4)

> Собрано 2026-09-24 по quests.json (40 квестов), story.json, character_arcs.json,
> gameplay_missions.json. Назначение: видеть зависимости, тупики и точки входа.
> Прогресс главной истории — `lore.mainStoryStage` 0→7, финалы при стадии ≥ 7.

## Общая структура

```
Старт (Соларис, 200 ₡, rep 0)
│
├─ Онбординг (6+1 страниц, /identity)          [вне квестов]
│
├─ СТОРОНА: 4 побочных квеста (rep 0–1)
│    quest_harvest_debt · quest_miner_run · quest_chip_rumor(rep1) · quest_smuggler_offer
│    → прокачивают reputation → доступ к quest_main_*
│
├─ ЛИНИЯ A: Main-история (mainStoryStage 0→7, только lore_main_*)
│    lore_main_01 «Первое решение»   (stage 0→1)
│    lore_main_02 «Неправильный маршрут» (1→2)
│    lore_main_03 «Аномалия»         (2→3, sigmaStage 1)
│    lore_main_04 «Нексит»           (3→4, nexiteExtractionPressure)
│    lore_main_05 «Первый след Нити» (4→5, sigmaStage 2)
│    lore_main_06 «Кровь Нексита»    (5→6)
│    lore_main_07 «Исключение»       (6→7, sigmaStage 3, algwarStage 1)
│
├─ ЗАКАЗЫ: quest_main_05…16 (12 шт.) — фракционные, гейт prereqRep/prereqFactionRep
│    5 из них несут геймплейные миссии: 06→honest_route, 07→silent_convoy,
│    08→smuggler_trace, 09→grey_package, 12→beacon_signal, 14→frontier_patrol
│    (05, 10, 11, 13, 15, 16 — диалоговые без миссий)
│
├─ ВЕТКИ (открытие с mainStoryStage 5):
│    ВОЙНА АЛГОРИТМОВ: algwar_01→05 (warStage 0→5) — 2 входа: algwar_01 (stage 0) И lore_main_07
│    СИГМА:            sigma_01→05 (sigmaStage 0→5)
│    ЗАЗОР:            zazor_01→04 (zazorStage 0→4, гейт sigmaStage 3)
│
├─ ПЕРСОНАЖИ: char_lena_01, char_kade_01, char_sera_01 (единичные)
│    + 6 арок по 5 стадий (character_arcs.json): lena/kade/mira/ila/ved/sera
│
└─ ФИНАЛЫ (mainStoryStage ≥ 7): 5 финалов по резонансу/уликам/трейтам/флагам
```

## Таблица узлов (основное)

| Узел | Гейт | Двигает | file |
|---|---|---|---|
| lore_main_01…07 | prereqMainStoryStage 0…6 | mainStoryStage 1…7 (+sigma/algwar) | quests.json:909–2686 |
| quest_main_05…16 | prereqRep 1…10 + prereqFactionRep 0…22 | флаги, репутация, 6 миссий | quests.json:240–898 |
| algwar_01…05 | stage 5 + prereqAlgorithmWarStage | warStage до 5 | quests.json:1415–1774 |
| sigma_01…05 | stage 5 + prereqSigmaStage | sigmaStage до 5 | quests.json:1876–2214 |
| zazor_01…04 | prereqSigmaStage 3 | zazorStage до 4 | quests.json:2297–2437 |
| char_*_01 + arc_* | factionId | арки (5 стадий, minRep 0/10/20/30/40, requiredFlag-цепочки) | character_arcs.json |
| Финалы | stage ≥ 7 + minEvidence/minTraits/флаги/резонанс | — | story.json:29–33, ending_resolver.dart |

## Финалы (requirements)

| Финал | minEvidence | minTraits | Флаг | Резонанс |
|---|---|---|---|---|
| Хранитель Нити | nexite_thread, thread_reply | empathy 4 | — | 60–100 |
| Цена компромисса | nexite_thread | self_preservation 4 | — | 40–80 |
| Кайрос без Реестра | — | autonomy 8 | zazor_identity_protected | 20–70 |
| Контур СИГМА | sigma_architecture, thread_reply | curiosity 8 | — | 30–90 |
| Ответ, которого нет | nav_echo, thread_reply | trust 4 | — | 0–100 |

## Найденные проблемы графа (бэклог)

1. **Две точки входа в войну алгоритмов**: algwar_01 (warStage 0) и lore_main_07 (ставит algwarStage 1) — ветка может «перепрыгнуть» первый квест; при этом если игрок шёл через algwar_01 и дожил до lore_main_07 — конфликт не определён.
2. **algwar_05 понижает sigmaStage до 1** (quests.json:1861): если игрок прошёл lore_main_03/05/07 (sigmaStage 1–3), выбор снижает стадию → риск потери доступа к Зазору (prereqSigmaStage 3). Мягкий soft-lock гейта.
3. **`karmcore` vs `karmacore`** — разрыв ключа originEvidence (quests.json:1251,1607,1700,1802 vs флаги/лор `karmacore`).
4. **Финал «Кайрос без Реестра» достижим только через квест char_sera_01** (флаг zazor_identity_protected выдаётся только там; арка sera выдаёт sera_intro) — единственная точка входа в финал спрятана в квесте, недоступном без rep voidari.
5. **Миссионные улики не влияют на финалы**: verified_route/beacon_thread_echo/smuggler_route_signature есть в story.json, но не в minEvidence финалов.
6. **Расхождение денег в квесте vs миссии**: quest_main_07 обещает 160 ₡ (текст), квест платит 0, миссия 240; quest_main_08: текст 220 / миссия 260; quest_main_12: текст 320 / миссия 220.
7. Станции дублируются в stations.json и universe.json (4 стартовых), при этом mission_frontier_patrol требует `station_fort_tavra`, существующего только в universe.json.
8. «Солари» (система) vs «Соларис» (станция) — в миссии honest_route «Система Соларис» (см. TERMINOLOGY.md).
9. «Верда», «Игнис», «Зазор» — локации лора вне universe.json (не на карте).
10. Станции/системы не имеют лор-описаний (derelicts — имеют) — подтверждённый пробел Этапа 3.2.
