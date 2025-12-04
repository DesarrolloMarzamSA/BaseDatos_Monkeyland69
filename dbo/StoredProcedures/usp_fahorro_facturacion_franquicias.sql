USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_fahorro_facturacion_franquicias]
WITH ENCRYPTION
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
select 
sucursal, 
cliente, 
digito_verificador, 
serie, 
factura, 
fecha_factura, 
codigo, 
descripcion, 
cod_barras, 
clas_fis, 
piezas_surtidas_con_cargo, 
piezas_surtidas_sin_cargo, 
precio_farm_sin_imp, 
precio_pub_sin_imp, 
precio_pub_con_imp, 
importe_bruto, 
porcentaje_descto_oferta, 
descto_oferta, 
porcentaje_descto_comercial, 
descto_comercial, 
ieps, 
iva, 
bonificacion_iva, 
porcentaje_utilidad, 
importe_neto, 
orden, 
porcentaje_iva, 
filler, 
no_registro, 
desc_comerc_prod, 
porcentaje_iva2, 
iva2, 
bonificacion_iva2, 
porcentaje_ieps, 
desc_comerc_ieps, 
iva_del_iesps, 
bonificacion_iva_del_iesps, 
timestamp, 
segto, 
ctepadre, 
rfc, 
tipo_documento, 
folio_fiscal, 
fecha_tandem 
into #facturacion_electronica_estandar 
from facturacion_electronica_estandar 
where ctepadre = '008' and cliente='05115'  and timestamp>=convert(varchar(10), current_timestamp-1, 121)

create index idx_tmp_factfranqahorro1 on #facturacion_electronica_estandar(sucursal, cliente)
create index idx_tmp_factfranqahorro2 on #facturacion_electronica_estandar(codigo)

select 
t1.cliente + 
left(t2.farmacia + '                    ', 20) + 
left(convert(varchar(8), convert(bigint, t1.folio_fiscal)) + '        ', 8) + 
'00' + t1.codigo + 
right('00000' + convert(varchar(5), t1.piezas_surtidas_con_cargo), 5) + 
right('00000' + convert(varchar(5), t1.piezas_surtidas_sin_cargo), 5) + 
'.' + left(right('00000' + convert(varchar(5), convert(int, t1.porcentaje_descto_oferta * 100)), 4), 2) + 
left(t1.clas_fis + '  ', 2) + 
left(right('000000000' + convert(varchar(15), case t3.grupo_est when 'PC01A' then t1.precio_pub_sin_imp + (t1.precio_pub_sin_imp * 0.5) else t1.precio_pub_sin_imp end), 15), 12) + 
left(right('000000000' + convert(varchar(15), case t3.grupo_est when 'PC01A' then t1.precio_farm_sin_imp + (t1.precio_farm_sin_imp * 0.5) else t1.precio_farm_sin_imp end), 15), 12) + 
right('0000000000000' + ltrim(rtrim(t1.cod_barras)), 13) + 
convert(varchar(8), t1.fecha_factura, 11) + 
left(right('0000000000' + convert(varchar(15), round((case t3.grupo_est when 'PC01A' then t1.precio_farm_sin_imp + (t1.precio_farm_sin_imp * 0.5) else t1.precio_farm_sin_imp end * (t1.porcentaje_descto_oferta / 100)), 2, 1)), 17), 13) + 
left(right('0000000000' + convert(varchar(15), round((case t3.grupo_est when 'PC01A' then t1.precio_farm_sin_imp + (t1.precio_farm_sin_imp * 0.5) else t1.precio_farm_sin_imp end - round((case t3.grupo_est when 'PC01A' then t1.precio_farm_sin_imp + (t1.precio_farm_sin_imp * 0.5) else t1.precio_farm_sin_imp end * (t1.porcentaje_descto_oferta / 100)) , 2, 1)) * (t1.porcentaje_descto_comercial/100), 2, 1)), 17), 13) + 
left(right('0000000000' + convert(varchar(15), round((round(case t3.grupo_est when 'PC01A' then t1.precio_farm_sin_imp + (t1.precio_farm_sin_imp * 0.5) else t1.precio_farm_sin_imp end, 2, 1) - 
round(((case t3.grupo_est when 'PC01A' then t1.precio_farm_sin_imp + (t1.precio_farm_sin_imp * 0.5) else t1.precio_farm_sin_imp end) * (t1.porcentaje_descto_oferta / 100)), 2, 1) - 
round((case t3.grupo_est when 'PC01A' then t1.precio_farm_sin_imp + (t1.precio_farm_sin_imp * 0.5) else t1.precio_farm_sin_imp end) * (t1.porcentaje_descto_comercial/100), 2, 1)) * (porcentaje_iva/100), 2, 1)), 17), 13) texto, 
t1.cliente + '-' + dbo.fn_digito_verificador(t1.cliente) + '.REC' archivo 
into #factfahorro 
from 
#facturacion_electronica_estandar t1 inner join clientes_baan t2 on t1.cliente = t2.cliente and t1.sucursal = t2.sucursal 
inner join maestro_productos_baan t3 on t1.codigo = t3.codigo order by t1.folio_fiscal

select * from #factfahorro 
END
GO
