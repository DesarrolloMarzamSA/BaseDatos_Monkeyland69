USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE	--	CREATE
PROCEDURE [dbo].[usp_fsmart_pedidos_codigos]

WITH ENCRYPTION
AS

UPDATE pedidos_fsmart  SET 
	sucursal = s.sucursal
FROM pedidos_fsmart  ped 
INNER JOIN sucursales s ON s.letra = ped.letra


UPDATE pedidos_fsmart  SET 
	codigo = mpb.codigo, 
	descripcion = mpb.descripcion 
FROM pedidos_fsmart  ped 
INNER JOIN maestro_productos_baan mpb ON 
	CONVERT(INT,mpb.codigo) < dbo.gobierno() 
	--AND CONVERT(BIGINT,ped.cod_barras) = CONVERT(BIGINT,mpb.cod_barras )
	AND ped.cod_barras = mpb.cod_barras 

DELETE FROM pedidos_fsmart 
WHERE codigo = '0000000' 

DELETE FROM pedidos_fsmart 
WHERE cuenta = '00000'  

DELETE FROM pedidos_fsmart 
WHERE sucursal = 0
GO
