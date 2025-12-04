

CREATE view [dbo].[inventario_baan_con_11] as
	select sucursal, codigo, piezas, timestamp, derecho_devolucion from capa_ibs.dbo.inventario_baan with(nolock)
	union
	select sucursal, codigo, piezas, timestamp, derecho_devolucion from capa_ibs.dbo.inventario_baan2 with(nolock)

GO

