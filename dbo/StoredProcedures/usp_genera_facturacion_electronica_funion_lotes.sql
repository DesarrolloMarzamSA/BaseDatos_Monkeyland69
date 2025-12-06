
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_genera_facturacion_electronica_funion_lotes]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

CREATE TABLE ##Fact_Elec_FUnion_hoy (
	sucursal													tinyint NOT NULL,
	cliente														varchar(5) NOT NULL,
	digito_verificador								varchar(1) NULL,
	factura														varchar(8) NOT NULL,
	fecha_factura											datetime NULL,
	codigo														varchar(7) NOT NULL,
	descripcion												varchar(40) NULL,
	cod_barras 												varchar(13) NULL,
	clas_fis													varchar(2) NULL,
	piezas_surtidas_con_cargo					int NULL,
	piezas_surtidas_sin_cargo					int NULL,
	precio_farm_sin_imp								money NULL,
	precio_pub_sin_imp								money NULL,
	precio_pub_con_imp								money NULL,
	importe_bruto											money NULL,
	porcentaje_descto_oferta					money NULL,
	descto_oferta											money NULL,
	porcentaje_descto_comercial				money NULL,
	descto_comercial									money NULL,
	ieps															money NULL,
	iva																money NULL,
	bonificacion_iva									money NULL,
	porcentaje_utilidad								money NULL,
	importe_neto											money NULL,
	orden															varchar(16) NULL,
	porcentaje_iva										money NULL,
	filler														varchar(5) NULL,
	no_registro												int NULL,
	desc_comerc_prod									money NULL,
	porcentaje_iva2										money NULL,
	iva2															money NULL,
	bonificacion_iva2									money NULL,
	porcentaje_ieps										money NULL,
	desc_comerc_ieps									money NULL,
	iva_del_iesps											money NULL,
	bonificacion_iva_del_iesps				money NULL,
	timestamp													datetime NULL,
	segto															char(2) NULL,
	ctepadre													char(3) NULL,
	rfc																char(13) NULL,
	tipo_documento										varchar(1) NULL,
	folio_fiscal											varchar(8) NULL,
	fecha_tandem											smalldatetime NULL,
PRIMARY KEY CLUSTERED (	sucursal ,	cliente ,	factura ,	codigo )
)
 




INSERT INTO ##Fact_Elec_FUnion_hoy
SELECT 
	f.sucursal													,
	f.cliente														,
	f.digito_verificador								,
	f.factura														,
	f.fecha_factura											,
	f.codigo														,
	f.descripcion												,
	f.cod_barras 												,
	f.clas_fis													,
	f.piezas_surtidas_con_cargo					,
	f.piezas_surtidas_sin_cargo					,
	f.precio_farm_sin_imp								,
	f.precio_pub_sin_imp								,
	f.precio_pub_con_imp								,
	f.importe_bruto											,
	f.porcentaje_descto_oferta					,
	f.descto_oferta											,
	f.porcentaje_descto_comercial				,
	f.descto_comercial									,
	f.ieps															,
	f.iva																,
	f.bonificacion_iva									,
	f.porcentaje_utilidad								,
	f.importe_neto											,
	f.orden															,
	f.porcentaje_iva										,
	f.filler														,
	f.no_registro												,
	f.desc_comerc_prod									,
	f.porcentaje_iva2										,
	f.iva2															,
	f.bonificacion_iva2									,
	f.porcentaje_ieps										,
	f.desc_comerc_ieps									,
	f.iva_del_iesps											,
	f.bonificacion_iva_del_iesps				,
	f.timestamp													,
	f.segto															,
	f.ctepadre													,
	f.rfc																,
	f.tipo_documento										,
	f.folio_fiscal											,
	f.fecha_tandem											
FROM facturacion_electronica_estandar f 
WHERE f.serie='U' and f.factura in (
1550194	,
1561776	,
1994042	,
2095440	,
2162491	,
2170325	,
2191629	,
2194782	,
2194845	,
2198466	,
2207873	,
2207958	,
2214223	,
2214225	,
2217243	,
2217277	,
2217330	,
2273118	,
2273122	,
2281942	,
2316223	,
2318587	,
2324163	,
2333475	,
2341616	,
2351695	,
2359310	,
2359311	,
2365001	,
2370371	,
2370383	
)
ORDER by f.sucursal, f.factura--,no_registro

DECLARE @sep VARCHAR(1)
SET @sep = '|'
SET @sep = ''

UPDATE ##Fact_Elec_FUnion_hoy SET orden = e.orden
FROM ##Fact_Elec_FUnion_hoy f
INNER JOIN encabezado e WITH (NOLOCK) 
	ON e.sucursal = f.sucursal AND e.factura = f.factura                                    


CREATE TABLE #tmp_fact_elect  (
	sucursal								INT,
	orden										INT,
  num_cuenta              VARCHAR(10),			--	 1
  folio                   VARCHAR(20),			--	 2
  codigo                  VARCHAR(20),			--	 3
  unid_c_cargo            INT,							--	 4
  unid_s_cargo            INT,							--	 5	
  porc_oferta             DECIMAL(17,2),		--	 6
	porc_financiero					DECIMAL( 6,2),		--	 7
  porc_iva                DECIMAL( 6,2),		--	 8
  porc_ieps               DECIMAL( 6,2),    --	 9
  pcio_farmacia           DECIMAL(17,2),		--	10
  pcio_max_pub            DECIMAL(17,2),		--	11
  impte_unit_oferta       DECIMAL(17,2),		--	12
  impte_unit_financiero   DECIMAL(17,2), 		--	13
  impte_unit_iva          DECIMAL(17,2),		--	14
  impte_unit_ieps         DECIMAL(17,2),		--	15
  impte_renglon           DECIMAL(17,2),		--	16
  impte_reng_oferta       DECIMAL(17,2),		--	17
  impte_reng_financiero   DECIMAL(17,2),		--	18
  impte_reng_subtotal     DECIMAL(17,2),		--	19
  impte_reng_iva          DECIMAL(17,2),		--	20
  impte_reng_ieps         DECIMAL(17,2),		--	21
  impte_reng_final        DECIMAL(17,2),		--	22
  no_pedido               VARCHAR(20),			--	23
	no_registro							INT
)
CREATE INDEX idx_fefunion ON #tmp_fact_elect (sucursal, folio, codigo)


INSERT INTO #tmp_fact_elect
  SELECT
		f.sucursal,
		99,
    f.cliente 																						AS num_cuenta,						--	 1
    s.serie_cfd + CONVERT(VARCHAR,CONVERT(BIGINT,f.folio_fiscal)) 	AS folio,									--	 2	nueva version		--	 CONVERT(VARCHAR,CONVERT(BIGINT,f.folio_fiscal))
    mpb.cod_barras_tandem																AS codigo,								--	 3
    piezas_surtidas_con_cargo															AS unid_c_cargo,    			--	 4
    piezas_surtidas_sin_cargo															AS unid_s_cargo,    			--	 5
    porcentaje_descto_oferta															AS porc_oferta,						--	 6
    CASE WHEN F.clas_fis IN ('B','BA') THEN 18
         WHEN F.clas_fis IN ('N','NA') THEN 0
         WHEN F.clas_fis IN ('H','HA') THEN descto_prod ELSE 0 END AS porc_financiero,	--	 7		
    f.porcentaje_iva																			AS porc_iva,							--	 8
    CASE WHEN mpb.grupo_est = 'PC01A' THEN 50 ELSE 0 END	AS porc_ieps,							--	 9
    precio_farm_sin_imp																		AS pcio_farmacia,     	  --	10
    precio_pub_sin_imp																		AS pcio_max_pub,    	    --	11
    0 																										AS impte_unit_oferta,			--	12
		0																											AS impte_unit_financiero,	--	13
		0																											AS impte_unit_iva,				--	14
    0               																			AS impte_unit_ieps,				--	15
    0 																										AS impte_renglon,					--	16
    0																										  AS impte_reng_oferta,			--	17
    0																											AS impte_reng_financiero,	--	18
    0                                                     AS impte_reng_subtotal,   --	19
    0                                                     AS impte_reng_iva,				--	20
    0																											AS impte_reng_ieps,				--	21
    importe_neto																					AS impte_reng_final,			--	22
    RTRIM(LTRIM(e.orden))																	AS no_pedido,							--	23	
		no_registro

  FROM ##Fact_Elec_FUnion_hoy f
  LEFT OUTER JOIN maestro_productos mpb ON mpb.codigo = f.codigo
  LEFT OUTER JOIN sucursales s ON f.sucursal = s.sucursal
  INNER JOIN encabezado e ON f.sucursal = e.sucursal AND f.factura = e.factura


UPDATE #tmp_fact_elect SET orden = 1  WHERE sucursal = 5
UPDATE #tmp_fact_elect SET orden = 2  WHERE sucursal = 11
UPDATE #tmp_fact_elect SET orden = 3  WHERE sucursal = 13
UPDATE #tmp_fact_elect SET orden = 4  WHERE sucursal = 1

UPDATE #tmp_fact_elect 
  SET impte_unit_oferta = (porc_oferta * pcio_farmacia) / 100														

UPDATE #tmp_fact_elect 
  SET impte_unit_financiero = ((pcio_farmacia - impte_unit_oferta ) * (porc_financiero )) / 100		

UPDATE #tmp_fact_elect 
  SET impte_renglon = unid_c_cargo * pcio_farmacia																	

UPDATE #tmp_fact_elect 
  SET impte_reng_oferta = impte_unit_oferta * unid_c_cargo 													

UPDATE #tmp_fact_elect 
  SET impte_unit_iva = (pcio_farmacia - impte_unit_oferta - impte_unit_financiero) * (porc_iva) / 100		

UPDATE #tmp_fact_elect 
  SET impte_reng_iva = impte_unit_iva * unid_c_cargo																					

UPDATE #tmp_fact_elect 
  SET impte_reng_financiero = impte_unit_financiero * unid_c_cargo														

UPDATE #tmp_fact_elect 
  SET impte_reng_subtotal = impte_renglon - impte_reng_oferta - impte_reng_financiero					

UPDATE #tmp_fact_elect 
  SET folio = '' where folio is null

--	ESTE ES RESULTADO REAL -----------------------------------
SELECT
  LEFT(num_cuenta + REPLICATE(' ',10),10) cuenta,	-- + @sep +	
  LEFT(folio + REPLICATE(' ',10) ,10) factura,	-- + @sep +	
  LEFT(right( cast('' as CHAR(13)) + cast(codigo  as varchar), 13 ) + REPLICATE(' ',20),20) codigo,
  LEFT(CONVERT(VARCHAR,unid_c_cargo         )+REPLICATE(' ', 7), 7) unid_c_cargo							,	-- + @sep +	
  LEFT(CONVERT(VARCHAR,unid_s_cargo         )+REPLICATE(' ', 7), 7) unid_s_cargo							,	-- + @sep +	
  LEFT(CONVERT(VARCHAR,porc_oferta          )+REPLICATE(' ', 6), 6) porc_oferta								,	-- + @sep +	
  LEFT(CONVERT(VARCHAR,porc_financiero      )+REPLICATE(' ', 6), 6) porc_financiero						,	-- + @sep +	
  LEFT(CONVERT(VARCHAR,porc_iva             )+REPLICATE(' ', 6), 6) porc_iva									,	-- + @sep +	
  LEFT(CONVERT(VARCHAR,porc_ieps            )+REPLICATE(' ', 6), 6) porc_ieps									,	-- + @sep +	
  LEFT(CONVERT(VARCHAR,pcio_farmacia        )+REPLICATE(' ',12),12) pcio_farmacia							,	-- + @sep +	
  LEFT(CONVERT(VARCHAR,pcio_max_pub         )+REPLICATE(' ',12),12) pcio_max_pub							,	-- + @sep +	
  LEFT(CONVERT(VARCHAR,impte_unit_oferta    )+REPLICATE(' ',12),12) impte_unit_oferta					,	-- + @sep +	
  LEFT(CONVERT(VARCHAR,impte_unit_financiero)+REPLICATE(' ',12),12) impte_unit_financiero			,	-- + @sep + 
  LEFT(CONVERT(VARCHAR,impte_unit_iva       )+REPLICATE(' ',12),12) impte_unit_iva						,	-- + @sep + 
  LEFT(CONVERT(VARCHAR,impte_unit_ieps      )+REPLICATE(' ',12),12) impte_unit_ieps						,	-- + @sep + 
  LEFT(CONVERT(VARCHAR,impte_renglon        )+REPLICATE(' ',12),12) impte_renglon							,	-- + @sep + 
  LEFT(CONVERT(VARCHAR,impte_reng_oferta    )+REPLICATE(' ',12),12) impte_reng_oferta					,	-- + @sep + 
  LEFT(CONVERT(VARCHAR,impte_reng_financiero)+REPLICATE(' ',12),12) impte_reng_financiero			,	-- + @sep + 
  LEFT(CONVERT(VARCHAR,impte_reng_subtotal  )+REPLICATE(' ',12),12) impte_reng_subtotal				,	-- + @sep + 
  LEFT(CONVERT(VARCHAR,impte_reng_iva       )+REPLICATE(' ',12),12) impte_reng_iva						,	-- + @sep + 
  LEFT(CONVERT(VARCHAR,impte_reng_ieps      )+REPLICATE(' ',12),12) impte_reng_ieps						,	-- + @sep + 
  LEFT(CONVERT(VARCHAR,impte_reng_final     )+REPLICATE(' ',12),12) impte_reng_final					,	-- + @sep + 
  LEFT(no_pedido														 +REPLICATE(' ',10),10)	no_pedido					--			,	-- + @sep + 
FROM #tmp_fact_elect 
ORDER BY orden,num_cuenta,folio,no_registro				--				,codigo
drop table #tmp_fact_elect

DROP TABLE ##Fact_Elec_FUnion_hoy

END
GO
