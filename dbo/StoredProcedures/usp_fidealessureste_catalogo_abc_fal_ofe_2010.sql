

/*
EXECUTE usp_fidealessureste_catalogo_abc_fal_ofe_2010 5
*/
--
--  HECHO POR MIGUEL SAMAYOA          31 - MAR - 2009
--  CATALOGO MAESTRO CON ALTAS BAJAS Y CAMBIOS PARA
--  FARMACIAS idealessureste


--	FECHA				DESCRIPCION														PROGRAMADOR				SOLICITO
--	----------	---------------------------------			----------------	----------
--	2011-07-07	SE AGREGARON BOLSAS DE OFERTAS				MIGUEL SAMAYOA		MOISES
--							XXPAD, LIBRE, ZFHYB

/*
		usp_fidealessureste_catalogo_abc_fal_ofe_2010 5
*/

CREATE --	CREATE	--	DROP
PROCEDURE [dbo].[usp_fidealessureste_catalogo_abc_fal_ofe_2010] (@sucursal int)
AS
/*
DECLARE @sucursal int
SET @sucursal = 5        --  5,  13 ,1
*/
DECLARE @bolsa1 VARCHAR(5), @bolsa2 VARCHAR(5), @bolsa3 VARCHAR(5)
--SET @bolsa1 = 'C2571'
SET @bolsa1 = 'XXPAD'
SET @bolsa2 = 'LIBRE'
SET @bolsa3 = 'ZFHYB'

DECLARE @dias int
SET @dias = 5

declare @descto DECIMAL(10,2)
SET @descto = 18

DECLARE @excepciones VARCHAR(50)
SET @excepciones = '9000605'

declare @descto_vol decimal (6,2)
declare @descto_neto decimal (6,2)
set @descto_vol = 3.5
set @descto_neto = 10


CREATE TABLE #catalogo_maestro_farmacias_idealessureste (
  tipoMov						VARCHAR(1)	  ,      --  1
  cod_barras        VARCHAR(20)	  ,      --  2
  clave_proveedor   VARCHAR(10)	  NOT NULL ,      --  3				(CODIGO)
  descripcion       VARCHAR(100)	,	     --  4
  desc_corta        VARCHAR(20)		,      --  5
  laboratorio       VARCHAR(50)		,		   --  7
  prec_farm         MONEY				  ,      --  9
  prec_pub          MONEY				  ,      --  10
  porc_iva          DECIMAL(5,2)  ,         --  11
  porc_ieps         DECIMAL(5,2)  ,         --  12
  porc_oferta       DECIMAL(5,2)  ,       --  13
  porc_financiero   DECIMAL(5,2)  ,   --  17
  unid_c_cargo      DECIMAL(5,2)  ,      --  18
  caduca            VARCHAR(1)	  ,              --  20
  refrigeracion     VARCHAR(1)	  ,       --  21
  devolucion        VARCHAR(1)	  ,          --  22
  c_ssa             VARCHAR(1)	  ,             --  23
  clas_fis          VARCHAR(10)		,
  desc_grupo_est    VARCHAR(50)		
--  familia VARCHAR(2),             --  6
--  presentacion VARCHAR(2),        --  8
--  unid_s_cargo      DECIMAL(5,2),      --  19
--  porc_oferta_2     DECIMAL(5,2),     --  15
--  escala_oferta_2   int,            --  16
--  escala_oferta     int,              --  14
--	bolsa							VARCHAR(5)
	PRIMARY KEY (clave_proveedor)
)


DECLARE @sep VARCHAR(1) 
SET @sep = '|'

SET @sep = ''


--  ALTAS
INSERT INTO #catalogo_maestro_farmacias_idealessureste   
  SELECT 
    'A' tipoMov,
    cod_barras_tandem,
    codigo AS clave_proveedor,
    descripcion,
    desc_corta,
    LEFT(lab_largo,50) laboratorio,
    CASE mpb.desc_grupo_est 
      WHEN 'PC01A' THEN mpb.prec_farm + (mpb.prec_farm * 0.5)  
      ELSE mpb.prec_farm  END prec_farm,
    CASE mpb.desc_grupo_est 
      WHEN 'PC1A'  THEN mpb.prec_pub + (mpb.prec_pub * 0.5)   
      ELSE mpb.prec_pub  END prec_pub,
    iva porc_iva,
    CASE mpb.grupo_est WHEN 'PC01A' THEN 50 ELSE 0 END porc_ieps,
    0 porc_oferta,	--	POR LA BURRADA
    CASE  WHEN clas_fis IN ('B','BA') THEN 18
          WHEN clas_fis IN ('N','NA') THEN 0
          WHEN clas_fis IN ('H','HA') THEN descto_prod END porc_financiero,
    1 unid_c_cargo,
    CASE WHEN clas_ssa IN ('1','2','3','4','5') THEN 1 ELSE 0 END caduca,
    LEFT(refrigerado,1) refrigeracion,
    '0' devolucion,
    clas_ssa c_ssa,
    clas_fis,
    desc_grupo_est
--    0 escala_oferta_2,
--    0 porc_oferta_2,
--    0 escala_oferta,
--    0 unid_s_cargo,
--    '00' presentacion,    
--    CASE WHEN clas_ssa IN ('1','2','3') THEN ' 2'
--       WHEN clas_ssa IN ('4','5'    ) THEN ' 1'
--       WHEN clas_ssa IN ('6','9'    ) THEN ' 4'
--       WHEN clas_ssa IN ('8'        ) THEN ' 5'
--       WHEN clas_ssa IN ('7'        ) THEN '13' ELSE '00' END familia,
  FROM maestro_productos_baan mpb
--  INNER JOIN dboferta ofe on mpb.codigo = ofe.codigo
  WHERE 
		mpb.codigo NOT IN (SELECT clave_proveedor FROM #catalogo_maestro_farmacias_idealessureste)
		AND datediff(d,fecha_alta,current_timestamp) <= 5 --  @dias
    AND isnumeric(mpb.cod_barras_tandem) = 1 
		AND LEFT(mpb.status,1) <> 'B'
    AND (CONVERT(bigINT, mpb.codigo) < dbo.gobierno() OR mpb.codigo IN (@excepciones))
    /*modificacion para omitir laboratorios 2013/03/05
    Abraham AMrcelino ramirez vega
    */
    and cod_lab not in ('0120','2334','2336','2441','0301')
--  BAJAS


INSERT INTO #catalogo_maestro_farmacias_idealessureste 
  SELECT 
    'B' tipoMov,
    cod_barras_tandem,
    codigo AS clave_proveedor,
    descripcion,
    desc_corta,
    LEFT(lab_largo,50) laboratorio,
    CASE mpb.desc_grupo_est 
      WHEN 'PC01A' THEN mpb.prec_farm + (mpb.prec_farm * 0.5)  
      ELSE mpb.prec_farm  END prec_farm,
    CASE mpb.grupo_est 
      WHEN 'PC1A'  THEN mpb.prec_pub + (mpb.prec_pub * 0.5)   
      ELSE mpb.prec_pub  END prec_pub,
    iva porc_iva,
    CASE mpb.grupo_est WHEN 'PC01A' THEN 50 ELSE 0 END porc_ieps,
    0 porc_oferta,	
    CASE  WHEN clas_fis IN ('B','BA') THEN 18
          WHEN clas_fis IN ('N','NA') THEN 0
          WHEN clas_fis IN ('H','HA') THEN descto_prod END porc_financiero,
    1 unid_c_cargo,
    CASE WHEN clas_ssa IN ('1','2','3','4','5') THEN 1 ELSE 0 END caduca,
    LEFT(refrigerado,1) refrigeracion,
    '0' devolucion,
    clas_ssa c_ssa,
    clas_fis,
    desc_grupo_est
--    0 escala_oferta,
--    0 porc_oferta_2,
--    0 escala_oferta_2,
--    0 unid_s_cargo,
--    '00' presentacion,    
--    'XX' familia,
  FROM maestro_productos_baan mpb
--  INNER JOIN cat_productos_idealessureste tor on mpb.cod_barras_tandem = tor.cod_barras_tandem
  WHERE mpb.codigo NOT IN (SELECT clave_proveedor FROM #catalogo_maestro_farmacias_idealessureste)
		AND DATEDIFF(d,fecha_baja,CURRENT_TIMESTAMP) <= 5 --  @dias
    AND ISNUMERIC(mpb.cod_barras_tandem) = 1 
		AND LEFT(mpb.status,1) <> 'B'
    AND (CONVERT(BIGINT, mpb.codigo) < dbo.gobierno() OR mpb.codigo IN (@excepciones))

--  CAMBIOS

CREATE TABLE #cambios (
  tipoMov VARCHAR(1),             --  2
  cod_barras VARCHAR(20),                 --  3
  clave_proveedor VARCHAR(10),            --  4
  descripcion VARCHAR(100),               --  5
  desc_corta VARCHAR(20),                 --  5
  laboratorio VARCHAR(50),
  prec_farm MONEY,                --  7
  prec_pub MONEY,                 --  6
  porc_iva  DECIMAL(5,2),
  porc_ieps DECIMAL(5,2),
  porc_oferta DECIMAL(5,2),
  porc_financiero DECIMAL(5,2),              --  9
  unid_c_cargo DECIMAL(5,2),
  caduca VARCHAR(1),
  refrigeracion VARCHAR(1),
  devolucion VARCHAR(1),
  c_ssa VARCHAR(1),             --  13
  clas_fis VARCHAR(10),
  desc_grupo_est VARCHAR(50),
  fecha_referencia datetime
--  familia VARCHAR(2),
--  presentacion VARCHAR(2),
--  unid_s_cargo DECIMAL(5,2),
--  escala_oferta int,                   --  8
--  porc_oferta_2 DECIMAL(5,2),
--  escala_oferta_2 int,
)



INSERT INTO #cambios
  SELECT 
    'C' tipoMov,
    cod_barras_tandem,
    codigo AS clave_proveedor,
    descripcion,
    desc_corta,
    LEFT(lab_largo,50) laboratorio,
    CASE mpb.grupo_est 
      WHEN 'PC01A' THEN mpb.prec_farm + (mpb.prec_farm * 0.5)  
      ELSE mpb.prec_farm  END prec_farm,
    CASE mpb.grupo_est 
      WHEN 'PC1A'  THEN mpb.prec_pub + (mpb.prec_pub * 0.5)   
      ELSE mpb.prec_pub  END prec_pub,
    iva porc_iva,
    CASE mpb.grupo_est WHEN 'PC01A' THEN 50 ELSE 0 END porc_ieps,
    0 porc_oferta,	
    CASE  WHEN clas_fis IN ('B','BA') THEN 18
          WHEN clas_fis IN ('N','NA') THEN 0
          WHEN clas_fis IN ('H','HA') THEN descto_prod END porc_financiero,
    1 unid_c_cargo,
    CASE WHEN clas_ssa IN ('1','2','3','4','5') THEN 1 ELSE 0 END caduca,
    LEFT(refrigerado,1) refrigeracion,
    '0' devolucion,
    clas_ssa c_ssa,
    clas_fis,
    desc_grupo_est,
    cpb.fecha_hora fecha_referencia
--    CASE WHEN clas_ssa IN ('1','2','3') THEN ' 2'
--         WHEN clas_ssa IN ('4','5'    ) THEN ' 1'
--         WHEN clas_ssa IN ('6','9'    ) THEN ' 4'
--         WHEN clas_ssa IN ('8'        ) THEN ' 5'
--         WHEN clas_ssa IN ('7'        ) THEN '13' ELSE '00' END familia,
--    '00' presentacion,    
--    0 unid_s_cargo,
--    0 escala_oferta,
--    0 porc_oferta_2,
--    0 escala_oferta_2,
FROM maestro_productos_baan mpb 
--INNER JOIN cat_productos_idealessureste tor on mpb.cod_barras_tandem = tor.cod_barras_tandem
INNER JOIN cambios_precio_baan cpb  ON mpb.codigo = cpb.t_item 
WHERE codigo NOT IN (SELECT clave_proveedor FROM #catalogo_maestro_farmacias_idealessureste)
	AND DATEDIFF(d, cpb.fecha_hora, CURRENT_TIMESTAMP) < 15 --@dias
  AND ISNUMERIC(mpb.cod_barras_tandem) = 1 
	AND LEFT(mpb.status,1) <> 'B'
  AND (CONVERT(BIGINT, mpb.codigo) < dbo.gobierno() OR mpb.codigo IN (@excepciones))



DECLARE @clave_proveedor VARCHAR(7) 
DECLARE @fecha_hora datetime 
DECLARE @cadena VARCHAR(200) 
DECLARE cursor_camb_precios CURSOR forward_only FOR 

SELECT DISTINCT clave_proveedor, MAX(fecha_referencia) 
FROM #cambios GROUP BY clave_proveedor 

OPEN cursor_camb_precios
FETCH NEXT FROM cursor_camb_precios INTO @clave_proveedor, @fecha_hora 
-------------------------------------------------------
WHILE @@fetch_status = 0 
BEGIN

	DELETE FROM #catalogo_maestro_farmacias_idealessureste 
		WHERE clave_proveedor = @clave_proveedor
		
  INSERT INTO #catalogo_maestro_farmacias_idealessureste 
    select
      tipoMov,
      cod_barras,
      clave_proveedor,
      descripcion,
      desc_corta,
      laboratorio,
      prec_farm,
      prec_pub,
      porc_iva,
      porc_ieps,
      porc_oferta,
      porc_financiero,
      unid_c_cargo,
      caduca,
      refrigeracion,
      devolucion,
      c_ssa,
      clas_fis,
      desc_grupo_est
--      familia,
--      presentacion,    
--      escala_oferta,
--      porc_oferta_2,
--      escala_oferta_2,
--      unid_s_cargo,
    from #cambios
    where clave_proveedor = @clave_proveedor AND fecha_referencia = @fecha_hora  

  FETCH NEXT FROM cursor_camb_precios INTO @clave_proveedor, @fecha_hora 
END 
-------------------------------------------------------
CLOSE cursor_camb_precios 
DEALLOCATE cursor_camb_precios





--  FALTANTES

INSERT INTO #catalogo_maestro_farmacias_idealessureste   
  SELECT 
    'F' tipoMov,
    cod_barras_tandem,
    mpb.codigo AS clave_proveedor,
    descripcion,
    desc_corta,
    LEFT(lab_largo,50) laboratorio,
    CASE mpb.desc_grupo_est 
      WHEN 'PC01A' THEN mpb.prec_farm + (mpb.prec_farm * 0.5)  
      ELSE mpb.prec_farm  END prec_farm,
    CASE mpb.desc_grupo_est 
      WHEN 'PC1A'  THEN mpb.prec_pub  + (mpb.prec_pub  * 0.5)   
      ELSE mpb.prec_pub  END prec_pub,
    iva porc_iva,
    CASE mpb.desc_grupo_est WHEN 'PC01A' THEN 50 ELSE 0 END porc_ieps,
    0 porc_oferta,	--	POR LA BURRADA
    CASE  WHEN clas_fis IN ('B','BA') THEN 18
          WHEN clas_fis IN ('N','NA') THEN 0
          WHEN clas_fis IN ('H','HA') THEN descto_prod END porc_financiero,
    1 unid_c_cargo,
    CASE WHEN clas_ssa IN ('1','2','3','4','5') THEN 1 ELSE 0 END caduca,
    LEFT(refrigerado,1) refrigeracion,
    '0' devolucion,
    clas_ssa c_ssa,
    clas_fis,
    desc_grupo_est
--    0 escala_oferta,
--    0 porc_oferta_2,
--    '00' presentacion,    
--    CASE WHEN clas_ssa IN ('1','2','3') THEN ' 2'
--         WHEN clas_ssa IN ('4','5'    ) THEN ' 1'
--         WHEN clas_ssa IN ('6','9'    ) THEN ' 4'
--         WHEN clas_ssa IN ('8'        ) THEN ' 5'
--         WHEN clas_ssa IN ('7'        ) THEN '13' ELSE '00' END familia,
--    0 unid_s_cargo,
--    0 escala_oferta_2,
  FROM maestro_productos_baan mpb
--  INNER JOIN dboferta ofe on mpb.codigo = ofe.codigo
  INNER JOIN inventario_baan i ON mpb.codigo = i.codigo AND i.sucursal = @sucursal AND i.piezas = 0
  WHERE mpb.codigo NOT IN (SELECT clave_proveedor FROM #catalogo_maestro_farmacias_idealessureste)
    AND ISNUMERIC(mpb.cod_barras_tandem) = 1 
		AND LEFT(mpb.status,1) <> 'B'		
    AND (CONVERT(bigINT, mpb.codigo) < dbo.gobierno() OR mpb.codigo IN (@excepciones))



------------------------------------------------------------------------------------------------
INSERT INTO #catalogo_maestro_farmacias_idealessureste   
  SELECT 
    ' ' tipoMov,
    cod_barras_tandem,
    mpb.codigo AS clave_proveedor,
    descripcion,
    desc_corta,
    LEFT(lab_largo,50) laboratorio,
    CASE mpb.desc_grupo_est 
      WHEN 'PC01A' THEN mpb.prec_farm + (mpb.prec_farm * 0.5)  
      ELSE mpb.prec_farm  END prec_farm,
    CASE mpb.grupo_est 
      WHEN 'PC1A'  THEN mpb.prec_pub  + (mpb.prec_pub  * 0.5)   
      ELSE mpb.prec_pub  END prec_pub,
    iva porc_iva,
    CASE mpb.grupo_est WHEN 'PC01A' THEN 50 ELSE 0 END porc_ieps,
    0 porc_oferta,	--	POR LA BURRADA
    CASE  WHEN clas_fis IN ('B','BA') THEN 18
          WHEN clas_fis IN ('N','NA') THEN 0
          WHEN clas_fis IN ('H','HA') THEN descto_prod END porc_financiero,
    1 unid_c_cargo,
    CASE WHEN clas_ssa IN ('1','2','3','4','5') THEN 1 ELSE 0 END caduca,
    LEFT(refrigerado,1) refrigeracion,
    '0' devolucion,
    clas_ssa c_ssa,
    clas_fis,
    desc_grupo_est
--    0 escala_oferta,
--    0 porc_oferta_2,
--    '00' presentacion,    
--    CASE WHEN clas_ssa IN ('1','2','3') THEN ' 2'
--         WHEN clas_ssa IN ('4','5'    ) THEN ' 1'
--         WHEN clas_ssa IN ('6','9'    ) THEN ' 4'
--         WHEN clas_ssa IN ('8'        ) THEN ' 5'
--         WHEN clas_ssa IN ('7'        ) THEN '13' ELSE '00' END familia,
--    0 unid_s_cargo,
--    0 escala_oferta_2,
  FROM maestro_productos_baan mpb
--  INNER JOIN dboferta ofe on mpb.codigo = ofe.codigo
  INNER JOIN inventario_baan i ON i.codigo = mpb.codigo AND i.sucursal = @sucursal 
  WHERE i.piezas > 0
    AND mpb.codigo NOT IN (SELECT clave_proveedor FROM #catalogo_maestro_farmacias_idealessureste)
    AND ISNUMERIC(mpb.cod_barras_tandem) = 1 
    AND (CONVERT(bigINT, mpb.codigo) < dbo.gobierno() OR mpb.codigo IN (@excepciones))
	--LEFT(mpb.status,1) <> 'B'

------------------------------------------------------------------------------------------------

	CREATE TABLE #fidealessureste_ofertas (
--	fecha							smalldatetime,
	sucursal						INT								,
	bolsa								VARCHAR( 5)				,
	codigo							VARCHAR( 7)				,
	cant_base						MONEY							,
	cant_oferta					MONEY							,
	porcentaje					MONEY							,
	vigencia_inicial		SMALLDATETIME			,
	vigencia_final			SMALLDATETIME			,
	disponible					INT								,
	timestamp						DATETIME
	primary key (codigo) )
	
	INSERT INTO #fidealessureste_ofertas
	EXECUTE usp_constructor_ofertas 'FIDEALESSURESTE', @sucursal
	
-----------------------------------------------------------------------------------------------
UPDATE #catalogo_maestro_farmacias_idealessureste SET 
	porc_oferta = porcentaje * 100
FROM #catalogo_maestro_farmacias_idealessureste cat
INNER JOIN #fidealessureste_ofertas ofe ON ofe.sucursal = @SUCURSAL AND cat.clave_proveedor = ofe.codigo 
WHERE tipoMov <> 'F'

--  RESULTADO FINAL
SELECT										--		 TOP 5000
  tipoMov																														,                                          --   1
  RIGHT(REPLICATE(' ', 20) + CONVERT(VARCHAR,CONVERT(BIGINT,cod_barras))		   , 20)	codigoBarras		,                                          --   2
  LEFT(clave_proveedor + REPLICATE(' ', 10), 10)	cveInternaProv			,                                          --   3
  LEFT(descripcion	   + REPLICATE(' ',100),100)	descripcion		,                                          --   4
  LEFT(desc_corta      + REPLICATE(' ', 20), 20)	descCorta		,                                          --   5
--  REPLICATE(' ', 2) + --@SEP +                                                                       --   
  LEFT(laboratorio     + REPLICATE(' ', 50), 50)	nombreLab		,                                          --   6
  RIGHT(REPLICATE(' ',12) + CONVERT(VARCHAR, CONVERT(DECIMAL(12,2),prec_farm      ) )  , 12 )		pcioFarmacia,  --  7
  RIGHT(REPLICATE(' ',12) + CONVERT(VARCHAR, CONVERT(DECIMAL(12,2),prec_pub       ) )  , 12 )		pcioMaxPub,  --  8
  RIGHT(REPLICATE(' ', 5) + CONVERT(VARCHAR, CONVERT(DECIMAL(12,2),porc_iva * 100 ) )  ,  5 )		porcIVA,  --  9
  RIGHT(REPLICATE(' ', 5) + CONVERT(VARCHAR, CONVERT(DECIMAL(12,2),porc_ieps      ) )  ,  5 )		porcIEPS,  --  10
  RIGHT(REPLICATE(' ', 5) + CONVERT(VARCHAR, CONVERT(DECIMAL(12,2),porc_oferta    ) )  ,  5 )		porcOferta,  --  11
  RIGHT(REPLICATE(' ', 5) + CONVERT(VARCHAR, CONVERT(DECIMAL(12,2),porc_financiero) )  ,  5 )		porcFinanciero,		--  12
  RIGHT(REPLICATE(' ', 7) + CONVERT(VARCHAR, CONVERT(DECIMAL(12,2),unid_c_cargo   ) )  ,  7 )		unidConCargo,			--  13
  caduca																																												caducable,        --  14
  CASE WHEN LEFT(refrigeracion,1) = 'R' THEN '1' ELSE '0' END																		refrigerado,      --  15
  CASE WHEN f.aplica_cast_caduc = 'SI' THEN '1' ELSE '0' END																						devolvible,	    --  16
  c_ssa																																													clasifSSA,			  --  17
  CASE WHEN i.piezas BETWEEN     1 AND  300  THEN '1'																							                --  18
       WHEN i.piezas BETWEEN   301 AND  600  THEN '2'
       WHEN i.piezas BETWEEN   601 AND  900  THEN '3'
       WHEN i.piezas BETWEEN   901 AND 1200  THEN '4'
       WHEN i.piezas >        1200           THEN '5'
       ELSE '0' END																																							cveExistencia, 
  RIGHT(REPLICATE(' ', 5) + CONVERT(VARCHAR, CONVERT(DECIMAL(12,2),CASE WHEN clas_fis IN ('B','BA')		THEN @descto_vol	ELSE 0 END ) )  ,  5 )  DesctoVolumen,  --  19
  RIGHT(REPLICATE(' ', 5) + CONVERT(VARCHAR, CONVERT(DECIMAL(12,2),CASE WHEN f.porc_convenio_lab_extra		IS NOT NULL THEN f.porc_convenio_lab_extra		ELSE 0 END ) )  ,  5 )  DescLimitados,  --  20
  RIGHT(REPLICATE(' ', 5) + CONVERT(VARCHAR, CONVERT(DECIMAL(12,2),0 ) ) ,  5 )																																	DescLab,  --  21      PENDIENTE POR RECIBIR POR EL USUARIO
  RIGHT(REPLICATE(' ', 5) + CONVERT(VARCHAR, CONVERT(DECIMAL(12,2),CASE WHEN f.porc_cast_caduc IS NOT NULL THEN f.porc_cast_caduc ELSE 0 END  ) )  ,  5 ) DevCaducidad,	--  22
  CASE                                                                                                  --  22
    WHEN i.sucursal =  5 THEN '1' 
    WHEN i.sucursal = 13 THEN '2'
    WHEN i.sucursal =  1 THEN '3'
    WHEN i.sucursal =  4 THEN '4'
    ELSE '0' END																																								idZona, 
--	LEFT(ge.descripcion + REPLICATE(' ',50),50)																									ClasifTerapeutica	--  24
	LEFT(desc_grupo_est + REPLICATE(' ',50),50)																									ClasifTerapeutica	--  24
--  presentacion ,
--  LEFT(familia + REPLICATE(' ',2) ,2) , 
--  RIGHT(REPLICATE(' ', 7) + CONVERT(VARCHAR, CONVERT(DECIMAL(12,2),unid_s_cargo   ) )  ,  7 ) , 
--  RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR, CONVERT(int,escala_oferta  ) )  ,  6 ) , 
--  RIGHT(REPLICATE(' ', 4) + CONVERT(VARCHAR, CONVERT(int,escala_oferta_2) )  ,  4 ) , 
--  RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR, CONVERT(DECIMAL(12,2),porc_oferta_2  ) )  ,  6 ) , 
FROM #catalogo_maestro_farmacias_idealessureste u
--	LEFT OUTER JOIN maestro_grupos_estadisticos_baan ge ON U.desc_grupo_est = ge.desc_grupo_est
INNER JOIN catalogo_productos_fidealessureste f ON u.clave_proveedor = f.codigo
--	LEFT OUTER JOIN cat_prod_f_idealessureste F ON u.cod_barras_tandem = f.cod_barras_tandem
--	LEFT OUTER JOIN castigos_f_idealessureste H ON H.cod_barras_tandem = f.cod_barras_tandem
LEFT OUTER JOIN inventario_baan i ON u.clave_proveedor = i.codigo AND i.sucursal = @sucursal
--CONVERT(bigint,u.cod_barras_tandem) = CONVERT(bigint,f.cod_barras_tandem) AND isnumeric(f.cod_barras_tandem) = 1
--order by tipoMov
order by u.clave_proveedor


--DROP TABLE #cambios
DROP TABLE #catalogo_maestro_farmacias_idealessureste

GO

