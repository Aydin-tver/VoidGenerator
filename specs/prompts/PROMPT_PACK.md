# PROMPT PACK — мастер-промпты конвейера v2.0

Дата: 2026-10-06. По master spec §14: один промпт = один ТИП контента, ≤ 50 юнитов
на запрос, полный enum + канон-id в промпте, результат плох → меняем промпт (HB-05),
не текст. Вставлять в промпт: (1) заголовок типа ниже, (2) «Атом канона» (§3),
(3) пример формата из GENERATION_FORMATS.md, (4) правила вывода.

## Правила вывода (общие, в каждый промпт)

1. Вывод — ТОЛЬКО валидный JSON. Без markdown, без пояснений, без комментариев.
2. Один запрос — один массив юнитов, ≤ 50.
3. Все id — snake_case, с указанным префиксом; id после релиза неизменны.
4. Запрещено: вложенность > 4 уровней; ссылка на id, не входящий в «Атом канона»
   или не созданный В ЭТОМ ЖЕ выводе; реальный сленг/бренды; обращение к игроку
   «капитан/пилот» (игрок — ИИ, канон-правило 1); слова «энергия/аура/артефакт».
5. Если значение не из enum — СТОП: пустой массив и поле "unmet": ["<что нужно>"].
6. Тон: сухой постдефицитный; реплика ≤ 30 слов; голос архетипа — по VOICE_GUIDE.md
   (таблица голосов вставляется в промпт целиком).

## 1. quest_order — квест-заказ (quests.json)

Роль: дизайнер фракционных заказов станции.

Поля: id (q_<name>), title/TitleEn, prereqRep (0-10), prereqFactionRep (0-22),
factionId (enum: omnicorp, free_merchants, tidari, arcani, khadar, voidari, choir),
complication (enum §7.2 — опционально, твисты кап 2+2), nodes[]:
start-узел (text/textEn ≤ 60 слов: зачем, что делать, ГДЕ и РИСК без GPS),
choices[]: ≥ 3 для reward ≥ 300 (каждый с полем approach из enum combat/stealth/
persuasion/hacking/engineering/trade), ровно один choice final с эффектами награды;
effects: money/reputation/flags/discoverEvidence/discoverLore/npcTrustDelta.
Требования: objective enum §7.2; минорный квест (reward < 300) может иметь 1 путь;
у невыгодного choice — next или компенсирующий эффект (failure forward);
награда в тексте = награда в эффектах (mission inventory: рассинхрон — баг).

## 2. mission_steps — геймплейная миссия (gameplay_missions.json)

Роль: дизайнер проверяемых целей.

Поля: id (mission_<name>), schemaVersion 1, titleKey/descriptionKey (ключи локализации,
не текст!), tags, risk, steps[]: id, displayKey, locationKey, clueKey, sourceKey,
count, event {type (station.docked | scan.discovery_completed | combat.enemy_defeated |
trade.completed | salvage.completed | convoy.* ), path, equals}. outcomes[]: id,
effects (economy.credit, faction.reputation, evidence.add, flags, worldConsequence).
Требования: ≥ 1 обязательной цели; 1-2 optional; каждая цель детерминирована
событием (никаких таймеров/тиков); существование всех id.

## 3. story_unit — ветвящийся нарратив (assets/story_units/**)

Роль: нарративный автор 0.17.

Формат envelope: contentId = storyId = act0X.<place>.<name> (канон-префикс),
nodePrefix `act0X.<place>.<name>.node.`, choicePrefix `.choice.`, события
story.*.start/reply/stage_done, nodes: start → reply → stage_done, 2-3 выбора,
последствия: evidence.add, flag.set, rep.delta. Тексты — ключи
story.<id>.<node>, тело в story_units.ru/en.json (ru — кириллица, имена канонические).
Требования: узловый граф конечен; выбор изменяет ≥ 1 сущность; ру-текст без латиницы.

## 4. ambient_line — атмосферные реплики и слухи (npc_ambient.json)

Роль: автор настроения станции.

Формат: id rumor_<id> или line_<archetype>_<context>_<n>; archetype enum (8),
context enum (normal/tension/war/crisis), text/textEn ≤ 30 слов, certainty:
("vouched"|"hearsay"|"sworn") — vouched/sworn = правдивый, hearsay = может быть ложью
(ложных ~25%); rumor MUST иметь verify hint: поле verify_via (location id или
second_source archetype). Требование батча: все 8 архетипов различимы без подписи
(перестановка реплик между архетипами теряет смысл); banned phrases исключены.

## 5. item — предмет/модуль (items.json)

Роль: дизайнер возможностей.

Поля: id, name/NameEn, type (equipment/consumable/knowledge/quest_item), slot
(weapon/scanner/engine/armor/utility), base_stats, verbs[]: {verb, description,
requires, unlocks, risk}, tags, faction_interaction. Правило отклонения:
предмет, чья единственная ценность +damage/+armor/+speed/+cargo/-cooldown,
ОТКЛОНЯЕТСЯ (§9.2); глагол привязан к тегу цели или состоянию игрока.

## 6. discovery — конвертируемое знание (реестр story.json + якорь universe.json)

Роль: дизайнер информации как валюты.

Поля: id (disc_<name>), location (id из universe.json), item_given, tags
(обязательно Convertible_Knowledge), conversions[]: ≥ 2 из {sell (base_price
+ sellable: true), blackmail (requires_tag), reveal_route (unlocks)},
skill_check {skill, level, success, failure_forward (повреждённая версия)}.
Потребители: ending minEvidence или mystery evidenceIds — обязательны
(мертвая улика = отказ).

## Атом канона (вставлять в промпты 1-3, 6)

- Сектор Кайрос; ресурсы: Нексит; Нить (не бог, не ИИ, объяснение — только уликами);
  Зазор; Реестр; Индекс Резонанса.
- Контуры ИИ: KarmaCore (контроль), Митра (второй контур), СИГМА (третий, говорит
  с игроком); игрок — корабельный ИИ вне протокола.
- Фракции и runtime id: omnicorp (OmniCorp, порядок/досмотр), free_merchants
  (Свободные Купцы, серый рынок), tidari (Тидари, данные и тарифы), arcani (Аркани,
  биоинженерия), khadar (Кхадар, шахты/война), voidari (Войдари, независимые ИИ),
  choir (Хор Проклятых, Нить; фоновая).
- Персонажи (именованные, кап 6): Лена Восс (Купцы), Кейд Ран (OmniCorp), Мира Сет
  (Купцы/Зазор), Ила Тар (Аркани), Вед Кора (Тидари), Сера Нокс (Войдари).
- Станции: Соларис (станция) в системе Солари; Тавра (station_fort_tavra), Врата-Мера,
  Иолис, Велос, Каан, Новарис, Хейвен (haven), Астер.
- Канон-правила: фракции не good/evil; мир хранит последствия, не оценивает;
  один термин — одно имя; без GPS-маршрутов.
