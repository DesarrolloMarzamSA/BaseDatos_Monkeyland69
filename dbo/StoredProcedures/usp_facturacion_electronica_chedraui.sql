
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_facturacion_electronica_chedraui] @segto varchar(2), @ctepadre varchar(3), @fecha char(10)
WITH ENCRYPTION
as
declare @fecha_tandem smalldatetime
select @fecha_tandem = convert(datetime, @fecha, 121)

select
case 
when t1.folio_fiscal is null 
then left(convert(varchar(8), convert(bigint, t1.factura)) + '            ', 12)  
else  left(convert(varchar(8), convert(bigint, t1.folio_fiscal)) + '            ', 12)  end +
t3.cuenta_estilo_chedraui + '      ' +
convert(varchar(8), t1.fecha_factura, 112) + 
left(CONVERT(VARCHAR(13), CONVERT(BIGINT, t2.cod_barras_tandem)) + '             ', 13) +
right('       ' + convert(varchar(7), t1.piezas_surtidas_con_cargo), 7) + 
right('       ' + convert(varchar(7), t1.piezas_surtidas_sin_cargo), 7) + 
right(' 
     ' + convert(varchar(10), t1.precio_farm_sin_imp), 9) + 
right('      ' + convert(varchar(10), t1.iva), 9) +
right('   ' + convert(varchar(6), t1.porcentaje_descto_oferta), 6) + 
right('   ' + convert(varchar(6), t1.porcentaje_descto_comercial), 6) 
from 
facturacion_electronica_estandar t1 inner join maestro_productos t2 on t1.codigo = t2.codigo
inner join cat_tiendas_chedraui t3 on t1.sucursal = t3.sucursal and t1.cliente = t3.cliente
where
t1.segto = @segto and
t1.ctepadre = @ctepadre and
t1.fecha_tandem = @fecha_tandem
order by
t1.factura,
t1.codigo

GO
