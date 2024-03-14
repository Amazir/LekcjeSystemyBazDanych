declare @i int, @j int
declare @first varchar(50)
declare @last varchar(50)

set @i = 10
set @j = @i + 5
set @first = 'john'
select @last = 'gold'

print @i
print @j
print @first
print @last

declare @i int

-- Konstrukcja if w TSQL
set @i = 1

if @i > 2
  print 'i is > 2'
else
  print 'i is <= 2'

-- Proste polecenie z użyciem IF
declare @i int

set @i = 1

if @i > 2
begin
  print 'i is > 2'
  select * from employees
end
else
begin
  print 'i is <= 2'
  select * from orders
end

-- Przykładowa pętla
declare @j int = 1

while @j <= 5
begin
  print @j
  select lastname from employees where employeeid = @j
  set @j = @j + 1
end

-- Podstawianie wartości pod zmienną
declare @first varchar(50)
declare @last varchar(50)

set @first = (select firstname from employees where employeeid = 1)
print @first

select @last = lastname from employees where employeeid = 1
print @last

select @first = firstname, @last = lastname  from employees where employeeid = 2
print @first + ' ' + @last

-- Taka konstrukcja wpisze w zmienną ostatni z 8 wyników
select @last = lastname from employees where employeeid > 1
print @last

-- Cursor
declare @id int
declare @last varchar(50)

declare emp_cursor cursor
    for select employeeid, lastname from employees
open emp_cursor
fetch next from emp_cursor into @id, @last

close emp_cursor
deallocate emp_cursor

print @id
print @last
-- Przyklad 2
declare @sum decimal(10,2) = 0, @qty decimal(10,2), @price decimal(10,2)

declare od_cursor cursor
    for select freight from orders where customerid = 'ALFKI'
open od_cursor

fetch next from od_cursor into @qty, @price

if @@FETCH_STATUS <> 0
    print 'empty set'

while @@FETCH_STATUS = 0
begin
    print cast(@qty as varchar) + ', ' + cast(@price as varchar)
    set @sum = @sum + @qty * @price
    fetch next from od_cursor into @qty, @price
end

close od_cursor
deallocate od_cursor

print @sum

-- Widoki
-- tworzenie
create view emp_names
as
select firstname + ' ' + lastname as name
from employees

-- Wyswietlenie widoku
select * from emp_names

-- Modyfikacja widoku
alter view emp_names
as
select employeeid, firstname + ' ' + lastname as name
from employees

-- Usuniecie widoku
drop view emp_names

-- Widoki part 2
create view product
as
select productid, categoryid, supplierid, productname, unitprice, unitsinstock
from products
where discontinued = 0

select * from product

drop view product

-- Widoki part 3
-- Wyświetlamy tylko produkty na stocku
-- Mozna tez uzyc create or alter
create view avail_product
as
select productid, categoryid, supplierid, productname, unitprice, unitsinstock
from product
where unitsinstock > 0
-- Zliczenie ich
select count(*) from avail_product
-- Czyszczenie viewsow
drop view product
drop view avail_product

-- Widok cwiczenie
-- Widok na ordery z kwotą wiekszą od 10
create view drogie_ordery
as select productid, categoryid, supplierid, productname, unitprice, unitsinstock
from product
where unitprice > 10

--
