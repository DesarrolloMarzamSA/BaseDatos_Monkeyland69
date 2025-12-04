

-- =============================================
-- Author:		Antonio Acosta
-- Create date: 2016-04-19
-- Description:	Presenta la información de facturación electrónica, empatando los datos con ibs para recalcular el importe neto que tiene la diferencia de un centavo
-- =============================================
CREATE PROCEDURE [dbo].[usp_genera_facturacion_electronica_sufacen3]
	@confecha nvarchar(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @sql nvarchar(2000)
	declare @fecha datetime
	if @confecha = ''
	begin
		set @fecha = convert(datetime, convert(varchar(10), current_timestamp, 121), 121)
	end
	else
	begin
		set @fecha = @confecha
	end
	
	-- Temporal que almacena datos de ibs
	create table #temporal (tmp_factura varchar(8), tmp_codigo varchar(7), tmp_piezas int, tmp_porcentaje_descuento money, tmp_descuento money, tmp_porcentaje_oferta money, tmp_oferta money, tmp_neto money)
	-- Llenado de temporal con descuentos
	set @sql = 'select * from openquery(as400, ''select substring(idinvn, 5, 12), idprdc, idsqty, ((sum(case when dtdity = ''''1'''' then dtdcam else 0 end) * idsqty) / double(idsalp * idsqty)) * 100, sum(case when dtdity = ''''1'''' then dtdcam else 0 end) * idsqty, ((sum(case when dtdity <> ''''1'''' then dtdcam else 0 end) * idsqty) / double((idsalp * idsqty) - (sum(case when dtdity = ''''1'''' then dtdcam else 0 end) * idsqty))) * 100 tmp_porcentaje_oferta, sum(case when dtdity <> ''''1'''' then dtdcam else 0 end) * idsqty tmp_oferta from ma4620ef04.srbisd left join ma4620ef04.srbgdt on idgdsq = dtgdsq where ididat between ' + convert(nvarchar(8), @fecha - 1, 112) + ' and ' + convert(nvarchar(8), @fecha, 112) + ' and idtypp = 1 and idcca1 = ''''99216'''' and substring(idordt, 1, 1) = ''''F'''' group by substring(idinvn, 5, 12), idprdc, idsqty, idsalp, idgdsq with ur'')'
	insert into #temporal (tmp_factura, tmp_codigo, tmp_piezas, tmp_porcentaje_descuento, tmp_descuento, tmp_porcentaje_oferta, tmp_oferta)
	execute (@sql)
	-- Llenado de temporal con neto
	set @sql = 'update #temporal set #temporal.tmp_neto = dbo.fn_getDiscount(idsalp, dis1, dis2, dis3, dis4, dis5, dis6) * idsqty from #temporal inner join openquery(as400, ''select substring(idinvn, 5, 12) factura, idprdc, idsqty, trunc(idsalp , 2) idsalp, dis1, dis2, dis3, dis4, dis5, dis6 from ma4620ef04.srbisd left join (select dtgdsq, sum(double(case when dtseq = 1 then dtdcpr else 0 end)) dis1, sum(double(case when dtseq = 2 then dtdcpr else 0 end)) dis2, sum(double(case when dtseq = 3 then dtdcpr else 0 end)) dis3, sum(double(case when dtseq = 4 then dtdcpr else 0 end)) dis4, sum(double(case when dtseq = 5 then dtdcpr else 0 end)) dis5, sum(double(case when dtseq = 6 then dtdcpr else 0 end)) dis6 from ma4620ef04.srbisd inner join ma4620ef04.srbgdt on idgdsq = dtgdsq where ididat between ' + convert(nvarchar(8), @fecha - 1, 112) + ' and ' + convert(nvarchar(8), @fecha, 112) + ' and idtypp = 1 and idcca1 = ''''99216'''' and substring(idordt, 1, 1) = ''''F'''' group by dtgdsq) des on idgdsq = dtgdsq where ididat between ' + convert(nvarchar(8), @fecha - 1, 112) + ' and ' + convert(nvarchar(8), @fecha, 112) + ' and idtypp = 1 and idcca1 = ''''99216'''' and substring(idordt, 1, 1) = ''''F'''' with ur'') netos on #temporal.tmp_factura = factura and #temporal.tmp_codigo = idprdc and #temporal.tmp_piezas = idsqty'
	execute (@sql)
	-- Consulta de relación
	SELECT        RIGHT('00' + CONVERT(varchar(2), t1.sucursal), 2) + t1.cliente + t1.digito_verificador + CASE WHEN t1.folio_fiscal IS NULL THEN t1.serie + LEFT(RIGHT(t1.factura, 7) 
	+ '          ', 9) ELSE LEFT(t2.serie_cfd + CONVERT(varchar(8), CONVERT(bigint, t1.folio_fiscal)) + '          ', 10) END + CONVERT(varchar(8), t1.fecha_factura, 112) 
	+ '00' + t1.codigo + LEFT(t1.descripcion + '                                        ', 40) + LEFT(t3.cod_barras_tandem + '             ', 13) + LEFT(t1.clas_fis + '  ', 2) 
	+ RIGHT('0000000' + CONVERT(varchar(7), t1.piezas_surtidas_con_cargo), 7) + RIGHT('0000000' + CONVERT(varchar(7), t1.piezas_surtidas_sin_cargo), 7) 
	+ RIGHT('0000000000' + CONVERT(varchar(10), t1.precio_farm_sin_imp), 10) + RIGHT('0000000000' + CONVERT(varchar(10), t1.precio_pub_sin_imp), 10) 
	+ RIGHT('0000000000' + CONVERT(varchar(10), t1.precio_pub_con_imp), 10) /*AS primera_parte,*/ + RIGHT('0000000000000' + CONVERT(varchar(13), t1.importe_bruto), 13)
	-- + RIGHT('000000' + CONVERT(varchar(10), case when tmp.tmp_porcentaje_descuento is not null then tmp.tmp_porcentaje_descuento else t1.porcentaje_descto_oferta end), 6)
	+ '000.00'
	+ RIGHT('0000000000000' + CONVERT(varchar(13), case when tmp.tmp_descuento is not null then tmp.tmp_descuento else t1.descto_oferta end), 13) 
	+ RIGHT('000000' + CONVERT(varchar(10), case when tmp.tmp_porcentaje_oferta is not null then tmp.tmp_porcentaje_oferta else t1.porcentaje_descto_comercial end), 6)
	-- + RIGHT('0000000000000' + CONVERT(varchar(13), case when tmp.tmp_oferta is not null then tmp.tmp_oferta else t1.descto_comercial end), 13) 
	+ '0000000000.00'
	+ RIGHT('0000000000000' + CONVERT(varchar(13), t1.ieps), 13) + RIGHT('0000000000000' + CONVERT(varchar(13), (tmp.tmp_neto * (t1.porcentaje_iva / 100))), 13) 
	+ RIGHT('0000000000000' + CONVERT(varchar(13), t1.bonificacion_iva), 13) + RIGHT('00000' + CONVERT(varchar(5), 
	CASE WHEN t1.porcentaje_utilidad < 0 THEN 0 ELSE t1.porcentaje_utilidad END), 5)+ RIGHT('0000000000000' + CONVERT(varchar(13), case when tmp.tmp_neto is not null then tmp.tmp_neto + (tmp.tmp_neto * (t1.porcentaje_iva / 100)) + t1.ieps else t1.importe_neto end), 13) 
	+ RIGHT('000000000' + REPLACE(t1.orden, ' ', ''), 9) + RIGHT('000000' + CONVERT(varchar(6), t1.porcentaje_iva), 6) + t1.filler + RIGHT('00000' + CONVERT(varchar(5), 
	t1.no_registro), 5) AS segunda_parte, t1.segto, t1.ctepadre, t1.rfc, t1.fecha_factura, t1.cliente, t1.sucursal, t1.factura, t1.fecha_tandem, t1.clas_fis
	from dbo.facturacion_electronica_estandar as t1
	inner join dbo.sucursales as t2
	on t1.sucursal = t2.sucursal
	inner join dbo.maestro_productos as t3
	on t1.codigo = t3.codigo
	left join #temporal as tmp
	on t1.factura = tmp.tmp_factura
	and t1.codigo = tmp.tmp_codigo
	and t1.piezas_surtidas_con_cargo = tmp.tmp_piezas
	where fecha_factura between @fecha-1 and @fecha
	and t1.sucursal = 3
	and segto = 'C2'
	and ctepadre = '216'
	order by cliente, factura

	drop table #temporal
END

GO

