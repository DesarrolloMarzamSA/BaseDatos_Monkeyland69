
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


CREATE	--	CREATE	--	DROP
PROCEDURE [dbo].[usp_fmorelost_fe]
--@sucursal INT,
@fecha VARCHAR(10)


AS

/*
EXECUTE usp_fmorelost_fe '2011-11-22'

DECLARE @fecha VARCHAR(10)
SET @fecha = '2011-08-07'
*/



SELECT	--	TOP 1000
	LEFT( suc.serie_cfd + CONVERT(VARCHAR, CONVERT(INT, fes.folio_fiscal))	+	REPLICATE(' ',12)	, 12)		folio_fiscal			,
	LEFT( CONVERT(VARCHAR, fes.sucursal) + CONVERT(VARCHAR, fes.cliente) + REPLICATE(' ',12) , 12)		suc								,
--	LEFT( CONVERT(VARCHAR, fes.fecha_factura, 112)																							,  8)		fecha_factura			,
	LEFT( CONVERT(VARCHAR, fes.fecha_tandem, 112)																							,  8)		fecha_factura			,
	LEFT( fes.cod_barras + REPLICATE(' ',13) 																										, 13)		codigo_ean				,
	RIGHT( REPLICATE(' ', 7) + CONVERT(VARCHAR, fes.piezas_surtidas_con_cargo)  								,  7)		pzas_c_cargo			,
	RIGHT( REPLICATE(' ', 7) + CONVERT(VARCHAR, fes.piezas_surtidas_sin_cargo)									,  7)		pzas_s_cargo			,
	RIGHT( REPLICATE(' ', 9) + CONVERT(VARCHAR, fes.precio_farm_sin_imp	)												,  9)		prec_farm					,
	RIGHT( REPLICATE(' ', 6) + CONVERT(VARCHAR, fes.descto_oferta				)												,  6)		descto_oferta			,
	RIGHT( REPLICATE(' ', 6) + CONVERT(VARCHAR, fes.descto_comercial		)												,  6)		descto_comercial	,
	RIGHT( REPLICATE(' ', 9) + CONVERT(VARCHAR, fes.porcentaje_iva			) 											,  9)		tasa_iva					

FROM facturacion_electronica_estandar fes	WITH (NOLOCK)
INNER JOIN sucursales suc	WITH (NOLOCK)	ON suc.sucursal = fes.sucursal
INNER JOIN cat_cuentas_fmorelost mos	WITH (NOLOCK)	ON 
	mos.sucursal = fes.sucursal AND mos.cliente = fes.cliente
WHERE
	fes.fecha_tandem = CONVERT(SMALLDATETIME, @fecha , 121) 
	AND fes.sucursal = 4 
--	AND fes.cliente IN ('87409', '87410', '87476')
ORDER BY fes.folio_fiscal, fes.no_registro
GO
