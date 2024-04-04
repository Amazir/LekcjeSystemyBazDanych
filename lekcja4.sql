create or alter procedure p_add_order
@customerid char(5),
@employeeid int,
@requireddate date
as
begin
declare @orderdate date = getdate()
insert orders(customerid,employeeid,orderdate,requireddate)
values(@customerid,@employeeid,@orderdate,@requireddate);
end;

create or alter procedure p_add_order
@customerid char(5), @employeeid int, @requireddate date
as
begin
    if not exists (select * from customers where customerid = @customerid)
        throw 50001, 'No customer with such id', 1;
    if not exists (select * from employees where employeeid = @employeeid)
        throw 50001, 'No employee with such id', 1;
    declare @orderdate date = getdate()
    insert orders(customerid,employeeid,orderdate,requireddate)
    values(@customerid,@employeeid,@orderdate,@requireddate);
end;

declare @requireddate date = dateadd(day, 7, getdate());
exec p_add_order 'ALFKI', 999, @requireddate;

create procedure p_add_detail
@orderid int, @productid int, @quantity int, @discount decimal(3,2)
as
begin
declare @unitprice decimal(10,2);
select @unitprice = unitprice from products where productid = @productid;
insert orderdetails(orderid, productid, unitprice, quantity, discount)
values(@orderid, @productid, @unitprice, @quantity, @discount);
end;

exec p_add_detail 20000, 1, 10, 0.12;

create or alter procedure p_add_order2
@customerid char(5), @employeeid int, @requireddate date,
@productid int, @quantity int, @discount decimal(3,2)
as
begin
begin try
    begin transaction;
        exec p_add_order 'ALFKI'
        , 1, @requireddate;
        exec p_add_detail @@identity, @productid, @quantity, @discount;
        commit;
    end try
    begin catch
        if @@trancount >= 1
        rollback;
        throw;
    end catch;
end;

declare @requireddate date = dateadd(day, 7, getdate());
exec p_add_order2 'ALFKI', 1, @requireddate, 10, 25, 0.12;
