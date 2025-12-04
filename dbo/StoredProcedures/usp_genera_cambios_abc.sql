



CREATE procedure [dbo].[usp_genera_cambios_abc] @sucursal int
as
--exec usp_genera_cambios_abc 3
--PROCEDIMIENTO PARA  CAMBIOS ESTÁNDAR CLIENTES SERVIDOR FTP
set nocount on
create table #cambios (codigo varchar(7), fecha_hora datetime, cadena varchar(200))
create table #presentacion (cadena varchar(200), i int identity)
insert into #cambios(codigo, fecha_hora, cadena) 
select 
t1.codigo,
t3.fecha_hora, 
--left(t1.cod_barras_tandem + '             ', 13) +
left(ltrim(isnull(t4.cod_barras_abc, t1.cod_barras_tandem)) + '             ', 13) +
left(t1.descripcion + '                                        ', 30) +
left(right('       ' + convert(varchar(15), case t1.grupo_est when 'PC01A' then t1.prec_pub + (t1.prec_pub * 0.5) else t1.prec_pub end), 12), 9) +
left(right('       ' + convert(varchar(15), case t1.grupo_est when 'PC01A' then t1.prec_farm + (t1.prec_farm * 0.5) else t1.prec_farm end), 12), 9)
from
maestro_productos_baan t1 inner join inventario_baan t2 on t1.codigo = t2.codigo
inner join cambios_precio_baan t3 on t1.codigo = t3.t_item
left outer join gdl_abc_catalogo t4 on t1.codigo = t4.codigo
where
datediff(d, t3.fecha_hora, current_timestamp) < 5 and
t2.sucursal = @sucursal and
isnumeric(t1.cod_barras) = 1 and 
convert(int, t1.codigo) < dbo.gobierno()
order by
t1.descripcion
asc

--CURSOR PARA EVITAR ENVIAR DOS CAMBIOS DE PRECIO DE UN SÓLO
--CODIGO EN CASO DE QUE CAMBIE MÁS DE UNA VEZ DE PRECIO EN LOS
--ÚLTIMOS DÍAS

declare @codigo varchar(7)
declare @fecha_hora datetime
declare @cadena varchar(200)
declare cur_codigos cursor fast_forward for select distinct codigo, max(fecha_hora) from #cambios group by codigo
open cur_codigos
fetch next from cur_codigos into @codigo, @fecha_hora
while @@fetch_status = 0
begin
	select @cadena = cadena from #cambios where codigo = @codigo and fecha_hora = @fecha_hora
	insert into #presentacion values(@cadena)
	fetch next from cur_codigos into @codigo, @fecha_hora
end
close cur_codigos
deallocate cur_codigos

select cadena from #presentacion

drop table #presentacion
drop table #cambios


set nocount off

GO

