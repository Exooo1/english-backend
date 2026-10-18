-- Ревизия всех слов: удаление дубликатов, исправление переводов и примеров,
-- заполнение пустых пояснений (meaning) для всех слов. Идемпотентно.

-- 1. Нормализация пробелов.
UPDATE words SET english = trim(english), translation = trim(translation),
  example = trim(example), meaning = trim(meaning)
WHERE english <> trim(english) OR translation <> trim(translation)
   OR example <> trim(example) OR meaning <> trim(meaning);

-- 2. Дубликаты: Pyjamas = Pajamas (брит./амер. написание одного слова).
-- Оставляем Pajamas, удаляем Pyjamas.
DELETE FROM words WHERE lower(english) = lower('Pyjamas');

-- 3. Исправление переводов.
UPDATE words SET translation = 'фирма, твёрдый, крепкий', updated_at = NOW() WHERE lower(english) = lower('Firm');
UPDATE words SET translation = 'пальто, куртка', updated_at = NOW() WHERE lower(english) = lower('Coat');
UPDATE words SET translation = 'сумка, пакет', updated_at = NOW() WHERE lower(english) = lower('Bag');
UPDATE words SET translation = 'глава, раздел, часть, отделение, филиал, период', updated_at = NOW() WHERE lower(english) = lower('Chapter');
UPDATE words SET translation = 'ребёнок, дитя', updated_at = NOW() WHERE lower(english) = lower('Child');
UPDATE words SET translation = 'ребёнок, малыш; шутить, подшучивать', updated_at = NOW() WHERE lower(english) = lower('Kid');
UPDATE words SET translation = 'занятый', updated_at = NOW() WHERE lower(english) = lower('Busy');

-- 4. Исправление примеров.
UPDATE words SET example = 'Hello, how are you?', updated_at = NOW() WHERE lower(english) = lower('Hello');
UPDATE words SET example = 'Read the first chapter of the book.', updated_at = NOW() WHERE lower(english) = lower('Chapter');
UPDATE words SET example = 'Answer the question, please.', updated_at = NOW() WHERE lower(english) = lower('Answer');

-- 5. Исправление пояснений.
UPDATE words SET meaning = 'Pajamas — пижама (американское написание; британское — pyjamas). Разница только в орфографии. Обычно мн. ч.', updated_at = NOW() WHERE lower(english) = lower('Pajamas');
UPDATE words SET meaning = 'Thank — благодарить; Thanks — разговорная форма «спасибо».', updated_at = NOW() WHERE lower(english) = lower('Thank');
UPDATE words SET meaning = 'Firm — фирма (существительное); твёрдый, крепкий (прилагательное): a firm mattress.', updated_at = NOW() WHERE lower(english) = lower('Firm');
UPDATE words SET meaning = 'Bag — отдельная сумка или пакет. Luggage/Baggage — весь багаж в поездке (неисчислимое).', updated_at = NOW() WHERE lower(english) = lower('Bag');

-- 6. Исправление пояснения в выражениях.
UPDATE expressions SET meaning = 'Усилитель после глагола: I like it very much — мне это очень нравится. I love you very much — я тебя очень люблю.', updated_at = NOW() WHERE lower(english) = lower('Very much');

-- 7. Единообразное написание «ребёнок» в пояснениях.
UPDATE words SET meaning = 'Child (мн. children) — ребёнок; Kid — разговорное «ребёнок».', updated_at = NOW() WHERE lower(english) = lower('Child');
UPDATE words SET meaning = 'Kid — разговорное «ребёнок»; Child — нейтральное.', updated_at = NOW() WHERE lower(english) = lower('Kid');
UPDATE words SET meaning = 'Baby (мн. babies) — малыш, младенец; Child — ребёнок (нейтрально), Kid — ребёнок (разговорно).', updated_at = NOW() WHERE lower(english) = lower('Baby');

-- 8. Заполнение пустых пояснений для всех слов.
UPDATE words SET meaning = 'Hello — привет, здравствуйте; Hi — более неформально.', updated_at = NOW() WHERE lower(english) = lower('Hello');
UPDATE words SET meaning = 'Chapter — глава (книги), раздел; также отделение, филиал и период (глава жизни).', updated_at = NOW() WHERE lower(english) = lower('Chapter');
UPDATE words SET meaning = 'Sunny — солнечный (о погоде); Sun — солнце.', updated_at = NOW() WHERE lower(english) = lower('Sunny');
UPDATE words SET meaning = 'Wall — стена; Fence — забор.', updated_at = NOW() WHERE lower(english) = lower('Wall');
UPDATE words SET meaning = 'Toy — игрушка; мн. ч. toys.', updated_at = NOW() WHERE lower(english) = lower('Toy');
UPDATE words SET meaning = 'Family — семья; в британском английском может сочетаться с глаголом во мн. ч. (my family are big).', updated_at = NOW() WHERE lower(english) = lower('Family');
UPDATE words SET meaning = 'First — первый по порядку; First of all — прежде всего.', updated_at = NOW() WHERE lower(english) = lower('First');
UPDATE words SET meaning = 'Third — третий; порядковое числительное от three.', updated_at = NOW() WHERE lower(english) = lower('Third');
UPDATE words SET meaning = 'Dog — собака; Puppy — щенок.', updated_at = NOW() WHERE lower(english) = lower('Dog');
UPDATE words SET meaning = 'Kennel — конура, будка собаки; также питомник для собак.', updated_at = NOW() WHERE lower(english) = lower('Kennel');
UPDATE words SET meaning = 'Party — вечеринка, праздник; также политическая партия.', updated_at = NOW() WHERE lower(english) = lower('Party');
UPDATE words SET meaning = 'One — один; также безличное местоимение «человек»: one must try.', updated_at = NOW() WHERE lower(english) = lower('One');
UPDATE words SET meaning = 'Name — имя, название; First name — имя, Last name — фамилия.', updated_at = NOW() WHERE lower(english) = lower('Name');
UPDATE words SET meaning = 'Tea — чай (неисчислимое); Make tea — заваривать чай.', updated_at = NOW() WHERE lower(english) = lower('Tea');
UPDATE words SET meaning = 'Coffee — кофе (неисчислимое); A cup of coffee — чашка кофе.', updated_at = NOW() WHERE lower(english) = lower('Coffee');
UPDATE words SET meaning = 'Quarter — четверть; также четверть часа: a quarter to five — без четверти пять.', updated_at = NOW() WHERE lower(english) = lower('Quarter');
UPDATE words SET meaning = 'Bathroom — ванная; в американском английском также туалет.', updated_at = NOW() WHERE lower(english) = lower('Bathroom');
UPDATE words SET meaning = 'Water — вода (неисчислимое, без -s); глагол — поливать.', updated_at = NOW() WHERE lower(english) = lower('Water');
UPDATE words SET meaning = 'Paw — лапа животного (с когтями); Hand — рука человека.', updated_at = NOW() WHERE lower(english) = lower('Paw');
UPDATE words SET meaning = 'Check — проверять; также чек (счёт в ресторане) и галочка.', updated_at = NOW() WHERE lower(english) = lower('Check');
UPDATE words SET meaning = 'Temperature — температура; Have a temperature — температурить.', updated_at = NOW() WHERE lower(english) = lower('Temperature');
UPDATE words SET meaning = 'Perfect — идеальный; Perfectly — идеально.', updated_at = NOW() WHERE lower(english) = lower('Perfect');
UPDATE words SET meaning = 'Now — сейчас; Right now — прямо сейчас.', updated_at = NOW() WHERE lower(english) = lower('Now');
UPDATE words SET meaning = 'Ready — готовый; Be ready for — быть готовым к чему-то.', updated_at = NOW() WHERE lower(english) = lower('Ready');
UPDATE words SET meaning = 'Smile — улыбаться, улыбка; Smile at someone — улыбнуться кому-то.', updated_at = NOW() WHERE lower(english) = lower('Smile');
UPDATE words SET meaning = 'Wag — вилять (хвостом), махать; Wag the tail — вилять хвостом.', updated_at = NOW() WHERE lower(english) = lower('Wag');
UPDATE words SET meaning = 'Tail — хвост; Tale — сказка (созвучно, но пишется иначе).', updated_at = NOW() WHERE lower(english) = lower('Tail');
UPDATE words SET meaning = 'Cat — кот, кошка; Kitten — котёнок.', updated_at = NOW() WHERE lower(english) = lower('Cat');
UPDATE words SET meaning = 'Morning — утро; In the morning — утром.', updated_at = NOW() WHERE lower(english) = lower('Morning');
UPDATE words SET meaning = 'Milk — молоко (неисчислимое, без -s).', updated_at = NOW() WHERE lower(english) = lower('Milk');
UPDATE words SET meaning = 'Station — станция, вокзал; Railway station — железнодорожный вокзал.', updated_at = NOW() WHERE lower(english) = lower('Station');
UPDATE words SET meaning = 'Car — машина, автомобиль; By car — на машине.', updated_at = NOW() WHERE lower(english) = lower('Car');
UPDATE words SET meaning = 'Day — день, сутки; All day — весь день.', updated_at = NOW() WHERE lower(english) = lower('Day');
UPDATE words SET meaning = 'Doctor — врач; See a doctor — сходить к врачу.', updated_at = NOW() WHERE lower(english) = lower('Doctor');
UPDATE words SET meaning = 'Bus — автобус; By bus — на автобусе.', updated_at = NOW() WHERE lower(english) = lower('Bus');
UPDATE words SET meaning = 'Cup — чашка; A cup of tea — чашка чая.', updated_at = NOW() WHERE lower(english) = lower('Cup');
UPDATE words SET meaning = 'Shirt — рубашка; T-shirt — футболка.', updated_at = NOW() WHERE lower(english) = lower('Shirt');
UPDATE words SET meaning = 'Phone — телефон, звонить; On the phone — по телефону.', updated_at = NOW() WHERE lower(english) = lower('Phone');
UPDATE words SET meaning = 'Door — дверь; Open the door — открыть дверь.', updated_at = NOW() WHERE lower(english) = lower('Door');
UPDATE words SET meaning = 'Hotel — отель, гостиница; Stay at a hotel — остановиться в отеле.', updated_at = NOW() WHERE lower(english) = lower('Hotel');
UPDATE words SET meaning = 'Apple — яблоко; Apple pie — яблочный пирог.', updated_at = NOW() WHERE lower(english) = lower('Apple');
UPDATE words SET meaning = 'Food — еда, пища (неисчислимое, без -s).', updated_at = NOW() WHERE lower(english) = lower('Food');
UPDATE words SET meaning = 'Engineer — инженер; Engine — двигатель, мотор.', updated_at = NOW() WHERE lower(english) = lower('Engineer');
UPDATE words SET meaning = 'Hour — час; Half an hour — полчаса.', updated_at = NOW() WHERE lower(english) = lower('Hour');
UPDATE words SET meaning = 'Sun — солнце; Sunshine — солнечный свет.', updated_at = NOW() WHERE lower(english) = lower('Sun');
UPDATE words SET meaning = 'Music — музыка (неисчислимое, без -s).', updated_at = NOW() WHERE lower(english) = lower('Music');
UPDATE words SET meaning = 'Breakfast — завтрак; Have breakfast — завтракать.', updated_at = NOW() WHERE lower(english) = lower('Breakfast');
UPDATE words SET meaning = 'Boy — мальчик; Girl — девочка.', updated_at = NOW() WHERE lower(english) = lower('Boy');
UPDATE words SET meaning = 'Brother — брат; Sister — сестра.', updated_at = NOW() WHERE lower(english) = lower('Brother');
UPDATE words SET meaning = 'Ticket — билет; Book a ticket — заказать билет.', updated_at = NOW() WHERE lower(english) = lower('Ticket');
UPDATE words SET meaning = 'University — университет; At university — в университете (брит., без the).', updated_at = NOW() WHERE lower(english) = lower('University');
UPDATE words SET meaning = 'Box — коробка, ящик; Mailbox — почтовый ящик.', updated_at = NOW() WHERE lower(english) = lower('Box');
UPDATE words SET meaning = 'Coat — пальто, куртка; Jacket — пиджак, лёгкая куртка.', updated_at = NOW() WHERE lower(english) = lower('Coat');
UPDATE words SET meaning = 'Chair — стул; Armchair — кресло.', updated_at = NOW() WHERE lower(english) = lower('Chair');
UPDATE words SET meaning = 'Key — ключ, клавиша; Key to the door — ключ от двери.', updated_at = NOW() WHERE lower(english) = lower('Key');
UPDATE words SET meaning = 'Drink — пить; напиток. Прошедшее время — drank.', updated_at = NOW() WHERE lower(english) = lower('Drink');
UPDATE words SET meaning = 'Son — сын; Daughter — дочь.', updated_at = NOW() WHERE lower(english) = lower('Son');
UPDATE words SET meaning = 'Hospital — больница; In hospital — в больнице (брит., без the).', updated_at = NOW() WHERE lower(english) = lower('Hospital');
UPDATE words SET meaning = 'Class — класс (группа), урок; Classroom — кабинет, классная комната.', updated_at = NOW() WHERE lower(english) = lower('Class');
UPDATE words SET meaning = 'Window — окно; Open the window — открыть окно.', updated_at = NOW() WHERE lower(english) = lower('Window');
UPDATE words SET meaning = 'Umbrella — зонт (от дождя).', updated_at = NOW() WHERE lower(english) = lower('Umbrella');
UPDATE words SET meaning = 'Girl — девочка, девушка; Boy — мальчик.', updated_at = NOW() WHERE lower(english) = lower('Girl');
UPDATE words SET meaning = 'Bird — птица; Birds sing — птицы поют.', updated_at = NOW() WHERE lower(english) = lower('Bird');
UPDATE words SET meaning = 'Horse — лошадь; Ride a horse — ездить верхом.', updated_at = NOW() WHERE lower(english) = lower('Horse');
UPDATE words SET meaning = 'Meeting — встреча, собрание; Have a meeting — проводить встречу.', updated_at = NOW() WHERE lower(english) = lower('Meeting');
UPDATE words SET meaning = 'Word — слово; In other words — другими словами.', updated_at = NOW() WHERE lower(english) = lower('Word');
UPDATE words SET meaning = 'Card — карта, открытка; Credit card — кредитная карта.', updated_at = NOW() WHERE lower(english) = lower('Card');
UPDATE words SET meaning = 'Office — офис; Office worker — офисный работник.', updated_at = NOW() WHERE lower(english) = lower('Office');
UPDATE words SET meaning = 'School — школа; At school — в школе (без the).', updated_at = NOW() WHERE lower(english) = lower('School');
UPDATE words SET meaning = 'Eye — глаз; мн. ч. eyes.', updated_at = NOW() WHERE lower(english) = lower('Eye');
UPDATE words SET meaning = 'Friend — друг; Best friend — лучший друг.', updated_at = NOW() WHERE lower(english) = lower('Friend');
UPDATE words SET meaning = 'Tree — дерево; Forest — лес.', updated_at = NOW() WHERE lower(english) = lower('Tree');
UPDATE words SET meaning = 'Song — песня; Sing a song — петь песню.', updated_at = NOW() WHERE lower(english) = lower('Song');
UPDATE words SET meaning = 'Computer — компьютер; Work on the computer — работать за компьютером.', updated_at = NOW() WHERE lower(english) = lower('Computer');
UPDATE words SET meaning = 'Knee — колено; мн. ч. knees.', updated_at = NOW() WHERE lower(english) = lower('Knee');
UPDATE words SET meaning = 'Wrist — запястье; Watch on the wrist — часы на запястье.', updated_at = NOW() WHERE lower(english) = lower('Wrist');
UPDATE words SET meaning = 'Sandwich — сэндвич, бутерброд; Make a sandwich — сделать сэндвич.', updated_at = NOW() WHERE lower(english) = lower('Sandwich');
UPDATE words SET meaning = 'Pound — фунт стерлингов (деньги Британии); также мера веса (около 454 граммов).', updated_at = NOW() WHERE lower(english) = lower('Pound');
UPDATE words SET meaning = 'Weather — погода (неисчислимое); Weather forecast — прогноз погоды.', updated_at = NOW() WHERE lower(english) = lower('Weather');
UPDATE words SET meaning = 'Problem — проблема, задача; No problem — без проблем.', updated_at = NOW() WHERE lower(english) = lower('Problem');
UPDATE words SET meaning = 'Violin — скрипка; Play the violin — играть на скрипке.', updated_at = NOW() WHERE lower(english) = lower('Violin');
UPDATE words SET meaning = 'Daughter — дочь; Son — сын.', updated_at = NOW() WHERE lower(english) = lower('Daughter');
UPDATE words SET meaning = 'Bedroom — спальня; Living room — гостиная.', updated_at = NOW() WHERE lower(english) = lower('Bedroom');
UPDATE words SET meaning = 'Pair — пара; A pair of shoes — пара обуви.', updated_at = NOW() WHERE lower(english) = lower('Pair');
UPDATE words SET meaning = 'Passport — паспорт; Passport control — паспортный контроль.', updated_at = NOW() WHERE lower(english) = lower('Passport');
UPDATE words SET meaning = 'Park — парк; глагол — парковаться: park a car.', updated_at = NOW() WHERE lower(english) = lower('Park');
UPDATE words SET meaning = 'Rain — дождь; глагол — идти (о дожде): It is raining.', updated_at = NOW() WHERE lower(english) = lower('Rain');
UPDATE words SET meaning = 'Sister — сестра; Brother — брат.', updated_at = NOW() WHERE lower(english) = lower('Sister');
UPDATE words SET meaning = 'Glass — стакан; стекло (неисчислимое); Glasses — очки.', updated_at = NOW() WHERE lower(english) = lower('Glass');
UPDATE words SET meaning = 'Egg — яйцо; Fried egg — жареное яйцо.', updated_at = NOW() WHERE lower(english) = lower('Egg');
UPDATE words SET meaning = 'Ice — лёд (неисчислимое); Ice cream — мороженое.', updated_at = NOW() WHERE lower(english) = lower('Ice');
UPDATE words SET meaning = 'Juice — сок (обычно неисчислимое); Orange juice — апельсиновый сок.', updated_at = NOW() WHERE lower(english) = lower('Juice');
UPDATE words SET meaning = 'Nose — нос; Blow your nose — высморкаться.', updated_at = NOW() WHERE lower(english) = lower('Nose');
UPDATE words SET meaning = 'Queen — королева; King — король.', updated_at = NOW() WHERE lower(english) = lower('Queen');
UPDATE words SET meaning = 'Ray — луч; A ray of sun — луч солнца.', updated_at = NOW() WHERE lower(english) = lower('Ray');
UPDATE words SET meaning = 'Zoo — зоопарк; Go to the zoo — сходить в зоопарк.', updated_at = NOW() WHERE lower(english) = lower('Zoo');
UPDATE words SET meaning = 'Cheese — сыр (обычно неисчислимое); A piece of cheese — кусок сыра.', updated_at = NOW() WHERE lower(english) = lower('Cheese');
UPDATE words SET meaning = 'Elephant — слон.', updated_at = NOW() WHERE lower(english) = lower('Elephant');
UPDATE words SET meaning = 'Lamb — ягнёнок; также мясо ягнёнка (ягнятина).', updated_at = NOW() WHERE lower(english) = lower('Lamb');
UPDATE words SET meaning = 'Address — адрес; глагол — обращаться; What is your address? — какой у тебя адрес?', updated_at = NOW() WHERE lower(english) = lower('Address');
UPDATE words SET meaning = 'Bill — счёт (в ресторане), купюра; Pay the bill — оплатить счёт.', updated_at = NOW() WHERE lower(english) = lower('Bill');
UPDATE words SET meaning = 'Traffic — движение транспорта, трафик (неисчислимое); Traffic jam — пробка.', updated_at = NOW() WHERE lower(english) = lower('Traffic');
UPDATE words SET meaning = 'Minute — минута; In a minute — через минуту.', updated_at = NOW() WHERE lower(english) = lower('Minute');
UPDATE words SET meaning = 'Board — доска; On board — на борту (корабля, самолёта).', updated_at = NOW() WHERE lower(english) = lower('Board');
UPDATE words SET meaning = 'Weekend — выходные; At the weekend — на выходных (брит.).', updated_at = NOW() WHERE lower(english) = lower('Weekend');
UPDATE words SET meaning = 'Direction — направление; Ask for directions — спросить дорогу.', updated_at = NOW() WHERE lower(english) = lower('Direction');
UPDATE words SET meaning = 'Degree — градус; степень (научная): a degree in law.', updated_at = NOW() WHERE lower(english) = lower('Degree');
UPDATE words SET meaning = 'Shoe — туфля, ботинок; A pair of shoes — пара обуви.', updated_at = NOW() WHERE lower(english) = lower('Shoe');
UPDATE words SET meaning = 'Husband — муж; Wife — жена.', updated_at = NOW() WHERE lower(english) = lower('Husband');
UPDATE words SET meaning = 'Grandfather — дедушка; Grandmother — бабушка.', updated_at = NOW() WHERE lower(english) = lower('Grandfather');
UPDATE words SET meaning = 'Uncle — дядя; Aunt — тётя.', updated_at = NOW() WHERE lower(english) = lower('Uncle');
UPDATE words SET meaning = 'Cousin — двоюродный брат или двоюродная сестра (одно слово для обоих полов).', updated_at = NOW() WHERE lower(english) = lower('Cousin');
UPDATE words SET meaning = 'Towel — полотенце; Bath towel — банное полотенце.', updated_at = NOW() WHERE lower(english) = lower('Towel');
UPDATE words SET meaning = 'Size — размер; What size are you? — какой у тебя размер?', updated_at = NOW() WHERE lower(english) = lower('Size');
UPDATE words SET meaning = 'Health — здоровье (неисчислимое); Healthy — здоровый.', updated_at = NOW() WHERE lower(english) = lower('Health');
UPDATE words SET meaning = 'Dentist — стоматолог; Go to the dentist — сходить к стоматологу.', updated_at = NOW() WHERE lower(english) = lower('Dentist');
UPDATE words SET meaning = 'Hobby — хобби, увлечение; мн. ч. hobbies.', updated_at = NOW() WHERE lower(english) = lower('Hobby');
UPDATE words SET meaning = 'Late — поздний, опоздавший; Be late for school — опоздать в школу.', updated_at = NOW() WHERE lower(english) = lower('Late');
UPDATE words SET meaning = 'Red — красный; Red light — красный свет светофора.', updated_at = NOW() WHERE lower(english) = lower('Red');
UPDATE words SET meaning = 'Black — чёрный; Black tea — чёрный чай.', updated_at = NOW() WHERE lower(english) = lower('Black');
UPDATE words SET meaning = 'Blue — синий, голубой; Feeling blue — грустный (идиома).', updated_at = NOW() WHERE lower(english) = lower('Blue');
UPDATE words SET meaning = 'Green — зелёный; Green light — зелёный свет.', updated_at = NOW() WHERE lower(english) = lower('Green');
UPDATE words SET meaning = 'Cheap — дешёвый; Expensive — дорогой.', updated_at = NOW() WHERE lower(english) = lower('Cheap');
UPDATE words SET meaning = 'Early — ранний, рано; Get up early — рано вставать.', updated_at = NOW() WHERE lower(english) = lower('Early');
UPDATE words SET meaning = 'Short — короткий, низкий (о росте); Long — длинный.', updated_at = NOW() WHERE lower(english) = lower('Short');
UPDATE words SET meaning = 'Wooden — деревянный; Wood — дерево (материал).', updated_at = NOW() WHERE lower(english) = lower('Wooden');
UPDATE words SET meaning = 'Brown — коричневый; Brown hair — каштановые волосы.', updated_at = NOW() WHERE lower(english) = lower('Brown');
UPDATE words SET meaning = 'White — белый; White wine — белое вино.', updated_at = NOW() WHERE lower(english) = lower('White');
UPDATE words SET meaning = 'Clean — чистый; чистить; Dirty — грязный.', updated_at = NOW() WHERE lower(english) = lower('Clean');
UPDATE words SET meaning = 'Sure — уверенный, конечно; Make sure — убедиться.', updated_at = NOW() WHERE lower(english) = lower('Sure');
UPDATE words SET meaning = 'Help — помогать, помощь; Help with — помогать с чем-то.', updated_at = NOW() WHERE lower(english) = lower('Help');
UPDATE words SET meaning = 'Write — писать; Write down — записывать.', updated_at = NOW() WHERE lower(english) = lower('Write');
UPDATE words SET meaning = 'Stop — останавливать, остановка; Stop doing — перестать делать.', updated_at = NOW() WHERE lower(english) = lower('Stop');
UPDATE words SET meaning = 'Swim — плавать; Go swimming — пойти поплавать.', updated_at = NOW() WHERE lower(english) = lower('Swim');
UPDATE words SET meaning = 'Understand — понимать; Make yourself understood — объясниться.', updated_at = NOW() WHERE lower(english) = lower('Understand');
UPDATE words SET meaning = 'Answer — отвечать, ответ; Answer the question — ответить на вопрос.', updated_at = NOW() WHERE lower(english) = lower('Answer');
UPDATE words SET meaning = 'Fly — летать; также муха; Fly to Moscow — лететь в Москву.', updated_at = NOW() WHERE lower(english) = lower('Fly');
UPDATE words SET meaning = 'Worry — беспокоиться; Worry about — беспокоиться о; Do not worry — не беспокойся.', updated_at = NOW() WHERE lower(english) = lower('Worry');
UPDATE words SET meaning = 'Eat — есть, кушать; Have breakfast — завтракать.', updated_at = NOW() WHERE lower(english) = lower('Eat');
UPDATE words SET meaning = 'Return — возвращаться, возвращать; Return home — вернуться домой.', updated_at = NOW() WHERE lower(english) = lower('Return');
UPDATE words SET meaning = 'Wash — мыть; Wash up — мыть посуду.', updated_at = NOW() WHERE lower(english) = lower('Wash');
UPDATE words SET meaning = 'Cut — резать; формы одинаковые: cut — cut — cut.', updated_at = NOW() WHERE lower(english) = lower('Cut');
UPDATE words SET meaning = 'Smoke — курить; дым; No smoking — курить запрещено.', updated_at = NOW() WHERE lower(english) = lower('Smoke');
UPDATE words SET meaning = 'Run — бегать; прошедшее время — ran.', updated_at = NOW() WHERE lower(english) = lower('Run');
UPDATE words SET meaning = 'Visit — посещать, визит; Visit friends — навестить друзей.', updated_at = NOW() WHERE lower(english) = lower('Visit');
UPDATE words SET meaning = 'Cry — плакать; Cry for help — звать на помощь.', updated_at = NOW() WHERE lower(english) = lower('Cry');
UPDATE words SET meaning = 'Boil — кипятить, кипеть; Boiled water — кипячёная вода.', updated_at = NOW() WHERE lower(english) = lower('Boil');
UPDATE words SET meaning = 'Open — открывать, открытый; Close — закрывать.', updated_at = NOW() WHERE lower(english) = lower('Open');
UPDATE words SET meaning = 'Today — сегодня; Yesterday — вчера; Tomorrow — завтра.', updated_at = NOW() WHERE lower(english) = lower('Today');
UPDATE words SET meaning = 'Yesterday — вчера; The day before yesterday — позавчера.', updated_at = NOW() WHERE lower(english) = lower('Yesterday');
UPDATE words SET meaning = 'Tomorrow — завтра; See you tomorrow — до завтра.', updated_at = NOW() WHERE lower(english) = lower('Tomorrow');
UPDATE words SET meaning = 'Usually — обычно; стоит перед смысловым глаголом: I usually walk.', updated_at = NOW() WHERE lower(english) = lower('Usually');
UPDATE words SET meaning = 'Always — всегда; стоит перед смысловым глаголом: She always sings.', updated_at = NOW() WHERE lower(english) = lower('Always');
UPDATE words SET meaning = 'Never — никогда; глагол в утвердительной форме: I never smoke.', updated_at = NOW() WHERE lower(english) = lower('Never');
UPDATE words SET meaning = 'Sometimes — иногда; стоит в начале или в конце предложения.', updated_at = NOW() WHERE lower(english) = lower('Sometimes');
UPDATE words SET meaning = 'Often — часто; How often? — как часто?', updated_at = NOW() WHERE lower(english) = lower('Often');
UPDATE words SET meaning = 'Thirsty — испытывающий жажду; Be thirsty — хотеть пить.', updated_at = NOW() WHERE lower(english) = lower('Thirsty');
UPDATE words SET meaning = 'Busy — занятый; Be busy with — быть занятым чем-то.', updated_at = NOW() WHERE lower(english) = lower('Busy');
UPDATE words SET meaning = 'Cloudy — облачный; It is cloudy — облачно.', updated_at = NOW() WHERE lower(english) = lower('Cloudy');
UPDATE words SET meaning = 'Windy — ветреный; It is windy — ветрено.', updated_at = NOW() WHERE lower(english) = lower('Windy');
UPDATE words SET meaning = 'Daily — ежедневный, ежедневно; Every day — каждый день.', updated_at = NOW() WHERE lower(english) = lower('Daily');
UPDATE words SET meaning = 'Use — использовать; Useful — полезный.', updated_at = NOW() WHERE lower(english) = lower('Use');
UPDATE words SET meaning = 'Mean — значить, иметь в виду; What do you mean? — что ты имеешь в виду?', updated_at = NOW() WHERE lower(english) = lower('Mean');
UPDATE words SET meaning = 'Welcome — добро пожаловать; You are welcome — пожалуйста (в ответ на спасибо).', updated_at = NOW() WHERE lower(english) = lower('Welcome');
