

CREATE	--	CREATE	--	DROP
PROCEDURE [dbo].[usp_fardemex_ofertas]

AS
/*
EXECUTE usp_fardemex_ofertas
*/


DECLARE @descto_cte MONEY
SET @descto_cte = (SELECT descuento FROM clientes_baan WHERE sucursal = 4 AND cliente = '87872')

SELECT
	'0'																																										zona								,
	LEFT(CONVERT(VARCHAR, CONVERT(BIGINT, mpb.cod_barras)) + REPLICATE(' ', 13)    , 13)	cod_barras					,
	LEFT(mpb.descripcion                + REPLICATE(' ', 35)   			  			, 35)					descripcion					,
	RIGHT(REPLICATE(' ',  9) + CONVERT(VARCHAR, mpb.prec_farm  			 )			,  9)					prec_farm						,
	RIGHT(REPLICATE(' ',  6) + CONVERT(VARCHAR, ofe.porcentaje *100	)				,  6)					cant_base						,
	RIGHT(REPLICATE(' ',  7) + CONVERT(VARCHAR, ofe.cant_base		)						,  7)					pzas_con_cargo			,
	RIGHT(REPLICATE(' ',  7) + CONVERT(VARCHAR, ofe.cant_oferta	)						,  7)					pzas_sin_cargo			,
	RIGHT(REPLICATE(' ',  7) + CONVERT(VARCHAR, 0								)						,  7)					lim_pzas_sin_cargo	,
	RIGHT(REPLICATE(' ',  6) + CONVERT(VARCHAR, 
		dbo.udf_calc_descto_prod( mpb.clas_fis, @descto_cte	, descto_prod	)	)	,  6)					descto
	--,bolsa	
FROM maestro_productos_baan mpb 
INNER JOIN dboferta ofe ON 
	ofe.codigo = mpb.codigo and bolsa='LIBRE' and ofe.sucursal=21
WHERE
	mpb.codigo < dbo.gobierno() AND
	LEFT(mpb.status ,1 ) <> 'B'

GO

