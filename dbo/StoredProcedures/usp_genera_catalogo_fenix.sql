
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_genera_catalogo_fenix] @sucursal int, @cliente VARCHAR(5)

--	CREADO			2009-08-15						MOISES
--	MODIFICADO	2010-03-25	GOBIERNO	MIGUEL SAMAYOA
--	MODIFICADO	2010-12-02	GOBIERNO	MIGUEL SAMAYOA

/*
exec usp_genera_catalogo_fenix 4, '00879'
*/

WITH ENCRYPTION
AS
DECLARE @descuento MONEY
SELECT @descuento = CONVERT(MONEY, descuento) FROM clientes_baan WHERE sucursal = @sucursal and cliente = @cliente

SELECT 
	RIGHT(REPLICATE('0',13) + mp.cod_barras, 13) + 
	LEFT(mp.descripcion + REPLICATE(' ',30), 30) +
	RIGHT(REPLICATE('0', 9) + convert(VARCHAR, 
		convert(MONEY,CASE mp.grupo_est WHEN 'PC01A' THEN mp.prec_farm * 1.5 ELSE mp.prec_farm END)), 9) +
	CASE 
	WHEN mp.clas_fis = 'B'  THEN RIGHT(REPLICATE('0', 6) + CONVERT(VARCHAR, @descuento			), 6)
	WHEN mp.clas_fis = 'BA' THEN RIGHT(REPLICATE('0', 6) + CONVERT(VARCHAR, @descuento			), 6)
	WHEN mp.clas_fis = 'N'  THEN '000.00' 
	WHEN mp.clas_fis = 'NA' THEN '000.00' 
	WHEN mp.clas_fis = 'H'  THEN RIGHT(REPLICATE('0', 6) + CONVERT(VARCHAR, mp.descto_prod	), 6) 
	WHEN mp.clas_fis = 'HA' THEN RIGHT(REPLICATE('0', 6) + CONVERT(VARCHAR, mp.descto_prod	), 6) END
		--RIGHT(REPLICATE(' ', 9) + convert(VARCHAR, 
	--	convert(MONEY,CASE mp.grupo_est WHEN 'PC01A' THEN mp.prec_pub  * 1.5 ELSE mp.prec_pub  END)), 9) 
from maestro_productos_baan mp 
INNER JOIN inventario_baan ib ON mp.codigo = ib.codigo
WHERE
	ib.sucursal = @sucursal AND
	ISNUMERIC(mp.cod_barras) = 1 AND 
	CONVERT(INT, mp.codigo) < dbo.gobierno() AND
	ib.piezas > 0
GO
