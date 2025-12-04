USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE	--	CREATE	--	DROP
PROCEDURE [dbo].[usp_fenix_pedidos_codigos]

WITH ENCRYPTION
AS

/*
EXECUTE usp_fenix_pedidos_codigos
*/
--BEGIN TRANSACTION
UPDATE pedidos_elfenix SET 
	codigo = mpb.codigo, 
	descripcion = mpb.descripcion, 
	importe = (ped.cantidad_pedida * mpb.prec_farm), 
	prec_farm = mpb.prec_farm 
FROM pedidos_elfenix  ped 
INNER JOIN maestro_productos_baan mpb ON 
	CONVERT(BIGINT, ped.cod_barras) = CONVERT(BIGINT, mpb.cod_barras ) 
WHERE 
	CONVERT(INT,mpb.codigo) < dbo.gobierno()

UPDATE pedidos_elfenix SET 
	sucursal = fenix.sucursal, 
	cuenta = fenix.cliente 
FROM pedidos_elfenix  ped 
INNER JOIN CatTiendasFenix fenix ON 
	CONVERT(INT,ped.mostrador) = CONVERT(INT,fenix.numTienda) 

DELETE FROM pedidos_elfenix
WHERE codigo = REPLICATE('0', 7)

DELETE FROM pedidos_elfenix
WHERE cuenta = REPLICATE('0', 5)
--ROLLBACK
GO
