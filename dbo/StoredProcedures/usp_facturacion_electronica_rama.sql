
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_facturacion_electronica_rama]

as
select 
factura remision,
folio_fiscal factura,
cod_barras,
codigo cod_marzam,
descripcion,
piezas_surtidas_con_cargo cantidad,
precio_farm_sin_imp,
precio_pub_sin_imp,
porcentaje_descto_oferta,
porcentaje_iva,
fecha_factura
from facturacion_electronica_estandar where sucursal = 1 and cliente =  '37980' and fecha_factura >= convert(datetime, convert(varchar(10), current_timestamp, 121), 121)
order by factura, no_registro
GO
