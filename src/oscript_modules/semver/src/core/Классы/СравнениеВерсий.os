Перем ОсновнойДиапазон;
Перем ВерсииПроверки;
Перем РезультирующийМассивВерсий;
Перем СравнениеВыполнено;

Процедура ПриСозданииОбъекта(ДиапазонСтрокой = "*")

	ОсновнойДиапазон = Новый ДиапазонВерсий(ДиапазонСтрокой);
	РезультирующийМассивВерсий = Новый Массив;
	ВерсииПроверки = Новый Массив;
	СравнениеВыполнено = Ложь;

КонецПроцедуры

// Добавляет диапазон в сравнение
//
// Параметры:
//   СтрокаДиапазона - Строка - строковое представление диапазона
// Возвращаемое значение:
//   ЭтотОбъект - класс СравнениеВерсий
Функция ДобавитьДиапазон(Знач СтрокаДиапазона) Экспорт
	
	ОсновнойДиапазон.ОбъединитьСДиапазоном(Новый ДиапазонВерсий(СтрокаДиапазона));
	
	СкинутьРезультат();

	Возврат ЭтотОбъект;

КонецФункции

// Добавляет массив версий в сравнение и возвращает себя
//
// Параметры:
//   СтрокаДиапазона - Массив - Элементы <Строка> или класс <Версия> проверяемых версий
//   ОчищатьМассив - булево - признак очистки предыдущего набора версий
// Возвращаемое значение:
//   ЭтотОбъект - класс СравнениеВерсий
Функция ПроверяемыеВерсии(Знач МассивВерсий, ОчищатьМассив = Ложь) Экспорт
	
	Если ОчищатьМассив Тогда
		СкинутьМассивВерсийПроверки();
	КонецЕсли;
	
	Для каждого ВходящаяВерсия Из МассивВерсий Цикл
		ПроверяемаяВерсия(ВходящаяВерсия, Ложь);
	КонецЦикла;

	СкинутьРезультат();

	Возврат ЭтотОбъект;
	
КонецФункции

// Добавляет версию в сравнение и возвращает себя
//
// Параметры:
//   ВходящаяВерсия - Строка/Класс_Версия - Версия для сравнения с диапазоном
//   ОчищатьМассив - булево - признак очистки предыдущего набора версий
// Возвращаемое значение:
//   ЭтотОбъект - класс СравнениеВерсий
Функция ПроверяемаяВерсия(Знач ВходящаяВерсия, ОчищатьМассив = Ложь) Экспорт
	
	Если ОчищатьМассив Тогда
		СкинутьМассивВерсийПроверки();
	КонецЕсли;

	ВерсииПроверки.Добавить(Версии.ВерсияИзСтроки(ВходящаяВерсия));

	СкинутьРезультат();

	Возврат ЭтотОбъект;

КонецФункции

// Выполняет сравнение и возвращает себя
//
// Возвращаемое значение:
//   ЭтотОбъект - класс СравнениеВерсий
Функция Сравнить() Экспорт
	
	СкинутьРезультат();

	РезультирующийМассивВерсий = ОсновнойДиапазон.ПроверитьВерсии(ВерсииПроверки);

	СравнениеВыполнено = Истина;

	Возврат ЭтотОбъект;

КонецФункции

// Выполняет сравнение и выгружает результат в массив
//
// Возвращаемое значение:
//   Массив - массив элементов класса версия 
Функция ВМассив() Экспорт
	
	Если Не СравнениеВыполнено Тогда
		Сравнить();
	КонецЕсли;

	Возврат РезультирующийМассивВерсий;

КонецФункции

// Выполняет сравнение и выгружает результат в массив строк версий
//
// Возвращаемое значение:
//   Массив - массив элементов строка  (вызов Версия.ВСтроку())
Функция ВМассивСтрок() Экспорт
	
	Если Не СравнениеВыполнено Тогда
		Сравнить();
	КонецЕсли;

	МассивСтрок = Новый Массив;

	Для каждого ВерсияРезультат Из РезультирующийМассивВерсий Цикл
		МассивСтрок.Добавить(ВерсияРезультат.ВСтроку());
	КонецЦикла;

	Возврат МассивСтрок;

КонецФункции

// Выполняет сравнение и проверяет, что все элементы, присутствуют в массиве после сравнения
//
// Возвращаемое значение:
//   Булево - все элементы есть в массиве
Функция ВДиапазоне() Экспорт
	
	МассивСтрокВерсий = ВМассивСтрок();
	Результат = ВерсииПроверки.Количество() > 0;

	Для каждого ВерсияПоиска Из ВерсииПроверки Цикл

		РезультатПоиска = МассивСтрокВерсий.Найти(ВерсияПоиска.ВСтроку());

		Если РезультатПоиска = Неопределено Тогда
			Результат = Ложь;
			Прервать
		КонецЕсли;

	КонецЦикла;

	Возврат Результат;

КонецФункции

// Выполняет сравнение и возвращает максимальную версию из результата
//
// Возвращаемое значение:
//   Версия - элемент класса версия 
Функция Максимальная() Экспорт
	
	Если Не СравнениеВыполнено Тогда
		Сравнить();
	КонецЕсли;

	Возврат Версии.МаксимальнаяИзМассива(РезультирующийМассивВерсий);

КонецФункции

// Выполняет сброс версий, результата сравнения и возвращает себя
// НЕ СБРАСЫВАЕТ ДИАПАЗОН ВЕРСИЙ
//
// Возвращаемое значение:
//   ЭтотОбъект - класс СравнениеВерсий
Функция Сброс() Экспорт
	
	СкинутьМассивВерсийПроверки();
	СкинутьРезультат();

	Возврат ЭтотОбъект;

КонецФункции

/////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ

Процедура СкинутьМассивВерсийПроверки()
	
	ВерсииПроверки.Очистить();

КонецПроцедуры

Процедура СкинутьРезультат()
	
	СравнениеВыполнено = Ложь;
	РезультирующийМассивВерсий.Очистить();

КонецПроцедуры

Лог = Логирование.ПолучитьЛог("oscript.lib.semver.range_compare");