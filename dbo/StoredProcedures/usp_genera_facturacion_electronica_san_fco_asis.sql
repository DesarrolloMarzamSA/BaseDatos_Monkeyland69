--  FACTURACION ELECTRONICA SAN FRANCISCO DE ASIS
--  GUADALAJARA Y METRO NORTE
--	27-FEB-2009			CREACION
--  18-JUN-2012			MODIFICACION:	SUPRIMIR SEGMENTO

CREATE PROCEDURE [dbo].[usp_genera_facturacion_electronica_san_fco_asis] (@sucursal INT , @FECHA VARCHAR(10))
AS

/*
DECLARE @sucursal INT
SET @SUCURSAL = 3
DECLARE @FECHA VARCHAR(10)
SET @FECHA = '2009-09-09'
*/

DECLARE @SEP VARCHAR(1)
SET @SEP = '|'
SET @SEP = ''
DECLARE @cliente VARCHAR(7)
DECLARE @Factura VARCHAR(10)
DECLARE @orden INT
DECLARE @contador INT
SET @contador = 1

-- PRINT 'COPIA TEMPORAL'

CREATE TABLE #facturacion_electronica_san_francisco_asis  (
  col1 VARCHAR(500),contador INT  )
-- PRINT 'CREA TABLA FINAL'
---------------------------------------------------------------------------------------
CREATE TABLE #primer_renglon_sf  (      
  primer_iden             VARCHAR(1),   
  proveedor               VARCHAR(5),   
  fecha_disco             VARCHAR(6),   
  total_registros         VARCHAR(6)  ) 
-- PRINT 'CREA TABLA PRIMER RENGLON "C"'
---------------------------------------------------------------------------------------
CREATE TABLE #encab_sanfco  (  
  registro                VARCHAR(1),   
  factura                 VARCHAR(10),  
  factura_tienda          VARCHAR(3),   
  factura_sec_depto       VARCHAR(3),   
  fecha_entrega           VARCHAR(6),   
  importe_a_pagar         MONEY,        
  importe_descuento       MONEY,        
  importe_total           MONEY,        
  importe_iva             MONEY,        
  importe_ieps            MONEY,        
  total_productos         INT,          
  ceros                   VARCHAR(18),  
  cliente                 VARCHAR(9),   
  sucursal                INT,
  contador                INT       )
-- PRINT 'CREA TABLA ENCABEZADO '

CREATE TABLE #registro_adicional_sfco ( 
  indica                VARCHAR(1),     
  venta_tasa_0          MONEY,          
  descuento_tasa_0      MONEY,          
  venta_tasa_10         MONEY,          
  iva_tasa_10           MONEY,          
  descuento_venta_10    MONEY,          
  iva_descto_vta_10     MONEY,          
  iva_global            MONEY,          
  iva_descto_global     MONEY,          
  numero_de_bolsas      INT,            
  numero_de_bultos      INT,            
  ceros                 VARCHAR(11),    
  contador              INT )
-- PRINT 'CREA TABLA REGISTRO ADICIONAL'
---------------------------------------------------------------------------------------
CREATE TABLE #detalle_sfco_asis (       
  factura                  VARCHAR(10),
  articulo                 VARCHAR(1),   
  cod_sanfco               VARCHAR(8),   
  can_sanfco               INT,          
  oferta                   INT,          
  porcentaje_descto_oferta INT,          
  precio_farm_sin_imp      MONEY,        
  precio_pub_con_imp       MONEY,        
  imp_farmacia_por_renglon MONEY,        
  imp_publico_por_renglon  MONEY,        
  imp_iva_por_renglon      MONEY,        
  imp_ieps_por_renglon     MONEY,        
  ceros                    VARCHAR(15),  
  aemecop                  VARCHAR(14),  
  margen_utilitario        INT,          
  clas_fis                 VARCHAR(2),   
  referencia               VARCHAR(2),   
  venta_neta               VARCHAR(2),   
  contador                 INT )
-- PRINT 'CREA TABLA DETALLE'
--------------------------------------------------------------------------------------------
SELECT
	F.sucursal,
	F.cliente,
--	F.digito_verificador,
	F.serie,
	F.factura,
	F.fecha_factura,
	F.codigo,
	F.descripcion,
	F.cod_barras,
	F.clas_fis,
	F.piezas_surtidas_con_cargo,
--	F.piezas_surtidas_sin_cargo,
	F.precio_farm_sin_imp,
	F.precio_pub_sin_imp,
	F.precio_pub_con_imp,
	F.importe_bruto,
	F.porcentaje_descto_oferta,
	F.descto_oferta,
	F.porcentaje_descto_comercial,
	F.descto_comercial,
	F.ieps,
	F.iva,
	F.bonificacion_iva,
	F.porcentaje_utilidad,
	F.importe_neto,
--	F.orden,
	F.porcentaje_iva,
--	F.filler,
--	F.no_registro,
--	F.desc_comerc_prod,
--	F.porcentaje_iva2,
--	F.iva2,
--	F.bonificacion_iva2,
	F.porcentaje_ieps,
	F.desc_comerc_ieps,
	F.iva_del_iesps,
--	F.bonificacion_iva_del_iesps,
--	F.TIMESTAMP,
--	F.segto,
--	F.ctepadre,
--	F.rfc,
--	F.tipo_documento,
	F.folio_fiscal 
INTO #sfco_hoy --select *
FROM facturacion_electronica_estandar f
WHERE  ctepadre = '231'
   and convert(varchar,f.fecha_factura,112) >= convert(varchar,getdate()-8,112)
  ORDER by factura,orden


IF (SELECT COUNT(*) FROM #sfco_hoy) > 0
	INSERT INTO #primer_renglon_sf  
		SELECT 
			'C' AS primer_iden,
			REPLICATE('0',5) AS proveedor,
			SUBSTRING(@FECHA,3,2)+SUBSTRING(@FECHA,6,2)+SUBSTRING(@FECHA,9,2) AS fecha_disco,
			REPLICATE('0', 6) AS total_registros  
---------------------------------------------------------------------------------------

-----------------------------------------------------------------------
----------------	SELECT * FROM #sfco_hoy

DECLARE  cur_encabezados CURSOR forward_only FOR 
SELECT --	DISTINCT
  factura,cliente
FROM #sfco_hoy 
GROUP BY factura,cliente
ORDER BY factura,cliente
-- PRINT 'CREA CURSOR ENCABEZADO'


DECLARE @importe						DECIMAL(14,2)
DECLARE @p_iva							DECIMAL(14,2)
DECLARE @descto_comercial		DECIMAL(14,2)
DECLARE @iva								DECIMAL(14,2)


OPEN cur_encabezados
FETCH NEXT FROM cur_encabezados INTO @factura,@cliente 
WHILE @@FETCH_STATUS = 0
BEGIN
	SET @importe = 0
	SET @p_iva = 0

--  PRINT 'FACTURA: '+@factura

  SELECT * INTO #TMP_FACTURA
    FROM #sfco_hoy
    WHERE factura = @factura AND cliente = @cliente
--    SELECT * FROM #TMP_FACTURA

  INSERT INTO #encab_sanfco 
    SELECT 
      'F' AS registro,
      @factura,
      REPLICATE('0', 3) AS factura_tienda,
      REPLICATE('0', 3) AS factura_sec_depto,
      SUBSTRING(@FECHA,3,2)+SUBSTRING(@FECHA,6,2)+SUBSTRING(@FECHA,9,2) AS fecha_entrega,
      (SELECT SUM(importe_neto                    ) suma FROM #TMP_FACTURA) AS importe_a_pagar,
      (SELECT SUM(descto_comercial                ) suma FROM #TMP_FACTURA) AS importe_descuento,
      (SELECT SUM(importe_neto + descto_comercial ) suma FROM #TMP_FACTURA) AS importe_total,
      (SELECT SUM(iva															) suma FROM #TMP_FACTURA) AS importe_iva,	
      (SELECT SUM(ieps                            ) suma FROM #TMP_FACTURA) AS importe_ieps,
      (SELECT SUM(piezas_surtidas_con_cargo       ) suma FROM #TMP_FACTURA) AS total_productos,
      REPLICATE('0',18) AS ceros,
      @cliente,
      @sucursal,
      @contador
  PRINT 'inserta encabezado '+@factura


	SET @importe =					(SELECT SUM(importe_bruto - descto_oferta + bonificacion_iva ) suma FROM #TMP_FACTURA)
	SET @p_iva =						(SELECT MAX(porcentaje_iva)		FROM #TMP_FACTURA )
	SET @descto_comercial = (SELECT SUM(descto_comercial) FROM #TMP_FACTURA)
	SET @iva =							(SELECT SUM(iva) suma					FROM #TMP_FACTURA)

  INSERT INTO #registro_adicional_sfco 
    SELECT 
      'A' AS indica,
      (CASE WHEN @p_iva =  0 THEN @importe					ELSE 0 END) AS venta_tasa_0,				
      (CASE WHEN @p_iva =  0 THEN @descto_comercial	ELSE 0 END) AS descuento_tasa_0,    
			(CASE WHEN @p_iva >  0 THEN @importe					ELSE 0 END) AS venta_tasa_10,				
      (CASE WHEN @p_iva >  0 THEN @iva							ELSE 0 END) AS iva_tasa_10,         
      (CASE WHEN @p_iva >  0 THEN @descto_comercial	ELSE 0 END) AS descuento_venta_10,  
      (CASE WHEN @p_iva =  0 THEN 0									ELSE 0 END) AS iva_descto_vta_10,   
      @iva																											AS iva_global,					
      0																													AS iva_descto_global,		
      0																													AS numero_de_bolsas,		
      0																													AS numero_de_bultos,		
      REPLICATE('0',11) AS ceros,																												
      @contador
  -- PRINT 'inserta registro adicional '

  INSERT INTO #detalle_sfco_asis
    SELECT 
      FACTURA,
      'P'                         AS articulo,                    
      codigo                      AS cod_sfco,                    
      piezas_surtidas_con_cargo   AS can_sfco,                    
      0							               AS oferta,                      
      porcentaje_descto_oferta    AS porcentaje_descto_oferta,    
      precio_farm_sin_imp,                                        
      precio_pub_con_imp,                                         
      importe_bruto               AS imp_farmacia_por_renglon,    
      piezas_surtidas_con_cargo * precio_pub_con_imp          AS imp_publico_por_renglon,     
      iva                         AS imp_iva_por_renglon,         
      ieps                        AS imp_ieps_por_renglon,        
      REPLICATE('0',15)           AS ceros,                       
      cod_barras                  AS aemecop,                     
      CASE WHEN precio_pub_con_imp = 0       THEN 0   ELSE 
        (1- (precio_farm_sin_imp / precio_pub_sin_imp )) * 100  END AS margen_utilitario,           
      CASE WHEN clas_fis IN ('BA','NA','HA') THEN '1' ELSE '0' END AS clas_fis,                                                   
      CASE WHEN clas_fis IN ('BA','NA','HA') THEN '1' ELSE '0' END AS referencia,
      CASE WHEN clas_fis IN ('N' ,'NA','L' ) THEN '1' ELSE '0' END AS venta_neta,
      @contador
    FROM #TMP_FACTURA
  -- PRINT 'INSERTA EL detalle '+@factura

    FETCH NEXT FROM cur_encabezados INTO @factura,@cliente
    set @contador = @contador + 1
    DROP TABLE #TMP_FACTURA

		--	IF @CONTADOR = 368  BREAK
end

/*           
          IF DEF-PRECIO-PUBLICO > ZEROS
             COMPUTE W-MARGEN = (1 - ( W-PRECIO-FARMACIA /
                                       DEF-PRECIO-PUBLICO )) * 100
          ELSE
             MOVE ZEROS TO W-MARGEN.

             MOVE W-MARGEN             TO MARGEN-UNITARIO       OF REG-FCO-SAL.

          IF DEF-CLASIFICACION-FISCAL = "BA" OR "NA" OR "HA"
             MOVE "1"                  TO CLASIFICACION-FISCAL  OF REG-FCO-SAL
          ELSE
             MOVE ZERO                 TO CLASIFICACION-FISCAL  OF REG-FCO-SAL.

             MOVE ZERO                 TO REFERENCIA            OF REG-FCO-SAL.
          IF DEF-CLASIFICACION-FISCAL = "N " OR "NA" OR "L "
             MOVE "1"                  TO VENTA-NETA            OF REG-FCO-SAL
          ELSE
             MOVE ZERO                 TO VENTA-NETA            OF REG-FCO-SAL.
*/

CLOSE cur_encabezados
DEALLOCATE cur_encabezados

INSERT INTO #facturacion_electronica_san_francisco_asis
  SELECT 
    primer_iden + @sep + 
    proveedor + @sep +
    fecha_disco + @sep + 
    total_registros,0
  FROM #primer_renglon_sf
  -- PRINT 'inserta primer renglon en la salida '

DECLARE @no_facturas INT
SET @no_facturas = @contador
SET @contador = 1

WHILE @contador < @no_facturas
BEGIN
  INSERT INTO #facturacion_electronica_san_francisco_asis
    SELECT  
      registro  + @sep + 
      RIGHT(REPLICATE('0',10) + right(factura,7)                             ,10) + @sep + 
      factura_tienda + @sep + 
      factura_sec_depto + @sep + 
      fecha_entrega + @sep + 
      RIGHT(REPLICATE('0',12) + CONVERT(VARCHAR,importe_a_pagar    ),12)+ @sep + 
      RIGHT(REPLICATE('0',12) + CONVERT(VARCHAR,importe_descuento  ),12)+ @sep + 
      RIGHT(REPLICATE('0',12) + CONVERT(VARCHAR,importe_total      ),12)+ @sep + 
      RIGHT(REPLICATE('0',12) + CONVERT(VARCHAR,importe_iva        ),12)+ @sep + 
      RIGHT(REPLICATE('0',12) + CONVERT(VARCHAR,importe_ieps       ),12)+ @sep + 
      RIGHT(REPLICATE('0', 6) + CONVERT(VARCHAR,total_productos    ), 6)+ @sep + 
      ceros + @sep + 
      cliente,
      @contador
--      RIGHT(REPLICATE('0',11) + CONVERT(VARCHAR,descuento_tasa_10  ),11) + @sep +
    FROM #encab_sanfco
    WHERE contador = @contador


  INSERT INTO #facturacion_electronica_san_francisco_asis
    SELECT  
      indica                                                            + @sep + 
      RIGHT(REPLICATE('0',11) + CONVERT(VARCHAR,venta_tasa_0       ),11) + @sep +
      RIGHT(REPLICATE('0',11) + CONVERT(VARCHAR,descuento_tasa_0   ),11) + @sep +
      RIGHT(REPLICATE('0',11) + CONVERT(VARCHAR,venta_tasa_10      ),11) + @sep +
      RIGHT(REPLICATE('0',11) + CONVERT(VARCHAR,iva_tasa_10        ),11) + @sep +
      RIGHT(REPLICATE('0',11) + CONVERT(VARCHAR,descuento_venta_10 ),11) + @sep +
      RIGHT(REPLICATE('0',11) + CONVERT(VARCHAR,iva_descto_vta_10  ),11) + @sep +
      RIGHT(REPLICATE('0',12) + CONVERT(VARCHAR,iva_global         ),12) + @sep +
      RIGHT(REPLICATE('0',12) + CONVERT(VARCHAR,iva_descto_global  ),12) + @sep +
      RIGHT(REPLICATE('0', 4) + CONVERT(VARCHAR,numero_de_bolsas   ), 4) + @sep +
      RIGHT(REPLICATE('0', 5) + CONVERT(VARCHAR,numero_de_bultos   ), 5) + @sep +
      ceros,    
      contador
    FROM #registro_adicional_sfco 
    WHERE contador = @contador
  -- PRINT 'inserta primer renglon en la salida '

  INSERT INTO #facturacion_electronica_san_francisco_asis
    SELECT  
      articulo + @sep +                                    
      RIGHT(REPLICATE('0', 8) + cod_sanfco                               , 8) + @sep +   
      RIGHT(REPLICATE('0', 6) + CONVERT(VARCHAR,can_sanfco)              , 6) + @sep +   
      RIGHT(REPLICATE('0', 6) + CONVERT(VARCHAR,oferta)                  , 6) + @sep +   
      RIGHT(REPLICATE('0', 5) + CONVERT(VARCHAR,porcentaje_descto_oferta), 5) + @sep +   
      RIGHT(REPLICATE('0', 8) + CONVERT(VARCHAR,precio_farm_sin_imp)     , 8) + @sep +   
      RIGHT(REPLICATE('0', 8) + CONVERT(VARCHAR,precio_pub_con_imp)      , 8) + @sep +   
      RIGHT(REPLICATE('0', 8) + CONVERT(VARCHAR,imp_farmacia_por_renglon), 8) + @sep +   
      RIGHT(REPLICATE('0', 8) + CONVERT(VARCHAR,imp_publico_por_renglon) , 8) + @sep +   
      RIGHT(REPLICATE('0', 8) + CONVERT(VARCHAR,imp_iva_por_renglon)     , 8) + @sep +   
      RIGHT(REPLICATE('0', 8) + CONVERT(VARCHAR,imp_ieps_por_renglon)    , 8) + @sep +   
      ceros                                                                   + @sep +   
      RIGHT(REPLICATE('0',14) + aemecop                                  ,14) + @sep +   
      RIGHT(REPLICATE('0', 4) + CONVERT(VARCHAR,margen_utilitario)       , 4) + @sep +   
      clas_fis                                                                + @sep +   
      referencia                                                              + @sep +
      CONVERT(VARCHAR,venta_neta),
      contador
    FROM #detalle_sfco_asis
    WHERE contador = @contador
  -- PRINT 'inserta detalle en la salida '

  SET @contador = @contador + 1
END

--	SELECT * FROM #primer_renglon_sf 
--	SELECT * FROM #encab_sanfco 
--	SELECT * FROM #registro_adicional_sfco 
--	SELECT * FROM #detalle_sfco_asis  
--	SELECT * FROM #sfco_hoy 


SELECT col1 FROM #facturacion_electronica_san_francisco_asis 

DROP TABLE #detalle_sfco_asis
DROP TABLE #primer_renglon_sf
DROP TABLE #registro_adicional_sfco

DROP TABLE #encab_sanfco
DROP TABLE #facturacion_electronica_san_francisco_asis
DROP TABLE #sfco_hoy

GO

