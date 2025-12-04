-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- [usp_fsmart_clientes_facturacion_reproceso] '2016-07-25'
-- =============================================
CREATE PROCEDURE [dbo].[usp_fsmart_clientes_facturacion_reproceso] @fecha varchar(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

declare @tablaListado table(cliente varchar(5),sucursal int,letra varchar(1))
	
	insert into @tablaListado
	SELECT distinct f.cliente,f.sucursal,rt.letra 
				 FROM facturacion_electronica_estandar f 
                 inner join rutas_pedidos_AS400 rt on f.sucursal = rt.sucursal
                 WHERE-- f.fecha_factura between  CONVERT(datetime,@fecha,121)-1 and   CONVERT(datetime,@fecha,121)+1
  --AND f.segto = 'E2' 
				
  f.factura in('00247553','00247822')
  AND f.ctepadre IN ('715','338','716','724') 
  AND f.sucursal IN (24,23,7,8)
				 ORDER BY f.sucursal, f.cliente
	
	--insert into @tablaListado
--select distinct substring(isnull(p.ALTKN,''),2,6) as cliente,c.sucursal,case when rt.letra='W' then 'X' else rt.letra end letra
--			from cat_cuentasfsmart c inner join [sap].[facturacion_fsmart_sap] p on rtrim(c.cliente)=rtrim(p.ALTKN)
--			 inner join rutas_pedidos_AS400 rt on c.sucursal = rt.sucursal
--			  WHERE p.[PARTNER]='0016008134'
			  --p.[VBELN] in('0900514654','0900520334','0900520335') --p.FKDAT between cast( CONVERT(datetime,@fecha,121)-1 as date) and   cast(CONVERT(datetime,@fecha,121)+1 as date)
			 --select * from rutas_pedidos_AS400
			 --select * from cat_cuentasfsmart where cliente='X52497'
				;WITH tablaListado1(Fila,cliente,sucursal,letra)
			AS (
			select distinct ROW_NUMBER() OVER(PARTITION BY  cliente ORDER BY cliente,sucursal desc) AS Fila,cliente,sucursal,letra from  @tablaListado --where letra not in('W')
			)
			select cliente,sucursal,letra from tablaListado1 where Fila=1
				
END

GO

