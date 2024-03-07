-- czyszczenie tabeli z id wiekszych niz 3 i poprawienie zeby id nie
-- naliczalo sie od nowej wartosci tylko starej (znowu od 3)
delete shippers where shipperid >3
dbcc checkident ('shippers', reseed, 3)

-- begin tran
-- insert shippers(companyname,phone)
-- values('ala','123')
--
-- select * from shippers
-- begin tran
-- select @@trancount
--
-- insert  shippers(companyname, phone)
-- values('bala', '123')
--
-- commit
--
-- rollback

select * from shippers

-- jeden bledny insert nie wejdzie ale id zachowa sie jakby wszedl
-- gdy nie ma bledu krytycznego to tak sie zachowuje
-- wiec trzeba to zmodyfikowac tak ze albo wszystkie inserty albo zaden
-- do tego sluzy try catch
begin tran

insert shippers(companyname, phone)
values (null, 911)

insert shippers(companyname, phone)
values ('Taxi2', 912)

commit

-- ten try zachowa sie tak ze albo wpisze obydwie liczby
-- albo w przypadku bledu nie wpisze zadnej (rollback cofa zmiany)
begin try
    begin tran

    insert shippers(companyname, phone)
    values (null, 911)

    insert shippers(companyname, phone)
    values ('Taxi2', 912)

    commit
end try
begin catch
    if @@trancount>0
        rollback;
    throw;
end catch

-- przenoszeine danych z innej tabeli, cofanie rollback
begin tran

insert shippers(companyname, phone)
select companyname,phone from suppliers;

rollback

-- utworznie nowej tabeli z kolumn innej
select supplierid as shipperid, companyname, phone
into newshippers
from suppliers;

-- usuwanie tabeli
drop table newshippers;
