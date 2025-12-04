

CREATE view [dbo].[productos_baan] as select codigo producto, convert(int, codigo) producto_int, descripcion, cod_barras from monkeyland.dbo.maestro_productos_baan with(nolock) where convert(int, codigo) < 6900000

GO

