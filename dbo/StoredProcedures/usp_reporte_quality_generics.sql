
CREATE procedure [dbo].[usp_reporte_quality_generics]
as
select 
t4.iata,
t1.cliente, 
replace(t1.farmacia, ',', ' '), 
t1.factura remision, 
isnull(t1.folio_fiscal, '        ') cfd,
case t3.clas_promocion when 'QUALITY GENERICS DISTRIBUTION' then 'QGD' else '   ' end as tipo,
sum(t2.prec_farm * t2.cant_ped) monto_bruto
from 
encabezado t1 inner join detalle t2 on t1.sucursal = t2.sucursal and t1.factura = t2.factura 
inner join maestro_productos_baan t3 on t2.codigos = '00' + t3.codigo 
inner join sucursales t4 on t1.sucursal = t4.sucursal
where 
t2.dest_det = 'AAA' and
t1.fechaprog >= convert(datetime, convert(varchar(10), current_timestamp, 121), 121)
group by
t4.iata, 
t1.cliente, 
t1.farmacia, 
t1.factura, 
t1.folio_fiscal,
case t3.clas_promocion when 'QUALITY GENERICS DISTRIBUTION' then 'QGD' else '   ' end
order by
t4.iata, 
t1.cliente, 
t1.farmacia, 
t1.factura

GO

