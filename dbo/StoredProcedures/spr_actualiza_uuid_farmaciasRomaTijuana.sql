-- =============================================
-- Author:		frmartinez
-- Create date: 01/07/2019
-- Description:	Actualiza UUID Facturacion Tijuana
-- =============================================
CREATE PROCEDURE [dbo].[spr_actualiza_uuid_farmaciasRomaTijuana]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    declare @cadena_sql varchar(max)
declare @cadena_sqlAux varchar(max)
declare @fecha varchar(8)= convert(varchar,getdate()-4,112)

---Estaba con este cliente padre 99447
---Se cambio por este 99586

set @cadena_sql= '
select u.CEINVN,TRIM(u.CECSTS) AS CECSTS,TRIM(u.CESERI) AS CESERI,u.CEFECH,
 TRIM(u.CEDENO) AS CEDENO,TRIM(u.CEUUID)AS CEUUID
 from MARZAMPRD.Z3OUUIDS u inner join MA4620EF04.SRONAM CL ON U.CEDENO=CL.NANUM 
WHERE CL.NANCA1 IN (''''99586'''') and u.cefech >= '+@fecha

CREATE TABLE #uuid_facturacion(
	[CEINVN] [numeric](12, 0) NOT NULL,[CECSTS] [char](5) NOT NULL,[CESERI] [char](10) NOT NULL,	[CEFECH] [numeric](30, 0) NOT NULL,	[CEDENO] [char](15) NOT NULL,	[CEUUID] [char](50) NOT NULL) 

INSERT INTO #uuid_facturacion
           ([CEINVN],[CECSTS],[CESERI],[CEFECH],[CEDENO],[CEUUID])
execute('select * from openquery(AS400, ''' + @cadena_sql + ''')')

set @cadena_sqlAux=replace(@cadena_sql,'MA4620EF04','MA4620EF11')
INSERT INTO #uuid_facturacion
           ([CEINVN],[CECSTS],[CESERI],[CEFECH],[CEDENO],[CEUUID])
execute('select * from openquery(AS400, ''' + @cadena_sqlAux + ''')')

--select * from #uuid_facturacion where CESERI not like '%REMISION%' and CESERI not like '%T%'


merge [dbo].[uuid_facturacion] as destino
using(select u.* 
	from #uuid_facturacion u
	left join uuid_facturacion u1 on u.CEINVN=u1.CEINVN	and u.CECSTS=u1.CECSTS and 	u.CESERI=u1.CESERI
	where u.CESERI not like '%REMISION%' and u.CESERI not like '%T%'and u1.ceinvn is null) as origen
on (destino.CEINVN=origen.CEINVN	and destino.CECSTS=origen.CECSTS and 	destino.CESERI=origen.CESERI)
when not matched then
insert ([CEINVN],[CECSTS],[CESERI],[CEFECH],[CEDENO],[CEUUID])
values(origen.[CEINVN],origen.[CECSTS],origen.[CESERI],origen.[CEFECH],origen.[CEDENO],origen.[CEUUID]);
drop table #uuid_facturacion 
	
END

GO

