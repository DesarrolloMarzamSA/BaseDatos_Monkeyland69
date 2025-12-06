
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_genera_facturacion_electronica_abc] @sucursal int, @segto varchar(2), @ctepadre varchar(3), @horario varchar(25)

as
--PROCEDIMIENTO PARA FACTURACIÓN ELECTRÓNICA FCIAS. MODERNA DE GDL
declare @fecha_facturacion datetime

select @fecha_facturacion = case  @horario
when 'matutino' then convert(datetime, convert(varchar(10), current_timestamp, 121), 121) else
convert(datetime, convert(varchar(10), dateadd(dd, 1, current_timestamp), 121), 121) end

if (datepart(dw, current_timestamp) = 6)
begin
	select @fecha_facturacion = case  @horario
	when 'matutino' then convert(datetime, convert(varchar(10), current_timestamp, 121), 121) else
	convert(datetime, convert(varchar(10), dateadd(dd, 2, current_timestamp), 121), 121) end
end

select
t1.cliente + 
right(t1.factura, 7) + 
--right('            '  + convert(varchar(12), convert(bigint, isnull(t1.folio_fiscal, t1.factura))), 7) +
'     0           ' +
convert(varchar(10)
, t1.fecha_factura, 112) + 
--t2.cod_barras + 
--right('             ' + convert(varchar(13), convert(bigint, t2.cod_barras)), 13) +
left(convert(varchar(13), t2.cod_barras_tandem) + '             ', 13) +
right('       ' + convert(varchar(7), t1.piezas_surtidas_con_cargo), 7) + 
right('       ' + convert(varchar(7), t1.piezas_surtidas_sin_cargo), 7) + 
right('      ' + convert(varchar(10), t1.precio_farm_sin_imp), 9) + 
right('   ' + convert(varchar(6), t1.porcentaje_descto_oferta), 6) + 
right('   ' + convert(varchar(6), t1.porcentaje_descto_comercial), 6) + 
right('      ' + convert(varchar(10), t1.iva), 9)
from facturacion_electronica_estandar t1 inner join maestro_productos t2 on t1.codigo = t2.codigo
where
t1.sucursal = @sucursal and
t1.segto = @segto and
t1.ctepadre = @ctepadre and
t1.fecha_factura >= @fecha_facturacion 
--t1.fecha_factura >= convert(datetime, '2011-10-20', 121)
--and t1.cliente = '10411'
order by
t1.factura,
t1.codigo

GO
