
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE	--	CREATE
PROCEDURE [dbo].[usp_fsfa_pedidos_codigos]

AS




UPDATE pedidos_sfa SET
	codigo = mp.codigo
FROM pedidos_sfa p
INNER JOIN maestro_productos_baan mp ON mp.cod_barras = p.cod_barras
WHERE mp.codigo < dbo.gobierno()


UPDATE pedidos_sfa SET
	sucursal = cf.sucursal
FROM pedidos_sfa p
INNER JOIN cat_sucursales_sanfco_asis cf ON cf.cliente = p.cuenta


DELETE FROM pedidos_sfa WHERE 
codigo = '0000000' OR 
codigo > dbo.gobierno()



DELETE FROM pedidos_sfa WHERE 
cuenta = '00000' OR
sucursal = 0


GO
