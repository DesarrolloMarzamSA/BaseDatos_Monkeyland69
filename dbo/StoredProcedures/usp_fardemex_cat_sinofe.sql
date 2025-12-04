
CREATE	--	CREATE	--	DROP
PROCEDURE [dbo].[usp_fardemex_cat_sinofe]

/*
EXECUTE usp_fardemex_cat_sinofe
*/

AS

DECLARE @descto_cte MONEY
SET @descto_cte = (SELECT descuento FROM clientes_baan WHERE sucursal = 4 AND cliente = '87872')

SELECT
	LEFT( mpb.cod_barras  + REPLICATE(' ', 13)    , 13)									cod_barras	,
	LEFT( mpb.descripcion + REPLICATE(' ', 35)    , 35)									descripcion	,
	RIGHT(REPLICATE(' ', 09) + CONVERT(VARCHAR,mpb.prec_farm   ) , 09)	prec_farm		,
	RIGHT(REPLICATE(' ', 06) + CONVERT(VARCHAR,
		dbo.udf_calc_descto_prod( mpb.clas_fis, @descto_cte	, descto_prod	 )   )  , 06)	descto
	--, status, clas_fis, clas_ssa
	--,mpb.codigo, ofe.bolsa
	
FROM maestro_productos_baan mpb
LEFT OUTER JOIN dboferta ofe ON 
	ofe.codigo = mpb.codigo and bolsa='LIBRE' and ofe.sucursal=21
WHERE 
	mpb.codigo < dbo.gobierno() AND
	LEFT(mpb.status ,1 ) <> 'B'
	AND ofe.bolsa IS NULL

GO

