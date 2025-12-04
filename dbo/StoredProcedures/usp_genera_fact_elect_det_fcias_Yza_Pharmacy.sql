CREATE procedure [dbo].[usp_genera_fact_elect_det_fcias_Yza_Pharmacy]
	@sucursal tinyint, 
	@segto varchar(2),
	@ctepadre varchar(3),
	@fecha datetime
as

--declare @sucursal tinyint
--declare @segto varchar(2)
--declare @ctepadre varchar(3)
--declare @fecha datetime
--set @sucursal = 11
--set @segto = 'C1'
--set @ctepadre = '578'
--set @fecha = '2011-07-22'

select	left(convert(varchar(12), t1.folio_fiscal) + replicate(' ', 12), 12) +
			left(convert(varchar(12), t2.mostrador) + replicate(' ', 12), 12) +
			convert(varchar(8), t1.fecha_factura,  112) +
			left(rtrim(ltrim(t3.cod_barras_tandem)) + replicate(' ', 13), 13) +  
			right(replicate(' ', 7) + convert(varchar(7), t1.piezas_surtidas_con_cargo), 7) +
			right(replicate(' ', 7) + convert(varchar(7), t1.piezas_surtidas_sin_cargo), 7) +
			right(replicate(' ', 9) + convert(varchar(9), t1.precio_farm_sin_imp), 9) +
			right(replicate(' ', 6) + convert(varchar(6), t1.porcentaje_descto_oferta), 6) +
			right(replicate(' ', 6) + convert(varchar(6), t1.porcentaje_descto_comercial), 6) +
			right(replicate(' ', 9)+ convert(varchar(9), t1.porcentaje_iva), 9)
from		facturacion_electronica_estandar t1 inner join cat_yza_pharmacy_facturacion t2 on
			t1.sucursal = t2.sucursal and
			t1.cliente = t2.cliente inner join maestro_productos_baan t3 on
			t1.codigo = t3.codigo
where	t1.sucursal = @sucursal and
			fecha_factura >= convert(datetime, convert(varchar(10), @fecha, 121), 121) and 
			t1.segto = @segto and
			t1.ctepadre = @ctepadre and
			t1.cliente in (select cliente from cat_yza_pharmacy_facturacion where sucursal = @sucursal)

GO

