USE master;
GO

DROP DATABASE IF EXISTS GraphDB;
GO

CREATE DATABASE GraphDB;
GO

USE GraphDB;
GO

---узлы
CREATE TABLE Universities (
    UniversityId INT NOT NULL PRIMARY KEY,
    UniversityName VARCHAR(100) NOT NULL
) AS NODE;

INSERT INTO Universities (UniversityId, UniversityName)
VALUES
    (1, N'БГУ'),
    (2, N'БГУИР'),
    (3, N'БГЭУ'),
    (4, N'БНТУ'),
    (5, N'БГМУ'),
    (6, N'БГАТУ'),
    (7, N'БГПУ'),
    (8, N'БГУП'),
    (9, N'БГК'),
    (10, N'БГАДТ');

CREATE TABLE Professors (
    ProfessorId INT NOT NULL PRIMARY KEY,
    ProfessorName VARCHAR(100)
) AS NODE;

INSERT INTO Professors (ProfessorId, ProfessorName)
VALUES
    (1, 'Иванов Иван Иванович'),
    (2, 'Петров Петр Петрович'),
    (3, 'Сидорова Анна Ивановна'),
    (4, 'Смирнов Сергей Викторович'),
    (5, 'Козлова Елена Александровна'),
    (6, 'Васильев Алексей Владимирович'),
    (7, 'Морозова Ольга Петровна'),
    (8, 'Николаев Игорь Геннадьевич'),
    (9, 'Соколова Людмила Сергеевна'),
    (10, 'Кузнецов Андрей Дмитриевич');

CREATE TABLE Publications (
    PublicationId INT NOT NULL PRIMARY KEY,
    PublicationTitle VARCHAR(200)
) AS NODE;

INSERT INTO Publications (PublicationId, PublicationTitle)
VALUES
    (1, 'Исследования в области квантовой физики'),
    (2, 'Применение искусственного интеллекта в медицине'),
    (3, 'Лингвистические анализы современных текстов'),
    (4, 'Исследования в области генетики и эволюции'),
    (5, 'Экономический анализ мировых рынков'),
    (6, 'Социологические исследования о миграции'),
    (7, 'Искусство и эстетика в современном мире'),
    (8, 'Инженерные разработки в области энергетики'),
    (9, 'Политические исследования в постсоветском пространстве'),
    (10, 'Инновации в области информационных технологий');

-----ребра
CREATE TABLE FriendOf as edge; -- связь профессор дружит с другим профессором

CREATE TABLE WorksIn (salary int) as edge; -- связь профессор работает в университете и получает зарплату

CREATE TABLE WorkingOn as edge; -- связь профессор работает над публикацией

CREATE TABLE publishes as edge; -- связь университет издает публикации 


alter table FriendOf add constraint EC_FriendOf connection (Professors to Professors);

alter table WorksIn add constraint EC_WorksIn connection (Professors to Universities);

alter table WorkingOn add constraint EC_WorkingOn connection (Professors to Publications);

alter table publishes add constraint EC_publishes connection (Universities to Publications);


insert into FriendOf ($from_id, $to_id)
values	((select $node_id from Professors where ProfessorId = 1), (select $node_id from Professors where ProfessorId = 4)),
		((select $node_id from Professors where ProfessorId = 1), (select $node_id from Professors where ProfessorId = 5)),
		((select $node_id from Professors where ProfessorId = 2), (select $node_id from Professors where ProfessorId = 1)),
		((select $node_id from Professors where ProfessorId = 3), (select $node_id from Professors where ProfessorId = 4)),
		((select $node_id from Professors where ProfessorId = 4), (select $node_id from Professors where ProfessorId = 2)),
		((select $node_id from Professors where ProfessorId = 4), (select $node_id from Professors where ProfessorId = 8)),
		((select $node_id from Professors where ProfessorId = 4), (select $node_id from Professors where ProfessorId = 6)),
		((select $node_id from Professors where ProfessorId = 5), (select $node_id from Professors where ProfessorId = 3)),
		((select $node_id from Professors where ProfessorId = 5), (select $node_id from Professors where ProfessorId = 10)),
		((select $node_id from Professors where ProfessorId = 6), (select $node_id from Professors where ProfessorId = 2)),
		((select $node_id from Professors where ProfessorId = 7), (select $node_id from Professors where ProfessorId = 10)),
		((select $node_id from Professors where ProfessorId = 8), (select $node_id from Professors where ProfessorId = 5)),
		((select $node_id from Professors where ProfessorId = 8), (select $node_id from Professors where ProfessorId = 9)),
		((select $node_id from Professors where ProfessorId = 9), (select $node_id from Professors where ProfessorId = 4)),
		((select $node_id from Professors where ProfessorId = 9), (select $node_id from Professors where ProfessorId = 6)),
		((select $node_id from Professors where ProfessorId = 10), (select $node_id from Professors where ProfessorId = 9)),
		((select $node_id from Professors where ProfessorId = 10), (select $node_id from Professors where ProfessorId = 1));

insert into WorksIn ($from_id, $to_id, salary)
values ((select $node_id from Professors where ProfessorId = 1), (select $node_id from Universities where UniversityId = 3), 2000),
	   ((select $node_id from Professors where ProfessorId = 2), (select $node_id from Universities where UniversityId = 6), 2300),
	   ((select $node_id from Professors where ProfessorId = 3), (select $node_id from Universities where UniversityId = 1), 3050),
	   ((select $node_id from Professors where ProfessorId = 4), (select $node_id from Universities where UniversityId = 7), 1000),
	   ((select $node_id from Professors where ProfessorId = 5), (select $node_id from Universities where UniversityId = 6), 800),
	   ((select $node_id from Professors where ProfessorId = 6), (select $node_id from Universities where UniversityId = 8), 1200),
	   ((select $node_id from Professors where ProfessorId = 7), (select $node_id from Universities where UniversityId = 9), 2075),
	   ((select $node_id from Professors where ProfessorId = 8), (select $node_id from Universities where UniversityId = 2), 2440),
	   ((select $node_id from Professors where ProfessorId = 9), (select $node_id from Universities where UniversityId = 10), 670),
	   ((select $node_id from Professors where ProfessorId = 10), (select $node_id from Universities where UniversityId = 4), 1400),
	   ((select $node_id from Professors where ProfessorId = 7), (select $node_id from Universities where UniversityId = 4), 2500),
	   ((select $node_id from Professors where ProfessorId = 8), (select $node_id from Universities where UniversityId = 5), 3000),
	   ((select $node_id from Professors where ProfessorId = 9), (select $node_id from Universities where UniversityId = 1), 4500),
	   ((select $node_id from Professors where ProfessorId = 10), (select $node_id from Universities where UniversityId = 9), 900),
	   ((select $node_id from Professors where ProfessorId = 10), (select $node_id from Universities where UniversityId = 3), 1960);

insert into WorkingOn ($from_id, $to_id)
values	((select $node_id from Professors where ProfessorId = 1), (select $node_id from Publications where PublicationId = 3)),
		((select $node_id from Professors where ProfessorId = 2), (select $node_id from Publications where PublicationId = 5)),
		((select $node_id from Professors where ProfessorId = 3), (select $node_id from Publications where PublicationId = 2)),
		((select $node_id from Professors where ProfessorId = 3), (select $node_id from Publications where PublicationId = 4)),
		((select $node_id from Professors where ProfessorId = 4), (select $node_id from Publications where PublicationId = 1)),
		((select $node_id from Professors where ProfessorId = 5), (select $node_id from Publications where PublicationId = 7)),
		((select $node_id from Professors where ProfessorId = 6), (select $node_id from Publications where PublicationId = 9)),
		((select $node_id from Professors where ProfessorId = 7), (select $node_id from Publications where PublicationId = 9)),
		((select $node_id from Professors where ProfessorId = 8), (select $node_id from Publications where PublicationId = 10)),
		((select $node_id from Professors where ProfessorId = 8), (select $node_id from Publications where PublicationId = 6)),
		((select $node_id from Professors where ProfessorId = 9), (select $node_id from Publications where PublicationId = 6)),
		((select $node_id from Professors where ProfessorId = 9), (select $node_id from Publications where PublicationId = 1)),
		((select $node_id from Professors where ProfessorId = 10), (select $node_id from Publications where PublicationId = 5));

insert into publishes ($from_id, $to_id)
values	((select $node_id from Universities where UniversityId = 1), (select $node_id from Publications where PublicationId = 1)),
		((select $node_id from Universities where UniversityId = 1), (select $node_id from Publications where PublicationId = 2)),
		((select $node_id from Universities where UniversityId = 2), (select $node_id from Publications where PublicationId = 6)),
		((select $node_id from Universities where UniversityId = 3), (select $node_id from Publications where PublicationId = 3)),
		((select $node_id from Universities where UniversityId = 5), (select $node_id from Publications where PublicationId = 10)),
		((select $node_id from Universities where UniversityId = 6), (select $node_id from Publications where PublicationId = 7)),
		((select $node_id from Universities where UniversityId = 7), (select $node_id from Publications where PublicationId = 5)),
		((select $node_id from Universities where UniversityId = 7), (select $node_id from Publications where PublicationId = 6)),
		((select $node_id from Universities where UniversityId = 8), (select $node_id from Publications where PublicationId = 9)),
		((select $node_id from Universities where UniversityId = 9), (select $node_id from Publications where PublicationId = 4)),
		((select $node_id from Universities where UniversityId = 10), (select $node_id from Publications where PublicationId = 8)),
		((select $node_id from Universities where UniversityId = 4), (select $node_id from Publications where PublicationId = 1)),
		((select $node_id from Universities where UniversityId = 4), (select $node_id from Publications where PublicationId = 10));


select Professor.ProfessorName, University.UniversityName, salary
from Professors as Professor
	 ,WorksIn
	 ,Universities as University
where match(Professor-(WorksIn)->University)
	  and salary > 2000


select Professor.ProfessorName, University.UniversityName, salary
from Professors as Professor
	 ,WorksIn
	 ,Universities as University
where match(Professor-(WorksIn)->University)
	  and UniversityName = 'БГУ'

select Professor.ProfessorName, University.UniversityName, University.UniversityId, salary
from Professors as Professor
	 ,WorksIn
	 ,Universities as University
where match(Professor-(WorksIn)->University)
	  and ProfessorName = 'Кузнецов Андрей Дмитриевич'
	

select Professor2.ProfessorName as friends
from Professors as Professor
	 ,Professors as Professor2
	 ,FriendOf
where match(Professor-(FriendOf)->Professor2)
	  and Professor.ProfessorName = 'Кузнецов Андрей Дмитриевич'


select Professor1.ProfessorName + ' дружит с ' + Professor2.ProfessorName as level1
	   ,Professor2.ProfessorName + ' дружит с ' + Professor3.ProfessorName as level2
from Professors as Professor1
	 ,Professors as Professor2
	 ,Professors as Professor3
	 ,FriendOf as FriendOf1
	 ,FriendOf as FriendOf2
where match(Professor1-(FriendOf1)->Professor2-(FriendOf2)->Professor3)
	  and Professor1.ProfessorName = 'Кузнецов Андрей Дмитриевич'


select Professor1.ProfessorName
	   , string_agg(Professor2.ProfessorName, '->') within group (graph path) as friends
from Professors as Professor1
	 ,FriendOf for path as fo
	 ,Professors for path as Professor2
where match(shortest_path(Professor1(-(fo)->Professor2){1,2}))
	  and Professor1.ProfessorName = 'Кузнецов Андрей Дмитриевич'

declare @ProfessorFrom as nvarchar(40) = N'Кузнецов Андрей Дмитриевич';
declare @ProfessorTo as nvarchar(40) = N'Николаев Игорь Геннадьевич';
with T1 as (
select Professor1.ProfessorName as ProfessorName
	   , string_agg(Professor2.ProfessorName, '->') within group (graph path) as friends
	   , last_value(Professor2.ProfessorName) within group (graph path) as LastNode
from Professors as Professor1
	 ,FriendOf for path as fo
	 ,Professors for path as Professor2
where match(shortest_path(Professor1(-(fo)->Professor2)+))
	  and Professor1.ProfessorName = @ProfessorFrom
)
select ProfessorName, friends
from T1
where LastNode = @ProfessorTo


	