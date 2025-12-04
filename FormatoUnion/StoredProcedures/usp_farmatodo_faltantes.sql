

CREATE PROCEDURE [FormatoUnion].[usp_farmatodo_faltantes]	
	@fecha VARCHAR(10)	
AS

SELECT 
	right(REPLICATE('0',7)+ped.cuenta , 7)  cuenta    ,
	right(REPLICATE(' ',15)+ped.pedido , 15)  pedido    ,
	convert(varchar(8),fecha,112) as fecha,
	right(REPLICATE('0',15)+ped.cod_barras , 15)  cod_barras,
	right(REPLICATE('0',7)+ CONVERT(varchar(7), isnull(cantidad_pedida,0) - isnull(cantidad_surtida,0)),7) as faltante
FROM [FormatoUnion].[pedidos_farmatodo_historia] ped
WHERE fecha = CONVERT(SMALLDATETIME,@fecha,121) and (isnull(cantidad_pedida,0)-isnull(cantidad_surtida,0))>0
ORDER BY arch_tandem, orden

GO

