

--usp_catalogo_ofertas_estandar_ftp 7, 'PLUS6', 'LIBRE', 1
--usp_catalogo_ofertas_estandar_ftp 21,'LIBRE', '	ZZZZZ', 1
CREATE 
procedure [dbo].[usp_catalogo_ofertas_estandar_ftp]
(@sucursal int, @primer_bolsa varchar(5), @segunda_bolsa varchar(5), @piezas int)
as

--	HISTORIAL DE MODIFICACIONES
--	FECHA				MODIFICO				DESCRIPCION
--	----------	-------------		--------------------------------------
--	2012-09-11	MIGUEL SAMAYOA	SE APUNTO LA SUCUSAL DE TIJ MARZAM A TIJ MEDIPAC PARA TOMAR EL INVENTARIO


begin
create table #resultados(id int identity(1,1), ofertas varchar(169))

insert into #resultados
select
convert(varchar(8), current_timestamp, 112) +
'00' + t1.codigo +
left(t2.descripcion + '                                        ', 40) +
left(right('0000000' + convert(varchar(15), case t2.grupo_est when 'PC01A' then t2.prec_farm + (t2.prec_farm * 0.5) else t2.prec_farm end), 13), 10) +
left(right('0000000' + convert(varchar(15), case t2.grupo_est when 'PC01A' then t2.prec_pub + (t2.prec_pub * 0.5) else t2.prec_pub end), 13), 10) +
right('000' + convert(varchar(12), t2.iva * 100), 6) +
case t2.grupo_est when 'PC01A' then '050.00' else '000.00' end +
'000.00' +
right('0000' + convert(varchar(4), t1.cant_base), 4) +
right('0000' + convert(varchar(4), t1.cant_oferta), 4) +
right('000' + convert(varchar(12), t1.porcentaje * 100), 6) +
convert(varchar(8), t1.vigencia_inicial, 112) +
convert(varchar(8), t1.vigencia_final, 112) +
left(convert(varchar(13), convert(bigint, t2.cod_barras)) + '             ', 13) + 
case when t1.cant_oferta > 0 and t1.porcentaje > 0 then 'M' else case when t1.cant_oferta > 0 then 'P' else 'D' end end +
left(t1.bolsa + '     ', 5) + '1' + 
case when t2.clas_fis = 'B' then '001.01' when t2.clas_fis = 'BA' then '001.01' when t2.clas_fis = 'N' then '000.00' when t2.clas_fis = 'NA' then '000.00' when t2.clas_fis = 'H' then right('000.00' + convert(varchar(6), t2.descto_prod), 6) when t2.clas_fis = 'HA' then right('000.00' + convert(varchar(6), t2.descto_prod), 6) end +
'             ' 
from dboferta t1 
inner join maestro_productos_baan t2 on t1.codigo = t2.codigo
inner join inventario_baan t3 on t1.codigo = t3.codigo and t1.sucursal = t3.sucursal
where 
--t1.sucursal = @sucursal ---	MODIFICACION PARA QUE SALGAN LOS CLIENTES DE TIJUANA II
t1.sucursal = CASE WHEN @sucursal = 25 THEN 6  WHEN @sucursal = 1 THEN 21 WHEN @sucursal = 4 THEN 21 ELSE @sucursal END 



and t1.bolsa = @primer_bolsa and
t2.status <> 'B01' and t3.piezas >= @piezas and
convert(int, t2.codigo) < dbo.gobierno()
union
select
convert(varchar(8), current_timestamp, 112) +
'00' + t1.codigo +
left(t2.descripcion + '                                        ', 40) +
left(right('0000000' + convert(varchar(15), case t2.grupo_est when 'PC01A' then t2.prec_farm + (t2.prec_farm * 0.5) else t2.prec_farm end), 13), 10) +
left(right('0000000' + convert(varchar(15), case t2.grupo_est when 'PC01A' then t2.prec_pub + (t2.prec_pub * 0.5) else t2.prec_pub end), 13), 10) +
right('000' + convert(varchar(12), t2.iva * 100), 6) +
case t2.grupo_est when 'PC01A' then '050.00' else '000.00' end +
'000.00' +
right('0000' + convert(varchar(4), t1.cant_base), 4) +
right('0000' + convert(varchar(4), t1.cant_oferta), 4) +
right('000' + convert(varchar(12), t1.porcentaje * 100), 6) +
convert(varchar(8), t1.vigencia_inicial, 112) +
convert(varchar(8), t1.vigencia_final, 112) +
left(convert(varchar(13), convert(bigint, t2.cod_barras)) + '             ', 13) + 
case when t1.cant_oferta > 0 and t1.porcentaje > 0 then 'M' else case when t1.cant_oferta > 0 then 'P' else 'D' end end +
left(t1.bolsa + '     ', 5) + '1' + 
case when t2.clas_fis = 'B' then '001.01' when t2.clas_fis = 'BA' then '001.01' when t2.clas_fis = 'N' then '000.00' when t2.clas_fis = 'NA' then '000.00' when t2.clas_fis = 'H' then right('000.00' + convert(varchar(6), t2.descto_prod), 6) when t2.clas_fis = 'HA' then right('000.00' + convert(varchar(6), t2.descto_prod), 6) end +
'             ' 
from 
dboferta t1 inner join maestro_productos_baan t2 on t1.codigo = t2.codigo
inner join inventario_baan t3 on t1.codigo = t3.codigo and t1.sucursal = t3.sucursal
where 
---t1.sucursal = @sucursal 	MODIFICACION PARA QUE SALGAN LOS CLIENTES DE TIJUANA II
t1.sucursal = CASE WHEN @sucursal = 25 THEN 6 WHEN @sucursal = 1 THEN 21 WHEN @sucursal = 4 THEN 21 ELSE @sucursal END 


and t1.bolsa = @segunda_bolsa and t1.codigo not in (select codigo from dboferta where sucursal = 1 and bolsa = @primer_bolsa) and
t2.status <> 'B01' and t3.piezas >= @piezas and
convert(int, t2.codigo) < dbo.gobierno()

select ofertas + right('00000' + convert(varchar(5), id), 5) from #resultados
end

GO

