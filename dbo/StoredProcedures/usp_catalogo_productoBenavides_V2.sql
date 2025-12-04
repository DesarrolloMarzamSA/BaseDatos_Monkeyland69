

CREATE procedure [dbo].[usp_catalogo_productoBenavides_V2]
as
set nocount on
declare @idioma char(5)
declare @codigo char(7)
declare @COD_PRODCLI char(20)
declare @fecha datetime
declare @estatus  varchar(1)
declare @codigo_checa char(7)


CREATE TABLE #catalogoBenavides([IDIOMA] [char](3) NOT NULL,
								[CODIGO] [char](7) NOT NULL,
								[COD_PRODCLI] [char](20) NOT NULL,
								[fecha] [datetime] NOT NULL,
								[estatus] [varchar](1) NOT NULL)

	insert into #catalogoBenavides 
  select IDIOMA,CODIGO,COD_PRODCLI,getdate() as fecha,'A' as estatus
 from openquery(as400, 'SELECT CAST(SUBSTRING(TRIM(T1.PXLANG) || ''     '', 1, 3) AS CHAR(3)) IDIOMA,
CAST(SUBSTRING(T1.PXPRDC || ''0000000'', 1, 7) AS CHAR(7)) CODIGO,CAST(RIGHT(''00000000000000000000'' || TRIM(T1.PXTX50), 20) AS CHAR(20)) COD_PRODCLI
FROM MA4620EF11.SROPRX T1 WHERE LENGTH(TRIM(T1.PXPRDC)) = 7 AND T1.PXLANG = ''BEN''
UNION SELECT CAST(SUBSTRING(TRIM(T1.PXLANG) || ''     '', 1, 3) AS CHAR(3)) IDIOMA,CAST(SUBSTRING(T1.PXPRDC || ''0000000'', 1, 7) AS CHAR(7)) CODIGO,  
CAST(RIGHT(''00000000000000000000'' || TRIM(T1.PXTX50), 20) AS CHAR(20)) COD_PRODCLI
FROM MA4620EF04.SROPRX T1 WHERE LENGTH(TRIM(T1.PXPRDC)) = 7 AND T1.PXLANG = ''BEN''') 
GROUP BY   idioma, codigo, cod_prodcli

insert into monkeyland..catalgoBenavides
select c.IDIOMA,c.CODIGO,c.COD_PRODCLI,c.fecha,c.estatus
from #catalogoBenavides c
left join monkeyland..catalgoBenavides c1 on c.IDIOMA=c1.IDIOMA 
and c.COD_PRODCLI=c1.COD_PRODCLI and c.CODIGO=c1.CODIGO
where c1.CODIGO is null

update c set c.CODIGO=c1.CODIGO,c.COD_PRODCLI=c1.COD_PRODCLI,c.fecha=getdate()
--select *
from monkeyland..catalgoBenavides c
inner join #catalogoBenavides c1 on c.IDIOMA=c1.IDIOMA 
and c.COD_PRODCLI=c1.COD_PRODCLI and c.CODIGO=c1.CODIGO


delete c
--select c.IDIOMA,c.CODIGO,c.COD_PRODCLI,c.fecha,c.estatus
from monkeyland..catalgoBenavides c
left join #catalogoBenavides c1 on c.IDIOMA=c1.IDIOMA 
and c.COD_PRODCLI=c1.COD_PRODCLI and c.CODIGO=c1.CODIGO
where c1.CODIGO is null

drop table #catalogoBenavides
set nocount off

--select count(*) from [monkeyland].[dbo].[catalgoBenavides] --4286
--select * from [monkeyland].[dbo].[catalgoBenavides] where CODIGO='0038501'
--update [monkeyland].[dbo].[catalgoBenavides] set [COD_PRODCLI]='1' where CODIGO='0038501'
--delete from [monkeyland].[dbo].[catalgoBenavides]  where CODIGO='0038501' and  [COD_PRODCLI]='1'
--insert into [catalgoBenavideshistorica]  select IDIOMA,CODIGO,COD_PRODCLI,fecha,estatus,getdate() from [catalgoBenavides] 

--select cast('2015-02-13 12:56:00' as datetime)

--select * from catalgoBenavides order by fecha

GO

