
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE    procedure [dbo].[usp_genera_catalogo_farmacos_csv] @sucursal int, @minexist int

as
set nocount on
--PROCEDIMIENTO PARA  CATALOGO ESTÁNDAR CLIENTES SERVIDOR FTP
create table #resultado_farmacos(id int identity(1,1), texto varchar(500))

insert into #resultado_farmacos(texto) values(
'Fecha,' +
'Código del Producto,' +
'Nombre Producto,' +
'Precio Farmacia s/imp,' +
'Precio Publico s/imp,' +
'Iva,' +
'Ieps,' +
'Impuesto 3,' +
'Tipo Producto,' +
'Laboratorio Fabricante,' +
'Clasificación Fiscal,' +
'Descripción Terapéutica,' +
'Id. Refrigerado,' +
'Id. Controlado,' +
'Código Ean,' +
'Unidad de Venta,' +
'Fecha de Caducidad,' +
'Grupo de la SSA,' +
'Acción sobre el Artículo,' +
'Pzas. Empaque Original,')

insert into #resultado_farmacos(texto) 
select 
convert(varchar(8), current_timestamp, 112) + ',' +
'00' + t1.codigo + ',' +
left(replace(t1.descripcion, ',', ' ') + '                                        ', 40) + ',' +
left(right('0000000' + convert(varchar(15), case t1.grupo_est when 'PC01A' then t1.prec_farm + (t1.prec_farm * 0.5) else t1.prec_farm end), 13), 10) + ',' +
left(right('0000000' + convert(varchar(15), case t1.grupo_est when 'PC01A' then t1.prec_pub + (t1.prec_pub * 0.5) else t1.prec_pub end), 13), 10) + ',' +
right('000' + convert(varchar(6), t1.iva * 100), 6) + ',' +
case t1.grupo_est when 'PC01A' then '050.00' else '000.00' end + ',' +
'000.00' + ',' +
case t1.clas_ssa when '1' then 'CO' 
when '2' then 'CO' 
when '3' then 'CO' 
when '4' then 'ET' 
when '5' then 'OT' 
when '6' then 'OT' 
when '7' then 'MC' 
when '8' then 'PF' 
when '9' then 'VA' 
else 'VA' end + ',' +
left(replace(t1.lab_largo, ',', ' ') + '                                        ', 40) + ',' +
left(t1.clas_fis + '  ', 2) + ',' +
'                                                                                ' + ',' +
case t1.refrigerado when 'R' then 'R' else ' ' end  + ',' +
case t1.clas_ssa when '1' then 'P' 
when '2' then 'P' 
when '3' then 'P' 
else ' ' end +  ',' +
--left(convert(varchar(13), convert(bigint, t1.cod_barras)) + '             ', 13) + 
left(t1.cod_barras_tandem + '             ', 13) +  ',' +
'PZA,19000101' + ',' +
left(t1.clas_ssa + '  ', 2) + ',' +
'C' + ',' +
right('0000' + convert(varchar(4), t1.pzas_empaque_original), 4)
from
maestro_productos_baan t1 inner join inventario_baan t2 on t1.codigo = t2.codigo
where
t2.sucursal = @sucursal and
isnumeric(t1.cod_barras) = 1 and 
t2.piezas >= @minexist and
convert(int, t1.codigo) < dbo.gobierno() /*and
t1.fecha_baja is null*/
order by 
left(t1.descripcion + '                                        ', 40) 


select texto from #resultado_farmacos order by id asc


set nocount off
GO
