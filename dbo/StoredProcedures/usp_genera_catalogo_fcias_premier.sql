USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_genera_catalogo_fcias_premier]
	@sucursal INT
WITH ENCRYPTION
AS
DECLARE @descuento VARCHAR(6)

--DECLARE @sucursal TINYINT
--DECLARE @descuento VARCHAR(6)
--SET @sucursal = 1

SELECT	@descuento = RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), descuento), 6) 
FROM	clientes_baan 
WHERE	sucursal = 1 AND 
		cliente = '66060'

SELECT 	LEFT(CONVERT(VARCHAR(13), CONVERT(BIGINT, t1.cod_barras)) + REPLICATE(' ', 13), 13) +
		LEFT(t1.descripcion + REPLICATE(' ', 30), 30) + 
		CASE t1.grupo_est 
			WHEN 'PC01A' THEN RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), ROUND(t1.prec_farm, 2, 2) + (ROUND(t1.prec_farm, 2, 2) * 0.5)), 9)
			ELSE RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), ROUND(t1.prec_farm, 2, 2)), 9) 
		END +
		CASE
			WHEN clas_fis = 'N' THEN '  0.00'
			WHEN clas_fis = 'NA' THEN '  0.00'
			WHEN clas_fis = 'B' THEN @descuento
			WHEN clas_fis = 'BA' THEN @descuento
			WHEN clas_fis = 'H' THEN RIGHT( REPLICATE(' ', 6) + CONVERT(VARCHAR(6), t1.descto_prod), 6)
			WHEN clas_fis = 'HA' THEN RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), t1.descto_prod), 6)
		END
FROM	maestro_productos_baan t1 INNER JOIN inventario_baan t2 ON
		t1.codigo = t2.codigo
WHERE 	t2.sucursal = @sucursal AND
		CONVERT(INT, t1.codigo) < dbo.gobierno() AND
		ISNUMERIC(t1.cod_barras) = 1 AND
		SUBSTRING(t1.status, 1,1) <> 'B' 
GO
