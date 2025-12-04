SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_benavides_existencias]
as
SELECT 
	t2.descripcion sucursal,
	t1.codigo,
	t3.descripcion,
	t1.piezas
FROM monkeyland.dbo.inventario_baan t1 
INNER JOIN monkeyland.dbo.sucursales t2 on 
	t1.sucursal = t2.sucursal and t2.fisica = 1
INNER JOIN monkeyland.dbo.maestro_productos_baan t3 on 
	t1.codigo = t3.codigo
INNER JOIN monkeyland.dbo.vw_cat_productos_benavides_fe t4 on 
	t1.codigo = t4.cod_mar
/*	
inner join monkeyland.dbo.catalogo_autoservicios t4 on 
	t1.codigo = t4.codigo and t4.sucursal = 7 and t4.segto = 'C1' and t4.ctepadre = '319' and t4.status = 'A'
	*/
ORDER BY
	t2.descripcion,
	t1.codigo,
	t3.descripcion,
	t1.piezas
GO
