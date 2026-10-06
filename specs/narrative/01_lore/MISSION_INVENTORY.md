# MISSION_INVENTORY — аудит 6 геймплейных миссий (KEEP/REWRITE/MERGE/REMOVE)

> По чеклисту Mission Card (Lore_Audit_1 §10) и данным gameplay_missions.json +
> quests.json. Первичный аудит 2026-09-24; ревизия 2026-10-06 после выполнения
> rewrite при WIP в хост-репо: все три REWRITE реализованы (см. статусы).
> Политика: «лучше 30 сильных миссий, чем 120 fetch-квестов».

## Сводка

| Миссия | Квест | Вердикт | Статус |
|---|---|---|---|
| mission_honest_route | quest_main_06 | **KEEP** | ✅ как было: narrative purpose (доказательство честного маршрута), evidence → канон |
| mission_silent_convoy | m09_merchant_shield | **REWRITE → DONE** | ✅ конвой = персона Лена Восс (+арка, выбор в финале); choice point n2: «отчитаться дословно» (rep omnicorp) vs «вычеркнуть координаты» (флаг silent_route_kept, доверие Купцов); optional-перехватчик; деньги синхронны (240) |
| mission_smuggler_trace | quest_main_08 | **KEEP** | ✅ связь с lore (route_signature → канон, mystery), требования корабля дают动机 апгрейдов; evidence smuggler_route_signature → финал unknown_answer (2026-10-06) |
| mission_grey_package | quest_main_09 | **REWRITE → DONE** | ✅ narrative purpose (посылка под OmniCorp-аналитика на Нова, приёмка «не спрашиваем»), evidence grey_parcel_handoff → mystery Зазора + финал sigma_choice (2026-10-06), smuggling_pressure +1 обоснован |
| mission_beacon_signal | quest_main_12 | **KEEP (усилен)** | ✅ лор-мост (маяк = ритм Нити); evidence beacon_thread_echo → mystery Нити + финал thread_guardian (2026-10-06); деньги синхронны (220) |
| mission_frontier_patrol | quest_main_14 | **REWRITE → DONE** | ✅ narrative purpose: Хор Проклятых добрался до Тавры (hook на пустоту канона); optional salvage; требования ship capabilities |

## Cross-cutting несинхроны

| Проблема | Где | Статус |
|---|---|---|
| Текст квеста ≠ выплата миссии (3 случая) | quest_main_07/08/12 | ✅ выровнено при rewrite |
| «Система Соларис» в honest_route | gameplay_missions.json | ✅ «Система Солари» |
| locationLabel grey_package «обломки средней опасности» | grey_package | сверено при rewrite |
| Миссионные evidence не в minEvidence финалов | story.json | ✅ FIX 2026-10-06: 4 улики подключены к 4 финалам тематически (см. BACKLOG #5) |

## Не делать

- Удалять миссии (REMOVE) — объём мал, все несут worldConsequences;
- GPS-координаты и «кнопку маршрута» — запрещено (quests GDD, канон-правило 7).
