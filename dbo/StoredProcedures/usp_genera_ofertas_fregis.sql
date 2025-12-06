
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE --	CREATE
PROCEDURE --usp_fregis_ofertas
[dbo].[usp_genera_ofertas_fregis]

AS

--DELETE FROM bolsas_ofertas WHERE cadena = 'FREGIS'
--INSERT INTO bolsas_ofertas VALUES ('FREGIS', 7, 'C2165', 1, 1, 0, GETDATE())
--INSERT INTO bolsas_ofertas VALUES ('FREGIS', 7, 'PLUS7', 2, 1, 0, GETDATE())
--INSERT INTO bolsas_ofertas VALUES ('FREGIS', 7, 'LIBRE', 3, 1, 0, GETDATE())

--EXECUTE usp_constructor_ofertas 'FREGIS', 7

--SELECT * --	DELETE 
--FROM bolsas_ofertas
--WHERE cadena = 'FREGIS'
--ORDER BY orden


CREATE TABLE #ofertas	(
	sucursal						INT								,
	bolsa								VARCHAR(  5)			,
	codigo							VARCHAR(  7)			,
	cant_base						INT								,
	cant_oferta					INT								,
	porcentaje					MONEY							,
	vigencia_inicial		SMALLDATETIME			,
	vigencia_final			SMALLDATETIME			,
	disponible					INT								,
	timestamp						DATETIME
	PRIMARY KEY (codigo)	
)

INSERT INTO #ofertas 
EXECUTE usp_constructor_ofertas 'FREGIS', 7

DECLARE @cliente VARCHAR(5)
SET @cliente = '07799'

DECLARE @descuento MONEY	--	VARCHAR(6)
SELECT @descuento = descuento	--	RIGHT(REPLICATE(' ',6) + CONVERT(VARCHAR, descuento), 6) 
	FROM clientes_baan WHERE cliente = @cliente	AND sucursal = 8	--	@sucursal 

/*
SELECT
	LEFT ( CONVERT(VARCHAR, ofe.sucursal) + REPLICATE(' ', 2)			,  2)		zona						,
	REPLICATE(' ',10)																											filler1					,
	LEFT(CONVERT(VARCHAR, CONVERT(BIGINT,mpb.cod_barras)) + REPLICATE(' ',13) , 13)		ean	,
	LEFT( descripcion + REPLICATE(' ', 30), 30)														descripcion			,
	RIGHT( REPLICATE(' ', 9) + CONVERT(VARCHAR, mpb.prec_farm	)		,  9)		prec_farm				,
	RIGHT( REPLICATE(' ', 6) + CONVERT(VARCHAR, ofe.porcentaje) 	,  6)		descto_ofe			,
	RIGHT( REPLICATE(' ', 7) + CONVERT(VARCHAR, ofe.cant_base)  	,  7)		cant_pzas_cc		,
	RIGHT( REPLICATE(' ', 7) + CONVERT(VARCHAR, ofe.cant_oferta)  ,  7)		cant_pzas_sc		,
	REPLICATE(' ', 7)																											filler2					,
	RIGHT( REPLICATE(' ', 6) + CONVERT(VARCHAR, 
	CASE  WHEN clas_fis IN ('B','BA') THEN @descuento
				WHEN clas_fis IN ('N','NA') THEN 0
				WHEN clas_fis IN ('H','HA') THEN mpb.descto_prod END)		,  6)		descto					,
	RIGHT( REPLICATE(' ', 2) + CONVERT(VARCHAR, 		CASE
			WHEN i.piezas = 0								THEN 0
			WHEN i.piezas BETWEEN 1 AND 50	THEN 1
			WHEN i.piezas > 50							THEN 2 END	)		,  9)		pzas			
FROM #ofertas ofe
INNER JOIN maestro_productos_baan mpb ON mpb.codigo = ofe.codigo
INNER JOIN inventario_baan i ON i.sucursal = 7 AND i.codigo = ofe.codigo
ORDER BY ofe.codigo
*/
SELECT
	RIGHT (REPLICATE('0', 2) +  CONVERT(VARCHAR, ofe.sucursal) 			,  2)							+
	REPLICATE(' ',10)																																	+
	LEFT(CONVERT(VARCHAR, CONVERT(BIGINT,mpb.cod_barras)) + REPLICATE(' ',13) , 13)		+
	LEFT( descripcion + REPLICATE(' ', 30), 30)																				+
	RIGHT( REPLICATE(' ', 9) + CONVERT(VARCHAR, mpb.prec_farm	)					,  9)					+
	RIGHT( REPLICATE(' ', 6) + CONVERT(VARCHAR, ofe.porcentaje * 100) 	,  6)					+
	RIGHT( REPLICATE(' ', 7) + CONVERT(VARCHAR, ofe.cant_base)  				,  7)					+
	RIGHT( REPLICATE(' ', 7) + CONVERT(VARCHAR, ofe.cant_oferta)  			,  7)					+
	REPLICATE(' ', 7)																																	+
	RIGHT( REPLICATE(' ', 6) + CONVERT(VARCHAR, 
	CASE  WHEN clas_fis IN ('B','BA') THEN @descuento
				WHEN clas_fis IN ('N','NA') THEN 0
				WHEN clas_fis IN ('H','HA') THEN mpb.descto_prod END)		,  6)								+
	RIGHT( REPLICATE(' ', 2) + CONVERT(VARCHAR, 		CASE
			WHEN i.piezas = 0								THEN 0
			WHEN i.piezas BETWEEN 1 AND 50	THEN 1
			WHEN i.piezas > 50							THEN 2 END	)		,  2)			
	--	+	ofe.codigo+ofe.bolsa
			--pzas			
	ofertas
FROM #ofertas ofe
INNER JOIN maestro_productos_baan mpb ON mpb.codigo = ofe.codigo
INNER JOIN inventario_baan i ON i.sucursal = 7 AND i.codigo = ofe.codigo
ORDER BY ofe.codigo


DROP TABLE #ofertas
GO
