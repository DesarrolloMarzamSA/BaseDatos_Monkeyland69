
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


CREATE	--	CREATE
PROCEDURE [dbo].[usp_feltrebol_fe]
--@sucursal INT,
@fecha VARCHAR(10)


/*
EXECUTE usp_feltrebol_fe '2011-08-31'

DECLARE @fecha VARCHAR(10)
SET @fecha = '2011-08-07'
*/

WITH ENCRYPTION
AS


SELECT	--	TOP 1000
	LEFT( suc.serie_cfd + CONVERT(VARCHAR, CONVERT(INT, fes.folio_fiscal))	+	REPLICATE(' ',12)	, 12)		folio_fiscal			,
	LEFT( CONVERT(VARCHAR, fes.cliente) + REPLICATE(' ',12) 																		, 12)		suc								,
	LEFT( CONVERT(VARCHAR, fes.fecha_factura, 112)																							,  8)		fecha_factura			,
	LEFT( fes.cod_barras + REPLICATE(' ',13) 																										, 13)		codigo_ean				,
	RIGHT( REPLICATE(' ', 7) + CONVERT(VARCHAR, fes.piezas_surtidas_con_cargo)  								,  7)		pzas_c_cargo			,
	RIGHT( REPLICATE(' ', 7) + CONVERT(VARCHAR, fes.piezas_surtidas_sin_cargo)									,  7)		pzas_s_cargo			,

--	LEFT( fes.descripcion , 30)																								descripcion			,

	RIGHT( REPLICATE(' ', 9) + CONVERT(VARCHAR, fes.precio_farm_sin_imp	)												,  9)		prec_farm					,
	RIGHT( REPLICATE(' ', 6) + CONVERT(VARCHAR, fes.descto_oferta				)												,  6)		descto_oferta			,
--	RIGHT( REPLICATE(' ', 6) + CONVERT(VARCHAR, fes.descto_comercial		)												,  6)		descto_comercial	,
	RIGHT( REPLICATE(' ', 6) + CONVERT(VARCHAR, fes.porcentaje_descto_comercial		)							,  6)		descto_comercial	,
	RIGHT( REPLICATE(' ', 9) + CONVERT(VARCHAR, fes.porcentaje_iva			) 											,  9)		tasa_iva					


	--RIGHT( REPLICATE(' ', 6) + CONVERT(VARCHAR, 
	--CASE  WHEN clas_fis IN ('B','BA') THEN 18
	--			WHEN clas_fis IN ('N','NA') THEN 0
	--			WHEN clas_fis IN ('H','HA') THEN mpb.descto_prod END)		,  6)		porc_financiero	,
	--RIGHT( REPLICATE(' ', 9) + CONVERT(VARCHAR, mpb.prec_pub	)		,  9)		prec_pub				

FROM facturacion_electronica_estandar fes	WITH (NOLOCK)
INNER JOIN sucursales suc	WITH (NOLOCK)	ON suc.sucursal = fes.sucursal
--INNER JOIN maestro_productos_baan mpb ON mpb.codigo = ofe.codigo
WHERE
	fes.fecha_tandem = CONVERT(SMALLDATETIME, @fecha , 121) 
	AND fes.sucursal = 1 AND fes.cliente = '90400'

	--AND fes.sucursal = 7 AND fes.segto = 'C1' AND fes.ctepadre = '319'--------
ORDER BY fes.folio_fiscal, fes.no_registro
GO
