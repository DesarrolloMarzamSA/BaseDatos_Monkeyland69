/*
usp_pharmacy_anzures_cambios
*/
CREATE 
	--	CREATE
PROCEDURE usp_pharmacy_anzures_cambios
(@suc INT)
AS

SELECT
	LEFT(mpb.cod_barras			+ REPLICATE(' ',13), 13)																						codbarras,
	LEFT(mpb.descripcion		+ REPLICATE(' ',30), 30)																						descripcion,
	RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR, CONVERT(MONEY,
		CASE WHEN mpb.grupo_est = 'PC01A' THEN mpb.prec_pub		* 1.5	ELSE mpb.prec_pub		END)) , 9)	prec_pub, 
	RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR, CONVERT(MONEY,
		CASE WHEN mpb.grupo_est = 'PC01A' THEN mpb.prec_farm	* 1.5	ELSE mpb.prec_farm	END)) , 9)	prec_farm 
FROM cambios_precio_baan cpb 
INNER JOIN maestro_productos_baan mpb ON cpb.t_item = mpb.codigo
WHERE	DATEDIFF(d, cpb.fecha_hora, CURRENT_TIMESTAMP) < 5
	AND	ISNUMERIC(mpb.cod_barras) = 1 
	AND	CONVERT(INT, mpb.codigo) < dbo.gobierno() 
	AND	mpb.status not like 'B%'

GO

