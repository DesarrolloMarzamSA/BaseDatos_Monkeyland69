
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

--usp_genera_facturacion_electronica_moderna 

CREATE procedure [dbo].[usp_genera_facturacion_electronica_moderna] @fecha varchar(10)
WITH ENCRYPTION
as
--PROCEDIMIENTO PARA FACTURACIÓN ELECTRÓNICA FCIAS. MODERNA DE CULIACÁN
declare @sucursal int, @segto varchar(2), @ctepadre varchar(3)

select
'      ' +
t1.cliente +
dbo.fn_digito_verificador(t1.cliente) +
right('       ' + convert(varchar(7), t1.porcentaje_descto_comercial), 7) +
right('       ' + convert(varchar(7), t1.porcentaje_descto_oferta), 7) +
right('             ' + convert(varchar(13), convert(bigint, t1.cod_barras)), 13) +
convert(varchar(8), t1.fecha_factura, 112) +
right('           ' + convert(varchar(11), t1.iva), 11) +
case when t1.folio_fiscal is null then right('            ' + convert(varchar(8), convert(bigint, t1.factura)), 12)  
else  right('            ' + convert(varchar(8), convert(bigint, t1.folio_fiscal)), 12)  end +
right('        ' + convert(varchar(8), t1.piezas_surtidas_con_cargo), 8) +
right('           ' + convert(varchar(11), t1.precio_farm_sin_imp), 11) +
'       0'
from facturacion_electronica_estandar t1
where
t1.sucursal  in(17,16) and 
t1.segto = 'C2' and
t1.ctepadre in ('214', '800') and
--t1.fecha_tandem >= convert(datetime, '2012-09-28', 121) 
t1.fecha_tandem >= convert(datetime, @fecha, 121) 
order by
t1.factura,
t1.codigo


GO
