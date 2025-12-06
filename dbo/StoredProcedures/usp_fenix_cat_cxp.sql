
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



CREATE--	CREATE
PROCEDURE [dbo].[usp_fenix_cat_cxp]

AS

SELECT 
	mp.codigo																																					codigo				,
	RIGHT(REPLICATE('0', 13) + mp.cod_barras																		, 13)	cod_barras		,
	LEFT (mp.descripcion	+ REPLICATE(' ', 30) ,30)																		descripcion		,
	RIGHT(REPLICATE('0', 10) + CONVERT(VARCHAR,mp.prec_farm )			, 10)	prec_farm											/*,
	mp.clas_fis												,
	mp.iva														,
	mp.status*/
FROM maestro_productos_baan		mp		WITH (NOLOCK)
INNER JOIN inventario_baan		ib			WITH (NOLOCK)	ON	ib.sucursal = 4	and ib.codigo = mp.codigo	AND ib.piezas > 0
WHERE mp.codigo < dbo.gobierno()
AND LEFT(mp.status ,1) != 'B'
ORDER BY mp.codigo

/*
SELECT 
	mp.lab_largo											,
	mp.codigo													,
	mp.descripcion										,
	mp.clas_fis												,
	0	lim															,
	mp.status													,
	mp.cod_barras											,
	--mp.descto													,
	--REPLICATE(' ', 10)	
	'¿COMO SE OBTIENE?'	aplica_descto	,
	mp.prec_farm											,
	mp.prec_pub												,
	mp.clas_ssa												
	
	
FROM maestro_productos_baan mp
INNER JOIN catalogo_autoservicios ca ON 
	ca.codigo = mp.codigo AND 
--	ca.sucursal = 1 AND ca.segto = 'C1' AND ca.ctepadre = '010'
*/

/*
SELECT  * FROM 	
	catalogo_autoservicios ca
where 
	ca.sucursal = 7 AND ca.segto = 'C1' AND ca.ctepadre = '319'*/
--WHERE mp.codigo < dbo.gobierno()
GO
