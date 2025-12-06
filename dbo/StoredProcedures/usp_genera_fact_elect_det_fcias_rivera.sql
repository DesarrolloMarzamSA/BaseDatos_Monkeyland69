
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_genera_fact_elect_det_fcias_rivera]
	@segto varchar(2),
	@ctepadre varchar(3),
	@factura varchar(8),
	@fecha datetime
WITH ENCRYPTION
as
--declare @segto varchar(2)
--declare @ctepadre varchar(3)
--declare @factura varchar(8)
--declare @fecha datetime
--set @segto = 'C2'
--set @ctepadre = '333'
--set @factura = '01141528'
--set @fecha = '26-11-2010'
select	'RPROVEE=' + convert(varchar, convert(int, factura)),
			'PROVEE=' + '    1',
			'ENTRE=14,6',
			'ALMA=1',
			'IMPU=.',
			'DESC=18.000',
			'DESCFIN=.',
			'OBSDOC=.',
			'MONEDA=1',
			'TIPCAM= 1.000',
			'FLETE=.',
			'CANTI='  + right(replicate(' ', 14) +convert(varchar(14), piezas_surtidas_con_cargo), 14),
			'PROD=' + cod_barras,
			'DESC 1=' + right(replicate('0', 6) + convert(varchar(5), porcentaje_descto_comercial) + '0', 6),
			--case
			--	when porcentaje_descto_comercial = 0.00 then '00.000'
			--	else right(replicate('0', 6) + convert(varchar(5), porcentaje_descto_comercial) + '0', 6)
			--end,
			'ESQ_IMP=' + 
			case
				when iva = 0.00 then '9'
				else '5'
			end,
			'IMPU 1=.',
			'IMPU 2=.',
			'IMPU 3=.',
			'IMPU 4=.',
			'COSTO=' + right(replicate(' ', 20) + convert(varchar, precio_farm_sin_imp), 20),
			'UNIDAD=pz',
			'FACTUNI=      1.000',
			'OBSPAR=.'
from		facturacion_electronica_estandar 
where	segto = @segto and
			ctepadre = @ctepadre and
			factura = @factura and
			fecha_tandem = convert(datetime, convert(varchar(10), @fecha, 121), 121)

GO
