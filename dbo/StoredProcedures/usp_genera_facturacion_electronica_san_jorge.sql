
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[usp_genera_facturacion_electronica_san_jorge]
WITH ENCRYPTION
as
--PROCEDIMIENTO PARA FACTURACIÓN ELECTRÓNICA FCIAS. MODERNA DE GDL
select
t1.cliente +
left(convert(varchar(8), convert(bigint, t1.factura)) + '            ', 12) +
'            ' +
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
t1.sucursal = 1 and
t1.rfc = 'EESV5402014UA' and
t1.fecha_tandem >= convert(datetime, convert(varchar(10), current_timestamp, 121), 121)
--t1.fecha_tandem >= convert(datetime, '2011-11-18', 121)
order by
t1.factura,
t1.codigo


GO
