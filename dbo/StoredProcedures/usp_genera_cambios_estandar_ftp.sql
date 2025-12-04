



CREATE   
procedure [dbo].[usp_genera_cambios_estandar_ftp] @sucursal int

as
--PROCEDIMIENTO PARA  CAMBIOS ESTÁNDAR CLIENTES SERVIDOR FTP
--	HISTORIAL DE MODIFICACIONES
--	FECHA				MODIFICO				DESCRIPCION
--	----------	-------------		--------------------------------------
--	2012-09-11	MIGUEL SAMAYOA	SE APUNTO LA SUCUSAL DE TIJ MARZAM A TIJ MEDIPAC PARA TOMAR EL INVENTARIO

create table #cambios (codigo varchar(7), fecha_hora datetime, cadena varchar(200))
create table #presentacion (cadena varchar(200), i int identity)
insert into #cambios(codigo, fecha_hora, cadena) 
select 
t1.codigo,
t3.fecha_hora, 
convert(varchar(8), current_timestamp, 112) +
'00' + t1.codigo +
left(t1.descripcion + '                                        ', 40) +
left(right('0000000' + convert(varchar(15), case t1.grupo_est when 'PC01A' then t1.prec_farm + (t1.prec_farm * 0.5) else t1.prec_farm end), 13), 10) +
left(right('0000000' + convert(varchar(15), case t1.grupo_est when 'PC01A' then t1.prec_pub + (t1.prec_pub * 0.5) else t1.prec_pub end), 13), 10) +
right('000' + convert(varchar(6), t1.iva * 100), 6) +
case t1.grupo_est when 'PC01A' then '050.00' else '000.00' end +
'000.00' +
left(t1.clas_fis + '  ', 2) +
left(convert(varchar(13), convert(bigint, t1.cod_barras)) + '             ', 13) + 
'                    ' 
from
maestro_productos_baan t1 
inner join inventario_baan t2 on t1.codigo = t2.codigo
inner join cambios_precio_baan t3 on t1.codigo = t3.t_item
where
datediff(d, t3.fecha_hora, current_timestamp) < 5 and
--t2.sucursal = @sucursal and			---	MODIFICACION PARA QUE SALGAN LOS CLIENTES DE TIJUANA II
t2.sucursal = CASE WHEN @sucursal = 25 THEN 6 when @sucursal = 4 THEN 21 when @sucursal = 1 THEN 21 ELSE @sucursal END AND 

isnumeric(t1.cod_barras) = 1 and 
convert(int, t1.codigo) < dbo.gobierno()

--CURSOR PARA EVITAR ENVIAR DOS CAMBIOS DE PRECIO DE UN SÓLO
--CODIGO EN CASO DE QUE CAMBIE MÁS DE UNA VEZ DE PRECIO EN LOS
--ÚLTIMOS DÍAS

declare @codigo varchar(7)
declare @fecha_hora datetime
declare @cadena varchar(200)
declare cur_codigos cursor fast_forward for 
	select distinct codigo, max(fecha_hora) from #cambios group by codigo
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

select cadena + right('00000' + convert(varchar(5), i), 5) from #presentacion

drop table #presentacion
drop table #cambios

GO

