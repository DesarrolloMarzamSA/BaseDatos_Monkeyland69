CREATE procedure usp_sams_surtido
as
select 
'00' +
t1.cliente + 
'000000000000000' +
case when t2.cant_surt > 0 then right('00000' + convert(varchar(5), t2.cant_ped - t2.cant_surt), 5) else right('00000' + convert(varchar(5), t2.cant_ped), 5) end  +
'00000000000000000000000000000000000000000000000000000000000' +
left(convert(varchar(13), convert(bigint, t4.cod_barras)) + '             ', 13) +
' ' 
from
encabezado t1 inner join detalle t2 on t1.sucursal = t2.sucursal and t1.factura = t2.factura
inner join catalogo_autoservicios t3 on t1.segto = t3.segto and t1.ctepadre = t3.ctepadre and t1.sucursal = t3.sucursal and '00' + t3.codigo = t2.codigos
inner join maestro_productos_baan t4 on '00' + t4.codigo = t2.codigos
where
t1.segto = 'E1' and t1.ctepadre = '139' and
t1.fechaprog = convert(datetime, convert(varchar(10), current_timestamp, 121), 121) and 
t3.grupo = 'RX  ' and
t2.dest_det = 'AAA'

GO

