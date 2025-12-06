
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE 
--	CREATE
PROCEDURE [dbo].[usp_fbenavides_catalogo]
--	@sucursal INT
WITH ENCRYPTION
AS



/*
	usp_fbenavides_catalogo
*/
--	NOMBRE SP: 	usp_genera_catalogo_BENAVIDES.      
--	CLIENTE: 	FARMACIAS BENAVIDES 
--	DESCRIPCION: 	OBTIENE INFORMACION DE maestro_productos_baan PARA CREAR EL CATALOGO MAESTRO DE ARTICULOS PARA BENAVIDES.
--	REPONSABLE: 	MIGUEL SAMAYOA.
--	FECHA creacion: 	23/10/ 2008 00:00 A.M.
--	MODIFICACIONES
--	2008-10-23		CREACION DEL USP																								MIGUEL SAMAYOA
--	2008-12-09		SE QUITO EL FILTRO DEL INVENTARIO																MIGUEL SAMAYOA
--	2010-01-29		SE APUNTO EL CATALOGO BENAVIDES A LA VISTA CATALOGO BENAVIDES		MIGUEL SAMAYOA				
--	2010-03-25		FUNCION GOBIERNO																								MIGUEL SAMAYOA				

DECLARE @factor INT	,	@sucursal INT
DECLARE @sep VARCHAR(1)
SET @factor = 100
SET @sep = ''
SET @sucursal = 7

--CREATE TABLE #tempo_mae_benavides ( 
--	tipo varchar(2), 
--	col1 varchar(500), 
--	codigo varchar(7),
--	cliente varchar(5),
--	folio_fiscal VARCHAR(20), 
--	orden int identity )

--INSERT INTO #tempo_mae_benavides (tipo,col1,codigo,cliente,folio_fiscal)
  SELECT 
--		'MA' tipo,
    '05'																																				prov						,		-- @sep +
    RIGHT(REPLICATE('0', 8) + CONVERT(VARCHAR, mpb.codigo)	, 8)								codigo					,		-- @sep +
    RIGHT(REPLICATE('0',18) + bcp.cod_ben										,18)								cod_ben					,		-- @sep +		--	2010-01-29
    '001'																																				multiplo_venta	,		-- @sep +
    '000'																																				linea_producto	,		-- @sep +
    LEFT (CONVERT(VARCHAR, mpb.descripcion) + REPLICATE(' ',30),30)							nombre_articulo	,		-- @sep + 
    LEFT(RIGHT(REPLICATE('0',10) + CONVERT(VARCHAR,CONVERT(INT,CASE mpb.grupo_est  WHEN 'PC01A' THEN mpb.prec_farm * 1.5 ELSE mpb.prec_farm END * @factor )),10),10)	precio_costo					,	 -- @sep +
    LEFT(RIGHT(REPLICATE('0',10) + CONVERT(VARCHAR,CONVERT(INT,CASE mpb.grupo_est  WHEN 'PC01A' THEN mpb.prec_farm * 1.5 ELSE mpb.prec_farm END * @factor )),10),10)	precio_farmacia				,	 -- @sep +
    LEFT(RIGHT(REPLICATE('0',10) + CONVERT(VARCHAR,CONVERT(INT,CASE mpb.grupo_est  WHEN 'PC01A' THEN mpb.prec_pub  * 1.5 ELSE mpb.prec_pub  END * @factor )),10),10)	precio_publico				,	 -- @sep +
    LEFT(RIGHT(REPLICATE('0',10) + CONVERT(VARCHAR,CONVERT(INT,CASE mpb.grupo_est  WHEN 'PC01A' THEN mpb.prec_farm * 1.5 ELSE mpb.prec_farm END * @factor )),10),10)	precio_costo_comision	,	 -- @sep +
    LEFT(CONVERT(VARCHAR, lab_largo) + REPLICATE(' ',30)				,30)																																																	nombre_prov_lab				,	 -- @sep +
    LEFT(mpb.cod_barras+ REPLICATE(' ',14)											,14)																																																	codigo_barras					,	 -- @sep +
    '0001'																																																																														empaque_original
    --	col1, 
		--mpb.codigo, 
		--'' Cliente,
		--'' Folio_Fiscal
  FROM	maestro_productos_baan mpb
  INNER JOIN cat_productos_benavides bcp on mpb.codigo = bcp.cod_mar
--  INNER JOIN inventario_baan ib ON ib.sucursal = @sucursal AND ib.codigo = mpb.codigo  
  WHERE 	CONVERT(INT, mpb.codigo) < dbo.gobierno() 
  AND mpb.cod_barras IS NOT NULL AND mpb.clas_ssa <> ''
  and  bcp.cod_ben not in('000000000000923680')
  
  

/*
SELECT * FROM #tempo_mae_benavides

DROP TABLE #tempo_mae_benavides
GO
*/


--	NOTA YA LA VISTA TIENE FILTRADA TODO LO NECESARIO

/*

ALTER VIEW [dbo].[cat_productos_benavides] AS
	SELECT 
		ca.codigo cod_mar, 
		RIGHT(ca.cod_prodcli,18) cod_ben, 
		mpb.cod_barras, 
		mpb.descripcion, 
		ca.fecha_hora_cambio fecha, 
		ca.STATUS estatus  
	FROM catalogo_autoservicios ca
	INNER JOIN maestro_productos_baan mpb ON mpb.codigo = ca.codigo AND mpb.codigo < dbo.gobierno()
	WHERE sucursal = 7 AND segto = 'C1' AND ctepadre = '319' AND ca.status = 'A'
GO

*/
GO
