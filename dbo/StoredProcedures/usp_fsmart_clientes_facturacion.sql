-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- [usp_fsmart_clientes_facturacion] '2023-11-27'
-- =============================================
CREATE PROCEDURE [dbo].[usp_fsmart_clientes_facturacion] @fecha varchar(10)
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
                 WHERE f.fecha_factura between  CONVERT(datetime,@fecha,121)-3 and   CONVERT(datetime,@fecha,121)+1
  --AND f.segto = 'E2' 
  AND f.ctepadre IN ('715','338','716','724') 
  AND f.sucursal IN (24,23,7,8)
				 ORDER BY f.sucursal, f.cliente
	
	 --select * from rutas_pedidos_AS400
			 --select * from cat_cuentasfsmart where cliente='X52497'
				;WITH tablaListado1(Fila,cliente,sucursal,letra)
			AS (
			select distinct ROW_NUMBER() OVER(PARTITION BY  cliente ORDER BY cliente,sucursal desc) AS Fila,cliente,sucursal,letra from  @tablaListado --where letra not in('W')
			)
			select cliente,case when cliente='11129' and sucursal=8 then 7 else sucursal end as sucursal,
			case when cliente='11129' and sucursal=8 then 'G' else letra end as letra			
			from tablaListado1 
			where Fila=1
			--order by cliente,sucursal
			--select * from rutas_pedidos_AS400 
END
 --select * from [sap].[facturacion_fsmart_sap] p
-- X52497
--X52528

-- 
--select distinct vbeln,altkn from [sap].[facturacion_fsmart_sap] where vbeln in('0900213496',
--'0900213586',
--'0900213547',
--'0900213499',
--'0900213500',
--'0900213501',
--'0900213548',
--'0900213593',
--'0900213730',
--'0900213731',
--'0900213828',
--'0900213824',
--'0900213827',
--'0900213834',
--'0900213833',
--'0900213732',
--'0900213825'
--)

GO

