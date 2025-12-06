
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE	--	CREATE	--	DROP
PROCEDURE [dbo].[usp_chedraui_pedidos_faltantes]
WITH ENCRYPTION
AS

/*
EXECUTE usp_chedraui_pedidos_faltantes
*/

SELECT 

	LEFT(upc  + REPLICATE(' ', 13) , 13)															AS	ean,
--cantidad_solicitada,
	RIGHT(REPLICATE(' ',  4)  + CONVERT(VARCHAR,cantidad_pedida) , 4)	AS	cantidad_pedida,
--cantidad_surtida,
	RIGHT(REPLICATE(' ',  4)  + CONVERT(VARCHAR,
		cantidad_pedida - cantidad_surtida) , 4)												AS	 faltante ,
	LEFT(orden_pharmacy + REPLICATE(' ', 11) , 11)										AS	orden_pharmacy, 
	LEFT(pc.tienda + REPLICATE(' ', 12) , 12)													AS	tienda,
	LEFT(CONVERT(VARCHAR,ct.zona) + REPLICATE(' ', 12) , 12)														AS	zona

FROM pedidos_chedraui_v3 pc
INNER JOIN catalogo_chedraui_tiendas_V3 ct ON 
	ct.tienda = pc.tienda --AND 


ORDER BY linea
GO
