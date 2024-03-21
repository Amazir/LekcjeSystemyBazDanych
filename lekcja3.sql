create proc p_customer_order_total -- funkcja
@customerid char(5) -- argument
as
begin
    -- sprawdzenie czy popelnilem blad przy wpisywainu czy po prostu nie zlozyl zadnego zamowienia
    if not exists (select * from customers where customerid = @customerid)
       throw 50001, 'No customer with such id', 1

    select orderid, orderdate, total
    from order_total_3
    where customerid = @customerid
end

create proc p_customer_order_total_2
@customerid char(5), @start_date date = '1997-01-01', @end_date date = '1997-12-31'
as
begin
    if @start_date > @end_date
       throw 50001, 'wrong date rangel', 1
    if not exists (select * from customers where customerid = @customerid)
       throw 50001, 'No customer with such id', 1

    select orderid, orderdate, total
    from order_total_3
    where customerid = @customerid
          and orderdate >= @start_date
          and orderdate <= @end_date
end

exec p_customer_order_total 'PARIS'
exec p_customer_order_total_2 'ALFKI'

create function f_customer_order_total (@customerid char(5))
returns table
as return (
    select orderid, orderdate, customerid, total
    from order_total_3
    where customerid = @customerid
)

select * from f_customer_order_total('ALFKI')
where orderdate >= '1997-01-01'
-- funkcji mozna uzywac w poleceniach a procedur nie

create function f_customer_order_total_2 (@customerid char(5), @start_date date, @end_date date)
returns table
as return(
    select orderid, orderdate, customerid, total
    from order_total_3
    where customerid = @customerid
    and orderdate > @start_date and orderdate < @end_date
)

select * from f_customer_order_total_2 ('ALFKI', '1997-01-01', '1997-12-31')

create function f_max(@a int, @b int)
returns int
as
begin
  declare @r int
  if @a > @b set @r = @a else set @r = @b
  return @r
end

create function f_customer_name(@customerid char(5))
returns varchar(100)
as
begin
    declare @companyname varchar(100)

    select @companyname = companyname
    from customers
    where customerid = @customerid

    return @companyname
end

create function f_order_detail_total(@orderid int)
returns decimal(10,2)
as
begin
    declare @total decimal(10,2)

    select @total = sum(unitprice * quantity * (1-discount))
    from orderdetails
    where orderid = @orderid

    return @total
end

select orderid, customerid, dbo.f_customer_name(customerid)
from orders
order by orderid

select orderid, freight + f_order_detail_total(orderid)
from orders


create function f_customer_order_total(@customerid char(5), @start_date date, @end_date date)
returns decimal(10,2)
as
begin
    declare @total decimal(10,2)

    select sum(freight + f_order_detail_total(orderid))
    from orders
    where customerid = @customerid
    and orderdate >= @start_date and orderdate <= @end_date
    return @total
end