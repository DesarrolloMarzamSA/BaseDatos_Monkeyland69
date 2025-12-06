
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

--usp_genera_facturacion_electronica_bazar 'matutino'

CREATE procedure [dbo].[usp_genera_facturacion_electronica_bazar] @horario varchar(25)

as

declare @fecha_facturacion datetime
select @fecha_facturacion = case  @horario
when 'matutino' then convert(datetime, convert(varchar(10), current_timestamp, 121), 121) else
convert(datetime, convert(varchar(10), dateadd(dd, 1, current_timestamp), 121), 121) end

select
t1.cliente + 
left(t2.farmacia + '                    ', 20) + 
case when t1.folio_fiscal is null then left(convert(varchar(8), convert(bigint, t1.factura)) + '            ', 12)  else  left(convert(varchar(8), convert(bigint, t1.folio_fiscal)) + '            ', 12)  end + 
--t1.factura +
'00' + 
t1.codigo +
right('0000000' + convert(varchar(7), t1.piezas_surtidas_con_cargo), 5) +  
right('0000000' + convert(varchar(7), t1.piezas_surtidas_sin_cargo), 5) + 
'.' + right('00' + convert(varchar(2), convert(int, round(porcentaje_descto_oferta, 0, 2))), 2) +
left(t1.clas_fis + '  ', 2) + 
right('000000000000' + convert(varchar(10), t1.precio_pub_sin_imp), 12) +  
right('000000000000' + convert(varchar(10), t1.precio_farm_sin_imp), 12) +  
' ' + 
t1.cod_barras +  
' ' +
replace(convert(varchar(10), t1.fecha_factura, 2), '.', '/')
from facturacion_electronica_estandar t1 inner join clientes_baan t2 on t1.sucursal = t2.sucursal and t1.cliente = t2.cliente
where
t1.sucursal in (11, 13) and
t1.segto = 'C2' and
t1.ctepadre = '468' and
t1.fecha_factura = @fecha_facturacion
--t1.fecha_factura = convert(datetime, '2009-07-06', 121) 
order by
t1.factura,
t1.codigo





GO
