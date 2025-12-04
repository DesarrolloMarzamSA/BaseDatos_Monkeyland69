USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_genera_catalogo_fcias_leyva_20] 
	@sucursal TINYINT
WITH ENCRYPTION
AS

DECLARE @descuento VARCHAR(6)
	
--DECLARE @sucursal TINYINT
--DECLARE @descuento VARCHAR(6)
--SET @sucursal = 1

SELECT	@descuento = RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), descuento), 6)   
FROM	clientes_baan   
WHERE	sucursal = @sucursal AND   
		cliente = '08590'  

SELECT	LEFT(CONVERT(VARCHAR(15), t1.cod_barras) + REPLICATE(' ', 15), 15) + 
		LEFT(t1.descripcion + REPLICATE(' ', 30), 30) + 
		CASE t1.grupo_est 
			WHEN 'PC01A' THEN RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), t1.prec_pub + (t1.prec_pub * 0.5)), 9)
			ELSE RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), t1.prec_pub), 9) 
		END +
		CASE t1.grupo_est 
			WHEN 'PC01A' THEN RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), t1.prec_farm + (t1.prec_farm * 0.5)), 9)
			ELSE RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), ROUND(t1.prec_farm, 2, 2)), 9) 
		END +
		CASE 
			WHEN t1.clas_fis = 'B' THEN RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(9), @descuento), 6)
			WHEN t1.clas_fis = 'BA' THEN RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(9), @descuento), 6)
			WHEN t1.clas_fis = 'N' THEN '  0.00' 
			WHEN t1.clas_fis = 'NA' THEN '  0.00' 
			WHEN t1.clas_fis = 'H' THEN RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(9), t1.descto_prod), 6) 
			WHEN t1.clas_fis = 'HA' THEN RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(9), t1.descto_prod), 6) 
		END +
		RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), CONVERT(INT, (t1.iva * 100))), 9) +  
		LEFT(CONVERT(VARCHAR(30), t1.lab_largo) + REPLICATE(' ', 30), 30) +
		CASE
			WHEN t2.piezas = 0 THEN '0'
			WHEN t2.piezas > 0 AND t2.piezas <= 50 THEN '1'
			WHEN t2.piezas > 50 THEN '1'
		END	+
		REPLICATE(' ', 1) +  
		REPLICATE(' ', 1) +  
		REPLICATE(' ', 30) +  
		REPLICATE(' ', 15) +  
		REPLICATE(' ', 4) +  
		REPLICATE(' ', 15)  
FROM	maestro_productos_baan t1 INNER JOIN inventario_baan t2 ON 
		t1.codigo = t2.codigo AND 
		t2.sucursal = @sucursal
WHERE	CONVERT(INT, t1.codigo) < dbo.gobierno() AND
		ISNUMERIC(t1.cod_barras_tandem) = 1 AND
		SUBSTRING(t1.status, 1,1) <> 'B' 
ORDER BY 
		t1.descripcion
GO
