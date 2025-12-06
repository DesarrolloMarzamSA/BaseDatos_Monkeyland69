
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_checa_ofaestan]
WITH ENCRYPTION
as

declare @sucursal varchar(50)
declare @fecha_facturacion varchar(50)
declare @facturas varchar(50)
declare @lineas varchar(50)

select 
t1.sucursal, t1.fecha_factura, count(t1.codigo) lineas
into #lineas
from
historica.dbo.facturacion_electronica_estandar t1
where
t1.fecha_factura = convert(datetime, convert(varchar(10), current_timestamp, 121), 121)
group by 
t1.sucursal, t1.fecha_factura

select sucursal, fecha_factura, count(factura) facturas into #facturas from
(select 
t1.sucursal, t1.fecha_factura, t1.factura, count(t1.codigo) lineas
from
historica.dbo.facturacion_electronica_estandar t1
where
t1.fecha_factura = convert(datetime, convert(varchar(10), current_timestamp, 121), 121)
group by 
t1.sucursal, t1.fecha_factura, t1.factura) t1
group by
sucursal, fecha_factura


select t3.descripcion sucursal, isnull(convert(varchar(10), t1.fecha_factura, 121), 'ERROR') fecha_facturacion , isnull(convert(varchar(10), t1.facturas), 'ERROR') facturas, isnull(convert(varchar(10), t2.lineas), 'ERROR') lineas 
into #checaras
from
#facturas t1 inner join #lineas t2 on t1.sucursal = t2.sucursal
right outer join sucursales t3 on t1.sucursal = t3.sucursal
where t3.sucursal <> 2


declare mi_cursor cursor fast_forward for select sucursal, fecha_facturacion, facturas, lineas from #checaras

open mi_cursor



fetch next from mi_cursor into @sucursal, @fecha_facturacion, @facturas, @lineas
while @@fetch_status = 0
begin
	if (@facturas = 'ERROR') or @lineas = 'ERROR' 
	begin
		insert into monkeyland.dbo.bitacora(interfase, mensaje, resultado, timestamp) values('Importacion ofaestan (fact elec std)', 'Fallo importacion de DSTANDAR de la sucursal ' + @sucursal, 0, current_timestamp)
	end
	if(@fecha_facturacion <> 'ERROR' and @facturas <> 'ERROR' and @lineas <> 'ERROR')
	begin
		insert into monkeyland.dbo.bitacora(interfase, mensaje, resultado, timestamp) values('Importacion ofaestan (fact elec std)', 'Importacion exitosa en suc ' + @sucursal + ' ' + @facturas + ' facturas y ' + @lineas + ' lineas', 1, current_timestamp)
	end
	fetch next from mi_cursor into @sucursal, @fecha_facturacion, @facturas, @lineas
end
close mi_cursor
deallocate mi_cursor
drop table #lineas
drop table #facturas
GO
