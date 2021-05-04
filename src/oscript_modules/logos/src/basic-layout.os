﻿Функция ПолучитьФорматированноеСообщение(Знач СобытиеЛога) Экспорт
	
	УровеньЛога = СобытиеЛога.ПолучитьУровеньЛога();
	УровеньСообщения = СобытиеЛога.ПолучитьУровень();
	НаименованиеУровня = УровниЛога.НаименованиеУровня(УровеньСообщения);
	Сообщение = СобытиеЛога.ПолучитьСообщение();
	ИмяЛога = СобытиеЛога.ПолучитьИмяЛога();
	
	Если УровеньЛога <= УровниЛога.Отладка Тогда
		ФорматированноеИмяЛога = ФорматироватьИмяЛога(ИмяЛога);
		ФорматированноеСообщение = СтрШаблон("%1 - [%2] - %3", НаименованиеУровня, ФорматированноеИмяЛога, Сообщение);
	Иначе
		ФорматированноеСообщение = СтрШаблон("%1 - %2", НаименованиеУровня, Сообщение);
	КонецЕсли;
	СтрокаПолей = ФорматироватьДополнительныеПоля(СобытиеЛога.ПолучитьДополнительныеПоля());
	Если Не ПустаяСтрока(СтрокаПолей) Тогда
		ФорматированноеСообщение = ФорматированноеСообщение + " " + СтрокаПолей;
	КонецЕсли;
	
	Возврат ФорматированноеСообщение;

КонецФункции

Функция ФорматироватьДополнительныеПоля(Знач ДополнительныеПоля)

	МассивСтрокПолей = Новый Массив();
	Для каждого Поле Из ДополнительныеПоля Цикл
		СтрокаПоля = СтрШаблон("%1=%2", Поле.Ключ, Поле.Значение);
		МассивСтрокПолей.Добавить(СтрокаПоля);
	КонецЦикла;

	Возврат СтрСоединить(МассивСтрокПолей, " ");

КонецФункции

Функция ФорматироватьИмяЛога(Знач ИмяЛога)
	
	КоличествоСимволов = 20;
	Результат = "";

	ИтоговаяДлинаЛога = СтрДлина(ИмяЛога);
	Если ИтоговаяДлинаЛога <= КоличествоСимволов Тогда
		Возврат ИмяЛога;
	КонецЕсли;

	УзлыЛога = СтрРазделить(ИмяЛога, ".");
	
	Если УзлыЛога.Количество() = 1 Тогда 
		Результат = СократитьСтроку(ИмяЛога, КоличествоСимволов);
		Возврат Результат;
	КонецЕсли;
	
	НеобходимоСокращатьУзелЛога = Истина;
	сч = 0;
	Для Каждого УзелЛога Из УзлыЛога Цикл
		
		ПоследнийУзелЛога = сч = УзлыЛога.ВГраница();
		
		Если НеобходимоСокращатьУзелЛога Тогда
			Если ПоследнийУзелЛога Тогда
				РезультирующийУзелЛога = СократитьСтроку(УзелЛога, Макс(1, КоличествоСимволов - СтрДлина(Результат)));
			Иначе
				РезультирующийУзелЛога = Лев(УзелЛога, 1);
			КонецЕсли;
		Иначе
			РезультирующийУзелЛога = УзелЛога;
		КонецЕсли;
		
		Результат = Результат + РезультирующийУзелЛога + ".";
		ИтоговаяДлинаЛога = ИтоговаяДлинаЛога - (СтрДлина(УзелЛога) - 1);
		
		Если ИтоговаяДлинаЛога <= КоличествоСимволов Тогда
			НеобходимоСокращатьУзелЛога = Ложь;
		КонецЕсли;

		сч = сч + 1;
	КонецЦикла;
	
	Результат = Лев(Результат, СтрДлина(Результат) - 1);
	
	Возврат Результат;

КонецФункции

Функция СократитьСтроку(Знач ИсходнаяСтрока, Знач КоличествоСимволов)
	
	Результат = ИсходнаяСтрока;
	
	Если СтрДлина(Результат) <= КоличествоСимволов Тогда
		Возврат Результат;
	КонецЕсли;

	Результат = "~" + Прав(Результат, Макс(КоличествоСимволов - 1, 1));
	
	Возврат Результат;
	
КонецФункции
