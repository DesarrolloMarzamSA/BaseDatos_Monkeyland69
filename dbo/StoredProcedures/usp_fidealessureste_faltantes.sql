
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


CREATE	--CREATE
PROCEDURE [dbo].[usp_fidealessureste_faltantes]	

--DECLARE
	@fecha VARCHAR(10)	
WITH ENCRYPTION
AS

--	SET @fecha = '2011-04-13'
/*
SELECT * FROM pedidos_fidealessureste_historia ped ORDER BY arch_tandem, orden 
EXECUTE usp_fidealessureste_faltantes '2011-04-13'
*/

--	2011-04-13		CREACION				MIGUEL SAMAYOA

--	TRUNCATE TABLE pedidos_fidealessureste_historia
SELECT 
	LEFT(ped.cuenta     + REPLICATE(' ',10) , 10)  cuenta    ,
	LEFT(ped.pedido     + REPLICATE(' ',10) , 10)  pedido    ,
	LEFT(ped.cod_barras + REPLICATE(' ',20) , 20)  cod_barras,
	LEFT(ped.codigo     + REPLICATE(' ',20) , 20)  codigo    ,
	RIGHT(REPLICATE(' ', 4) + CONVERT(VARCHAR,ISNULL( cantidad_pedida  , 0) ),  4) cantidad_pedida , 
	RIGHT(REPLICATE(' ', 4) + CONVERT(VARCHAR,ISNULL( cantidad_surtida , 0) ),  4) cantidad_surtida, 
	RIGHT(REPLICATE(' ',20) + (CASE WHEN cantidad_pedida > cantidad_surtida THEN 'FAL' WHEN codigo = '00000' THEN 'FEP' ELSE 'AAA' END) ,20) faltante--,
	--arch_cliente
FROM pedidos_fidealessureste_historia ped
WHERE fecha = CONVERT(SMALLDATETIME,@fecha,121)
ORDER BY arch_tandem, orden
GO
