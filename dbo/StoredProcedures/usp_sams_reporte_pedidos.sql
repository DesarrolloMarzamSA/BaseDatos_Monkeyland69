
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_sams_reporte_pedidos]

as
select t2.descripcion sucursal, t3.farmacia, t1.cliente, t1.factura, t1.folio_fiscal, t1.codigo, t1.cod_barras, t1.descripcion, t1.piezas_surtidas_con_cargo, t1.importe_neto from 
facturacion_electronica_estandar t1 inner join sucursales t2 on t1.sucursal = t2.sucursal 
inner join clientes_baan t3 on (t1.sucursal = t3.sucursal and t1.cliente = t3.cliente) or (t1.sucursal = 5 and t3.sucursal = 9 and t1.cliente = t3.cliente) or (t1.sucursal = 9 and t3.sucursal = 5 and t1.cliente = t3.cliente)
where t1.fecha_tandem = convert(datetime, convert(varchar(10), current_timestamp, 121) , 121) and  t1.segto = 'E1' and t1.ctepadre = '139'
--where t1.fecha_tandem >= convert(datetime, convert(varchar(10), '2011-02-01', 121) , 121) and  t1.segto = 'E1' and t1.ctepadre = '139'
--and t1.sucursal = 5 and t1.cliente = '02529'


GO
