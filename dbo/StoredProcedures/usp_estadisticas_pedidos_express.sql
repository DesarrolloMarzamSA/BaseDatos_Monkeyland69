USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_estadisticas_pedidos_express]
WITH ENCRYPTION
as
SELECT 
t2.descripcion sucursal,
t1.cuenta,
t4.farmacia,
t1.arch_tandem,
convert(varchar(10), t1.fecha_pedido, 121) fecha_pedido,
sum(t1.cantidad_surtida *t3.prec_farm) monto
FROM 
MONKEYLAND.DBO.PEDIDOS_servidor_FTP t1 inner join monkeyland.dbo.sucursales t2 on t1.sucursal = t2.sucursal
inner join monkeyland.dbo.maestro_productos_baan t3 on t1.codigo = t3.codigo
inner join monkeyland.dbo.clientes_baan t4 on t1.sucursal = t4.sucursal and t1.cuenta = t4.cliente
wHERE 
FECHA_PEDIDO > dateadd(d, -1, current_timestamp) AND NOMBRE = 'express'
group by
t2.descripcion,
t1.cuenta,
t4.farmacia,
t1.arch_tandem,
convert(varchar(10), t1.fecha_pedido, 121)
GO
