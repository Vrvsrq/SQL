/* Упражнение 1
Найдите номер модели, скорость и размер жесткого диска для всех ПК стоимостью менее 500 дол. 
Вывести: model, speed и hd */

select distinct model
    ,speed
    ,hd
from PC
where price < 500

/* Упражнение 2
Найдите производителей принтеров. Вывести: maker */

select distinct maker
from Product
where type = 'printer'

/* Упражнение 3
Найдите номер модели, объем памяти и размеры экранов ПК-блокнотов, цена которых превышает 1000 дол.*/

select model
    ,ram
    ,screen
from Laptop
where price > 1000

/* Упражнение 4
Найдите все записи таблицы Printer для цветных принтеров. */

select *
from Printer
where color = 'y'

/* Упражнение 5
Найдите номер модели, скорость и размер жесткого диска ПК, имеющих 12x или 24x CD и цену менее 600 дол. */

select model
    ,speed
    ,hd
from PC
where (cd = '12x' or cd = '24x')
    and price < 600

/* Упражнение 6 
Для каждого производителя, выпускающего ПК-блокноты c объёмом жесткого диска не менее 10 Гбайт,
найти скорости таких ПК-блокнотов. Вывод: производитель, скорость. */

select distinct maker
    ,speed
from Laptop as L
    left join Product as p on p.model = l.model
where l.hd >= 10

/* Упражнение 7
Найдите номера моделей и цены всех имеющихся в продаже продуктов (любого типа) производителя B (латинская буква).*/

select r.model
    ,price
from (
    select model
        ,price
    from PC
    union
    select model
        ,price
    from Laptop
    union
    select model
        ,price
    from Printer
) as r inner join Product as P on p.model = r.model
where maker = 'b'

/* Упражнение 8
Найдите производителя, выпускающего ПК, но не ПК-блокноты. */
-- Решение 1

select distinct maker
from Product
where type = 'PC'
    and maker not in (select maker
                    from Product
                    where type = 'Laptop'
                    )

-- Решение 2

select maker
from Product
where type = 'PC'
except
select maker
from Product
where type = 'Laptop'

/* Упражнение 9
Найдите производителей ПК с процессором не менее 450 Мгц. Вывести: Maker */

select distinct maker
from Product as p
    inner join PC on PC.model = p.model
where PC.speed >= 450

/* Упражнение 10
Найдите модели принтеров, имеющих самую высокую цену. Вывести: model, price */

select model
    ,price
from Printer
where price = (
    select max(price)
    from Printer
)

/* Упражнение 11
Найдите среднюю скорость ПК.*/

select avg(price) as avg_price
from PC
