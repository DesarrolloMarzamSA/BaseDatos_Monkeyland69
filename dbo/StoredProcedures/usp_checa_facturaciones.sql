


create  procedure [dbo].[usp_checa_facturaciones]
as
/*

select t3.descripcion sucursal, t1.fecha_facturacion, t1.facturas, t2.lineas from
(select t2.descripcion sucursal, t1.fechaprog fecha_facturacion, count(t1.factura) facturas
from encabezado t1 inner join sucursales t2 on t1.sucursal = t2.sucursal
where t1.fechaprog = convert(datetime, convert(varchar(10), current_timestamp, 121), 121)
group by t2.descripcion, t1.fechaprog) t1 inner join
(select t2.descripcion sucursal, t1.fechaprog fecha_facturacion, count(t3.factura) lineas
from encabezado t1 inner join sucursales t2 on t1.sucursal = t2.sucursal
inner join detalle t3 on t1.sucursal = t3.sucursal and t1.factura = t3.factura
where t1.fechaprog = convert(datetime, convert(varchar(10), current_timestamp, 121), 121)
group by t2.descripcion, t1.fechaprog) t2 on t1.sucursal = t2.sucursal
left outer join sucursales t3 on t1.sucursal = t3.descripcion


select t3.descripcion sucursal, isnull(convert(varchar(10), t1.fecha_facturacion, 121), 'ERROR') fecha_facturacion , isnull(convert(varchar(10), t1.facturas), 'ERROR') facturas, isnull(convert(varchar(10), t2.lineas), 'ERROR') lineas from
(select t2.descripcion sucursal, t1.fechaprog fecha_facturacion, count(t1.factura) facturas
from encabezado t1 inner join sucursales t2 on t1.sucursal = t2.sucursal
where t1.fechaprog = convert(datetime, convert(varchar(10), convert(datetime, '2008-11-17', 121), 121), 121)
group by t2.descripcion, t1.fechaprog) t1 inner join
(select t2.descripcion sucursal, t1.fechaprog fecha_facturacion, count(t3.factura) lineas
from encabezado t1 inner join sucursales t2 on t1.sucursal = t2.sucursal
inner join detalle t3 on t1.sucursal = t3.sucursal and t1.factura = t3.factura
where t1.fechaprog = convert(datetime, convert(varchar(10), convert(datetime, '2008-11-17', 121), 121), 121)
group by t2.descripcion, t1.fechaprog) t2 on t1.sucursal = t2.sucursal
right outer join sucursales t3 on t1.sucursal = t3.descripcion
where t3.sucursal <> 2
*/

declare @sucursal varchar(50)
declare @fecha_facturacion varchar(50)
declare @facturas varchar(50)
declare @lineas varchar(50)

select t3.descripcion sucursal, isnull(convert(varchar(10), t1.fecha_facturacion, 121), 'ERROR') fecha_facturacion , isnull(convert(varchar(10), t1.facturas), 'ERROR') facturas, isnull(convert(varchar(10), t2.lineas), 'ERROR') lineas 
into #checaras
from
(select t2.descripcion sucursal, t1.fechaprog fecha_facturacion, count(t1.factura) facturas
from encabezado t1 inner join sucursales t2 on t1.sucursal = t2.sucursal
where t1.fechaprog = convert(datetime, convert(varchar(10), current_timestamp, 121), 121)
group by t2.descripcion, t1.fechaprog) t1 inner join
(select t2.descripcion sucursal, t1.fechaprog fecha_facturacion, count(t3.factura) lineas
from encabezado t1 inner join sucursales t2 on t1.sucursal = t2.sucursal
inner join detalle t3 on t1.sucursal = t3.sucursal and t1.factura = t3.factura
where t1.fechaprog = convert(datetime, convert(varchar(10), current_timestamp, 121), 121)
group by t2.descripcion, t1.fechaprog) t2 on t1.sucursal = t2.sucursal
right outer join sucursales t3 on t1.sucursal = t3.descripcion
where t3.sucursal <> 2

declare mi_cursor cursor forward_only for select sucursal, fecha_facturacion, facturas, lineas from #checaras

open mi_cursor



fetch next from mi_cursor into @sucursal, @fecha_facturacion, @facturas, @lineas
while @@fetch_status = 0
begin
	if (@facturas = 'ERROR') or @lineas = 'ERROR' 
	begin
		insert into monkeyland.dbo.bitacora(interfase, mensaje, resultado, timestamp) values('Importacion encabezado y detalle', 'Fallo importacion de encabezado de la sucursal ' + @sucursal, 0, current_timestamp)
	end
	if (@lineas = 'ERROR')
	begin
		insert into monkeyland.dbo.bitacora(interfase, mensaje, resultado, timestamp) values('Importacion encabezado y detalle', 'Fallo importacion de detalle de la sucursal ' + @sucursal, 0, current_timestamp)
	end
	if(@fecha_facturacion <> 'ERROR' and @facturas <> 'ERROR' and @lineas <> 'ERROR')
	begin
		insert into monkeyland.dbo.bitacora(interfase, mensaje, resultado, timestamp) values('Importacion encabezado y detalle', 'Importacion exitosa en suc ' + @sucursal + ' ' + @facturas + ' facturas y ' + @lineas + ' lineas', 1, current_timestamp)
	end
	fetch next from mi_cursor into @sucursal, @fecha_facturacion, @facturas, @lineas
end
close mi_cursor
deallocate mi_cursor

GO

