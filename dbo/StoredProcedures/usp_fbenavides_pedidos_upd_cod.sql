
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE	--	CREATE
PROCEDURE [dbo].[usp_fbenavides_pedidos_upd_cod]	WITH ENCRYPTION
AS


DELETE FROM pedidos_benavides_historia
WHERE CONVERT(SMALLDATETIME,fecha_pedido,112) < DATEADD(DD, -8,  CURRENT_TIMESTAMP) 


UPDATE pedidos_benavides  SET 
	codigo = b.cod_mar, 
	descripcion = b.descripcion, 
	cod_barras = b.cod_barras 
FROM pedidos_benavides  ped 
INNER JOIN cat_productos_benavides b ON 
	ped.cod_bena = b.cod_ben 
	AND (ISNUMERIC(b.cod_mar) = 1) 
	AND b.cod_mar < dbo.gobierno()  ;


UPDATE pedidos_benavides SET 
	sucursal = cadena.sucursal, 
	cuenta = cadena.cuenta 
FROM pedidos_benavides  ped 
INNER JOIN cat_sucursales_benavides cadena ON 
	ped.cia = cadena.cia  AND activo = 1
	AND ped.mostrador = cadena.mostrador				;


-------------------------- chihuahua
UPDATE pedidos_benavides SET 
	letra 		 =  'Z'
FROM pedidos_benavides  ped 
INNER JOIN maestro_productos_baan mpb ON 
	mpb.clas_ssa IN ( '1', '2', '3') AND ped.codigo = mpb.codigo
WHERE sucursal IN (23, 24)


UPDATE pedidos_benavides SET 
	cuenta = ISNULL( (SELECT	cuenta FROM cat_sucursales_benavides 
		WHERE controlados = 1 AND cia = ped.cia	), '00000')
FROM pedidos_benavides  ped 
WHERE letra = 'Z' 
	AND sucursal IN (23, 24)
GO
