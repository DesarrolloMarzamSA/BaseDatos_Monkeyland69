
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE	--	CREATE	--	DROP
PROCEDURE [dbo].[usp_fmorelost_oferta]

--DECLARE 
--@bolsas VARCHAR(100)

WITH ENCRYPTION
AS

/*
EXECUTE usp_fmorelost_oferta
*/

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

/*
INSERT INTO bolsas_ofertas VALUES ('FMORELOST' , 4, 'LIBRE', 2, 1)
SELECT * FROM bolsas_ofertas
*/

INSERT INTO #ofertas 
EXECUTE usp_constructor_ofertas 'FMORELOST', 4




SELECT
	LEFT ( REPLICATE('0', 1) + CONVERT(VARCHAR, ofe.sucursal) + REPLICATE(' ',12)	, 12)		zona						,
--	RIGHT( REPLICATE('0', 7) + mpb.codigo													,  7)		codigo					,
	LEFT(  mpb.cod_barras + REPLICATE('0',13) 											, 13)		codigo_ean			,
	LEFT( descripcion + REPLICATE(' ', 30), 30)																								descripcion			,
	RIGHT( REPLICATE(' ', 9) + CONVERT(VARCHAR, mpb.prec_farm	)		,  9)		prec_farm				,
	RIGHT( REPLICATE(' ', 6) + CONVERT(VARCHAR, ofe.porcentaje) 	,  6)		descto_ofe			,
	RIGHT( REPLICATE(' ', 7) + CONVERT(VARCHAR, ofe.cant_base)  	,  7)		cant_pzas_cc		,
	RIGHT( REPLICATE(' ', 7) + CONVERT(VARCHAR, ofe.cant_oferta)  ,  7)		cant_pzas_sc		,
	RIGHT( REPLICATE(' ', 7) + CONVERT(VARCHAR, 0)								,  7)		lim_prod_sc			,
	RIGHT( REPLICATE(' ', 6) + CONVERT(VARCHAR, 
	CASE  WHEN clas_fis IN ('B','BA') THEN 18
				WHEN clas_fis IN ('N','NA') THEN 0
				WHEN clas_fis IN ('H','HA') THEN mpb.descto_prod END)		,  6)		porc_financiero	,
	RIGHT( REPLICATE(' ', 9) + CONVERT(VARCHAR, mpb.prec_pub	)		,  9)		prec_pub				

FROM #ofertas ofe
INNER JOIN maestro_productos_baan mpb ON mpb.codigo = ofe.codigo

	
ORDER BY ofe.codigo


DROP TABLE #ofertas
GO
