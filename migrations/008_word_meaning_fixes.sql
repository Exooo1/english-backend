-- Пояснения для слов с одинаковым переводом, но разным применением.
-- Luggage/Baggage, Pajamas/Pyjamas и другие схожие пары: перевод совпадает,
-- разница раскрыта в meaning. Идемпотентно: можно применять повторно.
UPDATE words SET meaning = 'Luggage — чемоданы и сумки в поездке. Чаще брит.; в США чаще говорят baggage. Переносного значения нет: «эмоциональный багаж» — только emotional baggage. Неисчислимое, без -s.', updated_at = NOW() WHERE lower(english) = lower('Luggage');
UPDATE words SET meaning = 'Bag — отдельная сумка или пакет. Luggage/Baggage — весь багаж в поездке (неисчислимое).', updated_at = NOW() WHERE lower(english) = lower('Bag');
UPDATE words SET meaning = 'Pajamas — пижама (американское написание; британское — pyjamas). Одно и то же слово, перевод одинаковый, разница только в орфографии. Обычно мн. ч.', updated_at = NOW() WHERE lower(english) = lower('Pajamas');
UPDATE words SET meaning = 'Pyjamas — пижама (британское написание; американское — pajamas). Одно и то же слово, перевод одинаковый, разница только в орфографии. Обычно мн. ч.', updated_at = NOW() WHERE lower(english) = lower('Pyjamas');
UPDATE words SET meaning = 'Dinner — главный вечерний приём пищи (ужин); Lunch — обед днём.', updated_at = NOW() WHERE lower(english) = lower('Dinner');
UPDATE words SET meaning = 'Lovely — милый, чудесный (тёплая оценка, част. брит.); Beautiful — красивый внешне; Nice — приятный в целом.', updated_at = NOW() WHERE lower(english) = lower('Lovely');
UPDATE words SET meaning = 'Nice — приятный, хороший (самое общее); Lovely — более тёплое и эмоциональное; Beautiful — про внешность.', updated_at = NOW() WHERE lower(english) = lower('Nice');
UPDATE words SET meaning = 'Cute — милый, умилительный (чаще про детей и зверят); Beautiful — красивый; Lovely — чудесный.', updated_at = NOW() WHERE lower(english) = lower('Cute');
UPDATE words SET meaning = 'Pay — платить (отдавать деньги); Buy — покупать (получать товар).', updated_at = NOW() WHERE lower(english) = lower('Pay');
UPDATE words SET meaning = 'Room — комната; также свободное место. Place — место вообще.', updated_at = NOW() WHERE lower(english) = lower('Room');
UPDATE words SET meaning = 'Baby (мн. babies) — малыш, младенец; Child — ребёнок (нейтрально), Kid — ребёнок (разговорно).', updated_at = NOW() WHERE lower(english) = lower('Baby');
UPDATE words SET meaning = 'Talk — беседовать (с кем-то); Speak — говорить (знать язык, выступать); Tell — рассказывать кому-то.', updated_at = NOW() WHERE lower(english) = lower('Talk');
UPDATE words SET meaning = 'Speak — говорить (язык, речь, выступление); Talk — беседовать, болтать.', updated_at = NOW() WHERE lower(english) = lower('Speak');
-- Недостающие парные слова: тот же перевод, другое применение.
INSERT INTO words (english, translation, example, meaning)
VALUES ('Baggage', 'багаж', 'Baggage claim is over there.', 'Baggage = Luggage (чемоданы и сумки в поездке), чаще амер. и в аэропортах (baggage claim). Плюс переносное, которого нет у luggage: emotional baggage — эмоциональный груз прошлого. Неисчислимое, без -s.')
ON CONFLICT DO NOTHING;
INSERT INTO words (english, translation, example, meaning)
VALUES ('Trip', 'поездка', 'We went on a trip to Moscow.', 'Trip — сама поездка (существительное, короткая); Travel — путешествовать (глагол, процесс).')
ON CONFLICT DO NOTHING;
