
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE  procedure [dbo].[usp_facturacion_abc] @sucursal as tinyint

as
select 
right('          '    + convert(varchar(10), convert(bigint, t1.cliente)), 10) +
right('            '  + convert(varchar(10),  convert(bigint, replace(t1.orden, ' ', ''))), 12) +
right('            '  + convert(varchar(12), convert(bigint, isnull(t1.folio_fiscal, t1.factura))), 12) +
--right('             ' + convert(varchar(13), convert(bigint, t1.cod_barras)), 13) +
--left(convert(varchar(13), t2.cod_barras_tandem) + '             ', 13) +
left(ltrim(isnull(t3.cod_barras_abc, t2.cod_barras_tandem)) + '             ', 13) +
--right('0000000000000' + replace(t1.cod_barras, ' ', ''), 13) +
right('            '  + convert(varchar(12), t1.piezas_surtidas_con_cargo), 12) +
right('            '  + convert(varchar(12), t1.piezas_surtidas_sin_cargo), 12) +
right('            '  + convert(varchar(12), convert(money, t1.importe_bruto/t1.piezas_surtidas_con_cargo)), 12) +
right('            '  + convert(varchar(12), t1.porcentaje_iva), 12) +
right('            '  + convert(varchar(12), t1.porcentaje_descto_comercial), 12) +
right('            '  + convert(varchar(12), t1.bonificacion_iva), 12) +
right('            '  + convert(varchar(12), t1.porcentaje_descto_oferta), 12) + 
right('            '  + convert(varchar(12), convert(money, t1.descto_oferta)), 12) + 
convert(varchar(10), t1.fecha_factura, 112)
from
facturacion_electronica_estandar t1 inner join maestro_productos t2 on t1.codigo = t2.codigo
left outer join gdl_abc_catalogo t3 on t2.codigo = t3.codigo
where 
t1.segto = 'C2' and
t1.ctepadre = '199' and
t1.sucursal = @sucursal and
--t1.cliente in ('85453', '02991', '00151', '84829', '10411', '01014', '81205', '10428', '10429', '85811') and
t1.fecha_factura >= convert(datetime, convert(varchar(10), current_timestamp, 121), 121) 
--t1.fecha_factura >= convert(datetime, '2011-10-20', 121)
order by 
t1.orden,
t1.cod_barras
GO
