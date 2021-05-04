#Использовать "../../model"

Функция Index() Экспорт
	
	Модель = Новый Структура;
	Модель.Вставить("Заголовок", "Хранилища конфигураций");
	Модель.Вставить("Список", Новый Массив);
	
	Результат = МенеджерБазДанных.МенеджерСущностей.Получить(Тип("ХранилищеКонфигурации"));
	Для Каждого Запись Из Результат Цикл
		Строка = ШаблонЗаписи();
		ЗаполнитьЗначенияСвойств(Строка, Запись);
		Модель.Список.Добавить(Строка);
	КонецЦикла;
	
	Возврат Представление("page", Модель);
КонецФункции

Функция Add() Экспорт

	Модель = Новый Структура;
	Модель.Вставить("Заголовок", "Хранилища конфигураций");
	
	Возврат Представление("element", Модель);

КонецФункции

Функция ШаблонЗаписи()
	Шаблон = Новый Структура;
	Шаблон.Вставить("Имя");
	Шаблон.Вставить("Идентификатор");
	Шаблон.Вставить("Ссылка");
	Шаблон.Вставить("Пользователь");
	Шаблон.Вставить("Комментарий");
	Возврат Шаблон;
КонецФункции