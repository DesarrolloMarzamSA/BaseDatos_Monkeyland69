USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE	--	CREATE	--	DROP
PROCEDURE [dbo].[usp_fregis_pedidos_respuesta]
WITH ENCRYPTION
AS

SELECT  
	LEFT(ped.cuenta     + REPLICATE(' ', 5) ,  5) cliente,
	LEFT(ped.codigo     + REPLICATE(' ', 7) ,  7) codigo, 
	LEFT(descripcion    + REPLICATE(' ',30) , 30) descripcion, 
	RIGHT(REPLICATE('0', 5) + CONVERT(VARCHAR, ISNULL(cantidad_surtida,cantidad_pedida - cantidad_surtida )) ,  5) faltante
	--,	cantidad_surtida,
	--cantidad_pedida
FROM pedidos_fregis ped 

GO
