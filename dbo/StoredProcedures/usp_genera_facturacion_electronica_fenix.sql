--select * from facturacion_electronica_estandar where sucursal = 1 and folio_fiscal = '00471604'
/*
exec usp_genera_facturacion_electronica_fenix '2011-02-24'
*/
CREATE PROCEDURE [dbo].[usp_genera_facturacion_electronica_fenix] @fecha varchar(10), @sucursal char(2)=''
as
declare @total_del_registro int

select @total_del_registro = count(*) from
facturacion_electronica_estandar t1 --inner join series_facturacion t2 on t1.sucursal = t2.sucursal
inner join maestro_productos t3 on t1.codigo = t3.codigo 
left outer join CatTiendasFenix t4 on t1.sucursal = t4.sucursal and t1.cliente = t4.cliente
inner join sucursales s ON s.sucursal = t1.sucursal
where
t1.segto = 'C1' and 
t1.ctepadre in ('010','122') and
t1.fecha_factura = convert(datetime, @fecha, 121) 
--t1.fecha_tandem = convert(datetime, @fecha, 121) 
--between convert(datetime, '2011-01-01', 121) and convert(datetime, '2011-02-24', 121)

--modificacion para poder hacer consultas diferenciando las series

if @sucursal =''
	begin
		select
		'C00500' + 
		convert(varchar(8), t1.fecha_factura, 112) + 
		right('000000' + convert(varchar(6), @total_del_registro), 6) +
		'                                                                                          C:' +
		right(replicate('0',9)+isnull(t4.numtienda,'0'),9) + 
		replicate(' ',99) + 
		'F' +
		--left(s.serie_cfd + convert(varchar(10), convert(int, t1.folio_fiscal)) + '            ',9) + ' ' +
		--left(s.serie_cfd + right(t1.folio_fiscal,8),10) +
		--modificacion para quitar cerros, a peticion de farmacias fenix
		--left(s.serie_cfd + right(cast(cast(t1.folio_fiscal as int)as char(8)),8),10)+
		--modificacion de la serie para la factura, capa intermedia aun utiliza sucursal 4
		--por razones de integridad de datos, por lo que las facturas salen como FD
		--pero tienen que salir como FU
		case 
		--la fecha esta asi por que hay facturas fiscales entregadas con FD por lo que
		--las entregas de esos dias tiene que ir con FD y no FU
		when convert(datetime, @fecha, 121)>=convert(datetime,'20130107',121)
		then left(case when s.serie_cfd='FD' then 'FU' else s.serie_cfd end + right(cast(cast(t1.folio_fiscal as int)as char(8)),8),10)
		else left(s.serie_cfd + right(cast(cast(t1.folio_fiscal as int)as char(8)),8),10)
		end +
		'000005' +
		convert(varchar(8), t1.fecha_factura, 112) + 
		right('000000000000' + convert(varchar(20), convert(bigint, t1.importe_neto * 100)), 12)+
		right('000000000000' + convert(varchar(20), convert(bigint, t1.descto_comercial * 100)), 12) +
		right('000000000000' + convert(varchar(20), convert(bigint, (t1.importe_bruto - t1.descto_oferta) * 100)), 12) +
		right('000000000000' + convert(varchar(20), convert(bigint, 100 * t1.iva)), 12) + 
		right('000000000000' + convert(varchar(20), case t3.grupo_est when 'PC01A' then convert(bigint, 100 * (t1.importe_bruto * 0.5)) else 0 end), 12)   +  --ieps
		right('000000' + convert(varchar(6), t1.piezas_surtidas_con_cargo + t1.piezas_surtidas_sin_cargo), 6) + 
		'                  A' + 
		case t1.porcentaje_iva when 0 then right('00000000000' + convert(varchar(20), convert(bigint, 100 * convert(money, t1.importe_bruto - t1.descto_oferta))), 11) else '00000000000' end +
		case t1.porcentaje_iva when 0 then right('00000000000' + convert(varchar(20), convert(bigint, 100 * t1.desc_comerc_prod)), 11) else '00000000000' end +
		case t1.porcentaje_iva when s.porcentaje_iva then right('00000000000' + convert(varchar(20), convert(bigint, 100 * convert(money, t1.importe_bruto - t1.descto_oferta))), 11) else '00000000000' end +
		case t1.porcentaje_iva when s.porcentaje_iva then right('00000000000' + convert(varchar(20), convert(bigint, 100 * t1.iva)), 11) else '00000000000' end + 
		'0000000000000000000000000000000000000000000000' +
		'0001' +
		'00000' +
		'           P' + 
		'0' + t1.codigo +
		right('000000' + convert(varchar(6), t1.piezas_surtidas_con_cargo), 6) +
		right('000000' + convert(varchar(6), t1.piezas_surtidas_sin_cargo), 6) +
		'00000' +
		right('00000000' + convert(varchar(10), convert(bigint, 100 * t1.precio_farm_sin_imp)), 8) +
		right('00000000' + convert(varchar(10), convert(bigint, 100 * t1.precio_pub_sin_imp)), 8) +
		right('00000000' + convert(varchar(10), convert(bigint, 100 * t1.precio_farm_sin_imp * t1.piezas_surtidas_con_cargo)), 8) +
		right('00000000' + convert(varchar(10), convert(bigint, 100 * t1.precio_pub_sin_imp * t1.piezas_surtidas_con_cargo)), 8) +
		right('00000000' + convert(varchar(10), convert(bigint, 100 * t1.iva * t1.piezas_surtidas_con_cargo)), 8) +
		case t3.grupo_est when 'PC01A' then right('00000000' + convert(varchar(12), convert(bigint, 100 * convert(money, precio_farm_sin_imp * 0.50))), 8) else '00000000' end +
		'              10' +
		t1.cod_barras +
		right('0000' + convert(varchar(4), convert(int, porcentaje_utilidad * 100)), 4)  + 
		'  ' + 
		case left(t3.clas_fis, 1) when 'N' then '*' else ' '  end +
		right('  ' + convert(varchar(2), isnull(t4.compania, 0)), 2) + 
		'0' + isnull(t4.numtienda,'00000000') + 
		'0500'
		from
			facturacion_electronica_estandar t1 --inner join series_facturacion t2 on t1.sucursal = t2.sucursal
			inner join maestro_productos t3 on t1.codigo = t3.codigo 
			left outer join CatTiendasFenix t4 on t1.sucursal =  case when t4.sucursal=1 then 21 else t4.sucursal end and t1.cliente = t4.cliente
			inner join sucursales s ON s.sucursal = t1.sucursal
		where
			t1.segto = 'C1' and 
			t1.ctepadre in ('010','122') and
			--t1.fecha_factura >= convert(datetime, convert(varchar(10), current_timestamp, 121), 121) 
			t1.fecha_factura >= convert(datetime, @fecha, 121)
			--and t4.numtienda is not null
			--t1.fecha_tandem = convert(datetime, @fecha, 121)
			--between convert(datetime, '2011-01-01', 121) and convert(datetime, '2011-02-24', 121)
			--ORDER BY t1.fecha_tandem, t1.sucursal, t1.folio_fiscal
	end
else
	begin
		select
		'C00500' + 
		convert(varchar(8), t1.fecha_factura, 112) + 
		right('000000' + convert(varchar(6), @total_del_registro), 6) +
		'                                                                                          C:' +
		right(replicate('0',9)+isnull(t4.numtienda,'0'),9) + 
		replicate(' ',99) + 
		'F' +
		--left(s.serie_cfd + right(t1.folio_fiscal,8),10) +
		--modificacion para quitar cerros, a peticion de farmacias fenix
		--left(s.serie_cfd + right(cast(cast(t1.folio_fiscal as int)as char(8)),8),10)+
		--modificacion de la serie para la factura, capa intermedia aun utiliza sucursal 4
		--por razones de integridad de datos, por lo que las facturas salen como FD
		--pero tienen que salir como FU
		case 
		--la fecha esta asi por que hay facturas fiscales entregadas con FD por lo que
		--las entregas de esos dias tiene que ir con FD y no FU
		when convert(datetime, @fecha, 121)>=convert(datetime,'20130107',121)
		then left(case when s.serie_cfd='FD' then 'FU' else s.serie_cfd end + right(cast(cast(t1.folio_fiscal as int)as char(8)),8),10)
		else left(s.serie_cfd + right(cast(cast(t1.folio_fiscal as int)as char(8)),8),10)
		end +
		'000005' +
		convert(varchar(8), t1.fecha_factura, 112) + 
		right('000000000000' + convert(varchar(20), convert(bigint, t1.importe_neto * 100)), 12)+
		right('000000000000' + convert(varchar(20), convert(bigint, t1.descto_comercial * 100)), 12) +
		right('000000000000' + convert(varchar(20), convert(bigint, (t1.importe_bruto - t1.descto_oferta) * 100)), 12) +
		right('000000000000' + convert(varchar(20), convert(bigint, 100 * t1.iva)), 12) + 
		right('000000000000' + convert(varchar(20), case t3.grupo_est when 'PC01A' then convert(bigint, 100 * (t1.importe_bruto * 0.5)) else 0 end), 12)   +  --ieps
		right('000000' + convert(varchar(6), t1.piezas_surtidas_con_cargo + t1.piezas_surtidas_sin_cargo), 6) + 
		'                  A' + 
		case t1.porcentaje_iva when 0 then right('00000000000' + convert(varchar(20), convert(bigint, 100 * convert(money, t1.importe_bruto - t1.descto_oferta))), 11) else '00000000000' end +
		case t1.porcentaje_iva when 0 then right('00000000000' + convert(varchar(20), convert(bigint, 100 * t1.desc_comerc_prod)), 11) else '00000000000' end +
		case t1.porcentaje_iva when s.porcentaje_iva then right('00000000000' + convert(varchar(20), convert(bigint, 100 * convert(money, t1.importe_bruto - t1.descto_oferta))), 11) else '00000000000' end +
		case t1.porcentaje_iva when s.porcentaje_iva then right('00000000000' + convert(varchar(20), convert(bigint, 100 * t1.iva)), 11) else '00000000000' end + 
		'0000000000000000000000000000000000000000000000' +
		'0001' +
		'00000' +
		'           P' + 
		'0' + t1.codigo +
		right('000000' + convert(varchar(6), t1.piezas_surtidas_con_cargo), 6) +
		right('000000' + convert(varchar(6), t1.piezas_surtidas_sin_cargo), 6) +
		'00000' +
		right('00000000' + convert(varchar(10), convert(bigint, 100 * t1.precio_farm_sin_imp)), 8) +
		right('00000000' + convert(varchar(10), convert(bigint, 100 * t1.precio_pub_sin_imp)), 8) +
		right('00000000' + convert(varchar(10), convert(bigint, 100 * t1.precio_farm_sin_imp * t1.piezas_surtidas_con_cargo)), 8) +
		right('00000000' + convert(varchar(10), convert(bigint, 100 * t1.precio_pub_sin_imp * t1.piezas_surtidas_con_cargo)), 8) +
		right('00000000' + convert(varchar(10), convert(bigint, 100 * t1.iva * t1.piezas_surtidas_con_cargo)), 8) +
		case t3.grupo_est when 'PC01A' then right('00000000' + convert(varchar(12), convert(bigint, 100 * convert(money, precio_farm_sin_imp * 0.50))), 8) else '00000000' end +
		'              10' +
		t1.cod_barras +
		right('0000' + convert(varchar(4), convert(int, porcentaje_utilidad * 100)), 4)  + 
		'  ' + 
		case left(t3.clas_fis, 1) when 'N' then '*' else ' '  end +
		right('  ' + convert(varchar(2), isnull(t4.compania, 0)), 2) + 
		'0' + isnull(t4.numtienda,'00000000') + 
		'0500'
		from
			facturacion_electronica_estandar t1 --inner join series_facturacion t2 on t1.sucursal = t2.sucursal
			inner join maestro_productos t3 on t1.codigo = t3.codigo 
			--left outer join CatTiendasFenix t4 on t1.sucursal = t4.sucursal and t1.cliente = t4.cliente
			left outer join CatTiendasFenix t4 on t1.sucursal =  case when t4.sucursal=1 then 21 else t4.sucursal end and t1.cliente = t4.cliente
			inner join sucursales s ON s.sucursal = t1.sucursal
		where
			t1.segto = 'C1' and 
			t1.ctepadre in ('010','122') and
			t1.fecha_factura >= convert(datetime, @fecha, 121)
			--and t4.numtienda is not null
			and t1.sucursal=@sucursal
	end

GO

