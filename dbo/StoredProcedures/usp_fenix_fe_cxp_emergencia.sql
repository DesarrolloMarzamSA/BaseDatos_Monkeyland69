
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
/*
exec usp_fenix_fe_cxp_emergencia '2012-06-07'
*/
CREATE --CREATE	--	DROP
PROCEDURE [dbo].[usp_fenix_fe_cxp_emergencia] 
@fecha VARCHAR(10)	--	fecha de solicitud

AS


DECLARE @total_del_registro INT
SELECT @total_del_registro = COUNT(*) 
FROM historica.dbo.fes_samayoa fe with(nolock) 
--FROM historica.dbo.fes fe with(nolock) 

INNER JOIN fenix_solicitadas x		 with(nolock)		ON x.solicitud = @fecha 
	AND x.sucursal = fe.sucursal AND x.folio_fiscal = fe.folio_fiscal
	--AND x.fechaprog <= '2011-12-31'

INNER JOIN sucursales su			 with(nolock) 				on su.sucursal = fe.sucursal
LEFT OUTER JOIN maestro_productos_baan mp with(nolock) 	on mp.codigo = fe.codigo 
--	INNER JOIN maestro_productos mp with(nolock) 	on mp.codigo = fe.codigo 
LEFT OUTER JOIN CatTiendasFenix ct			 with(nolock) 		on ct.sucursal = fe.sucursal and ct.cliente = fe.cliente
--WHERE
----	fe.fecha_factura = CONVERT(datetime, @fecha, 121)  and
--	fe.segto = 'C1'			and 
--	fe.ctepadre = '010'
	--	A PETICION DEL CLIENTE, SE ENVIA LA FACTURACION DESFAZADA UN DIA

SELECT	
	--x.orden,
	--x.fechaprog,
	--x.serie_cfd + x.folio_fiscal ,
	'C' 																																																															col1							,	--	1
	'00500'																																																														proveedor					,	--	2
	CONVERT(VARCHAR(8), fe.fecha_factura, 112)																																												fecha_disco				,	--	3
	RIGHT(REPLICATE('0', 6) + CONVERT(VARCHAR, @total_del_registro), 6)																																tot_regs					,	--	4
	REPLICATE(' ', 90)																																																								filler90					,	--	5
	'C:'																																																															c_fijo						,	--	6
	RIGHT(REPLICATE('0', 9) + ct.numtienda,9)																																													mostrador					,	--	7
	REPLICATE(' ', 99)																																																								filler99					,	--	8
	'F'																																																																f_fijo						,	--	9
	--	LEFT(su.serie_cfd_old + fe.folio_fiscal+ REPLICATE(' ', 10),10)	factura,
	/*
	LEFT(su.serie_cfd_old + 
		CASE WHEN su.sistema = 'IBS' THEN fe.folio_fiscal ELSE CONVERT(VARCHAR,CONVERT(BIGINT,fe.folio_fiscal)) END  + REPLICATE(' ', 10),	10)		factura						,	-- 10
		*/
	LEFT((CASE WHEN fe.fecha_factura < su.fecha_ibs THEN su.serie_cfd_old ELSE su.serie_cfd END) + 
		(CASE WHEN fe.fecha_factura > CONVERT(SMALLDATETIME,'2011-05-31',121) OR fe.fecha_factura < su.fecha_ibs THEN CONVERT(VARCHAR,CONVERT(BIGINT,fe.folio_fiscal))	ELSE	fe.folio_fiscal  END) + REPLICATE(' ', 10),	10)					factura,
	'000'																																																															no_fact_t					,	-- 11
	'005'																																																															no_fact_d					,	-- 12
	CONVERT(VARCHAR(8), fe.fecha_factura, 112)																																												fecha_entrega			,	-- 13
	RIGHT(REPLICATE('0', 12) + CONVERT(VARCHAR, CONVERT(BIGINT, fe.importe_neto * 100))												, 12)										importe_a_pagar		,	-- 14	
	RIGHT(REPLICATE('0', 12) + CONVERT(VARCHAR, CONVERT(BIGINT, fe.descto_comercial * 100))										, 12)										descto_comercial	,	-- 15
	RIGHT(REPLICATE('0', 12) + CONVERT(VARCHAR, CONVERT(BIGINT, (fe.importe_bruto - fe.descto_oferta) * 100))	, 12)										importe_bruto			,	-- 16
	RIGHT(REPLICATE('0', 12) + CONVERT(VARCHAR, CONVERT(BIGINT, 100 * fe.iva))																, 12)										importe_iva				,	-- 17
	--RIGHT(REPLICATE('0', 12) + CONVERT(VARCHAR, CASE mp.grupo_est WHEN 'PC01A' THEN CONVERT(BIGINT, 100 * (fe.importe_bruto * 0.5)) else 0 end), 12)	ieps
	RIGHT(REPLICATE('0', 12) + CONVERT(VARCHAR, CONVERT(BIGINT, 100 * CASE mp.grupo_est WHEN 'PC01A' THEN (fe.importe_bruto * 0.5) else 0 end)) , 12)	importe_ieps,	-- 18
	RIGHT(REPLICATE('0',  6) + CONVERT(VARCHAR, fe.piezas_surtidas_con_cargo + fe.piezas_surtidas_sin_cargo), 6)											piezas						,	--	19
	REPLICATE(' ', 18)																																																								filler18					,	--	20
	'A'																																																																a_fija						,	--	21
	RIGHT(REPLICATE('0', 11) + CONVERT(VARCHAR, CONVERT(BIGINT,	100 * CASE fe.porcentaje_iva WHEN 0 THEN (fe.importe_bruto - fe.descto_oferta) else 0 end)), 11) venta_tasa_0	,	--22
	RIGHT(REPLICATE('0', 11) + CONVERT(VARCHAR, CONVERT(BIGINT,	100 * CASE fe.porcentaje_iva WHEN 0 THEN fe.desc_comerc_prod else 0 end)), 11)  descto_tasa_0,	--	23
	RIGHT(REPLICATE('0', 11) + CONVERT(VARCHAR,CONVERT(BIGINT, 100 * (CASE WHEN fe.porcentaje_iva = su.porcentaje_iva THEN fe.importe_bruto - fe.descto_oferta ELSE 0 END) ) ), 11)		venta_tasa_10	,	--	24
	RIGHT(REPLICATE('0', 11) + CONVERT(VARCHAR,CONVERT(BIGINT, 100 * (CASE WHEN fe.porcentaje_iva = su.porcentaje_iva THEN fe.iva															 ELSE 0 END) ) ), 11)		iva_tasa_10	,	--	25
	RIGHT(REPLICATE('0', 11) + '0'		,11 ) 																																													descto_vta_10							,	--	26
	RIGHT(REPLICATE('0', 11) + '0'		,11 ) 																																													iva_descto_vta						,	--	27
	RIGHT(REPLICATE('0', 12) + '0'		,12 ) 																																													iva_global								,	--	28
	RIGHT(REPLICATE('0', 12) + '0'		,12 ) 																																													iva_descto_global					,	--	29
	RIGHT(REPLICATE('0',  4) + '1'		, 4 ) 																																													bolsas										,	--	30
	RIGHT(REPLICATE('0',  5) + '0'		, 5 ) 																																													bolsas										,	--	30
	REPLICATE(' ', 11)																																																								filler11									,	--	32
	'P'																																																																p_fija										,	--	33
	RIGHT(REPLICATE('0',  8) + fe.codigo	, 8 )																																												codigo										,	--	34
	RIGHT(REPLICATE('0',  6) + CONVERT(VARCHAR, fe.piezas_surtidas_con_cargo)																										, 6)	piezas_surtidas_con_cargo	,	--	35
	RIGHT(REPLICATE('0',  6) + CONVERT(VARCHAR, fe.piezas_surtidas_sin_cargo)																										, 6)	piezas_surtidas_sin_cargo	,	--	36
	RIGHT(REPLICATE('0',  5) + '0'		, 5 )																																														descto_adicional					,	--	37
	RIGHT(REPLICATE('0',  8) + CONVERT(VARCHAR, CONVERT(BIGINT, 100 * fe.precio_farm_sin_imp))																	, 8)	precio_farm_sin_imp				,	--	38
	RIGHT(REPLICATE('0',  8) + CONVERT(VARCHAR, CONVERT(BIGINT, 100 * fe.precio_pub_sin_imp))																		, 8)	precio_pub_sin_imp				,	--	39
	RIGHT(REPLICATE('0',  8) + CONVERT(VARCHAR, CONVERT(BIGINT, 100 * fe.precio_farm_sin_imp * fe.piezas_surtidas_con_cargo))		, 8)	total_renglon							,	--	40
	RIGHT(REPLICATE('0',  8) + CONVERT(VARCHAR, CONVERT(BIGINT, 100 * fe.precio_pub_sin_imp * fe.piezas_surtidas_con_cargo))		, 8)	venta_renglon							,	--	41
	RIGHT(REPLICATE('0',  8) + CONVERT(VARCHAR, CONVERT(BIGINT, 100 * fe.iva * fe.piezas_surtidas_con_cargo))										, 8)	iva_renglon								,	--	42
	RIGHT(REPLICATE('0',  8) + CONVERT(VARCHAR, CONVERT(BIGINT, 100 * precio_farm_sin_imp * 0.50))															, 8)	ieps_renglon							,	--	43
	REPLICATE(' ', 14)																																																								filler14									,	--	44
	'1'																																																																areaa											,	--	45
	RIGHT(REPLICATE('0', 14) + fe.cod_barras	, 14)																																										cod_barras								,	--	46
	RIGHT(REPLICATE('0',  4) + CONVERT(VARCHAR, CONVERT(INT, porcentaje_utilidad * 100)), 4)																					margen_utilitario					,	--	47
	RIGHT(REPLICATE(' ',  1) + ' '																											, 1)																					clas_fis									,	--	48
	RIGHT(REPLICATE(' ',  1) + ' '																											, 1)																					referencias								,	--	49
	RIGHT(REPLICATE(' ',  1) + CASE LEFT(mp.clas_fis, 1) WHEN 'N' THEN '*' ELSE ' ' END	, 1)																					vta_neta									,	--	50
	RIGHT(REPLICATE(' ',  2) + CONVERT(VARCHAR, isnull(ct.compania, 0)), 2)																														compania									,	--	51
	RIGHT(REPLICATE('0',  8) + ct.numtienda,8)																																												mostrador									,	--	52
	'0500'																																																														idprov											--	53
FROM fenix_solicitadas x		 with(nolock)	 
INNER JOIN sucursales su			 with(nolock) 				ON su.sucursal = x.sucursal
INNER JOIN facturacion_electronica_estandar fe  with(nolock) ON
--LEFT OUTER JOIN	historica.dbo.fes_samayoa fe  with(nolock) 			ON 
	fe.sucursal = x.sucursal AND fe.folio_fiscal = x.folio_fiscal
	--AND x.fechaprog =	@fecha --	'2011-12-31'

LEFT OUTER JOIN maestro_productos_baan mp	 with(nolock) ON mp.codigo = fe.codigo 
--	INNER JOIN maestro_productos mp	 with(nolock) ON mp.codigo = fe.codigo 
LEFT OUTER JOIN CatTiendasFenix ct		 with(nolock) 			ON ct.sucursal = fe.sucursal and ct.cliente = fe.cliente

WHERE
	x.solicitud = @fecha 
--	fe.fecha_factura = CONVERT(datetime, @fecha, 121)					--			AND
--	fe.segto = 'C1'									AND 
--	fe.ctepadre = '010'
	--	A PETICION DEL CLIENTE, SE ENVIA LA FACTURACION DESFAZADA UN DIA

ORDER by 
		x.orden

--fe.fecha_factura--, fe.sucursal, fe.folio_fiscal

GO
