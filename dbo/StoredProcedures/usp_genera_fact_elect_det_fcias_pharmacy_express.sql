
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_genera_fact_elect_det_fcias_pharmacy_express]
	@sucursal tinyint,
	@cliente varchar(5),
	@fecha datetime
WITH ENCRYPTION
as

--declare @sucursal tinyint
--declare @cliente varchar(5)
--declare @fecha datetime
--set @sucursal = 3
--set @cliente = '84145'
--set @fecha = '2011-05-04'

select	left(convert(varchar, convert(bigint, t1.folio_fiscal)) + replicate(' ', 12), 12) +
			right('00' + convert(varchar, t1.sucursal), 2) +
			replicate(' ', 10) +
			convert(varchar(8), t1.fecha_factura,  112) +
			left(convert(varchar(13), convert(bigint, t1.cod_barras)) + replicate(' ', 13), 13) +
			right(replicate(' ', 9) + convert(varchar(9), t1.precio_farm_sin_imp), 9) +
			right(replicate(' ', 7) + convert(varchar(7), t1.piezas_surtidas_con_cargo), 7) +
			right(replicate(' ', 7) + convert(varchar(7), t1.piezas_surtidas_sin_cargo), 7) +
			right(replicate(' ', 9) + convert(varchar(9), t1.porcentaje_iva), 9) +
			right(replicate(' ', 6) + convert(varchar(6), t1.porcentaje_descto_oferta), 6) +
			right(replicate(' ', 6) + convert(varchar(6), t1.porcentaje_descto_comercial), 6)
from		facturacion_electronica_estandar t1
where	sucursal = @sucursal and
			cliente = @cliente and
			fecha_tandem = convert(datetime, convert(varchar(10), @fecha, 121), 121)
GO
