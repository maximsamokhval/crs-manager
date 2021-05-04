#Использовать asserts
#Использовать sql

Перем юТест;
Перем мСтрокаСоединения;

Функция ПолучитьТекстИзФайла(ИмяФайла)
    ФайлОбмена = Новый Файл(ИмяФайла);
    Данные = "";
    Если ФайлОбмена.Существует() Тогда
        Текст = Новый ЧтениеТекста(ИмяФайла, КодировкаТекста.UTF8);
        Данные = Текст.Прочитать();
        Текст.Закрыть();
    Иначе
        Возврат Ложь;
    КонецЕсли;
    возврат Данные;
КонецФункции

Процедура Инициализация()
КонецПроцедуры

Функция ПолучитьСписокТестов(Тестирование) Экспорт

	СуфикМетодов = "";
	мСтрокаСоединения = ПолучитьТекстИзФайла("fixtures\pgsql-con-str.txt");
	Если мСтрокаСоединения = Ложь Тогда
		СуфикМетодов = "НетПараметровСоединения";
	КонецЕсли;


	юТест = Тестирование;

	СписокТестов = Новый Массив;
	СписокТестов.Добавить("Тест_Должен_ПроверитьГенерациюСтрокиСоединения");
	СписокТестов.Добавить("Тест_Должен_СоздатьТаблицу" + СуфикМетодов);
	СписокТестов.Добавить("Тест_Должен_ДобавитьСтроки" + СуфикМетодов);
	СписокТестов.Добавить("Тест_Должен_ДолженИзменитьСтроки" + СуфикМетодов);
	СписокТестов.Добавить("Тест_Должен_ДолженПолучитьВыборку" + СуфикМетодов);

	Возврат СписокТестов;

КонецФункции

Процедура Тест_Должен_ПроверитьГенерациюСтрокиСоединения() Экспорт
	
	Соединение = Новый Соединение();
	Соединение.ТипСУБД = Соединение.ТипыСУБД.PostgreSQL;
	Соединение.Сервер = "localhost";
	Соединение.ИмяПользователя = "postgres";
	Соединение.ИмяБазы = "test";
	Соединение.Пароль = "testpassword";
	Соединение.Порт = 3306;

	Попытка
		/// Заведомо известно падение при открытии.
		/// Строка соединения генерируется только при открытии
		Соединение.Открыть();
	Исключение
		Ожидаем.Что(Соединение.СтрокаСоединения).Равно("Host=localhost;Username=postgres;Password=testpassword;Database=test;port=3306;");
	КонецПопытки;
	

КонецПроцедуры

Процедура Тест_Должен_СоздатьТаблицу() Экспорт
	
	Соединение = Новый Соединение();
	Соединение.ТипСУБД = Соединение.ТипыСУБД.PostgreSQL;
	Соединение.СтрокаСоединения = мСтрокаСоединения;
	Соединение.Открыть();

	ЗапросВставка = Новый Запрос();
	ЗапросВставка.УстановитьСоединение(Соединение);

	ЗапросВставка.Текст = "DROP TABLE IF EXISTS users";
	ЗапросВставка.ВыполнитьКоманду();

	ЗапросВставка.Текст = "Create table users (id integer, title varchar(50))";
	ЗапросВставка.ВыполнитьКоманду();
	
	Соединение.Закрыть();

КонецПроцедуры

Процедура Тест_Должен_ДобавитьСтроки() Экспорт

	Соединение = Новый Соединение();
	Соединение.ТипСУБД = Соединение.ТипыСУБД.PostgreSQL;
	Соединение.СтрокаСоединения = мСтрокаСоединения;
	Соединение.Открыть();

	ЗапросВставка = Новый Запрос();
	ЗапросВставка.УстановитьСоединение(Соединение);

	ЗапросВставка.Текст = "DROP TABLE IF EXISTS testdata";
	ЗапросВставка.ВыполнитьКоманду();
		
	ЗапросВставка.Текст = "Create table testdata (userlogin varchar(50))";
	ЗапросВставка.ВыполнитьКоманду();

	ЗапросВставка.Текст = "INSERT INTO testdata (userlogin) VALUES (@value1)";
	ЗапросВставка.УстановитьПараметр("value1", "Tom&jerry");
	Результат = ЗапросВставка.ВыполнитьКоманду();

	Соединение.Закрыть();

	Ожидаем.Что(Результат).Равно(1);

КонецПроцедуры

Процедура Тест_Должен_ДолженИзменитьСтроки() Экспорт
	
	Соединение = Новый Соединение();
	Соединение.ТипСУБД = Соединение.ТипыСУБД.PostgreSQL;
	Соединение.СтрокаСоединения = мСтрокаСоединения;
	Соединение.Открыть();

	ЗапросВставка = Новый Запрос();
	ЗапросВставка.УстановитьСоединение(Соединение);

	ЗапросВставка.Текст = "DROP TABLE IF EXISTS users1";
	ЗапросВставка.ВыполнитьКоманду();

	ЗапросВставка.Текст = "Create table users1 (id integer, name varchar(50), born date, isadmin bool)";
	ЗапросВставка.ВыполнитьКоманду();

	ЗапросВставка.Текст = "insert into users1 (id, name, born, isadmin) values(@id, @name, @born, @isadmin)";
	ЗапросВставка.УстановитьПараметр("id", 1);
	ЗапросВставка.УстановитьПараметр("isadmin", Истина);
	ЗапросВставка.УстановитьПараметр("name", "Сергей");
	ЗапросВставка.УстановитьПараметр("born", Дата(1980,9,13));
	ЗапросВставка.ВыполнитьКоманду();

	ЗапросВставка.Текст = "update users1 set name = @name";
	ЗапросВставка.УстановитьПараметр("name", "Сергей Александрович");
	Результат = ЗапросВставка.ВыполнитьКоманду();

	Соединение.Закрыть();

	Ожидаем.Что(Результат).Равно(1);

КонецПроцедуры


Процедура Тест_Должен_ДолженПолучитьВыборку() Экспорт

	Соединение = Новый Соединение();
	Соединение.ТипСУБД = Соединение.ТипыСУБД.PostgreSQL;
	Соединение.СтрокаСоединения = мСтрокаСоединения;
	Соединение.Открыть();

	ЗапросВставка = Новый Запрос();
	ЗапросВставка.УстановитьСоединение(Соединение);

	ЗапросВставка.Текст = "DROP TABLE IF EXISTS users";
	ЗапросВставка.ВыполнитьКоманду();

	ЗапросВставка.Текст = "Create table users (id integer, title varchar(50))";
	ЗапросВставка.ВыполнитьКоманду();

	ЗапросВставка.Текст = "insert into users (id, title) values(@id, @title)";
	ЗапросВставка.УстановитьПараметр("id", 1);
	ЗапросВставка.УстановитьПараметр("title", "Сергей");
	ЗапросВставка.ВыполнитьКоманду();

	ЗапросВставка.Текст = "insert into users (id, title) values(@id, @title)";
	ЗапросВставка.УстановитьПараметр("id", 2);
	ЗапросВставка.УстановитьПараметр("title", "Оксана");
	ЗапросВставка.ВыполнитьКоманду();

	ЗапросВставка.Параметры.Очистить();
	ЗапросВставка.Текст = "select * from users where id = @newid";
	ЗапросВставка.УстановитьПараметр("newid", 1);
	ТЗ = ЗапросВставка.Выполнить().Выгрузить();

	Ожидаем.Что(ТЗ.Количество()).Равно(1);

	Соединение.Закрыть();

КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////////////
// Инициализация

Инициализация();