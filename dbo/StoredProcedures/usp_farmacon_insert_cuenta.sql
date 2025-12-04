USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
--select * from sys.sysobjects where name like'%farmacon%' and xtype='U'


--select * from cat_farmacon



CREATE procedure [dbo].[usp_farmacon_insert_cuenta]
(@sucursal int,
@cuenta varchar(5))
WITH ENCRYPTION
as

insert into cat_farmacon values(@sucursal,@cuenta,GETDATE())


select top(10)* from cat_farmacon order by timestamp desc
GO
