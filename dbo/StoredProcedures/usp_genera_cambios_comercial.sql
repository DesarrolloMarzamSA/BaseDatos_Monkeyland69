




CREATE procedure [dbo].[usp_genera_cambios_comercial] @grupo as varchar(3)
as

declare @valor_iva as money
select @valor_iva = porcentaje_iva from sucursales where sucursal = 1


--GENERA CANMBIOS, EN TRES MODALIDADES ETICOS, OTC Y EXT?, SEGÚN CAMPO DE GRUPO EN DBCATAUT
select 
'000000' + char(9) +
'012730' + char(9) +
convert(varchar(13), convert(bigint, t1.cod_barras)) + char(9) +
'0' + char(9) +
rtrim(t1.descripcion) + char(9) +
case replace(t2.grupo_factura, ' ', '') 
when '1' then ' 81'
when '2' then ' 83'
when '3' then '119' end + char(9) +
'0' + char(9) +
'0000' + char(9) +
'0' + char(9) +
convert(varchar(10), t3.fecha_hora, 103) + char(9) +
rtrim(t1.descripcion) + char(9) +
'001' + char(9) +
'PZA' + char(9) +
'0' + char(9) +
'001' + char(9) +
'PZA' + char(9) +
'0' + char(9) +
'0000' + char(9) +
'0' + char(9) +
'01/01/1900' + char(9) +
case t1.refrigerado when 'R' then '1' else '0' end + char(9) +
case t1.clas_ssa when '1' then '1' when '2' then '1' when '3' then '1' else '0' end + char(9) +
t1.clas_ssa + char(9) +
case t1.grupo_est when 'PC01A' then convert(varchar(9), round(t1.prec_farm, 2, 2) + (round(t1.prec_farm, 2, 2) * 0.5)) else convert(varchar(9), round(t1.prec_farm, 2, 2)) end + char(9) +
case iva 
when @valor_iva then case t1.grupo_est when 'PC01A' then convert(varchar(9), round(convert(money, t1.prec_pub * (1 + @valor_iva)), 2, 2) + (round(convert(money, t1.prec_pub * (1 + @valor_iva)), 2, 2) * 0.5)) else convert(varchar(9), round(convert(money, t1.prec_pub * (1 + @valor_iva)), 2, 2)) end
else           case t1.grupo_est when 'PC01A' then convert(varchar(9), round(t1.prec_pub, 2, 2) + (round(t1.prec_pub, 2, 2) * 0.5))				  else convert(varchar(9), round(t1.prec_pub, 2, 2)) end  end  + char(9) +
case iva 
when @valor_iva then case t1.grupo_est when 'PC01A' then convert(varchar(9), round(convert(money, t1.prec_pub * (1 + @valor_iva)), 2, 2) + (round(convert(money, t1.prec_pub * (1 + @valor_iva)), 2, 2) * 0.5)) else convert(varchar(9), round(convert(money, t1.prec_pub * (1 + @valor_iva)), 2, 2)) end
else           case t1.grupo_est when 'PC01A' then convert(varchar(9), round(t1.prec_pub, 2, 2) + (round(t1.prec_pub, 2, 2) * 0.5))				  else convert(varchar(9), round(t1.prec_pub, 2, 2)) end  end  + char(9) +
'.00' + char(9) +
'C' + char(9) +
'16.00' + char(9) +
'.00' + char(9) +
'.00' + char(9) +
'.00' + char(9) +
'.00' + char(9) +
'.00' + char(9) +
'030' + char(9) +
'0000' + char(9) +
'0' + char(9) +
'0000' + char(9) +
'0' + char(9) +
'0' + char(9) +
'0' + char(9) +
'00  ' col1,
t1.codigo
into #comerci
from maestro_productos_baan t1 inner join catalogo_autoservicios t2 on t1.codigo = t2.codigo
inner join cambios_precio_baan t3 on t1.codigo = t3.t_item
where 
isnumeric(t1.cod_barras) = 1 and
t2.segto = 'E1' and t2.ctepadre = '009' and
t2.sucursal = 1 and
convert(int, t1.codigo) < dbo.gobierno() and
replace(t2.grupo_factura, ' ', '')  = @grupo and
datediff(dd, t3.fecha_hora, current_timestamp) <= 1

create table #resultados(texto varchar(500))
declare @codigo varchar(7), @texto varchar(500)
declare mi_cursor cursor fast_forward for select distinct codigo from #comerci

open mi_cursor

fetch next from mi_cursor into @codigo

while @@fetch_status = 0
begin
	insert into #resultados select top 1 col1 from #comerci where codigo = @codigo
	fetch next from mi_cursor into @codigo
end

close mi_cursor
deallocate mi_cursor
select * from #resultados

--select distinct grupo_factura from catalogo_autoservicios where segto = 'E1' and ctepadre = '009' and status = 'A' and sucursal = 1

GO

