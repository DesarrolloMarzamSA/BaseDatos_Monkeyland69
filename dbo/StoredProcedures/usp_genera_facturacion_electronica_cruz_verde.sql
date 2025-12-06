
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[usp_genera_facturacion_electronica_cruz_verde] @sucursal int, @ctepadre varchar(3), @horario varchar(25)

as
declare @factura as varchar(8)
declare @detalle as varchar(500)

create table #resultados(linea int identity, col1 varchar(500))


declare @fecha_facturacion datetime

select @fecha_facturacion = case  @horario
when 'matutino' then convert(datetime, convert(varchar(10), current_timestamp, 121), 121) else
convert(datetime, convert(varchar(10), dateadd(dd, 1, current_timestamp), 121), 121) end

if (datepart(dw, current_timestamp) = 6)
begin
	select @fecha_facturacion = case  @horario
	when 'matutino' then convert(datetime, convert(varchar(10), current_timestamp, 121), 121) else
	convert(datetime, convert(varchar(10), dateadd(dd, 2, current_timestamp), 121), 121) end
end


select
right('00000000' + convert(varchar(8), convert(bigint, t1.factura)), 8) + ' ' +
t1.cliente + ' ' +
left(t1.descripcion + '                              ', 31) + ' ' +
t1.cod_barras + ' ' +
right('00000' + convert(varchar(5), t1.piezas_surtidas_con_cargo), 5) + ' ' +
right('0000000' + convert(varchar(10), t1.precio_farm_sin_imp), 10) + ' ' +
right('0000000' + convert(varchar(10), t1.precio_pub_sin_imp), 10) + ' ' +
left(t1.clas_fis + '  ', 2) + ' ' +
convert(varchar(8), t1.fecha_factura, 112) + ' ' +
right('00000000000' + convert(varchar(13), t1.importe_neto), 13) col1,
t1.factura,
t1.importe_neto
into #facturacion_cruz_verde
from facturacion_electronica_estandar t1
where
t1.sucursal = @sucursal and
t1.ctepadre = @ctepadre and
t1.fecha_factura = @fecha_facturacion
--t1.fecha_factura = convert(datetime, '2009-06-01', 121)
order by
t1.factura,
t1.cliente,
t1.cod_barras

--select * from facturacion_electronica_estandar where sucursal = 50 and fecha_factura = convert(datetime, '2009-06-01', 121) and ctepadre = '208'

declare cur_facturas cursor fast_forward for select distinct factura from #facturacion_cruz_verde

open cur_facturas

fetch next from cur_facturas into @factura

while @@fetch_status = 0
begin
	
	insert into #resultados select col1 from #facturacion_cruz_verde where factura = @factura
	insert into #resultados select '                                                                                                     ' + right('00000000000' + convert(varchar(13), sum(importe_neto)), 13) from #facturacion_cruz_verde where factura = @factura
	fetch next from cur_facturas into @factura
end

close cur_facturas
deallocate cur_facturas

select col1 from #resultados order by linea asc

drop table #resultados
drop table #facturacion_cruz_verde

GO
