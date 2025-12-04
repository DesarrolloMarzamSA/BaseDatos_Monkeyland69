--usp_genera_facturacion_electronica_sufacen_en_demanda 3, 'C2', '216', 'matutino', '2012-10-23'

CREATE   procedure [dbo].[usp_genera_facturacion_electronica_sufacen_en_demanda] @sucursal int, @segto varchar(2), @ctepadre varchar(3), @horario varchar(25), @fecha varchar(10)
as

declare @fecha_facturacion datetime
select @fecha_facturacion = convert(datetime, @fecha , 121) 

select
t1.cliente + 
--case when t1.folio_fiscal is null then left(convert(varchar(8), convert(bigint, t1.factura)) + '            ', 12)  else  left(convert(varchar(8), convert(bigint, t1.folio_fiscal)) + '            ', 12)  end + 
left(convert(varchar(8), convert(bigint, t1.factura)) + '            ', 12) +
'0           ' +
convert(varchar(10), t1.fecha_factura, 112) + 
t1.cod_barras +  
right('       ' + convert(varchar(7), t1.piezas_surtidas_con_cargo), 7) +  
right('       ' + convert(varchar(7), t1.piezas_surtidas_sin_cargo), 7) +  
right('      ' + convert(varchar(10), t1.precio_farm_sin_imp), 9) +  
right('   ' + convert(varchar(6), t1.porcentaje_descto_oferta), 6) +  
right('   ' + convert(varchar(6), t1.porcentaje_descto_comercial), 6) +  
right('      ' + convert(varchar(10), t1.iva), 9)
from facturacion_electronica_estandar t1
where
t1.sucursal = @sucursal and
t1.segto = @segto and
t1.ctepadre = @ctepadre and
t1.fecha_factura = @fecha_facturacion
order by
t1.factura,
t1.codigo

GO

