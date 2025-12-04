
CREATE view [dbo].[inventario_baan_sin_filtro] as select sucursal, codigo, piezas, desplazamiento, transito, timestamp, derecho_devolucion, status from capa_ibs.dbo.inventario_baan_sin_filtro with(nolock)

GO

