# TERMINOLOGY — канонические имена мира Wanderers

> Источник: quests.json, lore.json, journey_events.json, character_arcs.json,
> factions.dart, universe.json. Унификация проведена 2026-10-06 (grep-проверка);
> статусы актуальны. Правило: в нарративных текстах — русское имя; в ключах/id —
> латиница (lowercase). Смеси в одном предложении («На терминале Solaris») — запрещены.

## Канонические имена

| Канон (нарратив, ru) | id/ключ (латиница) | en | Статус |
|---|---|---|---|
| СИГМА | `sigma` | SIGMA | CANON (ru-тексты приведены к «СИГМА» 2026-10-06) |
| Нить | `thread` | The Thread | CANON |
| Реестр | `registry` | Registry | CANON (ru-нарратив без латиницы) |
| Кайрос | `kairos` | Kairos | CANON |
| Нексит | `nexite` | Nexite | CANON |
| Зазор | `zazor` | the Gap | CANON (en исправлено) |
| Митра | `mitra` | Mitra | CANON |
| Тидари | `tidari` | Tidari | CANON |
| Аркани | `arcani` | Arcani | CANON |
| Кхадар | `khadar` | Khadar | CANON |
| Войдари | `voidari` | Voidari | CANON (VoiDari исправлено в factions.dart + flight_screen) |
| OmniCorp | `omnicorp` | OmniCorp | CANON |
| Свободные Купцы | `free_merchants` | Free Merchants | CANON («Свободные торговцы»/«Free Traders» исправлены; l10n, missions) |
| Хор Проклятых | `choir` | Choir of the Damned | CANON (сокращение «Хор» допустимо в HUD после первого упоминания) |
| KarmaCore | `karmacore` | KarmaCore | CANON — единая орфография ключей (originEvidence, флаги, lore-id war_karmacore_*; karmcore исправлено 2026-10-06) |
| KarmCredit | `karmcredit` | KarmCredit | CANON (бренд-название допустимо в обоих текстах) |
| Индекс Резонанса | `resonanceIndex` | Resonance Index | CANON (механика англ. — ок для ключей) |

## Устранённые расхождения (2026-10-06)

1. ~~«На терминале Solaris» (algwar_01)~~ → «На терминале Соларис».
2. KarmCredit — допустим как бренд, корпус единообразен.
3. 11 заголовков `war_*` в lore.json: titleEn содержал русский → записаны реальные английские (The Exception… The Exception Protocol).
4. `faction_omni`/`faction_merchants` → `faction_omnicorp`/`faction_free_merchants` (id-ским lore согласован с factions.dart; обновлены grants в quests.json).
5. ~~`factionId: "independent"` (journey_events.json)~~ — удалено (фракции не существует в factions.dart; реп-эффект создал бы фантомный ключ сейва).
6. ~~«Система Соларис» (gameplay_missions.json)~~ → «Система Солари» (исправлено ранее при портировании).
7. Планеты «Верда» (Аркани) и «Игнис» (Кхадар) — вне universe.json; известная пустота канона (BACKLOG, не блокер).

## Запрещённые варианты (для новых текстов)

- Латиница в ru-нарративе: SIGMA, Registry, Kairos, Nexite, Mitra, Thread, Solaris;
- «Свободные торговцы» (канон — «Свободные Купцы»);
- «karmcore» в любых ключах (канон — `karmacore`);
- «VoiDari»;
- «Система Соларис» (правильно: «Система Солари» для системы, «Соларис» — станция);
- «Пустота» как синоним Void (Void — только фракция voidari).
