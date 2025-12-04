

CREATE view [dbo].[ibs_respuestas_traductor]
as
select 
substring(t1.archivo, 1, 8) archivo,
t1.sucursal,
t1.cliente,
t1.codigo, 
t1.cant_ped,
t1.cant_surt,
isnull(t2.resp_handheld, '7') motivo,
t1.prec_farm,
t1.fecha_pedido,
t1.ibs_orno,
t1.fecha_respuesta,
T1.orden
from
capa_ibs.dbo.pedidos_traductor t1 with(nolock) 
left outer join capa_ibs.dbo.destinos_detalle_ibs t2 with(nolock) 
on t1.motivo_no_surtido = t2.dest_det

GO

