
CREATE PROCEDURE [dbo].[usp_funion_faltantes]	
	@fecha VARCHAR(10)	
AS

--	SET @fecha = '2011-04-13'
/*
SELECT * FROM pedidos_funion_historia ped ORDER BY arch_tandem, orden 
EXECUTE usp_funion_faltantes '2011-04-13'
*/

--	2011-04-13		CREACION				MIGUEL SAMAYOA

--	TRUNCATE TABLE pedidos_funion_historia
--codigo original antes del cambio en 2018/09/12
/*
SELECT 
	LEFT(ped.cuenta     + REPLICATE(' ',10) , 10)  cuenta    ,
	LEFT(ped.pedido     + REPLICATE(' ',10) , 10)  pedido    ,
	LEFT(ped.cod_barras + REPLICATE(' ',20) , 20)  cod_barras,
	LEFT(ped.codigo     + REPLICATE(' ',20) , 20)  codigo    ,
	RIGHT(REPLICATE(' ', 4) + CONVERT(VARCHAR,ISNULL( cantidad_pedida  , 0) ),  4) cantidad_pedida , 
	RIGHT(REPLICATE(' ', 4) + CONVERT(VARCHAR,ISNULL( cantidad_surtida , 0) ),  4) cantidad_surtida, 
	RIGHT(REPLICATE(' ',20) + (CASE WHEN cantidad_pedida > cantidad_surtida THEN 'FAL' WHEN codigo = '00000' THEN 'FEP' ELSE 'AAA' END) ,20) faltante--,
	--arch_cliente
FROM pedidos_funion_historia ped
WHERE fecha = CONVERT(SMALLDATETIME,@fecha,121)
ORDER BY arch_tandem, orden
*/

--nuevo formato solicitado el 2018/08/27
SELECT 
	right(REPLICATE('0',7)+ped.cuenta , 7)  cuenta    ,
	right(REPLICATE(' ',15)+ped.pedido , 15)  pedido    ,
	convert(varchar(8),fecha,112) as fecha,
	right(REPLICATE('0',15)+ped.cod_barras , 15)  cod_barras,
	right(REPLICATE('0',7)+ CONVERT(varchar(7), isnull(cantidad_pedida,0) - isnull(cantidad_surtida,0)),7) as faltante
FROM pedidos_funion_historia ped
WHERE fecha = CONVERT(SMALLDATETIME,@fecha,121) and isnull(cantidad_pedida-cantidad_surtida,0)>0
ORDER BY arch_tandem, orden

GO

