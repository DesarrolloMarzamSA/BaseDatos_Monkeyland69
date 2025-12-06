
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE	--	CREATE	--	DROP
PROCEDURE [dbo].[usp_fregis_pedidos_rechazos]

AS

SELECT  
	LEFT(ped.cuenta					+ REPLICATE(' ', 5) ,  5) cliente,
	LEFT(ped.codigo    			+ REPLICATE(' ', 7) ,  7) codigo, 
	LEFT(ped.descripcion		+ REPLICATE(' ',30) , 30) descripcion, 
	RIGHT(REPLICATE('0', 5)	+ CONVERT(VARCHAR, cantidad_pedida) ,  5) faltante
	--,	cantidad_surtida,
	--cantidad_pedida
FROM pedidos_fregis ped 
INNER JOIN maestro_productos mp ON mp.codigo = ped.codigo --AND mp.lab_corto = 'MERCK'
INNER JOIN inventario_baan ib ON ib.sucursal = 7 AND ib.codigo = ped.codigo AND ib.piezas = 0
GO
