
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE	--	CREATE
PROCEDURE [dbo].[usp_fminne_pedidos_codigos]

WITH ENCRYPTION
AS

UPDATE pedidos_minne  SET 
	sucursal = s.sucursal
FROM pedidos_minne  ped 
INNER JOIN sucursales s ON s.letra = ped.letra


UPDATE pedidos_minne  SET 
	codigo = mpb.codigo, 
	descripcion = mpb.descripcion 
FROM pedidos_minne  ped 
INNER JOIN maestro_productos_baan mpb ON 
	CONVERT(INT,mpb.codigo) < dbo.gobierno() AND 
	ped.cod_barras = mpb.cod_barras

DELETE FROM pedidos_minne WHERE sucursal = 0

DELETE FROM pedidos_minne WHERE codigo = '0000000' 

DELETE FROM pedidos_minne WHERE cuenta = '00000' 

GO
