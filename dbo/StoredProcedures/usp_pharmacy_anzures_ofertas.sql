
CREATE
--	CREATE
PROCEDURE usp_pharmacy_anzures_ofertas
--	DECLARE
@sucursal INT, @cliente VARCHAR(5), @bolsa1 VARCHAR(5), @bolsa2 VARCHAR(5)

/*
usp_pharmacy_anzures_ofertas 1, '43372', 'LIBRE', 'C1010'
*/

/*
SET @sucursal = 1
SET @bolsa1 = 'LIBRE'
SET @bolsa2 = 'A2   '
SET @cliente = '43372'
*/

--------------------------------------------------------------------------------------------------
--	HECHO POR:	 MIGUEL SAMAYOA

--  2010-05-21  CREACION
--------------------------------------------------------------------------------------------------

AS

DECLARE @descuento MONEY, @factor MONEY
SET @descuento = 
	(SELECT descuento FROM clientes_baan 
		WHERE sucursal = @sucursal and cliente = @cliente)

SET @factor = 100

CREATE TABLE #ofertas_pharmacy_anzures	(
	codigo									VARCHAR(7)		NOT NULL PRIMARY KEY,
	grupo_est								VARCHAR(5),
	sucursal								INT,
	cod_barras							VARCHAR(13),
	descripcion							VARCHAR(31),
	prec_farm								MONEY,
	descto_ofer_sin_escala	MONEY,
	piezas_con_cargo				INT,
	piezas_sin_cargo				INT,
	limit_prod_sin_cargo		INT,
	descto_fin							MONEY,
	bolsa										VARCHAR(5)
	)

INSERT INTO #ofertas_pharmacy_anzures
	SELECT
		ofe.codigo				,
		mpb.grupo_est			,
		@sucursal					,
		mpb.cod_barras		,
		mpb.descripcion		,
		CONVERT(MONEY,
		--CASE WHEN mpb.grupo_est = 'PC01A' THEN mpb.prec_farm + (mpb.prec_farm * 0.5) * 100 
		--     ELSE mpb.prec_farm * 100 END 		)										prec_farm							,

		CASE WHEN mpb.grupo_est = 'PC01A' THEN (mpb.prec_farm  * 1.5) 
					ELSE mpb.prec_farm END 		)										prec_farm							,

		CASE WHEN mpb.clas_fis IN ('B','BA') THEN @descuento
				 WHEN mpb.clas_fis IN ('N','NA') THEN 0
				 WHEN mpb.clas_fis IN ('H','HA') THEN descto_prod 
				 ELSE 0 END 																			descto_ofer_sin_escala,
		ofe.cant_base																					piezas_con_cargo			,
		ofe.cant_oferta																				piezas_sin_cargo			,
		0																											limit_prod_sin_cargo	,
		ofe.porcentaje																				descto_fin						,
		ofe.bolsa
	FROM dboferta ofe
	INNER JOIN maestro_productos_baan mpb ON ofe.codigo = mpb.codigo
		AND mpb.codigo = ofe.codigo
	WHERE ofe.sucursal = @sucursal AND ofe.bolsa = @bolsa1

INSERT INTO #ofertas_pharmacy_anzures
	SELECT
		ofe.codigo				,
		mpb.grupo_est			,
		@sucursal					,
		mpb.cod_barras		,
		mpb.descripcion		,
		CONVERT(MONEY,	
		--CASE WHEN mpb.grupo_est = 'PC01A' THEN mpb.prec_farm + (mpb.prec_farm * 0.5) * 100 
		--     ELSE mpb.prec_farm * 100 END 		)										prec_farm							,

		CASE WHEN mpb.grupo_est = 'PC01A' THEN (mpb.prec_farm  * 1.5) 
					ELSE mpb.prec_farm END 		)										prec_farm							,

		CASE WHEN mpb.clas_fis IN ('B','BA') THEN @descuento
				 WHEN mpb.clas_fis IN ('N','NA') THEN 0
				 WHEN mpb.clas_fis IN ('H','HA') THEN descto_prod 
				 ELSE 0 END 																			descto_ofer_sin_escala,
		ofe.cant_base																					piezas_con_cargo			,
		ofe.cant_oferta																				piezas_sin_cargo			,
		0																											limit_prod_sin_cargo	,
		ofe.porcentaje																				descto_fin	,
		ofe.bolsa
	FROM dboferta ofe
	INNER JOIN maestro_productos_baan mpb ON ofe.codigo = mpb.codigo
		AND mpb.codigo = ofe.codigo
	WHERE ofe.sucursal = @sucursal AND ofe.bolsa = @bolsa2
	AND ofe.codigo NOT IN 
		(SELECT codigo FROM #ofertas_pharmacy_anzures)


SELECT 
	LEFT ( o.sucursal + REPLICATE(' ',12)																		, 12)		zona								,
	RIGHT( REPLICATE('0',13) + o.cod_barras																	, 13)		cod_barras					,
	LEFT ( o.descripcion + REPLICATE(' ',31)																, 31)		descripcion					,
	RIGHT( REPLICATE(' ',10) + CONVERT(VARCHAR, o.prec_farm * @factor			)	, 10)		prec_farm						,
	RIGHT( REPLICATE(' ',10) + CONVERT(VARCHAR, o.descto_ofer_sin_escala	)	, 10)		desc_ofer_s_e				,
	RIGHT( REPLICATE(' ',10) + CONVERT(VARCHAR, o.piezas_con_cargo				)	, 10)		piezas_con_cargo		,
	RIGHT( REPLICATE(' ',10) + CONVERT(VARCHAR, o.piezas_sin_cargo				)	, 10)		piezas_sin_cargo		,
	RIGHT( REPLICATE(' ',10) + CONVERT(VARCHAR, o.limit_prod_sin_cargo		)	, 10)		limit_prod_sin_cargo,
	RIGHT( REPLICATE(' ',10) + CONVERT(VARCHAR, o.descto_fin * @factor		)	, 10)		descto_fin
	,o.codigo
--	,o.grupo_est
--	,bolsa
FROM #ofertas_pharmacy_anzures o
ORDER by grupo_est

DROP TABLE #ofertas_pharmacy_anzures

GO

