USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE 
--	CREATE 
PROCEDURE [dbo].[usp_fidealessureste_fact_elect_2010] 


--DECLARE
@fecha varchar(10)	--	@sucursal int, 

--set @fecha = '2010-07-28'

/*
EXECUTE usp_fidealessureste_fact_elect_2010 '2011-02-02'
*/
WITH ENCRYPTION
AS


--------------------------------------------------------------------------------------------------
--	HECHO POR:	 MIGUEL SAMAYOA

--	usp_fidealessureste_fact_elect_2010 '2010-01-15'

--	EL USO DELA TABLA ENCABEZADO SE UTILIZA PARA CONOCER EL TIPO DE PEDIDO MANUAL / ELECTRONICO

--  2009-12-16  SE CAMBIO EL FOLIO POR EL CFD A PETICION DE FIDEALESSURESTE / PALMA.
--	2010-01-17	SE RELLENAN CON CEROS LOS CODIGOS DE BARRAS A PETICION DE FIDEALESSURESTE / PALMA.
--	2010-07-28	SE AGREGO CLIENTE PADRE 012
--	2011-01-24	SE RELLENAN CON CEROS LOS CODIGOS DE BARRAS A PETICION DE FIDEALESSURESTE / ERICK SANCHEZ
--------------------------------------------------------------------------------------------------
SELECT 
*
INTO #Fact_Elec_FIdealessureste_hoy
FROM facturacion_electronica_estandar f
WHERE f.segto = 'C2' AND f.ctepadre IN ('571' , '012') AND 
--fecha_factura = CONVERT(datetime,@fecha,121)
	fecha_tandem >= CONVERT(datetime,@fecha,121)
ORDER by sucursal,no_registro

/*
DECLARE @sep VARCHAR(1)
SET @sep = '|'
*/

CREATE TABLE #tmp_fact_elect  (
	sucursal								INT										,
	orden										INT										,
  noCuenta					      VARCHAR(10)						,	--	 1
  folio                   VARCHAR(20)	NOT NULL	,	--	 2
  codigo                  VARCHAR(20)						,	--	 3
  Piezas									INT										,	--	 4
  porcOferta							MONEY									,	--	 5
	porcFinanciero					MONEY									,	--	 6
  porcIVA						      MONEY									,	--	 7
  porcIEPS						    MONEY  								, --	 8
  pcioFarmacia					  MONEY									,	--	 9
  pcioMaxPub							MONEY									,	--	10
  impte_unit_oferta       MONEY									,	--	11
  impte_unit_financiero   MONEY									,	--	12
  impte_unit_iva          MONEY									,	--	13
  impte_unit_ieps         MONEY									,	--	14
  impte_renglon           MONEY									,	--	15
  impte_reng_oferta       MONEY									,	--	16
  impte_reng_financiero   MONEY									,	--	17
  impte_reng_subtotal     MONEY									,	--	18
  impte_reng_iva          MONEY									,	--	19
  impte_reng_ieps         MONEY									,	--	20
  impte_reng_final        MONEY									,	--	21
  no_pedido               INT										,	--	22
  impte_desc_vol          MONEY									,	--	23
  impte_desc_lim          MONEY									,	--	24
  impte_desc_lab          MONEY									,	--	25
  solo_elect              VARCHAR(1)						,  --	26
  grupo_est               VARCHAR(10) 					,    
  clas_fis                VARCHAR(10)						,
  clas_ssa                VARCHAR(10)						,
	no_registro							INT			
)



UPDATE #tmp_fact_elect SET orden = 1  WHERE sucursal = 5
UPDATE #tmp_fact_elect SET orden = 2  WHERE sucursal = 11
UPDATE #tmp_fact_elect SET orden = 3  WHERE sucursal = 13
UPDATE #tmp_fact_elect SET orden = 4  WHERE sucursal = 1
UPDATE #tmp_fact_elect SET orden = 5  WHERE sucursal = 3


INSERT INTO #tmp_fact_elect
  SELECT
		f.sucursal																																					AS sucursal										,
		99																																									AS orden											,
    f.cliente 																																					AS noCuenta										,	--	 1
    s.serie_cfd	+CONVERT(VARCHAR, CONVERT(BIGINT,f.folio_fiscal))																												AS folio											,	--	 2	CONVERT(VARCHAR, CONVERT(BIGINT,f.folio_fiscal))
    f.cod_barras																																				AS codigo											,	--	 3
    f.piezas_surtidas_con_cargo																													AS Piezas											,	--	 4
    f.porcentaje_descto_oferta																													AS porcOferta									,	--	 5
    f.descto_comercial																																	AS porcFinanciero							,	--	 6
    f.porcentaje_iva																																		AS porcIVA										,	--	 7
    f.porcentaje_ieps																																		AS porcIEPS										,	--	 8
    f.precio_farm_sin_imp																																AS pcioFarmacia								,	--	 9
    f.precio_pub_sin_imp																																AS pcioMaxPub									,	--	10
    0 																																									AS impte_unit_oferta					,	--	11
		0																																										AS impte_unit_financiero			,	--	12
		0																																										AS impte_unit_iva							,	--	13
    0               																																		AS impte_unit_ieps						,	--	14
    0 																																									AS impte_renglon							,	--	15
    0																										  															AS impte_reng_oferta					,	--	16
    0																																										AS impte_reng_financiero			,	--	17
    0                                                     															AS impte_reng_subtotal				,	--	18
    0                                                     															AS impte_reng_iva							,	--	19
    0																																										AS impte_reng_ieps						,	--	20
    importe_neto																																				AS impte_reng_final						,	--	21
    CASE WHEN ISNUMERIC(f.orden) = 1			THEN CONVERT(INT,f.orden)			ELSE 0		END		AS no_pedido									,	--	22
    CASE WHEN mpb.clas_fis in ('B','BA')  THEN importe_bruto * 3.5			ELSE 0		END		AS impte_desc_vol							,	--	23
    importe_neto  * ISNULL(u.porc_bonif_nl,0)																						AS impte_desc_lim							, --	24
    0																																										AS impte_desc_lab							,	--	25
    CASE WHEN LEFT(e.mafnarch,4) = 'RUNI' THEN 1 ELSE 0 END															AS solo_elect									,	--	26
    mpb.grupo_est,
    f.clas_fis,
    mpb.clas_ssa,
    no_registro
  FROM #Fact_Elec_FIdealessureste_hoy f
  LEFT OUTER JOIN maestro_productos mpb ON mpb.codigo = f.codigo
  LEFT OUTER JOIN catalogo_productos_fidealessureste u ON u.codigo = f.codigo
  LEFT OUTER JOIN sucursales s ON f.sucursal = s.sucursal
  INNER JOIN encabezado e ON f.sucursal = e.sucursal AND f.factura = e.factura

-- ==============================================================================================================
--																	CALCULOS SOLICITADOS POR ERICKA CARBONELL

UPDATE #tmp_fact_elect 
  SET impte_unit_oferta = (porcOferta * pcioFarmacia) / 100														

UPDATE #tmp_fact_elect 
  SET impte_unit_financiero = ((pcioFarmacia - impte_unit_oferta ) * (porcFinanciero )) / 100		

UPDATE #tmp_fact_elect 
  SET impte_renglon = Piezas * pcioFarmacia																	

UPDATE #tmp_fact_elect 
  SET impte_reng_oferta = impte_unit_oferta * Piezas 													

UPDATE #tmp_fact_elect 
  SET impte_unit_iva = (pcioFarmacia - impte_unit_oferta - impte_unit_financiero) * (porcIVA) / 100		

UPDATE #tmp_fact_elect 
  SET impte_reng_iva = impte_unit_iva * Piezas																					

UPDATE #tmp_fact_elect 
  SET impte_reng_financiero = impte_unit_financiero * Piezas														

UPDATE #tmp_fact_elect 
  SET impte_reng_subtotal = impte_renglon - impte_reng_oferta - impte_reng_financiero					

-- ==============================================================================================================

SELECT
  LEFT(	noCuenta					+	REPLICATE(' ',10)                        	,10) 	noCuenta								,	-- + @sep +	001_010
  LEFT(	folio	 						+	REPLICATE(' ',10)                        	,10) 	folio                 	,	-- + @sep +	011_020
	LEFT(	codigo						+	REPLICATE(' ',20)												 	,20) 	codigo                	,	-- + @sep +	021_040
	RIGHT(REPLICATE(' ', 7)	+	CONVERT(VARCHAR,Piezas								)	 	, 7) 	Piezas          				,	-- + @sep +	041_047
	RIGHT(REPLICATE(' ', 5)	+	CONVERT(VARCHAR,porcOferta           	)	 	, 5) 	porcOferta            	,	-- + @sep +	048_052
	RIGHT(REPLICATE(' ', 5)	+	CONVERT(VARCHAR,porcFinanciero       	)	 	, 5) 	porcFinanciero					,	-- + @sep +	053_057
	RIGHT(REPLICATE(' ', 5)	+	CONVERT(VARCHAR,porcIVA              	)	 	, 5) 	porcIVA             	 	,	-- + @sep +	058_062
	RIGHT(REPLICATE(' ', 5)	+	CONVERT(VARCHAR,porcIEPS             	)	 	, 5) 	porcIEPS            	 	,	-- + @sep +	063_067
	RIGHT(REPLICATE(' ',12)	+	CONVERT(VARCHAR,pcioFarmacia         	)	 	,12) 	pcioFarmacia        	 	,	-- + @sep +	068_079
	RIGHT(REPLICATE(' ',12)	+	CONVERT(VARCHAR,pcioMaxPub			      )  	,12) 	pcioMaxPub          		,	-- + @sep +	080_091
	RIGHT(REPLICATE(' ',12)	+	CONVERT(VARCHAR,impte_unit_oferta     )  	,12) 	impte_unit_oferta     	,	-- + @sep +	092_103
	RIGHT(REPLICATE(' ',12)	+	CONVERT(VARCHAR,impte_unit_financiero )  	,12) 	impte_unit_financiero 	,	-- + @sep + 104_115
	RIGHT(REPLICATE(' ',12)	+	CONVERT(VARCHAR,impte_unit_iva        )  	,12) 	impte_unit_iva        	,	-- + @sep + 116_127
	RIGHT(REPLICATE(' ',12)	+	CONVERT(VARCHAR,impte_unit_ieps       )  	,12) 	impte_unit_ieps       	,	-- + @sep + 128_139
	RIGHT(REPLICATE(' ',12)	+	CONVERT(VARCHAR,impte_renglon         )  	,12) 	impte_renglon         	,	-- + @sep + 140_151
	RIGHT(REPLICATE(' ',12)	+	CONVERT(VARCHAR,impte_reng_oferta     )  	,12) 	impte_reng_oferta     	,	-- + @sep + 152_163
	RIGHT(REPLICATE(' ',12)	+	CONVERT(VARCHAR,impte_reng_financiero )  	,12) 	impte_reng_financiero 	,	-- + @sep + 164_175
	RIGHT(REPLICATE(' ',12)	+	CONVERT(VARCHAR,impte_reng_subtotal   )  	,12) 	impte_reng_subtotal   	,	-- + @sep + 176_187
	RIGHT(REPLICATE(' ',12)	+	CONVERT(VARCHAR,impte_reng_iva        )  	,12) 	impte_reng_iva        	,	-- + @sep + 188_189
	RIGHT(REPLICATE(' ',12)	+	CONVERT(VARCHAR,impte_reng_ieps       )  	,12) 	impte_reng_ieps       	,	-- + @sep + 200_211
	RIGHT(REPLICATE(' ',12)	+	CONVERT(VARCHAR,impte_reng_final      )  	,12) 	impte_reng_final      	,	-- + @sep + 212_223
	RIGHT(REPLICATE(' ',10)	+	CONVERT(VARCHAR,no_pedido							)		,10)	no_pedido             	,	-- + @sep + 224_233
	RIGHT(REPLICATE(' ',12)	+	CONVERT(VARCHAR,impte_desc_vol        )  	,12) 	impte_desc_vol					,	-- + @sep + 234_245
	RIGHT(REPLICATE(' ',12)	+	CONVERT(VARCHAR,impte_desc_lim        )  	,12) 	impte_desc_lim					,	-- + @sep + 246_257
	RIGHT(REPLICATE(' ',12)	+	CONVERT(VARCHAR,impte_desc_lab        )  	,12) 	impte_desc_lab					,	-- + @sep + 258_269
	RIGHT(REPLICATE(' ', 1)	+	solo_elect																, 1)	solo_elect								--					270_270
FROM #tmp_fact_elect 
ORDER BY orden,noCuenta,folio,no_registro



DROP TABLE #tmp_fact_elect

DROP TABLE #Fact_Elec_FIdealessureste_hoy

GO
