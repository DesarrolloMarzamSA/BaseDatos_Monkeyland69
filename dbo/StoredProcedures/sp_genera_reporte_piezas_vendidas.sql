
--EXEC [dbo].[sp_genera_reporte_piezas_vendidas] '20250705'

-- =============================================

-- Author:		<Author,,Name>

-- Create date: <Create Date,,>

-- Description:	<Description,,>

-- =============================================

CREATE PROCEDURE [dbo].[sp_genera_reporte_piezas_vendidas] 

	-- Add the parameters for the stored procedure here

@fecha char(8)

AS

BEGIN

	DECLARE @consultaAs400 Nvarchar(max)
	DECLARE @consultaSql Nvarchar(max)

   DECLARE @TableCountAs400 AS TABLE (registros int)
    DECLARE @CountTemporal int

	-- SET NOCOUNT ON added to prevent extra result sets from

	-- interfering with SELECT statements.

	SET NOCOUNT ON;


CREATE TABLE #cifras_temp

	(

	almacen varchar(5) NULL,

	codigo_cliente varchar(15) NULL,

	codigo_producto varchar(15) NULL,

	cantidad_pedida int NULL,

	cantidad_surtida int NULL,

	fecha varchar(15) NULL,

	tipo_documento1 varchar(5) NULL,

	tipo_documento2 varchar(5) NULL,

	cuenta_padre varchar(10) NULL,

	factura varchar(15) NULL,

	linea_factura int NULL

	)  ON [PRIMARY]



declare @query nvarchar(max)

SELECT @consultaAs400 = '

select COUNT(IDSROM)

 from MA4620EF04.SROISDPL where IDIDAT='+@fecha+'

and IDCCA1<>''''99995'''' and IDCCA1<>''''99998'''' and IDORDT not in (''''FZ'''',''''F1'''',''''F0'''',''''FA'''')
AND IDCUNO not in (''''A98840'''') and substring(rtrim(IDORDT),1,1)=''''F''''
and IDORNO not in (
''''79647150'''',
''''79647175'''',
''''79647239'''',
''''79647369'''',
''''79649402'''',
''''79649409'''',
''''79649416'''',
''''79649419'''',
''''79649432'''',
''''79649431'''',
''''79649464'''',
''''79649487'''',
''''79649491'''',
''''79649497'''',
''''79649500'''',
''''79649503'''',
''''79649518'''',
''''79649521'''',
''''79649545'''',
''''79649552'''',
''''79649575'''',
''''79649590'''',
''''79649594'''',
''''79649597'''',
''''79649601'''',
''''79649604'''',
''''79649606'''',
''''79649609'''',
''''79649617'''',
''''79649625'''',
''''79649923'''',
''''79650314'''',
''''79650468'''',
''''79650538'''',
''''79650750'''',
''''79650927'''',
''''79651154'''',
''''79651737'''',
''''79651726'''',
''''79651817'''',
''''79651907'''',
''''79652115'''',
''''79652223'''',
''''79652375'''',
''''79652474'''',
''''79652745'''',
''''79653346'''',
''''79654238'''',
''''79654457'''',
''''79654574'''',
''''79654578'''',
''''79654589'''',
''''79654593'''',
''''79654600'''',
''''79654602'''',
''''79654644'''',
''''79654614'''',
''''79655034'''',
''''79655040'''',
''''79655107'''',
''''79655063'''',
''''79655128'''',
''''79655809'''',
''''79655849'''',
''''79655910'''',
''''79656142'''',
''''79656178'''',
''''79656334'''',
''''79657017'''',
''''79657022'''',
''''79657025'''',
''''79657026'''',
''''79657027'''',
''''79657030'''',
''''79657031'''',
''''79657038'''',
''''79657050'''',
''''79657063'''',
''''79657068'''',
''''79657077'''',
''''79657098'''',
''''79657046'''',
''''79657141'''',
''''79657150'''',
''''79657161'''',
''''79657163'''',
''''79657174'''',
''''79657181'''',
''''79657191'''',
''''79657196'''',
''''79657198'''',
''''79657200'''',
''''79657201'''',
''''79657207'''',
''''79657214'''',
''''79657215'''',
''''79657217'''',
''''79657216'''',
''''79657218'''',
''''79657222'''',
''''79657223'''',
''''79657230'''',
''''79657232'''',
''''79657246'''',
''''79657262'''',
''''79657266'''',
''''79657267'''',
''''79657269'''',
''''79657270'''',
''''79657274'''',
''''79657275'''',
''''79657277'''',
''''79657820'''')

union ALL

select COUNT(IDSROM)

 from MA4620EF11.SROISDPL where IDIDAT='+@fecha+'

and IDCCA1<>''''99995'''' and IDCCA1<>''''99998'''' and IDORDT not in (''''FZ'''',''''F1'''',''''F0'''',''''FA'''')
AND IDCUNO not in (''''A98840'''') and substring(rtrim(IDORDT),1,1)=''''F''''
and IDORNO not in (
''''79647150'''',
''''79647175'''',
''''79647239'''',
''''79647369'''',
''''79649402'''',
''''79649409'''',
''''79649416'''',
''''79649419'''',
''''79649432'''',
''''79649431'''',
''''79649464'''',
''''79649487'''',
''''79649491'''',
''''79649497'''',
''''79649500'''',
''''79649503'''',
''''79649518'''',
''''79649521'''',
''''79649545'''',
''''79649552'''',
''''79649575'''',
''''79649590'''',
''''79649594'''',
''''79649597'''',
''''79649601'''',
''''79649604'''',
''''79649606'''',
''''79649609'''',
''''79649617'''',
''''79649625'''',
''''79649923'''',
''''79650314'''',
''''79650468'''',
''''79650538'''',
''''79650750'''',
''''79650927'''',
''''79651154'''',
''''79651737'''',
''''79651726'''',
''''79651817'''',
''''79651907'''',
''''79652115'''',
''''79652223'''',
''''79652375'''',
''''79652474'''',
''''79652745'''',
''''79653346'''',
''''79654238'''',
''''79654457'''',
''''79654574'''',
''''79654578'''',
''''79654589'''',
''''79654593'''',
''''79654600'''',
''''79654602'''',
''''79654644'''',
''''79654614'''',
''''79655034'''',
''''79655040'''',
''''79655107'''',
''''79655063'''',
''''79655128'''',
''''79655809'''',
''''79655849'''',
''''79655910'''',
''''79656142'''',
''''79656178'''',
''''79656334'''',
''''79657017'''',
''''79657022'''',
''''79657025'''',
''''79657026'''',
''''79657027'''',
''''79657030'''',
''''79657031'''',
''''79657038'''',
''''79657050'''',
''''79657063'''',
''''79657068'''',
''''79657077'''',
''''79657098'''',
''''79657046'''',
''''79657141'''',
''''79657150'''',
''''79657161'''',
''''79657163'''',
''''79657174'''',
''''79657181'''',
''''79657191'''',
''''79657196'''',
''''79657198'''',
''''79657200'''',
''''79657201'''',
''''79657207'''',
''''79657214'''',
''''79657215'''',
''''79657217'''',
''''79657216'''',
''''79657218'''',
''''79657222'''',
''''79657223'''',
''''79657230'''',
''''79657232'''',
''''79657246'''',
''''79657262'''',
''''79657266'''',
''''79657267'''',
''''79657269'''',
''''79657270'''',
''''79657274'''',
''''79657275'''',
''''79657277'''',
''''79657820'''')

with ur '

SELECT @consultaSql= 'select *

from openquery(AS400, '''+@consultaAs400+''') '  

insert into @TableCountAs400
EXEC sp_executesql @consultaSql

--SELECT * FROM @TableCountAs400;

--SELECT COUNT(1) FROM @TableCountAs400;

--SELECT SUM(registros) FROM @TableCountAs400


select @query=' insert into #cifras_temp (almacen,codigo_cliente,codigo_producto,cantidad_pedida,cantidad_surtida,fecha,tipo_documento1,tipo_documento2,cuenta_padre,factura,linea_factura)

select rtrim(IDSROM),

       rtrim(IDCUNO),

	   rtrim(IDPRDC),

	   IDSQTY,

	   IDQTY,

	   rtrim(IDIDAT),

	   substring(rtrim(IDORDT),1,1),

	   rtrim(IDTYPP),

	   rtrim(IDCCA1),

	   rtrim(IDINVN),

	   rtrim(IDLINE)

from openquery(AS400,''

select IDSROM,IDCUNO,IDPRDC,IDSQTY,IDQTY,IDIDAT,IDORDT,IDTYPP,IDCCA1,IDINVN,IDLINE

 from MA4620EF04.SROISDPL where IDIDAT='''''+@fecha+'''''

and IDCCA1<>''''99995'''' and IDCCA1<>''''99998'''' and IDORDT not in (''''FZ'''',''''F1'''',''''F0'''',''''FA'''')
AND IDCUNO not in (''''A98840'''') and substring(rtrim(IDORDT),1,1)=''''F''''
and IDORNO not in (
''''79647150'''',
''''79647175'''',
''''79647239'''',
''''79647369'''',
''''79649402'''',
''''79649409'''',
''''79649416'''',
''''79649419'''',
''''79649432'''',
''''79649431'''',
''''79649464'''',
''''79649487'''',
''''79649491'''',
''''79649497'''',
''''79649500'''',
''''79649503'''',
''''79649518'''',
''''79649521'''',
''''79649545'''',
''''79649552'''',
''''79649575'''',
''''79649590'''',
''''79649594'''',
''''79649597'''',
''''79649601'''',
''''79649604'''',
''''79649606'''',
''''79649609'''',
''''79649617'''',
''''79649625'''',
''''79649923'''',
''''79650314'''',
''''79650468'''',
''''79650538'''',
''''79650750'''',
''''79650927'''',
''''79651154'''',
''''79651737'''',
''''79651726'''',
''''79651817'''',
''''79651907'''',
''''79652115'''',
''''79652223'''',
''''79652375'''',
''''79652474'''',
''''79652745'''',
''''79653346'''',
''''79654238'''',
''''79654457'''',
''''79654574'''',
''''79654578'''',
''''79654589'''',
''''79654593'''',
''''79654600'''',
''''79654602'''',
''''79654644'''',
''''79654614'''',
''''79655034'''',
''''79655040'''',
''''79655107'''',
''''79655063'''',
''''79655128'''',
''''79655809'''',
''''79655849'''',
''''79655910'''',
''''79656142'''',
''''79656178'''',
''''79656334'''',
''''79657017'''',
''''79657022'''',
''''79657025'''',
''''79657026'''',
''''79657027'''',
''''79657030'''',
''''79657031'''',
''''79657038'''',
''''79657050'''',
''''79657063'''',
''''79657068'''',
''''79657077'''',
''''79657098'''',
''''79657046'''',
''''79657141'''',
''''79657150'''',
''''79657161'''',
''''79657163'''',
''''79657174'''',
''''79657181'''',
''''79657191'''',
''''79657196'''',
''''79657198'''',
''''79657200'''',
''''79657201'''',
''''79657207'''',
''''79657214'''',
''''79657215'''',
''''79657217'''',
''''79657216'''',
''''79657218'''',
''''79657222'''',
''''79657223'''',
''''79657230'''',
''''79657232'''',
''''79657246'''',
''''79657262'''',
''''79657266'''',
''''79657267'''',
''''79657269'''',
''''79657270'''',
''''79657274'''',
''''79657275'''',
''''79657277'''',
''''79657820'''')
union

select IDSROM,IDCUNO,IDPRDC,IDSQTY,IDQTY,IDIDAT,IDORDT,IDTYPP,IDCCA1,IDINVN,IDLINE

 from MA4620EF11.SROISDPL where IDIDAT='''''+@fecha+'''''

and IDCCA1<>''''99995'''' and IDCCA1<>''''99998'''' and IDORDT not in (''''FZ'''',''''F1'''',''''F0'''',''''FA'''')
AND IDCUNO not in (''''A98840'''') and substring(rtrim(IDORDT),1,1)=''''F''''
and IDORNO not in (
''''79647150'''',
''''79647175'''',
''''79647239'''',
''''79647369'''',
''''79649402'''',
''''79649409'''',
''''79649416'''',
''''79649419'''',
''''79649432'''',
''''79649431'''',
''''79649464'''',
''''79649487'''',
''''79649491'''',
''''79649497'''',
''''79649500'''',
''''79649503'''',
''''79649518'''',
''''79649521'''',
''''79649545'''',
''''79649552'''',
''''79649575'''',
''''79649590'''',
''''79649594'''',
''''79649597'''',
''''79649601'''',
''''79649604'''',
''''79649606'''',
''''79649609'''',
''''79649617'''',
''''79649625'''',
''''79649923'''',
''''79650314'''',
''''79650468'''',
''''79650538'''',
''''79650750'''',
''''79650927'''',
''''79651154'''',
''''79651737'''',
''''79651726'''',
''''79651817'''',
''''79651907'''',
''''79652115'''',
''''79652223'''',
''''79652375'''',
''''79652474'''',
''''79652745'''',
''''79653346'''',
''''79654238'''',
''''79654457'''',
''''79654574'''',
''''79654578'''',
''''79654589'''',
''''79654593'''',
''''79654600'''',
''''79654602'''',
''''79654644'''',
''''79654614'''',
''''79655034'''',
''''79655040'''',
''''79655107'''',
''''79655063'''',
''''79655128'''',
''''79655809'''',
''''79655849'''',
''''79655910'''',
''''79656142'''',
''''79656178'''',
''''79656334'''',
''''79657017'''',
''''79657022'''',
''''79657025'''',
''''79657026'''',
''''79657027'''',
''''79657030'''',
''''79657031'''',
''''79657038'''',
''''79657050'''',
''''79657063'''',
''''79657068'''',
''''79657077'''',
''''79657098'''',
''''79657046'''',
''''79657141'''',
''''79657150'''',
''''79657161'''',
''''79657163'''',
''''79657174'''',
''''79657181'''',
''''79657191'''',
''''79657196'''',
''''79657198'''',
''''79657200'''',
''''79657201'''',
''''79657207'''',
''''79657214'''',
''''79657215'''',
''''79657217'''',
''''79657216'''',
''''79657218'''',
''''79657222'''',
''''79657223'''',
''''79657230'''',
''''79657232'''',
''''79657246'''',
''''79657262'''',
''''79657266'''',
''''79657267'''',
''''79657269'''',
''''79657270'''',
''''79657274'''',
''''79657275'''',
''''79657277'''',
''''79657820'''')
with ur

'')  where IDCUNO not in (''A98840'') and substring(rtrim(IDORDT),1,1)=''F'''



EXEC sp_executesql @query
print 'ejecucion AS400';


PRINT 'INICIA COUNT';
set @CountTemporal = (SELECT COUNT(1) FROM #cifras_temp)
PRINT 'TERMIN count: ' + CONVERT(VARCHAR(10), @CountTemporal);

BEGIN 
TRY

IF ( (SELECT SUM(ISNULL(registros, 0)) from @TableCountAs400) = @CountTemporal)
 BEGIN
 print 'inicia proceso if';

select factura into #facturaExcluir from #cifras_temp where codigo_producto>=9900000

insert into #facturaExcluir (factura) values ('60700017049')



--<28/08/2019> Edson y Luis Angel Se agrego el almacen U01 a la lista de exclusiones 



	
SELECT almacen,codigo_cliente, codigo_producto, SUM(cantidad_pedida) AS cantidad_pedida,
            0 AS cantidad_ofertada, SUM(cantidad_surtida) AS cantidad_entregada
   into #cifras_ventas
   FROM #cifras_temp
   WHERE fecha=@fecha and tipo_documento1 = 'F' AND (tipo_documento2 = 1) AND (cuenta_padre not in (99995,99998,99940))
    and almacen not in ('Y01','Y02','Y03','Y04','Y05','Y06','Y07','Y08','Y09',
					   'Z01','Z02','Z03','Z04','Z05','Z06','Z07','Z08','Z09','UWA','JWA','CWA','UFM','U01','U02','U03') 
    --and factura not IN ('60700017049') --esta nota no debe de ser reportada ya que es erronea fecha=20140327
    and factura not IN (select factura from #facturaExcluir) 
   GROUP BY almacen, codigo_cliente, codigo_producto



   print 'ejecucion cifras control';

   merge into reportePiezas as destino
   using(select [almacen],[codigo_cliente],[codigo_producto],[cantidad_pedida],[cantidad_surtida],[fecha],[tipo_documento1],[tipo_documento2],[cuenta_padre],[factura],[linea_factura]
		 from #cifras_temp
		 WHERE fecha=@fecha and tipo_documento1 = 'F' AND (tipo_documento2 = 1) AND (cuenta_padre not in (99995,99998,99940))
				and almacen not in ('Y01','Y02','Y03','Y04','Y05','Y06','Y07','Y08','Y09',
								    'Z01','Z02','Z03','Z04','Z05','Z06','Z07','Z08','Z09','UWA','JWA','CWA','UFM') 
				--and factura not IN ('60700017049')) as origen
				and factura not IN (select factura from #facturaExcluir)) as origen
	on destino.factura=origen.factura
	when not matched then
		insert values(origen.[almacen],origen.[codigo_cliente],origen.[codigo_producto],origen.[cantidad_pedida],origen.[cantidad_surtida],
					  CONVERT(datetime,stuff(stuff(cast(origen.[fecha] as varchar),5,0,'-'),8,0,'-')+ ' 00:00:000',120),
					  origen.[tipo_documento1],origen.[tipo_documento2],origen.[cuenta_padre],origen.[factura],origen.[linea_factura]);
   


   print 'se genera merge';
   
   select * from (
SELECT x.almacen,'000000' AS codigo_cliente, COUNT(x.almacen) AS codigo_producto,
 SUM(cantidad_pedida) AS cantidad_pedida, 0 AS cantidad_ofertada, SUM(cantidad_entregada) AS cantidad_entregada
   FROM #cifras_ventas as x
   GROUP BY x.almacen
   union
   select almacen,codigo_cliente, codigo_producto, cantidad_pedida,cantidad_ofertada,cantidad_entregada
   from #cifras_ventas
) as datos
   ORDER BY almacen, codigo_cliente

   print 'informacion devuelta';

drop table #cifras_temp

drop table #cifras_ventas

END

ELSE
BEGIN

SELECT 'Hubo perdida de informacion al crear tabla'
drop table #cifras_temp

END
end TRY
   BEGIN
   CATCH 
		 
			
			PRINT ERROR_MESSAGE(); -- Retrieve the error message    
			PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR(10));     PRINT 'Error Severity: ' + CAST(ERROR_SEVERITY() AS NVARCHAR(10));     PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR(10));
   end CATCH

END

GO

