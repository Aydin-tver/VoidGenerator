# BACKLOG — открытые проблемы нарративного контента

> Извлечено из STORY_GRAPH.md («Найденные проблемы графа»), LORE_CANON.md («Пустоты»)
> и завершённого LORE_IMPROVEMENT_PLAN.md (удалён, работа закрыта).
> Файлы данных живут в репо игры Wanderers (`C:\dev\Wanderers`): quests.json, story.json,
> gameplay_missions.json, universe.json, stations.json. Здесь — только учёт.

## Баги графа (приоритет: софтлоки и опечатки — дешёвые фиксы, высокая отдача)

> Верификация 2026-10-06 скриптом `bin/check_quest_graph.dart` в репо Wanderers
> (dart run bin/check_quest_graph.dart). Скрипт — постоянный инструмент: гонять
> после каждого изменения квестов/арок/коммов.

| # | Проблема | Где | Статус |
|---|---|---|---|
| 1 | Две точки входа в войну алгоритмов (algwar_01 и lore_main_07) — конфликт не определён | quests.json | **CLOSED (by design, 2026-10-06)** — оба входа дают warStage 1; algwar_02 требует ровно 1; стадии только растут (max-кламп). Линейка корректна при любом порядке |
| 2 | algwar_05 понижает sigmaStage до 1 → мягкий софтлок гейта Зазора | quests.json:2159 | **CLOSED** — рантайм клампит stage-эффекты по max (quest_repository_impl.dart:224-227), гейт Зазора имеет запасной вход zazorStage>0 (zazor_use_case.dart:13). Скрипт следит, чтобы контент не полагался на кламп (проверка downgrade) |
| 3 | Разрыв ключа `karmcore` vs `karmacore` в originEvidence | quests.json | **CLOSED (как баг)** — рантайм-ключ последовательно `karmcore` (данные + identity_screen.dart:50). Осталась косметика: текущая гипотеза показывается сырым ключом в identity_screen.dart:132 — исправить отображение |
| 4 | Финал «Кайрос без Реестра» — единственный источник флага zazor_identity_protected (char_sera_01) | story.json | **ACCEPTED RISK** — канон-правило 5 (LORE_CANON) запрещает второй источник без ADR. Скрипт держит это на радаре (WARN single-source) |
| 5 | Миссионные улики не входят в minEvidence финалов | story.json | **FIXED (2026-10-06)** — подключены тематически: thread_guardian += beacon_thread_echo; industrial_compromise += verified_route; sigma_choice += grey_parcel_handoff; unknown_answer += smuggler_route_signature. Скрипт теперь проверяет мёртвые улики (проверка 5) |
| 7 | station_fort_tavra отсутствует в stations.json | stations.json | **CLOSED (как баг)** — stationById имеет fallback в universe.json (game_content_datasource.dart). Дублирование станций остаётся техдолгом |
| 11 | **НОВОЕ (2026-10-06):** char_ila_01 недостижим — флаг lead_char_ila_01 не выдаёт никто (в comm_pools лиды есть только для lena/kade/sera; арка Илы questIds:[]) | comm_pools.json | **FIXED** — добавлен lead_ila (arcani, minRep 50) в comm_pools.json; скрипт подтверждает достижимость; 393 теста Wanderers проходят |

## Закрыто при портировании (проверить перед удалением строк)

| # | Проблема | Статус в плане |
|---|---|---|
| 6 | Рассинхрон денег квест/миссия (07, 08, 12) | ✅ исправлено (160→240, 220→260, 320→220) |
| 8 | «Система Соларис» → «Солари» в honest_route | ✅ исправлено |

## Контентные пустоты (бэклог, не блокеры)

- **Терминология — унифицировано 2026-10-06 по TERMINOLOGY.md:** karmcore→karmacore (11 refs: quests/lore/mysteries/identity_screen, показ гипотезы теперь через имя, не сырой ключ); «На терминале Solaris»→«Соларис»; VoiDari→Voidari (factions.dart); phantom-фракция independent удалена из journey_events.json; lore-id faction_omni/faction_merchants → faction_omnicorp/faction_free_merchants (согласовано с factions.dart); 11 заголовков war_* получили настоящий titleEn.
- «Верда», «Игнис», «Зазор» — локации лора вне universe.json (не на карте).
- Хор Проклятых (choir) — фракция без единого квеста; hook уже в quest_main_14.
- Станции/системы без лор-описаний (8 станций — сухие конфиги; у 4 стартовых описания есть).
- Полные NPC-идентичности станций (локальные NPC/слухи/проблемы) — сделаны только rumors у 4 станций.
- Mission authority migration (shadow → движок) по спеке 0.18 — отложено по ADR-0011 (сначала этап 3.19 полного shadow).

## Правила

- Фикс выполнен в репо Wanderers → строка переносится в «Закрыто» с номером коммита.
- Новая находка → добавляется сюда же, НЕ раздувая LORE_CANON (там только канон-факты).
- #2, #3, #4, #7 — исправить до начала AI-генерации контента по master spec (иначе конвейер размножит битые ссылки).
