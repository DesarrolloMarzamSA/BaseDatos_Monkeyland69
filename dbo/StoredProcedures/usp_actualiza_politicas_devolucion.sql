SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_actualiza_politicas_devolucion]
as
select 
PGPRDC codigo,
case PGUFA1 when 'N' then 0 else 1 end acepta_devolucion,
case convert(int, PGUFN2) + convert(int, PGUFA2) when 0 then ' ' else case PGUFA1 when 'N' then '' else 'Sólo se acepta ' + convert(varchar(10), convert(int, PGUFN2)) + ' dias antes y ' +  convert(varchar(10),convert(int, PGUFA2)) + ' despues de la fecha 
de caducidad' end end leyenda
into #politicas
from AS400.S101FEBT.MA4620EF04.SROPRG

create  table #leyendas(id int identity(1,1), leyenda varchar(255))

insert into #leyendas(leyenda) select distinct leyenda from #politicas order by leyenda

delete from SalesOrder.dbo.politicas_devolucion

delete from SalesOrder.dbo.leyendas_politicas_devolucion

insert into SalesOrder.dbo.leyendas_politicas_devolucion(leyenda_id, leyenda) select id, leyenda from #leyendas

select 
t2.sucursal,
t1.codigo,
t1.acepta_devolucion,
t1.leyenda
into #politicas_sucursales
from
#politicas t1 inner join sucursales t2 on t2.sucursal = t2.sucursal





select 
t1.sucursal,
substring(t1.codigo, 1, 7) codigo,
t1.acepta_devolucion,
t2.id,
count(*) ocurrencia
into #sinduplicados
from
#politicas_sucursales t1 inner join #leyendas t2 on t1.leyenda = t2.leyenda
where
isnumeric(t1.codigo) = 1
group by
t1.sucursal,
substring(t1.codigo, 1, 7),
t1.acepta_devolucion,
t2.id

insert into SalesOrder.dbo.politicas_devolucion(sucursal, codigo, acepta_devolucion, leyenda_id)
select distinct sucursal, codigo, acepta_devolucion, id from #sinduplicados

drop table #sinduplicados
drop table #politicas
drop table #politicas_sucursales
drop table #leyendas

GO
