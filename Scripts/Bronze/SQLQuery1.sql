USE DataWareHouse;


if OBJECT_ID( 'demo_table', 'U') is not null
	 drop table  demo_table;
go

create table demo_table (
id int,
name nvarchar(50)
);
go 

select * from demo_table;
go

CREATE SCHEMA Silver;
go

CREATE SCHEMA Gold;
go
