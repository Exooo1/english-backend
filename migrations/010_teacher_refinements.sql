-- Уточнения переводов и пояснений (учительская правка).
-- Baggage/Luggage: только baggage имеет переносное значение «психологический груз»,
-- потому что исторически значило «груз, который несут с собой»; luggage — строго физический.
-- Правки формулировок, е/ё, примеров. Идемпотентно.

-- 1. Переводы.
UPDATE words SET translation = 'ночь', updated_at = NOW() WHERE lower(english) = lower('Night');
UPDATE words SET translation = 'привет, здравствуйте', updated_at = NOW() WHERE lower(english) = lower('Hello');
UPDATE words SET translation = 'тёплый, согревать', updated_at = NOW() WHERE lower(english) = lower('Warm');

-- 2. Baggage/Luggage — точное различие.
UPDATE words SET meaning = 'Baggage — багаж, чемоданы и сумки в поездке; чаще амер., в аэропортах всегда baggage (baggage claim). В отличие от luggage, имеет переносное значение: emotional baggage — психологический груз прошлого, «багаж эмоций». Неисчислимое, без -s.', updated_at = NOW() WHERE lower(english) = lower('Baggage');
UPDATE words SET meaning = 'Luggage — багаж, чемоданы и сумки в поездке; чаще брит. Только физический багаж: переносного значения нет, «эмоциональный багаж» — только emotional baggage. Неисчислимое, без -s.', updated_at = NOW() WHERE lower(english) = lower('Luggage');

-- 3. Правки пояснений.
UPDATE words SET meaning = 'Family — семья; в британском английском глагол может стоять во мн. ч.: my family are coming to visit.', updated_at = NOW() WHERE lower(english) = lower('Family');
UPDATE words SET meaning = 'One — один; также неопределённо-личное местоимение: one must try — нужно стараться.', updated_at = NOW() WHERE lower(english) = lower('One');
UPDATE words SET meaning = 'Meet — встретиться, познакомиться; Know — знать (уже какое-то время).', updated_at = NOW() WHERE lower(english) = lower('Meet');
UPDATE words SET meaning = 'Know — знать; Meet — встретиться, познакомиться.', updated_at = NOW() WHERE lower(english) = lower('Know');
UPDATE words SET meaning = 'Study — учиться, изучать (процесс); Learn — узнавать, выучивать (результат).', updated_at = NOW() WHERE lower(english) = lower('Study');
UPDATE words SET meaning = 'Learn — узнавать, выучивать; Study — учиться, изучать (процесс).', updated_at = NOW() WHERE lower(english) = lower('Learn');
UPDATE words SET meaning = 'Bill — счёт (в ресторане); купюра (амер.; в Британии купюра — note).', updated_at = NOW() WHERE lower(english) = lower('Bill');
UPDATE words SET meaning = 'Temperature — температура; Have a temperature — иметь повышенную температуру.', updated_at = NOW() WHERE lower(english) = lower('Temperature');
UPDATE words SET meaning = 'Hot — горячий; Warm — тёплый.', updated_at = NOW() WHERE lower(english) = lower('Hot');
UPDATE words SET meaning = 'Warm — тёплый; Hot — горячий.', updated_at = NOW() WHERE lower(english) = lower('Warm');
UPDATE words SET meaning = 'Home — место, где живёшь; House — здание как строение.', updated_at = NOW() WHERE lower(english) = lower('Home');
UPDATE words SET meaning = 'Cold — холодный; простуда: catch a cold — простудиться.', updated_at = NOW() WHERE lower(english) = lower('Cold');
UPDATE words SET meaning = 'Hospital — больница; In hospital — в больнице (на лечении, брит. без the; амер. — in the hospital).', updated_at = NOW() WHERE lower(english) = lower('Hospital');
UPDATE words SET meaning = 'Weekend — выходные; At the weekend — на выходных (брит.; амер. — on the weekend).', updated_at = NOW() WHERE lower(english) = lower('Weekend');
