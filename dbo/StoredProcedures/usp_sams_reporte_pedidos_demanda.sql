USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_sams_reporte_pedidos_demanda]
WITH ENCRYPTION
as
select t2.descripcion sucursal, t3.farmacia, t1.cliente, t1.factura, t1.folio_fiscal, t1.codigo, t1.cod_barras, t1.descripcion, t1.piezas_surtidas_con_cargo, t1.importe_neto from 
facturacion_electronica_estandar t1 inner join sucursales t2 on t1.sucursal = t2.sucursal 
inner join clientes_baan t3 on (t1.sucursal = t3.sucursal and t1.cliente = t3.cliente) or (t1.sucursal = 5 and t3.sucursal = 9 and t1.cliente = t3.cliente) or (t1.sucursal = 9 and t3.sucursal = 5 and t1.cliente = t3.cliente)
where t1.sucursal = 4 and t1.folio_fiscal in (
'60321376',
'60321378',
'60324258',
'60333246')
GO
