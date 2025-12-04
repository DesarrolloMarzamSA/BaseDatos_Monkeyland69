
CREATE view [dbo].[rutas_ibs]
as
select t1.sucursal, t1.ip, t1.usuario, t1.password, t1.volumen ruta_pedidos, t1.respuestas ruta_respuestas, t1.letra, t2.ibs_letra 
from capa_ibs.dbo.rutas_facturacion_ibs t1 
inner join capa_ibs.dbo.sucursales t2 on t1.sucursal = t2.sucursal where t2.fisica = 1

GO

