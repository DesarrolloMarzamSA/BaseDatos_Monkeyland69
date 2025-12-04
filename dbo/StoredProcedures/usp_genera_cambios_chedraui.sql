




CREATE procedure [dbo].[usp_genera_cambios_chedraui]
as

truncate table chedraui_precios

insert into chedraui_precios select codigo, prec_farm, prec_pub from maestro_productos_baan where convert(int, codigo) < 6900000

create table #cambios (codigo varchar(7), fecha_hora datetime, cadena varchar(200))
create table #presentacion (cadena varchar(200), i int identity)
insert into #cambios(codigo, fecha_hora, cadena) 
select 
t1.codigo,
t3.fecha_hora,
right('0000000000000' + convert(varchar(13), convert(bigint, t1.cod_barras)), 13) +
left(t1.descripcion + '                                        ', 31) + 
left(right('         ' + convert(varchar(15), case t1.grupo_est when 'PC1A' then  t4.ppub +  (t4.ppub * 0.5) else  t4.ppub end), 11), 8) + ' ' +
left(right('         ' + convert(varchar(15), case t1.grupo_est when 'PC01A' then t4.pfar + (t4.pfar * 0.5) else t4.pfar end), 11), 8)  
from
maestro_productos_baan t1 
inner join cambios_precio_baan t3 on t1.codigo = t3.t_item
inner join chedraui_precios t4 on t1.codigo = t4.codigo
where
datediff(d, t3.fecha_hora, current_timestamp) < 5 and
isnumeric(t1.cod_barras) = 1 and 
convert(int, t1.codigo) < dbo.gobierno()

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

select cadena  from #presentacion

drop table #presentacion
drop table #cambios

GO

