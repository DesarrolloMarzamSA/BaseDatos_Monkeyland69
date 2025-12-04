
CREATE procedure [dbo].[usp_genera_trama4_spt_fahorro] @iva_factura int, @facturota int, @trama varchar(7), @ajuste money
as

create table #resultados(orden int identity(1,1), texto varchar(4000))


declare @importe money
declare @iva money
declare @total money
declare @margen int

select @margen = 3

select 
convert(varchar(10), t1.horacap, 112) fecha_factura,
t1.orden,
t2.cuenta_estilo_ahorro suc_id,
t1.factura,
sum(t1.cant_ped) piezas,
sum(t1.total -
case left(t1.clas_fis, 1) when 'N' then 0 else round(round(round(t1.prec_farm * (1 - t1.porcentaje), @margen, 1) * t1.desc_base, @margen, 1) * t1.cant_ped, @margen, 1) end -
case t1.grupo_estadistico when 'PC01A' then round(round(round(round(t1.prec_farm * (1 - t1.porcentaje), @margen, 1) * t1.cant_ped, 2) / 3, @margen, 1) * t1.desc_base, @margen, 1) else 0 end) importe,
sum((t1.total  * t1.def_iva)- case t1.def_iva when 0 then 0 else case left(t1.clas_fis, 1) when 'N' then 0 else round(round(t1.total * t1.def_iva, @margen, 1) * t1.desc_base, @margen, 1) end end ) iva,
sum(t1.total -
case left(t1.clas_fis, 1) when 'N' then 0 else round(round(round(t1.prec_farm * (1 - t1.porcentaje), @margen, 1) * t1.desc_base, @margen, 1) * t1.cant_ped, @margen, 1) end -
case t1.grupo_estadistico when 'PC01A' then round(round(round(round(t1.prec_farm * (1 - t1.porcentaje), @margen, 1) * t1.cant_ped, 2) / 3, @margen, 1) * t1.desc_base, @margen, 1) else 0 end +
(t1.total  * t1.def_iva)- case t1.def_iva when 0 then 0 else case left(t1.clas_fis, 1) when 'N' then 0 else round(round(t1.total * t1.def_iva, @margen, 1) * t1.desc_base, @margen, 1) end end
) total
into #trama4
from 
historica.dbo.facturas_spt_fahorro t1 inner join cat_cuentas_spt_fahorro t2 on t1.sucursal = t2.sucursal_remision and t1.cliente = t2.cuenta_remision
where 
t1.iva = @iva_factura and 
t1.facturota = @facturota and
t1.cant_ped > 0
and t1.factura NOT IN('02963871') and t1.cliente NOT IN('86530')
group by
convert(varchar(10), t1.horacap, 112),
t1.orden,
t2.cuenta_estilo_ahorro,
t1.factura
order by
convert(varchar(10), t1.horacap, 112),
t1.orden,
t1.factura




select 
@importe = sum(total - case left(clas_fis, 1) when 'N' then 0 else round(round(round(prec_farm * (1 - porcentaje), @margen, 1) * desc_base, @margen, 1) * cant_ped, @margen, 1) end - case grupo_estadistico when 'PC01A' then round(round(round(round(prec_farm * (1 - porcentaje), @margen, 1) * cant_ped, 2) / 3, @margen, 1) * desc_base, @margen, 1) else 0 end),
@iva = sum((total  * def_iva)- case def_iva when 0 then 0 else case left(clas_fis, 1) when 'N' then 0 else round(round(total * def_iva, @margen, 1) * desc_base, @margen, 1) end end ),
@total = sum(total - case left(clas_fis, 1) when 'N' then 0 else round(round(round(prec_farm * (1 - porcentaje), @margen, 1) * desc_base, @margen, 1) * cant_ped, @margen, 1) end - case grupo_estadistico when 'PC01A' then round(round(round(round(prec_farm * (1 - porcentaje), @margen, 1) * cant_ped, 2) / 3, @margen, 1) * desc_base, @margen, 1) else 0 end + (total  * def_iva)- case def_iva when 0 then 0 else case left(clas_fis, 1) when 'N' then 0 else round(round(total * def_iva, @margen, 1) * desc_base, @margen, 1) end end)
from 
historica.dbo.facturas_spt_fahorro 
where 
iva = @iva_factura and 
facturota = @facturota and
cant_ped > 0
and factura NOT IN('02963871') and cliente NOT IN('86530')




insert into #resultados(texto)  
select 
'04|' +
@trama + ' ' +
'    |' +
factura + '|' +
left(convert(varchar(10), convert(int, orden)) + '                                                                                                                                                                                                                                                          ', 250) + '|' +
right('            ' + convert(varchar(11), iva), 11) + '|' +
right('           ' + convert(varchar(10), total), 11) + '|' +
'          ' + '|' +
'  |' +
' |' +
right('              ' + suc_id, 14) + '|' +
'        |' +
right('           ' + convert(varchar(8), piezas), 8) + '|' +
'     |' +
'   |' +
'   |' +
'      |' +
'    |' +
left(fecha_factura + '                    ', 14)  + --a petición de ray 2010-09-09 sin pipe
'      |' + --a petición de ray 2010-09-09 con pipe
right('           ' + convert(varchar(11), importe), 11) + '|' +
'           |' +
'           |' +
'      |' +
'           |' +
'     |' +
'     |' +
'  |' +
'           |' +
' |' +
'           |' +
'           |' +
'                                                                           |' +
'                                                                           |' +
'              |' +
'             |' +
'             |' +
'             |' +
'        |' 
from #trama4

insert into #resultados(texto)  
select 
'04|' +
@trama + ' ' +
'    |' +
'        |' +
'                                                                                                                                                                                                                                                          |' +
right('           ' + convert(varchar(11), @iva), 11) + '|' +
right('           ' + convert(varchar(11), @total), 11) + '|'+
'          ' + '|' +
'  |' +
' |' +
'              |' +
'        |' +
'IMPORTES|' +
'     |' +
'   |' +
'   |' +
'      |' +
'    |' +
'              ' + --a petición de ray 2010-09-09 sin pipe
'      |' +  --a petición de ray 2010-09-08
right('           ' + convert(varchar(11), @importe), 11) + '|' +
'           |' +
'           |' +
'      |' +
'           |' +
'     |' +
'     |' +
'  |' +
'           |' +
' |' +
'           |' +
'           |' +
'                                                                           |' +
'                                                                           |' +
'              |' +
'             |' +
'             |' +
'             |' +
'        |' 



insert into #resultados(texto)  
select 
'04|' +
@trama + ' ' +
'    |' +
'        |' +
'                                                                                                                                                                                                                                                          |' +
'           ' + '|' +
right('           ' + convert(varchar(11), @ajuste), 11) + '|'+
'          ' + '|' +
'  |' +
' |' +
'              |' +
'        |' +
'  AJUSTE|' +
'     |' +
'   |' +
'   |' +
'      |' +
'    |' +
'              ' + --a petición de ray 2010-09-09 sin pipe
'      |' + --a petición de ray 2010-09-08
'           ' + '|' +
'           |' +
'           |' +
'      |' +
'           |' +
'     |' +
'     |' +
'  |' +
'           |' +
' |' +
'           |' +
'           |' +
'                                                                           |' +
'                                                                           |' +
'              |' +
'             |' +
'             |' +
'             |' +
'        |' 

insert into #resultados(texto)  
select 
'04|' +
@trama + ' ' +
'    |' +
'        |' +
'                                                                                                                                                                                                                                                          |' +
'           ' + '|' +
right('           ' + convert(varchar(11), @total - @ajuste), 11) + '|'+
'          ' + '|' +
'  |' +
' |' +
'              |' +
'        |' +
'   TOTAL|' +
'     |' +
'   |' +
'   |' +
'      |' +
'    |' +
'              ' + --a petición de ray 2010-09-09 sin pipe
'      |' + --a petición de ray 2010-09-08
'           ' + '|' +
'           |' +
'           |' +
'      |' +
'           |' +
'     |' +
'     |' +
'  |' +
'           |' +
' |' +
'           |' +
'           |' +
'                                                                           |' +
'                                                                           |' +
'              |' +
'             |' +
'             |' +
'             |' +
'        |' 

select texto from #resultados order by orden asc

GO

