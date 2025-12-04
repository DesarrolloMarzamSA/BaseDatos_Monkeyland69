USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_genera_catalogo_fcias_farmatodo]
	@sucursal TINYINT,
	@tipo int=0
WITH ENCRYPTION
AS	

--DECLARE @sucursal TINYINT
--DECLARE @descuento varchar(6)
--SET @sucursal = 1

if @tipo=0
	begin
		SELECT	RIGHT(REPLICATE('0', 2) + CONVERT(VARCHAR, @sucursal), 2) +
				REPLICATE('  ', 5) +
				LEFT(CONVERT(VARCHAR(13), CONVERT(BIGINT, t1.cod_barras)) + '             ', 13) + 
				LEFT(t1.descripcion + REPLICATE(' ', 30), 30) + 
				CASE t1.grupo_est 
					WHEN 'PC01A' THEN RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR, CONVERT(MONEY, ROUND(t1.prec_farm, 2, 2) + (ROUND(t1.prec_farm, 2, 2) * 0.5))), 9)
					ELSE RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR, CONVERT(MONEY, ROUND(t1.prec_farm, 2, 2))), 9)
					END +
				CASE 
					WHEN t1.clas_fis = 'B' THEN '100.00'
					WHEN t1.clas_fis = 'BA' THEN '100.00'
					WHEN t1.clas_fis = 'N' THEN '  0.00'
					WHEN t1.clas_fis = 'NA' THEN '  0.00' 
					WHEN t1.clas_fis = 'H' THEN RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR, CONVERT(MONEY, t1.descto_prod)), 6)
					WHEN t1.clas_fis = 'HA' THEN RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR, CONVERT(MONEY, t1.descto_prod)), 6)
				END--+RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR, CONVERT(MONEY, ROUND(t1.prec_pub, 2, 2))), 9)
		FROM	maestro_productos_baan t1 INNER JOIN inventario_baan t2 ON 
				t1.codigo = t2.codigo AND 
				t2.sucursal = @sucursal
		WHERE	CONVERT(INT, t1.codigo) < dbo.gobierno() AND
				ISNUMERIC(t1.cod_barras) = 1 AND
				SUBSTRING(t1.status, 1,1) <> 'B' 
		ORDER BY t1.descripcion
	end
else if @tipo=1
	begin
		SELECT	CONVERT(CHAR(13), CONVERT(BIGINT, t1.cod_barras)) +'|'+ 
				CONVERT(CHAR(45),t1.descripcion) +'|'+ 
				CASE t1.grupo_est 
					WHEN 'PC01A' 
					THEN RIGHT(CONVERT(CHAR(9), CONVERT(MONEY, ROUND(t1.prec_farm, 2, 2) + (ROUND(t1.prec_farm, 2, 2) * 0.5))), 9)
					ELSE RIGHT(CONVERT(CHAR(9), CONVERT(MONEY, ROUND(t1.prec_farm, 2, 2))), 9)
				END +'|'+
				CONVERT(CHAR(9), CONVERT(MONEY, ROUND(t1.prec_pub, 2, 2)))
		FROM	maestro_productos_baan t1 
		WHERE	CONVERT(INT, t1.codigo) < dbo.gobierno() AND
				ISNUMERIC(t1.cod_barras) = 1 AND
				SUBSTRING(t1.status, 1,1) <> 'B'
				and codigo in (select codigo from inventario_baan where sucursal = @sucursal)
		ORDER BY t1.descripcion	
	end

GO
