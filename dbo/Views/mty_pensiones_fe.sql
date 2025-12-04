
CREATE view [dbo].[mty_pensiones_fe]
as
select sucursal, cliente, fecha_tandem, 
convert(varchar(6), t1.fecha_factura, 12) +
t1.cliente +
right(t1.folio_fiscal, 7) +
t1.cod_barras + 
' ' +
t1.codigo +
left(t1.descripcion + replicate(' ', 30), 30) +
right('000000' + convert(varchar(4), t1.piezas_surtidas_con_cargo), 6) +
right('000000' + convert(varchar(4), t1.piezas_surtidas_sin_cargo), 6) +
right('0000000' + convert(varchar(12), convert(money, t1.precio_farm_sin_imp - (t1.precio_farm_sin_imp * t1.porcentaje_descto_oferta/100))), 10) + 
'00.00' +
right('00' + convert(varchar(5), t1.porcentaje_descto_comercial), 5) +
right('0000000' + convert(varchar(12), convert(money, t1.precio_farm_sin_imp * (t1.porcentaje_iva/100) * t1.piezas_surtidas_con_cargo)), 10) + 
'0000000.00' +
right('0000000' + convert(varchar(12), convert(money, t1.precio_pub_sin_imp)), 10) columnota
from
monkeyland.dbo.facturacion_electronica_estandar t1 with(nolock)
--where t1.sucursal = 7 and t1.folio_fiscal = '00493944' and t1.codigo = '0047002'

GO

