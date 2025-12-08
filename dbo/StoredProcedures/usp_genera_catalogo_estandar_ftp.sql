--select 'select top 1 descuento from clientes_baan where ' + replace(query, 'fecha_tandem >= convert(datetime, convert(varchar(10), current_timestamp, 121), 121) and ', '') from parametros_fact_elec_estandar where cliente = 'FBGUADALUPANA'
--exec usp_genera_catalogo_estandar_ftp 1, 1, 'MAYPO'


--	HISTORIAL DE MODIFICACIONES
--	FECHA				MODIFICO				DESCRIPCION
--	----------	-------------		--------------------------------------
--	2012-09-11	MIGUEL SAMAYOA	SE APUNTO LA SUCUSAL DE TIJ MARZAM A TIJ MEDIPAC PARA TOMAR EL INVENTARIO

CREATE 
	procedure [dbo].[usp_genera_catalogo_estandar_ftp] 
	@sucursal int, @minexist int, @cliente varchar(30)
 
 
as
set nocount on
/*declare @iva as money
select @iva = porcentaje_iva from sucursales where sucursal = @sucursal
declare @descuento as money
declare @descuento_tabla table (descuento money)
declare @sentencia_sql as varchar(500)
select @sentencia_sql = 'select top 1 descuento from clientes_baan where ' + replace(query, 'fecha_tandem >= convert(datetime, convert(varchar(10), current_timestamp, 121), 121) and ', '') from parametros_fact_elec_estandar where cliente = @cliente
insert into @descuento_tabla(descuento)  exec(@sentencia_sql)
select @descuento = descuento from @descuento_tabla
if @@rowcount < 1
begin
	select @descuento = 0
end
--declare @iva as money
--select @iva = .11
--select iva, clas_fis, case iva when 0 then 0 else @iva end from maestro_productos_baan
--PROCEDIMIENTO PARA  CATALOGO ESTÁNDAR CLIENTES SERVIDOR FTP
select 
convert(varchar(8), current_timestamp, 112) +
'00' + t1.codigo +
left(t1.descripcion + '                                        ', 40) +
left(right('0000000' + convert(varchar(15), case t1.grupo_est when 'PC01A' then t1.prec_farm + (t1.prec_farm * 0.5) else t1.prec_farm end), 13), 10) +
left(right('0000000' + convert(varchar(15), case t1.grupo_est when 'PC01A' then t1.prec_pub + (t1.prec_pub * 0.5) else t1.prec_pub end), 13), 10) + 
right('000' + convert(varchar(6), case t1.iva when 0 then 0 else @iva end * 100), 6) + 
case t1.grupo_est when 'PC01A' then '050.00' else '000.00' end +
'000.00' +
case t1.clas_ssa when '1' then 'CO' 
when '2' then 'CO' 
when '3' then 'CO' 
when '4' then 'ET' 
when '5' then 'OT' 
when '6' then 'OT' 
when '7' then 'MC' 
when '8' then 'PF' 
when '9' then 'VA' 
else 'VA' end +
left(t1.lab_largo + '                                        ', 40) ,
left(t1.clas_fis + '  ', 2) +
'                                                                                ' +
case t1.refrigerado when 'R' then 'R' else ' ' end  +
case t1.clas_ssa when '1' then 'P' 
when '2' then 'P' 
when '3' then 'P' 
else ' ' end + 
--left(convert(varchar(13), convert(bigint, t1.cod_barras)) + '             ', 13) + 
left(t1.cod_barras_tandem + '             ', 13) + 
'PZA19000101' +
left(t1.clas_ssa + '  ', 2) +
'C' +
right('0000' + convert(varchar(4), t1.pzas_empaque_original), 4) +
case t1.clas_fis 
when 'B'  then '001.01' 
when 'BA' then '001.01' 
when 'N'  then '000.00' 
when 'NA' then '000.00' 
when 'H'  then right('000' + convert(varchar(6), case when t1.descto_prod > @descuento then @descuento else t1.descto_prod end), 6)  
when 'HA' then right('   ' + convert(varchar(6), case when t1.descto_prod > @descuento then @descuento else t1.descto_prod end), 6)  end +
'              ' 
from
maestro_productos_baan t1 inner join inventario_baan t2 on t1.codigo = t2.codigo
where
--t2.sucursal = @sucursal and	--	MODIFICACION PARA QUE SALGAN LOS CLIENTES DE TIJUANA II
t2.sucursal = CASE WHEN @sucursal = 25 THEN 6 WHEN @sucursal = 1 THEN 21 when @sucursal=4 then 21 ELSE @sucursal END and
isnumeric(t1.cod_barras) = 1 and 
t2.piezas >= @minexist and
convert(int, t1.codigo) < dbo.gobierno() /*and
t1.fecha_baja is null*/
order by 
left(t1.descripcion + '                                        ', 40) */


declare @sqlProdts varchar(max)
declare @sucursalAux varchar(3)
set @sucursalAux=@sucursal
--PROCEDIMIENTO PARA  CATALOGO ESTÁNDAR CLIENTES SERVIDOR FTP
set @sqlProdts='
declare @iva as money
select @iva = porcentaje_iva from sucursales where sucursal = '+@sucursalAux+'
declare @descuento as money
declare @descuento_tabla table (descuento money)
declare @sentencia_sql as varchar(500)
select @sentencia_sql = ''select top 1 descuento from clientes_baan where '' + replace(query, ''fecha_tandem >= convert(datetime, convert(varchar(10), current_timestamp, 121), 121) and '', '''') from parametros_fact_elec_estandar where cliente = '''+@cliente+'''
print(@sentencia_sql)
insert into @descuento_tabla(descuento)  exec(@sentencia_sql)
select @descuento = descuento from @descuento_tabla
if @@rowcount < 1
begin
	select @descuento = 0
end
select 
convert(varchar(8), current_timestamp, 112) +
''00'' + t1.codigo +
left(t1.descripcion + ''                                        '', 40) +
left(right(''0000000'' + convert(varchar(15), case t1.grupo_est when ''PC01A'' then t1.prec_farm + (t1.prec_farm * 0.5) else t1.prec_farm end), 13), 10) +
left(right(''0000000'' + convert(varchar(15), case t1.grupo_est when ''PC01A'' then t1.prec_pub + (t1.prec_pub * 0.5) else t1.prec_pub end), 13), 10) + 
right(''000'' + convert(varchar(6), case t1.iva when 0 then 0 else @iva end * 100), 6) + 
case t1.grupo_est when ''PC01A'' then ''050.00'' else ''000.00'' end +
''000.00'' +
case t1.clas_ssa when ''1'' then ''CO'' 
when ''2'' then ''CO'' 
when ''3'' then ''CO'' 
when ''4'' then ''ET'' 
when ''5'' then ''OT'' 
when ''6'' then ''OT'' 
when ''7'' then ''MC'' 
when ''8'' then ''PF'' 
when ''9'' then ''VA'' 
else ''VA'' end +
left(t1.lab_largo + ''                                        '', 40) ,
left(t1.clas_fis + ''  '', 2) +
''                                                                                '' +
case t1.refrigerado when ''R'' then ''R'' else '' '' end  +
case t1.clas_ssa when ''1'' then ''P'' 
when ''2'' then ''P'' 
when ''3'' then ''P'' 
else '' '' end + 
left(t1.cod_barras_tandem + ''             '', 13) + 
''PZA19000101'' +
left(t1.clas_ssa + ''  '', 2) +
''C'' +
right(''0000'' + convert(varchar(4), t1.pzas_empaque_original), 4) +
case t1.clas_fis 
when ''B''  then ''001.01'' 
when ''BA'' then ''001.01'' 
when ''N''  then ''000.00'' 
when ''NA'' then ''000.00'' 
when ''H''  then right(''000'' + convert(varchar(6), case when t1.descto_prod > @descuento then @descuento else t1.descto_prod end), 6)  
when ''HA'' then right(''   '' + convert(varchar(6), case when t1.descto_prod > @descuento then @descuento else t1.descto_prod end), 6)  end +
''              '' 
from
maestro_productos_baan t1 inner join inventario_baan t2 on t1.codigo = t2.codigo
where
t1.prec_farm is not null and t1.prec_pub is not null and
t2.sucursal in('+ case when @sucursal=4 or @sucursal=1 then '4,21' when @sucursal=25 then '6' else @sucursalAux end +') and
t1.refrigerado is not null and t1.clas_ssa  is not null and t1.cod_barras_tandem  is not null and  t1.pzas_empaque_original is not null and t1.clas_fis  is not null and t1.descto_prod is not null and
isnumeric(t1.cod_barras) = 1 and 
t2.piezas >= '+convert(varchar(6),@minexist)+' and
convert(int, t1.codigo) < dbo.gobierno()
order by 
left(t1.descripcion + ''                                        '', 40)' 
--print(@sqlProdts)
execute(@sqlProdts)
set nocount off
GO
