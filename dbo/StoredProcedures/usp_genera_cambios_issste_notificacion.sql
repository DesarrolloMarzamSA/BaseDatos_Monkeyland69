
/*
exec usp_genera_cambios_issste_notificacion2 1, '16730'
exec usp_genera_cambios_issste_notificacion 1, '16730'

*/

CREATE procedure [dbo].[usp_genera_cambios_issste_notificacion] @sucursal int, @cliente varchar(5)
as
set nocount on
begin
declare @descuento money
select @descuento = convert(money, descuento/100) from clientes_baan where sucursal = @sucursal and cliente = @cliente

declare @codigo varchar(7)
declare @codigo_chocolate varchar(7)
declare @precio_farmacia_nuevo money
declare @precio_publico_nuevo money
declare @precio_farmacia_anterior money
declare @precio_publico_anterior money
declare @fecha_hora_nuevo datetime
declare @fecha_hora_anterior datetime

create table #cambios_issste(tipo varchar(1), cod_barras varchar(16), codigo varchar(14), nombre varchar(50), precio_farmacia_nuevo money, precio_farmacia_anterior money, precio_publico_nuevo money, precio_publico_anterior money, iva money, descuento money, fecha datetime, precio_menos_desc money)

declare cur_cambios cursor fast_forward for select t_item, max(fecha_hora) fecha_hora from cambios_precio_baan where (fecha_hora > dateadd(dd, -5, current_timestamp) and convert(int, t_item) < dbo.gobierno()) or (convert(int, t_item) < dbo.gobierno() and t_item in  (
'0032004',
'0197509',
'0483006',
'0483007',
'0580401',
'0820502',
'0862302',
'1080902',
'1101010',
'1124003',
'1234502',
'1244005',
'1244008',
'1244010',
'1244011',
'1383401',
'1409003',
'1424504',
'1566001',
'1610503',
'1701702',
'1797501',
'1801003',
'1802502',
'1935001',
'1943001',
'1943002',
'2131501',
'2265009',
'2265012',
'2265013',
'2266001',
'2338006',
'2338010',
'2645501',
'2700201',
'2700202',
'2700203',
'2772001',
'2810004',
'2842002',
'2946801')) group by t_item order by t_item
open cur_cambios
fetch next from cur_cambios into @codigo, @fecha_hora_nuevo

while @@fetch_status = 0
begin
	select @precio_farmacia_nuevo = t_prfn, @precio_publico_nuevo = t_prpn from cambios_precio_baan where t_item = @codigo and fecha_hora = @fecha_hora_nuevo
	select @codigo_chocolate = t_item, @precio_farmacia_anterior = t_prfn, @precio_publico_anterior = t_prpn, @fecha_hora_anterior = max(fecha_hora) from cambios_precio_baan where t_item = @codigo and fecha_hora < @fecha_hora_nuevo group by t_item, t_prfn, t_prpn
	insert into #cambios_issste(tipo, codigo, precio_farmacia_anterior, precio_farmacia_nuevo, precio_publico_anterior, precio_publico_nuevo, fecha) 
	values('A', '00' + @codigo, @precio_farmacia_anterior, @precio_farmacia_nuevo, @precio_publico_anterior, @precio_publico_nuevo, @fecha_hora_nuevo)
	fetch next from cur_cambios into @codigo, @fecha_hora_nuevo
end

close cur_cambios
deallocate cur_cambios

update #cambios_issste set cod_barras = t2.cod_barras, nombre = t2.descripcion, iva = t2.iva, descuento =  
case 
when t2.clas_fis = 'B'  then @descuento
when t2.clas_fis = 'BA' then @descuento
when t2.clas_fis = 'N'  then 0
when t2.clas_fis = 'NA' then 0
when t2.clas_fis = 'H'  then t2.descto_prod
when t2.clas_fis = 'HA' then t2.descto_prod end,
precio_menos_desc =
case 
when t2.clas_fis = 'B'  then precio_farmacia_nuevo - (precio_farmacia_nuevo * @descuento)
when t2.clas_fis = 'BA' then precio_farmacia_nuevo - (precio_farmacia_nuevo * @descuento)
when t2.clas_fis = 'N'  then precio_farmacia_nuevo
when t2.clas_fis = 'NA' then precio_farmacia_nuevo
when t2.clas_fis = 'H'  then precio_farmacia_nuevo - (precio_farmacia_nuevo * t2.descto_prod/100)
when t2.clas_fis = 'HA' then precio_farmacia_nuevo - (precio_farmacia_nuevo * t2.descto_prod/100) end
from #cambios_issste t1 inner join maestro_productos_baan t2 on t1.codigo = '00' + t2.codigo


update #cambios_issste set cod_barras = t2.cod_barras, nombre = t2.descripcion, iva = t2.iva, descuento =  
case 
when t2.clas_fis = 'B'  then @descuento
when t2.clas_fis = 'BA' then @descuento
when t2.clas_fis = 'N'  then 0
when t2.clas_fis = 'NA' then 0
when t2.clas_fis = 'H'  then 0.17
when t2.clas_fis = 'HA' then 0.17 end,
precio_menos_desc =
case 
when t2.clas_fis = 'B'  then precio_farmacia_nuevo - (precio_farmacia_nuevo * @descuento)
when t2.clas_fis = 'BA' then precio_farmacia_nuevo - (precio_farmacia_nuevo * @descuento)
when t2.clas_fis = 'N'  then precio_farmacia_nuevo
when t2.clas_fis = 'NA' then precio_farmacia_nuevo
when t2.clas_fis = 'H'  then precio_farmacia_nuevo - (precio_farmacia_nuevo * 0.17)
when t2.clas_fis = 'HA' then precio_farmacia_nuevo - (precio_farmacia_nuevo * 0.17) end
from #cambios_issste t1 inner join maestro_productos_baan t2 on t1.codigo = '00' + t2.codigo
where 
t2.codigo in (
'0032004',
'0197509',
'0483006',
'0483007',
'0580401',
'0820502',
'0862302',
'1080902',
'1101010',
'1124003',
'1234502',
'1244005',
'1244008',
'1244010',
'1244011',
'1383401',
'1409003',
'1424504',
'1566001',
'1610503',
'1701702',
'1797501',
'1801003',
'1802502',
'1935001',
'1943001',
'1943002',
'2131501',
'2265009',
'2265012',
'2265013',
'2266001',
'2338006',
'2338010',
'2645501',
'2700201',
'2700202',
'2700203',
'2772001',
'2810004',
'2842002',
'2946801')

select 
t1.cod_barras [Código EAN],
t1.nombre [Descripción],
case t2.grupo_est when 'PC01A' then t1.precio_menos_desc + (t1.precio_menos_desc * 0.5) else t1.precio_menos_desc end [Precio Compra Unitario],
case t2.grupo_est when 'PC01A' then t1.precio_farmacia_nuevo + (t1.precio_farmacia_nuevo * 0.5) else t1.precio_farmacia_nuevo end [Precio Farmacia],
case t2.grupo_est when 'PC01A' then t1.precio_publico_nuevo + (t1.precio_publico_nuevo * 0.5) else t1.precio_publico_nuevo end [Precio Público],
case t2.grupo_est when 'PC01A' then .5 else 0 end [% Ieps],
t2.iva [% Iva],
t1.codigo [Código Marzam]
from
#cambios_issste t1 inner join maestro_productos_baan t2 on t1.codigo = '00' + t2.codigo
where
substring(t2.status, 1, 1) <> 'B' or 
t2.codigo in (
'0032004',
'0197509',
'0483006',
'0483007',
'0580401',
'0820502',
'0862302',
'1080902',
'1101010',
'1124003',
'1234502',
'1244005',
'1244008',
'1244010',
'1244011',
'1383401',
'1409003',
'1424504',
'1566001',
'1610503',
'1701702',
'1797501',
'1801003',
'1802502',
'1935001',
'1943001',
'1943002',
'2131501',
'2265009',
'2265012',
'2265013',
'2266001',
'2338006',
'2338010',
'2645501',
'2700201',
'2700202',
'2700203',
'2772001',
'2810004',
'2842002',
'2946801')

end




set nocount off

GO

