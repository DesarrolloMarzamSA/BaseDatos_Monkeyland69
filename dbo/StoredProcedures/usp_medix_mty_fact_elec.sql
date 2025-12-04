CREATE procedure [dbo].[usp_medix_mty_fact_elec] @fecha as char(10)
as
set nocount on

select 
convert(varchar(8), t1.fecha_factura, 112) + 
t1.cliente +
t1.folio_fiscal +
t1.codigo +
left(t1.descripcion + replicate(' ', 30), 30) +
right('0000000000000' + t1.cod_barras, 13) +
right('0000000' + convert(varchar(6), t1.piezas_surtidas_con_cargo), 5) +
right('0000000' + convert(varchar(6), t1.piezas_surtidas_sin_cargo), 5) +
right('0000' + convert(varchar(5), t1.porcentaje_descto_oferta), 5) +
right('0000000000' + convert(varchar(10), t1.precio_pub_sin_imp), 8) +
right('0000000000' + convert(varchar(10), t1.precio_pub_sin_imp * (1 + (t1.porcentaje_iva/100))), 8) +
right('0000000000' + convert(varchar(10), t1.precio_farm_sin_imp), 8) +
right('0000000000' + convert(varchar(10), t1.precio_farm_sin_imp * (1 + (t1.porcentaje_iva/100))), 8) +
right('0000000000' + convert(varchar(10), t1.porcentaje_descto_comercial), 5)
from facturacion_electronica_estandar t1 with(nolock) inner join clientes_baan t2 with(nolock) on t1.sucursal = t2.sucursal and t1.cliente = t2.cliente
where 
t1.sucursal = 7 and
t1.ctepadre = '174' and
fecha_tandem >= convert(smalldatetime, @fecha, 121)

set nocount off

GO

