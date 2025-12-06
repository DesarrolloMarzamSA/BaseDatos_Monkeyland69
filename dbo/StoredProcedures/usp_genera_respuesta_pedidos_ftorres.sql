
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
--	22 jul 2009
--	Genera FALTANTES (Respuestas de Pedidos) de FARMACIAS LAS TORRES

--  usp_genera_respuesta_pedidos_ftorres 'pedidos_ftorres'

CREATE PROCEDURE [dbo].[usp_genera_respuesta_pedidos_ftorres] @tabla varchar(100)

AS

--	declare @tabla varchar(100)
--	set @tabla = 'pedidos_ftorres'

DECLARE @pedido VARCHAR(15)
declare @query varchar(1000)
set @query = 

'SELECT 
  ped.pedido,
	ped.cod_barras, 
	CASE WHEN ped.cod_torres IS NULL THEN REPLICATE('' '',20) ELSE ped.cod_torres END cod_torres, 
	(CASE WHEN ped.descripcion IS NULL THEN ''PRODUCTO DESCONOCIDO'' 
		ELSE ped.descripcion END) descripcion, 
	ped.cod_torres codigo, 
	(CASE WHEN cantidad_surtida IS NULL OR cantidad_surtida = cantidad_pedida	THEN cantidad_pedida 
		ELSE cantidad_pedida - cantidad_surtida	END) faltante, 
	cliente, 
	cantidad_surtida, 
	cantidad_pedida 
INTO faltantes_ftorres
FROM '+ @tabla + ' ped 
WHERE ped.cantidad_surtida = 0 or PED.cantidad_surtida IS NULL OR ped.codigo IS NULL '

--  INNER JOIN cat_productos_torres tor ON tor.cod_mar = ped.codigo 

--	PRINT @query

EXECUTE (@query)


IF (SELECT COUNT(*) FROM faltantes_ftorres) = 0
	BEGIN
		SET @pedido =	(SELECT TOP 1 pedido FROM pedidos_ftorres)
		INSERT INTO faltantes_ftorres (pedido, cod_barras, cod_torres, descripcion, codigo, cantidad_pedida, faltante, cliente ) VALUES 
			(@pedido,REPLICATE('0',13),REPLICATE('0',20),REPLICATE(' ',100),REPLICATE('0',7) ,0,0,REPLICATE('0',5))
	END

SELECT 
  pedido + 
	LEFT( cod_barras	+ REPLICATE(' ',20) ,20) +  
	LEFT( cod_torres	+ REPLICATE(' ',20) ,20) +  
	LEFT( descripcion	+ REPLICATE(' ',52) ,52) +  
	LEFT( CONVERT(VARCHAR,faltante) + REPLICATE(' ', 7) ,7 ) +  
	LEFT( cliente + REPLICATE(' ',25),25) 
	--	,cantidad_surtida,cantidad_pedida
FROM faltantes_ftorres

--	select * from faltantes_ftorres

DROP TABLE faltantes_ftorres
GO
