USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
/*
usp_pharmacy_anzures_fact_elect 1, '2010-05-07'
*/

CREATE
--	CREATE
PROCEDURE [dbo].[usp_pharmacy_anzures_fact_elect]
--	DECLARE 
@sucursal INT, @fecha VARCHAR(10)

WITH ENCRYPTION
AS

/*
SET @sucursal = 1
SET @fecha = '2010-05-20'
*/

DECLARE @rfc VARCHAR(20)
SET @rfc = 'GPA041118FK6'

SELECT 
	RIGHT(REPLICATE(' ',12) + CONVERT(VARCHAR,folio_fiscal)							,12)		factura				,
	RIGHT(REPLICATE(' ',12) + CONVERT(VARCHAR,cliente)									,12)		suc						,
	RIGHT(REPLICATE(' ', 8) + CONVERT(VARCHAR(10),fecha_factura,112)		, 8)		fecha					,
	LEFT (cod_barras + REPLICATE(' ',13)																,13)		ean						,
	RIGHT(REPLICATE(' ', 7) + CONVERT(VARCHAR,piezas_surtidas_con_cargo), 7)		pzas_cargo		,
	RIGHT(REPLICATE(' ', 7) + CONVERT(VARCHAR,piezas_surtidas_sin_cargo), 7)		pzas_gratis		,
	RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR,precio_farm_sin_imp)			, 9)		prec_farm_siva,
	RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR,f.porcentaje_iva)					, 9)		tasa_iva			,
	RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR,f.descto_oferta)					, 6)		descto_ofe		,
	RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR,f.descto_comercial)				, 6)		descto_fin		
FROM facturacion_electronica_estandar f
WHERE sucursal = @sucursal
AND fecha_factura = CONVERT(DATETIME,@fecha,121)
AND rfc = @rfc


GO
