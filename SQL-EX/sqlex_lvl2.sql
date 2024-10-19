/* Задание 7
Найдите номера моделей и цены всех имеющихся в продаже продуктов (любого типа) производителя B (латинская буква). */
with cte as (
    select model
        ,price
    from PC
    union
    select model
        ,price
    from Laptop
)
select p.model
    ,price
from cte as c
    inner join Product as p on p.model = c.model
where maker = 'B';

/* Задание 8
Найдите производителя, выпускающего ПК, но не ПК-блокноты. */
select distinct maker
from Product
where type = 'PC'
    and maker not in (select maker
                    from Product
                    where type = 'Laptop');

/* Задание 14
Найдите класс, имя и страну для кораблей из таблицы Ships, имеющих не менее 10 орудий. */
select s.class
    ,s.name
    ,c.country
from Ships as s
    left join Classes as c on c.class = s.class
where c.numGuns >= 10;

/* Задание 15
Найдите размеры жестких дисков, совпадающих у двух и более PC. Вывести: HD */
select hd
from PC
group by hd
having count(hd) >= 2;

/* Задание 16
Найдите пары моделей PC, имеющих одинаковые скорость и RAM. В результате каждая 
пара указывается только один раз, т.е. (i,j), но не (j,i), Порядок вывода: модель с большим номером,
модель с меньшим номером, скорость и RAM. */
select distinct a.model
    ,b.model
    ,a.speed
    ,a.ram
from PC as a, PC as b
where a.speed = b.speed
    and a.ram = b.ram
    and a.model > b.model;

/* Задание 17
Найдите модели ПК-блокнотов, скорость которых меньше скорости каждого из ПК.
Вывести: type, model, speed */
select distinct p.type
    ,l.model
    ,speed
from Laptop as l
    left join Product as p on p.model = l.model
where speed < all (select speed
                from PC);

/* Задание 18
Найдите производителей самых дешевых цветных принтеров. Вывести: maker, price */
select distinct maker
    ,price
from Printer as pr
    left join Product as p on p.model = pr.model
where color = 'y'
    and price = (
        select min(price)
        from Printer
        where color = 'y'
        );

/* Задание 20
Найдите производителей, выпускающих по меньшей мере три различных модели ПК. Вывести: Maker, число моделей ПК. */
select maker
    ,count(model) as count_model
from Product
where type = 'PC'
group by maker
    having count(model) >= 3;

/* Задание 23
Найдите производителей, которые производили бы как ПК
со скоростью не менее 750 МГц, так и ПК-блокноты со скоростью не менее 750 МГц.
Вывести: Maker */
select distinct maker
from PC
    left join Product as p on p.model = pc.model
where PC.speed >= 750
intersect
select distinct maker
from Laptop as l
    left join product as p on p.model = l.model
where l.speed >=750;

/* Задание 24
Перечислите номера моделей любых типов, имеющих самую высокую цену по всей имеющейся в базе данных продукции. */

-- Собираю во временную таблицу все модели и цены
with cte as (
select model
    ,price
from PC
union all
select model
    ,price
from Laptop
union all
select model
    ,price
from Printer)
-- Выбираю максимальную цену с временной таблиц
select distinct model
from cte
where price = (select max(price)
            from cte)
;

/* Задание 25
Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM 
и с самым быстрым процессором среди всех ПК, имеющих наименьший объем RAM.
Вывести: Maker */

-- Собираю во временную таблицу модели с наименьшим Ram
with cte as (
    select model
        ,speed
    from PC
    where ram = (select min(ram) 
            from PC)
    )

select distinct maker 
from product
where maker in(
    -- Получаю Производителей с самым быстрым процессором среди всех ПК, имеющих наименьший объем RAM
    select maker 
    from Product as p 
	    inner join cte on cte.model = p.model
    where speed = (select max(speed) from cte))
and type = 'Printer';

/* Задание 26
Найдите среднюю цену ПК и ПК-блокнотов, выпущенных производителем A (латинская буква).
Вывести: одна общая средняя цена. */
select avg(price) as avg_price
from(
    select price, maker
    from PC
	    inner join Product as p on p.model = pc.model and maker = 'A'
    union all
    select price, maker
    from laptop as l
	    inner join Product as p on p.model = l.model and maker = 'A'
) as f;

/* Задание 27
Найдите средний размер диска ПК каждого из тех производителей, 
которые выпускают и принтеры. Вывести: maker, средний размер HD. */
select maker
    ,avg(hd) as avg_hd
from PC
    inner join Product as p on p.model = pc.model
where maker in (
    select distinct maker
    from product
    where type = 'printer')
group by maker;

/* Задание 28
Используя таблицу Product, определить количество производителей, выпускающих по одной модели. */
select count(maker) as qty
from(
    select maker
        ,count(model) as e
    from product
    group by maker
    having count(model) = 1
    ) as r;

/* Задание 29
В предположении, что приход и расход денег на каждом пункте приема фиксируется 
не чаще одного раза в день [т.е. первичный ключ (пункт, дата)], написать запрос 
с выходными данными (пункт, дата, приход, расход). Использовать таблицы Income_o и Outcome_o. */
select i.point
    ,i.date
    ,inc
    ,out
from Income_o as i 
    left join Outcome_o as o on i.point = o.point and i.date = o.date
union
select i.point
    ,i.date
    ,inc
    ,out
from Income_o as o
    right join Outcome_o as i on i.point = o.point and i.date = o.date;

/* Задание 30
В предположении, что приход и расход денег на каждом пункте приема фиксируется произвольное число раз 
(первичным ключом в таблицах является столбец code), требуется получить таблицу, в которой каждому 
пункту за каждую дату выполнения операций будет соответствовать одна строка.
Вывод: point, date, суммарный расход пункта за день (out), суммарный приход пункта за день (inc). 
Отсутствующие значения считать неопределенными (NULL). */

with cte as(
select i.point
    ,i.date
    ,out
    ,inc
from Income as i
    left join Outcome as o on o.date = i.date
        and o.point = i.point
        and i.code = o.code
union all
select o.point
    ,o.date
    ,out
    ,inc
from Outcome as o
    left join Income as i on o.date = i.date 
        and o.point = i.point 
        and i.code = o.code
)
select point
    ,date
    ,sum(out) as outcome
    ,sum(inc) as income
from cte
group by point
    ,date;

/* Задание 34
По Вашингтонскому международному договору от начала 1922 г. запрещалось строить линейные корабли водоизмещением более 35 тыс.тонн. 
Укажите корабли, нарушившие этот договор (учитывать только корабли c известным годом спуска на воду). Вывести названия кораблей. */

select distinct name
from Ships as s
	left join Classes as c on c.class = s.class
where c.displacement > 35000
	and s.launched >= 1922
	and type = 'bb';

/* Задание 35
В таблице Product найти модели, которые состоят только из цифр или только из латинских букв (A-Z, без учета регистра).
Вывод: номер модели, тип модели. */

select model, type
from Product
where model not like '%[^A-Z]%'
    OR model not like '%[^0-9]%';

/*Задание 36
Перечислите названия головных кораблей, имеющихся в базе данных (учесть корабли в Outcomes). */

select name
from Ships as s 
    inner join Classes as c on c.class = s.name
union
select ship as name
from Outcomes as o
	inner join Classes as c on c.class = o.ship;

/* Задание 37
Найдите классы, в которые входит только один корабль из базы данных (учесть также корабли в Outcomes). */

with cte as (
select ship as name
    ,class
from Outcomes as o
    inner join Classes as c on c.class = o.ship
union
select name
    ,class
from Outcomes as o
    inner join Ships as s on s.name = o.ship
union
select name
    ,c.class
from Ships as s
    inner join Classes as c on c.class = s.class
)

select class
from cte
group by class
having count(name) =1;

/* Задание 39
Найдите корабли, `сохранившиеся для будущих сражений`; т.е. выведенные из строя в одной битве (damaged),
они участвовали в другой, произошедшей позже. */
select distinct t.ship
from (
		select *
		from Outcomes as o
			inner join Battles as b on b.name = o.battle
			and result = 'damaged'
	) as t
	inner join (
		select *
		from Outcomes as o
			inner join Battles as b on b.name = o.battle
	) as t_2 on t.ship = t_2.ship
	and t.battle <> t_2.battle
	and t.date < t_2.date;

/* Задание 40
Найти производителей, которые выпускают более одной модели, при этом все выпускаемые производителем модели являются продуктами одного типа.
Вывести: maker, type */

with cte as (
	select distinct maker
		,[type]
	from Product
	where maker in(
			select distinct maker
			from Product
			group by maker
			having count(model) > 1
		)
)

select distinct maker
    ,[type]
from cte
where maker in (
		select maker
		from cte
		group by maker
		having count([type]) = 1
	)
;
/* Задание 41
Для каждого производителя, у которого присутствуют модели хотя бы в одной из таблиц PC, Laptop или Printer,
определить максимальную цену на его продукцию.
Вывод: имя производителя, если среди цен на продукцию данного производителя присутствует NULL, то выводить для этого производителя NULL,
иначе максимальную цену.
*/

with cte as (
    select maker
    ,price
from Product as p
	inner join PC on pc.model = p.model
union all
select maker
    ,price
from Product as p
	inner join laptop as l on l.model = p.model
union all
select maker
    ,price
from Product as p
	inner join Printer as pr on pr.model = p.model
    ) 

select maker,
case
	when count(price) < count(*) -- проверяем есть ли null значения
	    then null
	else max(price)
end as m_price
from cte
group by maker;

/* Задание 43
Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду. */

select b.name 
from battles as b
    left join ships as s on s.launched = year(b.date)
where launched is null;

/* Задание 46
Для каждого корабля, участвовавшего в сражении при Гвадалканале (Guadalcanal), вывести название, водоизмещение и число орудий. */

select o.ship
    ,c.displacement
    ,c.numguns
from outcomes as o
	left join Ships as s on s.name = o.ship
	left join Classes as c on c.class = s.class or c.class = o.ship
where o.battle = 'Guadalcanal';

/* Задание 48
Найдите классы кораблей, в которых хотя бы один корабль был потоплен в сражении. */

select c.class
from outcomes as o
	inner join Ships as s on s.name = o.ship
	inner join Classes as c on c.class = s.class
where o.result = 'sunk'
union
select c.class
from outcomes as o
	inner join Classes as c on c.class = o.ship
where o.result = 'sunk';

/* Задание 52
Определить названия всех кораблей из таблицы Ships, которые могут быть линейным японским кораблем,
имеющим число главных орудий не менее девяти, калибр орудий менее 19 дюймов и водоизмещение не более 65 тыс.тонн */

select name
from ships as s
	left join classes as c on c.class = s.class
where
c.country = 'Japan'
	and ( type = 'bb' or type is null)
	and ( numguns >= 9 or numguns is null)
	and ( bore < 19 or bore is null)
	and (displacement <= 65000 or displacement is null);

/* Задание 53
Определите среднее число орудий для классов линейных кораблей.
Получить результат с точностью до 2-х десятичных знаков */

select cast(avg(cast(count as numeric(6,2))) as numeric(6,2)) as avg_numguns
from (
select class
    ,sum(numguns) as count
from classes as c
where type = 'bb'
group by class) as r
;
/* Задание 55
Для каждого класса определите год, когда был спущен на воду первый корабль этого класса. Если год спуска на воду головного корабля неизвестен,
 определите минимальный год спуска на воду кораблей этого класса. Вывести: класс, год. */

select c.class
    ,min(launched) as r
from classes as c
	left join Ships as s on s.class = c.class
	left join Outcomes as o on o.ship = s.name or o.ship = c.class
group by c.class;

/* Задание 56
Для каждого класса определите число кораблей этого класса, потопленных в сражениях. Вывести: класс и число потопленных кораблей. */

-- собираю таблицу со всеми короблями 
with cte as (
select class
    ,name
    ,result
from Outcomes as o
    inner join Ships as s on o.ship = s.name
union
select class
    ,ship
    ,result
from classes as c
    left join Outcomes as o on c.class = o.ship)

-- еслив классе есть потопленные корабли то 1, иначе 0 и суммирую
select class
    ,sum(sunks) as sunks
from(select class,
         case
         when result= 'sunk' then 1 else 0
         end as Sunks
    from cte) as B
group by class;

/* Задание 59
Посчитать остаток денежных средств на каждом пункте приема для базы данных с отчетностью не чаще одного раза в день. Вывод: пункт, остаток. */

with cte as(
select i.point
    ,i.date
    ,inc
    ,out
from Income_o as i 
    left join Outcome_o as o on i.point = o.point and i.date = o.date
union
select 
    i.point
    ,i.date
    ,inc
    ,out
from Income_o as o
    right join Outcome_o as i on i.point = o.point and i.date = o.date
)

select point,
case
	when sum(out) is not null
    then sum(inc) - sum(out)
    else sum(inc)
end as remain
from cte
group by point;

/* Задание 60
Посчитать остаток денежных средств на начало дня 15/04/01 на каждом пункте приема для базы данных 
с отчетностью не чаще одного раза в день. Вывод: пункт, остаток.
Замечание. Не учитывать пункты, информации о которых нет до указанной даты. */

with cte as(
select i.point
    ,i.date
    ,inc
    ,out
from Income_o as i 
    left join Outcome_o as o on i.point = o.point and i.date = o.date
union
select 
    i.point
    ,i.date
    ,inc
    ,out
from Income_o as o
    right join Outcome_o as i on i.point = o.point and i.date = o.date
)

select point,
case
	when sum(out) is not null
    then sum(inc) - sum(out)
    else sum(inc)
end as remain
from cte
where date < '2001-04-15 00:00:00.000'
group by point;

/* Задание 61
Посчитать остаток денежных средств на всех пунктах приема для базы данных с отчетностью не чаще одного раза в день. */

with cte as(
select i.point
    ,i.date
    ,inc
    ,out
from Income_o as i 
    left join Outcome_o as o on i.point = o.point and i.date = o.date
union
select 
    i.point
    ,i.date
    ,inc
    ,out
from Income_o as o
    right join Outcome_o as i on i.point = o.point and i.date = o.date
)

select sum(remain) as remain
from (
    select
    case
	    when sum(out) is not null
        then sum(inc) - sum(out)
        else sum(inc)
    end as remain
    from cte
    group by point
) as e;

/* Задание 63
Определить имена разных пассажиров, когда-либо летевших на одном и том же месте более одного раза. */

select name
from Passenger
where ID_psg in (
    select ID_psg
    from Pass_in_trip
    group by id_psg, place
    having count(place) > 1
    );

/* Задание 64
Используя таблицы Income и Outcome, для каждого пункта приема определить дни, когда был приход, но не было расхода и наоборот.
Вывод: пункт, дата, тип операции (inc/out), денежная сумма за день. */

with cte as (
    select i.point
        ,i.date
        ,o.out
        ,i.inc
    from Income as i
    left join Outcome as o on o.date = i.date 
        and o.point = i.point 
        and i.code = o.code
    union all
    select o.point 
        ,o.date
        ,o.out
        ,i.inc
    from Outcome as o 
    left join Income as i on o.date = i.date
        and o.point = i.point
        and i.code = o.code
)

select point
    ,date
    ,case 
        when sum(inc) is null
        then 'out'
        when sum(out) is null
        then 'inc'
    end as operation
	-- Применяем sum к результату выражения case
    ,sum(case
            when inc is null
            then out 
            when out is null
            then inc
        end) as money_sum
from cte
group by point
    ,date
having
-- выбираем только те строки, где сумма inc или out равна нюлю
   sum(inc) is null or sum(out) is null