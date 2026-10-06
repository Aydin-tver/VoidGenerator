# TERMINOLOGY — канонические имена мира Wanderers

> Источник: quests.json, lore.json, journey_events.json, character_arcs.json,
> factions.dart, universe.json. Проверено grep'ом по контенту (2026-09-24).
> Правило: в нарративных текстах — русское имя; в ключах/id — латиница (lowercase).
> Смеси в одном предложении (типа «На терминале Solaris») — запрещены.

## Канонические имена

| Канон (нарратив, ru) | id/ключ (латиница) | Вариации, встречающиеся в контенте | Статус |
|---|---|---|---|
| СИГМА | `sigma` | ⚠️ SIGMA (латиницей в русских текстах, 83 вхождения) — доминирует; должно быть «СИГМА» в ru-текстах | fix: привести к «СИГМА» в bodyRu |
| Нить | `thread` | The Thread (en), `thread_` (ключи) — ок | CANON |
| Реестр | `registry` | Registry в ru-текстах; флаг `lore_trusted_registry` | fix нарратива |
| Кайрос | `kairos` | Kairos в ru-текстах (4×) | fix нарратива |
| Нексит | `nexite` | Nexite в ru-текстах (17×) | fix нарратива |
| Зазор | `zazor` | «the Gap» (lore.json:125) | fix en |
| Митра | `mitra` | Mitra в ru-текстах (20×) | fix нарратива |
| Тидари | `tidari` | — | CANON |
| Аркани | `arcani` | — | CANON |
| Кхадар | `khadar` | — | CANON |
| Войдари | `voidari` | ⚠️ «VoiDari» (flight_screen.dart:481) | fix UI |
| OmniCorp | `omnicorp` | — | CANON |
| Свободные Купцы | `free_merchants` | ⚠️ «Свободные торговцы» (flight_screen.dart:482, gameplay_missions.json:5), «Free Traders» (en) | fix: выбрать одно имя — «Свободные Купцы» |
| Хор Проклятых | `choir` | сокращение «Хор» допустимо в HUD после первого упоминания | CANON |
| KarmaCore | — | ⚠️ вторая орфография `karmcore` (7× в ключах originEvidence) vs `karmacore` (флаги/лор) — разрыв ключа | fix ключей |
| KarmCredit | `karmcredit` | — | CANON |
| Индекс Резонанса | `resonanceIndex` | механика полностью англ. — ок для ключей | CANON |
| Нить/Пустота (Void) | — | «Пустота» в контенте не встречается — не канон; Void только во фракции voidari | не путать |

## Известные нарушения (список на исправление)

1. `quests.json:1420` — «На терминале Solaris…» → «Соларис» (algwar_01, ru-текст с латиницей).
2. `quests.json:1499` — «KarmCredit утверждает» → «KarmCredit» допустимо как название корпорации-бренда (ок), но только если корпус единообразен.
3. 11 заголовков `war_*` в lore.json: поле `titleEn` содержит русский текст (копия titleRu).
4. `faction_omni` / `faction_merchants` (lore.json:111,120) ≠ runtime-фракции `omnicorp` / `free_merchants` (factions.dart) — разные id-скимы одной сущности.
5. `journey_events.json:21` — `factionId: "independent"` не существует во factions.dart.
6. «Солари» (система, universe.json:71) ≠ «Соларис» (станция) — в gameplay_missions.json:2 написано «Система Соларис», что смешивает имена.
7. Планеты «Верда» (Аркани) и «Игнис» (Кхадар) — lore.json:79,88 — отсутствуют в universe.json.

## Запрещённые варианты (для новых текстов)

- «СИГМА» латиницей в русских текстах; «KarmaCore»→«karmcore» разрыв;
- «Свободные торговцы» (уступает канону «Свободные Купцы»);
- «VoiDari», «Registry», «Kairos», «Nexite», «Mitra», «Thread» в ru-нарративе;
- «Система Соларис» (правильно: «Система Солари» для системы, «Соларис» — станция).
