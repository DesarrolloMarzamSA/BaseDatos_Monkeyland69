USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
/*
usp_pharmacy_anzures_catalogo 1, '43372'
*/


CREATE 
--	CREATE
PROCEDURE [dbo].[usp_pharmacy_anzures_catalogo] 


--DECLARE
@sucursal INT, @cliente VARCHAR(5)

WITH ENCRYPTION
AS
--	SET @sucursal = 1
--	SET @cliente = '43372'

DECLARE @descto_financiero MONEY
SET @descto_financiero = 
	(SELECT cb.descuento FROM clientes_baan cb 
	WHERE cb.sucursal = @sucursal AND cb.cliente = @cliente)

SELECT 
	cod_barras,
	LEFT( descripcion + REPLICATE(' ',30) ,30 )													descripcion	,
	RIGHT( REPLICATE('0',9) + CONVERT(VARCHAR,	
		CASE mpb.grupo_est 
			WHEN 'PC01A' THEN CONVERT(MONEY,mpb.prec_farm * 1.5)
			ELSE mpb.prec_farm  END 		), 9 )															prec_farm		,
	RIGHT( REPLICATE('0',9) + CONVERT(VARCHAR,	
		CONVERT(MONEY,
    CASE
			WHEN mpb.clas_fis = 'B'		THEN @descto_financiero
			WHEN mpb.clas_fis = 'BA'	THEN @descto_financiero
			WHEN mpb.clas_fis = 'N'		THEN 0
			WHEN mpb.clas_fis = 'NA'	THEN 0
			WHEN mpb.clas_fis = 'H'		THEN mpb.descto_prod
			WHEN mpb.clas_fis = 'HA'	THEN mpb.descto_prod END))
			, 9 )	descto
FROM maestro_productos_baan mpb
INNER JOIN inventario_baan ib ON ib.sucursal = @sucursal AND ib.codigo = mpb.codigo
WHERE LEFT(mpb.status ,1) <> 'B'
	AND CONVERT(INT, mpb.codigo ) < dbo.gobierno()
--	AND grupo_est = 'PC01A'
ORDER BY mpb.grupo_est 

--mpb.codigo
GO
