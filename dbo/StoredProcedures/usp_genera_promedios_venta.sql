
CREATE procedure usp_genera_promedios_venta
as
select 
t1.sucursal,
right(t2.codigos, 7) codigo,
t1.fechaprog fecha,
sum(cant_ped) piezas
into #ventas
from
encabezado t1 inner join detalle t2 on t1.sucursal = t2.sucursal and t1.factura = t2.factura
where
t1.fechaprog >= dateadd(dd, -25, current_timestamp) and
t1.sucursal = 1
group by
t1.sucursal,
right(t2.codigos, 7),
t1.fechaprog
order by
t1.sucursal,
right(t2.codigos, 7),
t1.fechaprog

create index idx_ventas1 on #ventas(sucursal, codigo)
select sucursal, codigo, count(fecha) dias into #dias_venta from #ventas

truncate table promedios_venta 

insert into promedios_venta(sucursal, codigo, cantidad_vendida)
select 
t1.sucursal,
t1.codigo,
sum(piezas)/t2.dias
from 
#ventas t1 inner join #dias_venta t2 on t1.sucursal = t2.sucursal and t1.codigo = t2.codigo

GO

