

CREATE
--  CREATE 
PROCEDURE	[dbo].[usp_genera_ofertas_fhidalgo_culiacan] AS

DECLARE @porcentaje DECIMAL
SET @porcentaje = 18

SELECT 
	REPLICATE(' ',1) filler1,
	dbo.cant_base,
	mpb.descripcion,
	REPLICATE(' ',1) filler2,
	@porcentaje descto_financiero,
	REPLICATE(' ',1) filler3,
	dbo.porcentaje,
	REPLICATE(' ',1) filler4,
	mpb.cod_barras,
	0 limite,
	REPLICATE(' ',2) filler5,
	mpb.prec_farm,
	REPLICATE(' ',1) filler6,
	dbo.cant_oferta,
	dbo.sucursal
INTO #ofe_fhidalgo
FROM dboferta dbo
INNER JOIN inventario_baan ib						ON ib.codigo = dbo.codigo AND ib.sucursal = dbo.sucursal
INNER JOIN maestro_productos_baan mpb		ON mpb.codigo = dbo.codigo 
WHERE CONVERT(int,dbo.codigo) < dbo.gobierno() AND dbo.sucursal = 17
AND bolsa = 'D1813'


SELECT
	filler1 + 
	RIGHT( REPLICATE(' ', 7) + CONVERT(VARCHAR,cant_base)					, 7) + 
	LEFT(	descripcion + REPLICATE(' ',30)													,30) +
	filler2 +
	RIGHT( REPLICATE(' ', 6) + CONVERT(VARCHAR,descto_financiero)	, 6) + 
	filler3 +
	RIGHT( REPLICATE(' ', 6) + CONVERT(VARCHAR,porcentaje)				, 6) + 
	filler4 +
	cod_barras +
	RIGHT( REPLICATE(' ', 7) + CONVERT(VARCHAR,limite)						, 7) + 
	filler5 +
	RIGHT( REPLICATE(' ', 9) + CONVERT(VARCHAR,prec_farm)					, 9) + 
	filler6 +
	RIGHT( REPLICATE(' ', 7) + CONVERT(VARCHAR,cant_oferta)				, 7) + 
	LEFT( CONVERT(VARCHAR,sucursal) + REPLICATE(' ',12)						,12)

FROM #ofe_fhidalgo

DROP TABLE #ofe_fhidalgo

GO

