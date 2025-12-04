


--exec usp_genera_cambios_precio_moderna 17, '11560'
--select * from cambios_precio_baan where t_item = '0525233'
--select top 100 * from encabezado where sucursal = 7 and farmacia like '%klyns%'
CREATE procedure [dbo].[usp_genera_cambios_precio_moderna] @sucursal int, @cliente varchar(5)
as
begin
declare @descuento money
select @descuento = convert(money, descuento) from clientes_baan where sucursal = @sucursal and cliente = @cliente

declare @codigo varchar(7)
declare @precio_farmacia_nuevo money
declare @precio_publico_nuevo money
declare @precio_farmacia_anterior money
declare @precio_publico_anterior money
declare @fecha_hora_nuevo datetime
declare @fecha_hora_anterior datetime

create table #cambios_moderna(tipo varchar(1), cod_barras varchar(16), codigo varchar(14), nombre varchar(50), precio_farmacia_nuevo money, precio_farmacia_anterior money, precio_publico_nuevo money, precio_publico_anterior money, iva money, descuento money, fecha datetime)

declare cur_cambios cursor fast_forward for select t_item, t_prfn, t_prpn, max(fecha_hora) fecha_hora from cambios_precio_baan where fecha_hora > dateadd(dd, -5, current_timestamp) and convert(int, t_item) < dbo.gobierno() group by t_item, t_prfn, t_prpn
open cur_cambios
fetch next from cur_cambios into @codigo, @precio_farmacia_nuevo, @precio_publico_nuevo, @fecha_hora_nuevo

while @@fetch_status = 0
begin
	select @precio_farmacia_anterior = t_prfn, @precio_publico_anterior = t_prpn, @fecha_hora_anterior = max(fecha_hora) from cambios_precio_baan where t_item = @codigo and fecha_hora < @fecha_hora_nuevo group by t_prfn, t_prpn
	insert into #cambios_moderna(tipo, codigo, precio_farmacia_anterior, precio_farmacia_nuevo, precio_publico_anterior, precio_publico_nuevo, fecha) 
	values('A', '00' + @codigo, @precio_farmacia_anterior, @precio_farmacia_nuevo, @precio_publico_anterior, @precio_publico_nuevo, @fecha_hora_nuevo)
	fetch next from cur_cambios into @codigo, @precio_farmacia_nuevo, @precio_publico_nuevo, @fecha_hora_nuevo
end

close cur_cambios
deallocate cur_cambios

update #cambios_moderna set cod_barras = t2.cod_barras, nombre = t2.descripcion, iva = t2.iva, descuento =  
case 
when t2.clas_fis = 'B'  then @descuento
when t2.clas_fis = 'BA' then @descuento
when t2.clas_fis = 'N'  then 0
when t2.clas_fis = 'NA' then 0
when t2.clas_fis = 'H'  then t2.descto_prod
when t2.clas_fis = 'HA' then t2.descto_prod end 
from #cambios_moderna t1 inner join maestro_productos_baan t2 on t1.codigo = '00' + t2.codigo


select 
left(t1.nombre + '                                                  ', 30) +
right('0000000000000000' + t1.cod_barras, 13) +
right('            ' + convert(varchar(12), convert(money, case t2.grupo_est when 'PC01A' then t1.precio_farmacia_nuevo + (t1.precio_farmacia_nuevo * 0.5) else t1.precio_farmacia_nuevo end)), 11) +
right('            ' + convert(varchar(12), convert(money, case t2.grupo_est when 'PC01A' then t1.precio_publico_nuevo + (t1.precio_publico_nuevo * 0.5) else t1.precio_publico_nuevo end)), 11)
from
#cambios_moderna t1 inner join maestro_productos_baan t2 on t1.codigo = '00' + t2.codigo


end

GO

