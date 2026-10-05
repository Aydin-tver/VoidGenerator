# Story port topology — Wanderers mainline into authoring contract 0.17

Source of truth for legacy plot: `C:\dev\Wanderers\docs\production\STORY_WALKTHROUGH_3_18.md` (§1 mainline, §2 quests, §3 side lines, §4 endings, §5 speedrun).

Consequence vocabulary available after step 0 (`vocabulary.catalog.json`):

| Legacy variable | Engine consequence |
|---|---|
| доверие персонажа | `character.trust` |
| улики (9 шт, стабильные ID legacy) | `evidence.add` |
| флаги (`zazor_identity_protected`…) | `story.flag` |
| черты (автономия/любопытство/самосохранение/эмпатия) | `trait.add` |
| стадии линеек (main 1–7, sigma, zazor, algwar) | `story.stage` (`lineId` + `stage`) |
| резонанс (± дельта, старт 82) | `thread.resonance` |
| репутация фракций | `faction.reputation` |
| thread-счётчик (capability) и прочие capabilities | **host-side**: движок emits `story.flag` (например `impulse_coordinates_saved`), Wanderers маппит флаг → capability |

Reachability по capabilities (scan/survival/combat/mobility/stealth/cargo) и по резонансу — **host-domain** (Deliberate boundary, NARRATIVE_AUTHORING_0_17). Движок не гейтит узлы capabilities; гейт только на событиях-фактах и зависимостях.

## Mainline units (критический путь, все Соларис кроме отмеченных)

| Юнит (contentId/storyId) | Namespace | Вход-событие | Ключевые развилки | Эмитит |
|---|---|---|---|---|
| `act01.solaris.route` | act01.solaris | flight.entered_region | следовать/изменить маршрут; записать/стереть аномалию | `story.stage lore_main 1`, `trait.add` (autonomy/curiosity/self_preservation), `thread.resonance` |
| `act01.solaris.corridor` | act01.solaris | flight.entered_region | довериться себе/Реестру; сохранить координаты | stage 2, флаг `impulse_coordinates_saved` |
| `act01.solaris.packet` | act01.solaris | flight.entered_region | ответить/молчать (открывает СИГМА) | stage 3, `story.stage sigma 1` |
| `act01.solaris.mining` | act01.solaris | flight.entered_region | Тидари/OmniCorp | stage 4, `faction.reputation` |
| `act01.solaris.impulse` | act01.solaris | flight.entered_region | ответить/наблюдать | stage 5, `story.stage sigma 2` |
| `act01.ferum.mine` | act01.ferum | flight.entered_region | шахтёры/добыча → выбор улики; публиковать/скрыть журнал | stage 6, `evidence.add evidence_miner_anomaly` ИЛИ `evidence_nexite_thread`, репутации |
| `act01.nova.karmacore` | act01.nova | flight.entered_region | оба выбора дают thread_reply | stage 7, `evidence.add evidence_thread_reply`, честный ответ → `evidence_sigma_architecture` |

## Side lines

| Линейка | Юниты | Гейты/выход |
|---|---|---|
| СИГМА | `act01.solaris.sigma_01`, `act01.nova.sigma_02`, `act01.solaris.sigma_03`, `act01.nova.sigma_04`, `act01.haven.sigma_05` | `story.stage sigma 1..5`; усиливает концовку «Контур СИГМА» |
| Зазор | `act01.haven.zazor_01..04` | зависимость: `story.stage sigma >= 3` (host предусловие); выход — флаг/стадия zazor |
| Алговойна | `act01.solaris.algwar_01..05` | `story.stage algwar 1..5` |
| Персонажи | `act01.solaris.char_lena`, `act01.ferum.char_kade`, `act01.haven.char_sera` | sera: `story.flag zazor_identity_protected` + `evidence.add evidence_nav_echo` + `trait.add` (autonomy/empathy); lena → trust; kade → улика |

## Missions (6 боевых/проверяемых, JSON миссий)

| Миссия | ID legacy | Объективы (детерминированные события) |
|---|---|---|
| «Честный маршрут» | main_06 | `scan.discovery_completed` + `station.docked station_solaris` |
| «Тихий конвой» | main_07 | событие патруля на маршруте + `combat.retreat` |
| «След контрабандистов» | main_08 | скан + `combat.victory` |
| «Серая посылка» | main_09 | обломки + `station.docked station_nova` |
| «Сигнал маяка» | main_12 | скан + резонанс-событие (assist) |
| «Фронтирный патруль» | main_14 | 2× `combat.victory` + `station.docked station_fort_tavra` |

Заказы main_05/10/11/13/15/16 — цепочки репутации на станциях, вне движка на этой фазе.

## Endings (host-side на shadow-фазе)

Движок эмитит только улики/флаги/черты/резонанс-дельты. Решение концовки — проверка в Wanderers по таблице §4 walkthrough (улики + черта + резонанс-диапазон). Отдельный юнит `endings.resolution` не создаётся до миграции в modern.

## Golden-сценарии для симулятора (фикстуры)

1. Спидран-маршрут §5 (все 7 стадий + char_sera при необходимости).
2. «Цена компромисса»: самосохранение, улика nexite_thread, резонанс 40–80.
3. «Хранитель Нити»: nexite_thread + эмпатия, резонанс ≥60.
4. «Кайрос без Реестра»: автономия 8 (lore_main_01) + флаг sera + резонанс <70.
5. «Контур СИГМА»: sigma до 5 + honest answer, любопытство ≥8.
6. «Ответ, которого нет»: nav_echo + thread_reply, доверие ≥4.

## Правила авторинга (не нарушать)

- Юнит = файл, один `owner.agentId`; ID неизменяемы; префиксы как в таблицах.
- Текст только через `textKey`; ключи `story.<namespace>.<unit>.<node>`.
- Никаких новых типов событий/последствий без предварительного шага каталога.
- После каждого юнита: analyze → test → `validate_narrative_authoring` → `validate_narratives` → fixture.
