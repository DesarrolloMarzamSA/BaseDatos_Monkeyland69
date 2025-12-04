SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

--	ACTUALIZACION AUTOMATICA DE PRODUCTOS FTORRES
--	MIGUEL SAMAYOA

--	2010-03-25	MIGUEL SAMAYOA	GOBIERNO
--	2010-04-19	MIGUEL SAMAYOA	ALTAS


--	usp_actualiza_cat_productos_ftorres '\\190.1.4.26\d$\Interfases\SUR_FTORRES\FTORRES_CATALOGOS\temp\20090917_CATFLT.txt'

CREATE PROCEDURE [dbo].[usp_actualiza_cat_productos_ftorres] (@archivo_txt VARCHAR(500) )
as

--	DECLARE @archivo_txt VARCHAR(500)
--	SET @archivo_txt = '\\190.1.5.116\d$\Interfases\SUR_FTORRES\FTORRES_CATALOGOS\temp\20100416_CATFLT.txt'

CREATE TABLE #tmp_buffer	(
	buffer varchar(200)	)

EXECUTE ('BULK INSERT #tmp_buffer FROM "'+@archivo_txt+'"')

CREATE TABLE #catalogo_ftorres_actualizado	(
	cod_barras	VARCHAR( 20)	PRIMARY KEY,
	cod_torres	VARCHAR( 10),
	unidad			VARCHAR(  5),
	descripcion	VARCHAR(100),
	cod_mar			VARCHAR(  7)									)

INSERT INTO #catalogo_ftorres_actualizado	(cod_barras, cod_torres, unidad, descripcion)
	SELECT 
		rtrim(substring(buffer,  1, 20)) cod_barras,
		rtrim(substring(buffer, 21, 10)) cod_torres,
		rtrim(substring(buffer, 31,  5)) unidad,
		rtrim(substring(buffer, 36,100)) descripcion
	FROM #tmp_buffer

UPDATE #catalogo_ftorres_actualizado 
SET cod_mar = mpb.codigo  --	WHERE
FROM #catalogo_ftorres_actualizado b
INNER JOIN maestro_productos_baan mpb ON 
	CONVERT(BIGINT,mpb.cod_barras) = CONVERT(BIGINT,b.cod_barras) 
	--AND LEFT(mpb.status,1) <> 'B'
AND convert(INT,mpb.codigo) < dbo.gobierno()
AND ISNUMERIC(mpb.cod_barras) = 1
AND ISNUMERIC(b.cod_barras) = 1

--	SELECT * FROM #catalogo_ftorres_actualizado	WHERE cod_mar IS NOT NULL

DECLARE @records INT
SET @records = 
	(SELECT COUNT(*) FROM #catalogo_ftorres_actualizado WHERE cod_mar IS NOT NULL 
	AND NOT cod_barras IN (SELECT t.cod_barras FROM cat_productos_torres t)  )

IF @records > 0
	BEGIN
--	TRUNCATE TABLE cat_productos_torres
	INSERT INTO cat_productos_torres (cod_barras, cod_torres, unidad, descripcion, timestamp, cod_mar)
		SELECT cod_barras, cod_torres, unidad, descripcion, current_timestamp, cod_mar
			FROM #catalogo_ftorres_actualizado	
			WHERE cod_mar IS NOT NULL
END

DROP TABLE #tmp_buffer
DROP TABLE #catalogo_ftorres_actualizado


GO
