

CREATE procedure [dbo].[usp_alerta_accesos]
as
declare @texto varchar(500)
declare @descripcion varchar(50)
declare @estatus varchar(50)

select 
t2.sucursal,
max(t1.timestamp) fecha_hora 
into #registros
from 
andover1.continuumdb.dbo.accessevent t1 inner join asistencia_areas t2 on t1.areaidlo = t2.areaidlo
inner join sucursales t3 on t2.sucursal = t3.sucursal
where
t1.timestamp > dateadd(hh, -2, current_timestamp)
group by
t2.sucursal

select distinct sucursal into #sucursales from asistencia_areas

select 
t1.sucursal, isnull(convert(varchar(20), t2.fecha_hora, 121), 'sin registro') estatus
into #resultados
from
#sucursales t1 left outer join #registros t2 on t1.sucursal = t2.sucursal

declare cur_resultados cursor fast_forward for select t2.descripcion, t1.estatus from #resultados t1 inner join sucursales t2 on t1.sucursal = t2.sucursal where estatus = 'sin registro'

open cur_resultados
fetch next from cur_resultados into @descripcion, @estatus

while @@fetch_status = 0
begin
	select @texto = 'La sucursal ' + @descripcion + ' no tiene registros de asistencia desde hace mas de dos horas'
	insert into bitacora(interfase, mensaje, resultado, timestamp) values('Accesos', @texto, 0, current_timestamp)
	fetch next from cur_resultados into @descripcion, @estatus
end


close cur_resultados
deallocate cur_resultados


drop table #registros
drop table #sucursales
drop table #resultados

GO

