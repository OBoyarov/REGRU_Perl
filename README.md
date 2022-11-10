# REG.RU Техническое задание для программиста на Perl
---
### Описание задач:

1.	Можно реализовать любую из задач на любимом фреймворке (Catalyst || Mojolicious || Dancer2).
a.	“Замечательный банк”. Нужно реализовать самые замечательные функции:
- показать всех клиентов
- добавить клиента
- удалить клиента
- изменить контакты клиента
- перевести деньги клиента A клиенту B
Данные должны храниться в базе данных.

b.	“Замечательная телефонная книжка”. Нужно реализовать самые замечательные функции:
- показать все контакты
- добавить контакт
- удалить контакт
- изменить контакт
Данные должны храниться в базе данных.

c.	Если наши задачи не нравятся, то можно придумать своё ТЗ, описать его словами, написать код. Подойдёт модуль собственной разработки на CPAN или github.

2.	Для игры нам нужно реализовать код. Напиши класс персонажа “Рыцарь печального образа”, у которого есть методы: “нанести урон копьём”, “оседлать коня”, “исцелиться”. Нашему рыцарю нужен враг, напиши класс “Великан”, который умеет “нанести урон дубиной” и “околдовать”. Оба этих класса должны иметь метод “погибнуть”, логика которого одинаковая для обоих. Значит, нужен родительский класс “Участник сражения”. Когда участник сражения наносит урон врагу, у врага уменьшается здоровье. Когда здоровья не осталось, сражение закончилось.

3.	В переменной $datetime содержится дата/время в таком формате:
2016-04-11 20:59:03
Напиши регулярное выражение, которое поможет разбить строку и заполнить переменные $date и $time. В переменную $date должно попасть 2016-04-11, в $time - 20:59:03.

4.	В базе данных есть 2 таблицы:
domains - домены
users - пользователи
В таблице domains нас интересуют поля:
user_id - id пользователя, которому принадлежит домен
dname - имя домена
В таблице users нас интересуют поля:
user_id - id пользователя
name - имя пользователя
Напиши SQL-запрос, который выведет имена доменов, которые есть у пользователя с именем Иван Иванов.

5.	В директории /var/logs/archive лежит файл backup.tar.gz. Нужно:
a.	установить права на запись в эту директорию для всех пользователей;
b.	распаковать архив backup.tar.gz;
c.	удалить все файлы, имена которых заканчиваются на .tmp;
d.	вывести имена всех файлов, которые содержат строку user deleted.
Задание должно быть выполнено на языке вашей любимой командной оболочки Linux.

6.	Ты вводишь в адресной строке браузера reg.ru, и через несколько секунд видишь главную страницу сайта. Опиши текстом, что происходит между этими событиями?

Ответы на каждое задание должны содержаться в собственной директории. Для каждого задания создаётся отдельный файл. Допускается, что на какое-то задание будет несколько .pm файлов. Примеры: task1.txt, task2.pl, Giant.pm, … Эти файлы должны находиться на github. Ответы на задания - ссылки на файлы в github.

---

### Комментарии:

Задача 1, решение по ссылке [Bank](https://github.com/OBoyarov/REGRU_Perl/tree/main/Bank):
Выбрал фреймворк mojolicious, выбрал банк. 
Использовал Mojolicious::Lite, для задачи посчитал его использование достаточным.
Упор был в разборе работы роутинга и передачи параметров в шаблоны. Поэтому в работе с базой данных использовал DBI.
Не нравится сам формат использования коннекта к базе данных, так как при запуске проекта создает глобальное подключение к БД и при разработке в режиме дебага забиваются подвисшие подключения на сервере(если прерывать работу веб-сервера\закрывать консоль). Считаю правильным перед каждым выполнением запроса\транзакции открывать соединение и закрывать после выполнения. Для этого требуется вывести connect и disconnect в отдельные процедуры.

Задача 2, решение по ссылке [Game](https://github.com/OBoyarov/REGRU_Perl/tree/main/Game):
Было выбрано привычное для меня использование класса - геттинги и сеттинги, так визуально понимаешь что делается в коде. Хотя можно было уложиться в одну процедуру с записью возвратом результата. В связи с этим код получился немного "громоздким" при выводе действий в консоль.

Задача 3, решение по ссылке [Datatime]([https://github.com/OBoyarov/REGRU_Perl/tree/main/Datatime]):
Тут просто сплит по пробелу регуляркой.
Глянуть вывод можно здесь: perl.isp.regruhosting.ru/datetime/task.pl



