#Использовать ".."

#Использовать asserts

&Тест
Процедура СемафорыСОдинаковымКлючомБлокируются() Экспорт

	Семафор1 = Семафоры.Получить("тестовый семафор");
	Семафор2 = Семафоры.Получить("тестовый семафор");

	Семафор1.Захватить();
	
	ПараметрыМетода = Новый Массив;
	ПараметрыМетода.Добавить(10);

	Ожидаем.Что(Семафор2).Метод("Захватить", ПараметрыМетода).ВыбрасываетИсключение("Истекло время ожидания");
	
	Семафор1.Освободить();
	
	Семафор2.Захватить(10);
	Семафор2.Освободить();

КонецПроцедуры

&Тест
Процедура СемафорыСРазнымиКлючамиНеБлокируются() Экспорт
	
	Семафор1 = Семафоры.Получить("тестовый семафор 1");
	Семафор2 = Семафоры.Получить("тестовый семафор 2");
	
	Семафор1.Захватить();
	Семафор2.Захватить(10);
	
	Семафор1.Освободить();
	Семафор2.Освободить();
КонецПроцедуры
