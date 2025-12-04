USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_genera_facturacion_electronica_moderna_gdl] @sucursal int, @segto varchar(2), @ctepadre varchar(3)
--exec usp_genera_facturacion_electronica_anefar 17, 'C2', '214'
WITH ENCRYPTION
as
--PROCEDIMIENTO PARA FACTURACIÓN ELECTRÓNICA FCIAS. MODERNA DE GDL
select
t1.cliente + 
--left(convert(varchar(8), convert(bigint, t1.factura)) + '            ', 12) +
case when t1.folio_fiscal is null then left(convert(varchar(8), convert(bigint, t1.factura)) + '            ', 12)  
else  left(convert(varchar(8), convert(bigint, t1.folio_fiscal)) + '            ', 12)  end + 
'0           ' +
convert(varchar(10), t1.fecha_factura, 112) +
--left(t1.cod_barras + '             ', 13) +
right('             ' + convert(varchar(13), convert(bigint, t1.cod_barras)), 13) +
right('       ' + convert(varchar(7), t1.piezas_surtidas_con_cargo), 7) +
right('       ' + convert(varchar(7), t1.piezas_surtidas_sin_cargo), 7) +
right('      ' + convert(varchar(10), t1.precio_farm_sin_imp), 9) +
right('   ' + convert(varchar(6), t1.porcentaje_descto_oferta), 6) +
right('   ' + convert(varchar(6), t1.porcentaje_descto_comercial), 6) +
right('      ' + convert(varchar(10), t1.porcentaje_iva), 9)
from facturacion_electronica_estandar t1
where
t1.sucursal in(@sucursal,16,18) and
t1.segto = @segto and
t1.ctepadre in ('214', '800') 
--t1.fecha_tandem = '20120928'
--modifique esta parte :toño 
--and t1.fecha_tandem = convert(datetime, convert(varchar(10), current_timestamp, 121), 121)
and t1.fecha_tandem >= convert(datetime, convert(varchar(10), current_timestamp-1, 121), 121)
order by
t1.factura,
t1.codigo



--select convert(datetime, convert(varchar(10), current_timestamp-1, 121), 121)
--select * from Historica.dbo.encabezado where factura='00698023' and ctepadre in ('214', '800') 

--select * from facturacion_electronica_estandar where factura='00698023' and ctepadre in ('214', '800') 
GO
