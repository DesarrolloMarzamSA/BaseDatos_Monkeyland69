CREATE procedure usp_rosales_etiquetas
as

if datepart(hh, current_timestamp) > 12
begin
	select 
	substring(t2.nom_prod, 1, 10) +
	substring(t2.codigos, 3, 7) +
	right('0000000000' + convert(varchar(10), convert(int, round(t2.prec_pub, 2, 1) * 100)), 10) +
	'PMAXPUBROSALES     ' +
	right('0000000000' + convert(varchar(10), convert(int, round(t2.prec_pub - (t2.prec_pub * 0.3), 2, 1) * 100)), 10) +
	right('0000' + convert(varchar(6), t2.cant_ped), 4) +
	convert(varchar(6), t1.fecha_tandem, 12) +
	'              '
	from 
	encabezado t1 inner join detalle t2 on t1.sucursal = t2.sucursal and t1.factura = t2.factura
	where
	t1.sucursal = 4 and 
	t1.cliente in ('77420', '26864') and
	t1.fecha_tandem > convert(smalldatetime, convert(varchar(10), current_timestamp, 121), 121) and
	t2.dest_det = 'AAA'
end
else
begin
	select 
	substring(t2.nom_prod, 1, 10) +
	substring(t2.codigos, 3, 7) +
	right('0000000000' + convert(varchar(10), convert(int, round(t2.prec_pub, 2, 1) * 100)), 10) +
	'PMAXPUBROSALES     ' +
	right('0000000000' + convert(varchar(10), convert(int, round(t2.prec_pub - (t2.prec_pub * 0.3), 2, 1) * 100)), 10) +
	right('0000' + convert(varchar(6), t2.cant_ped), 4) +
	convert(varchar(6), t1.fecha_tandem, 12) +
	'              '
	from 
	encabezado t1 inner join detalle t2 on t1.sucursal = t2.sucursal and t1.factura = t2.factura
	where
	t1.sucursal = 4 and 
	t1.cliente in ('77420', '26864') and
	t1.fecha_tandem = convert(smalldatetime, convert(varchar(10), current_timestamp, 121), 121) and
	t2.dest_det = 'AAA'
end

GO

