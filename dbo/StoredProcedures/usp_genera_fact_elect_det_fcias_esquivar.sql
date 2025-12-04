CREATE procedure [dbo].[usp_genera_fact_elect_det_fcias_esquivar]-- '','20161212'
	@rfc varchar(20),
	@fecha datetime
as

--declare @rfc varchar(20)
declare @fecha2 varchar(20)
--set @rfc = 'fes960502pj9'
set @fecha2 =  convert(varchar,getdate()-1,111)

select	t1.cliente + 
			left(convert(varchar, convert(bigint, t1.folio_fiscal)) + replicate(' ', 12), 12) +
			'0' + 
			'           ' +
			right('0000' + convert(varchar, datepart(yyyy,fecha_factura)), 4) +
			right('00' + convert(varchar, datepart(mm,fecha_factura)), 2) +
			right('00' + convert(varchar, datepart(dd,fecha_factura)), 2) +
			left(t1.cod_barras + '             ', 13) +
			right('       ' + convert(varchar, t1.piezas_surtidas_con_cargo), 7) +
			right('       ' + convert(varchar, t1.piezas_surtidas_sin_cargo), 7) +
			right('         ' + convert(varchar, (t1.importe_neto/t1.piezas_surtidas_con_cargo)), 9) +
			right('      ' + convert(varchar, '0'), 6) +
			right('      ' + convert(varchar, '0'), 6) +
			right('         ' + convert(varchar, t1.porcentaje_iva), 9)
from		facturacion_electronica_estandar t1
where	--rfc = @rfc and
		t1.ctepadre in('142','927')  and 
			convert(varchar,t1.fecha_factura,112)> = --convert(varchar,getdate()-1,112)
			convert(varchar,@fecha-1,112)
			--convert(varchar,t1.fecha_factura,112)>='2018-04-04' and convert(varchar,t1.fecha_factura,112)<'2018-04-06'
			 --convert(datetime, convert(varchar(10), @fecha2, 121), 121)
			--convert(varchar,t1.fecha_factura,112) between convert(varchar,getdate()-3,112) and convert(varchar,getdate()-2,112)
			--select * from Historica..encabezado where ctepadre in('142','927') and convert(varchar,fechaprog,112)> =convert(varchar,getdate()-1,112)
			--select convert(varchar,getdate()-3,112)

GO

