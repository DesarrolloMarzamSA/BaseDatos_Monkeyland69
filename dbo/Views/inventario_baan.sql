


CREATE view [dbo].[inventario_baan] as select sucursal, codigo, piezas, timestamp, derecho_devolucion from capa_ibs.dbo.inventario_baan with(nolock)

GO

