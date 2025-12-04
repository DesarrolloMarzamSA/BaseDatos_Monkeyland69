
CREATE	--	CREATE	--	DROP
PROCEDURE usp_chedraui_catalogo_maestro_2010
AS

--	SELECT TOP 500 * FROM clientes_baan WHERE FARMACIA like '%ched%' ORDER BY fecha_alta

/*
EXECUTE usp_chedraui_catalogo_maestro_2010
*/

DECLARE @descto_cliente MONEY

SET @descto_cliente = (SELECT descuento FROM clientes_baan WHERE sucursal = 1 AND cliente = '99015')

SELECT
	--mp.codigo,	mp.clas_fis, mp.clas_ssa,
	LEFT(CONVERT(VARCHAR,ib.sucursal) + REPLICATE(' ', 12), 12)									AS sucursal			,
	LEFT(mp.cod_barras + REPLICATE(' ', 13)								,13)									AS ean					,
	--LEFT(mp.cod_prodcli + REPLICATE(' ', 13)								,13)	AS cod_chedruai					,
	LEFT(mp.descripcion + REPLICATE(' ', 30)							,30)									AS descripcion	,
	
	RIGHT(REPLICATE(' ', 09) + CONVERT(VARCHAR,
		CONVERT(DECIMAL(12,4),mp.prec_farm) )								,09)									AS prec_farm		,
	
	RIGHT(REPLICATE(' ', 06) + ISNULL(CONVERT(VARCHAR,ofe.porcentaje), 0)	,06)	AS oferta				,

	REPLICATE(' ', 09) 	AS prod_con_cargo,
	REPLICATE(' ', 09) 	AS prod_sin_cargo,
	REPLICATE(' ', 04) 	AS lim_prod_sin_cargo,																												
	
	RIGHT(REPLICATE('0', 05) + CONVERT(VARCHAR,										/*CONVERT(DECIMAL(12,4),*/
		dbo.udf_calc_descto_prod(clas_fis, @descto_cliente,	mp.descto_prod) )					
																												,05)									AS descto_financiero,
	REPLICATE(' ', 04)																													AS filler,																												
	RIGHT(REPLICATE(' ', 06) +CONVERT(VARCHAR,0)	,06)									AS exist_zona

--FROM maestro_productos_baan AS mp WITH (NOLOCK)
FROM vi_catalogo_chedraui AS mp WITH (NOLOCK)
INNER JOIN inventario_baan AS ib WITH (NOLOCK) ON 
	ib.sucursal = mp.sucursal AND 
	ib.codigo = mp.codigo 
	--AND ib.piezas > 0
	
LEFT OUTER JOIN dboferta AS ofe ON 
	ofe.sucursal = ib.sucursal AND 
	ofe.codigo = mp.codigo 
	AND bolsa = 'LIBRE'

WHERE CONVERT(INT,mp.codigo) < dbo.gobierno()

ORDER BY mp.prec_farm
--mp.codigo, mp.sucursal

GO

