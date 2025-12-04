CREATE PROCEDURE [dbo].[usp_genera_catalogo_a_b_c_fcias_las_torres]
as

DECLARE @sep VARCHAR(1) 
DECLARE @dias INT
set @sep = '|'
set @dias = 5
DECLARE @mayorista VARCHAR(10)
SET @mayorista = 'P00002'


DECLARE @descuento decimal
SELECT @descuento = descuento FROM clientes_baan where sucursal = 1 and cliente = '19130'

CREATE TABLE #catalogo_maestro_farmacias_torres (
  mayorista VARCHAR(10),          
  status VARCHAR(1),              
  cod_barras VARCHAR(20),         
  cod_torres VARCHAR(10),         
  farmaceutico VARCHAR(1),
  descripcion VARCHAR(100),        
  prec_pub MONEY,                 
  prec_farm MONEY,                
  descto MONEY,                   
  descto2 MONEY,              
  descto3 MONEY,              
  p_costo MONEY,
  iva MONEY,                      
  unidad VARCHAR(7),              
  fecha_referencia DATETIME,      
  codigo VARCHAR(7) )             


INSERT INTO #catalogo_maestro_farmacias_torres   
  SELECT --TOP 1
    @mayorista mayorista,
    'A' status,
    tor.cod_barras,
    cod_torres,
    CASE tipo_prod WHEN '00' THEN '1' ELSE '0' END farmaceutico,
    tor.descripcion,
    CASE mpb.grupo_est 
      WHEN 'PC1A'  THEN mpb.prec_pub + (mpb.prec_pub * 0.5) * 100  
      ELSE mpb.prec_pub * 100 END prec_pub,
    CASE mpb.grupo_est 
      WHEN 'PC01A' THEN mpb.prec_farm + (mpb.prec_farm * 0.5) * 100 
      ELSE mpb.prec_farm * 100 END prec_farm,
    CASE
			WHEN mpb.clas_fis = 'B'		THEN @descuento
			WHEN mpb.clas_fis = 'BA'	THEN @descuento
			WHEN mpb.clas_fis = 'N'		THEN 0
			WHEN mpb.clas_fis = 'NA'	THEN 0
			WHEN mpb.clas_fis = 'H'		THEN mpb.descto_prod
			WHEN mpb.clas_fis = 'HA'	THEN mpb.descto_prod END * 100 descto,
    0 descto2,
    0 descto3,
    0 p_costo,
    iva * 100 iva,
    tor.unidad , 
    fecha_alta, 
    codigo
  FROM maestro_productos_baan mpb
  INNER JOIN cat_productos_torres tor on CONVERT(BIGINT,mpb.cod_barras) = CONVERT(BIGINT,tor.cod_barras)
  WHERE datediff(d,fecha_alta,current_timestamp) <= @dias
    AND ISNUMERIC(mpb.cod_barras) = 1 
    AND CONVERT(INT, mpb.codigo) < dbo.gobierno()


INSERT INTO #catalogo_maestro_farmacias_torres 
  SELECT 
    @mayorista mayorista,
    'B' status,
    tor.cod_barras,
    cod_torres,
    CASE tipo_prod WHEN '00' THEN '1' ELSE '0' END farmaceutico,
    tor.descripcion,
    0 prec_pub,
    0 prec_farm,
    0 descto,
    0 descto2,
    0 descto3,
    0 p_costo,
    0 iva,
    tor.unidad  ,
    fecha_baja fecha_referencia,
    codigo
  FROM maestro_productos_baan mpb
  INNER JOIN cat_productos_torres tor on CONVERT(BIGINT,mpb.cod_barras) = CONVERT(BIGINT,tor.cod_barras)
  WHERE datediff(d,fecha_baja,current_timestamp) <= @dias
    AND ISNUMERIC(mpb.cod_barras) = 1 
    AND CONVERT(INT, mpb.codigo) < dbo.gobierno()


CREATE TABLE #cambios (
  mayorista VARCHAR(10),        
  status VARCHAR(1),            
  cod_barras VARCHAR(20),       
  cod_torres VARCHAR(10),       
  farmaceutico VARCHAR(1),
  descripcion VARCHAR(100),      
  prec_pub MONEY,               
  prec_farm MONEY,              
  descto MONEY,                 
  descto2 MONEY,            
  descto3 MONEY,
  p_costo MONEY,
  iva MONEY,                    
  unidad VARCHAR(7),            
  fecha_referencia DATETIME,    
  codigo VARCHAR(7) )           


INSERT INTO #cambios
  SELECT 
    @mayorista mayorista,                                     
    'C' status,                                             
    tor.cod_barras,                                         
    cod_torres,                                             
    CASE tipo_prod WHEN '00' THEN '1' ELSE '0' END farmaceutico,
    tor.descripcion,                                        
    CASE mpb.grupo_est 
      WHEN 'PC1A'  THEN mpb.prec_pub + (mpb.prec_pub * 0.5) * 100  
      ELSE mpb.prec_pub * 100 END prec_pub,                 
    CASE mpb.grupo_est 
      WHEN 'PC01A' THEN mpb.prec_farm + (mpb.prec_farm * 0.5) * 100 
      ELSE mpb.prec_farm * 100 END prec_farm,               
    CASE 
			WHEN mpb.clas_fis = 'B'		THEN @descuento
			WHEN mpb.clas_fis = 'BA'	THEN @descuento
			WHEN mpb.clas_fis = 'N'		THEN 0
			WHEN mpb.clas_fis = 'NA'	THEN 0
			WHEN mpb.clas_fis = 'H'		THEN mpb.descto_prod
			WHEN mpb.clas_fis = 'HA'	THEN mpb.descto_prod END * 100 descto,
    0 descto2,                          
    0 descto3,
    0 p_costo,        
    iva * 100 iva,                                          
    tor.unidad  ,                                           
    cpb.fecha_hora fecha_referencia,                        
    codigo                                                  
FROM maestro_productos_baan mpb 
INNER JOIN cambios_precio_baan cpb  ON mpb.codigo = cpb.t_item 
INNER JOIN cat_productos_torres tor ON CONVERT(BIGINT,mpb.cod_barras) = CONVERT(BIGINT,tor.cod_barras)
WHERE datediff(d, cpb.fecha_hora, CURRENT_TIMESTAMP) < 3 
  AND ISNUMERIC(mpb.cod_barras) = 1 
  AND CONVERT(INT, mpb.codigo) < dbo.gobierno()

DECLARE @codigo VARCHAR(7) 
DECLARE @fecha_hora DATETIME 
DECLARE @cadena VARCHAR(200) 
DECLARE cur_codigos CURSOR fast_forward FOR 

SELECT DISTINCT codigo, MAX(fecha_referencia) 
FROM #cambios GROUP BY codigo 

OPEN cur_codigos
FETCH NEXT FROM cur_codigos INTO @codigo, @fecha_hora 
-------------------------------------------------------
WHILE @@fetch_status = 0 
BEGIN
  INSERT INTO #catalogo_maestro_farmacias_torres 
    SELECT
      mayorista,        
      status,           
      cod_barras,       
      cod_torres,       
      farmaceutico,
      descripcion,      
      prec_pub,         
      prec_farm,        
      descto,           
      descto2,      
      descto3,
      0 p_costo,          
      iva,              
      unidad,           
      fecha_referencia, 
      codigo            
    FROM #cambios
    where codigo = @codigo AND fecha_referencia = @fecha_hora  

  FETCH NEXT FROM cur_codigos INTO @codigo, @fecha_hora 
END 
-------------------------------------------------------
CLOSE cur_codigos 
DEALLOCATE cur_codigos

INSERT INTO #catalogo_maestro_farmacias_torres   
  SELECT 
    @mayorista mayorista,
    ' ' status,
    tor.cod_barras,
    cod_torres,
    CASE tipo_prod WHEN '00' THEN '1' ELSE '0' END farmaceutico,
    tor.descripcion,
    CASE mpb.grupo_est 
      WHEN 'PC1A'  THEN mpb.prec_pub + (mpb.prec_pub * 0.5) * 100  
      ELSE mpb.prec_pub * 100 END prec_pub,
    CASE mpb.grupo_est 
      WHEN 'PC01A' THEN mpb.prec_farm + (mpb.prec_farm * 0.5) * 100 
      ELSE mpb.prec_farm * 100 END prec_farm,
		CASE 
			WHEN mpb.clas_fis = 'B'		THEN @descuento
			WHEN mpb.clas_fis = 'BA'	THEN @descuento
			WHEN mpb.clas_fis = 'N'		THEN 0
			WHEN mpb.clas_fis = 'NA'	THEN 0
			WHEN mpb.clas_fis = 'H'		THEN mpb.descto_prod
			WHEN mpb.clas_fis = 'HA'	THEN mpb.descto_prod END * 100 descto,
    0 descto2,
    0 descto3,
    0 p_costo,
    iva * 100 iva,
    tor.unidad , 
    fecha_alta, 
    codigo
  FROM maestro_productos_baan mpb
  INNER JOIN cat_productos_torres tor on CONVERT(BIGINT,mpb.cod_barras) = CONVERT(BIGINT,tor.cod_barras)
  WHERE tor.cod_torres NOT IN 
			(SELECT cod_torres FROM #catalogo_maestro_farmacias_torres)
		AND ISNUMERIC(mpb.cod_barras) = 1 
    AND CONVERT(INT, mpb.codigo) < dbo.gobierno()

UPDATE #catalogo_maestro_farmacias_torres
SET descto2 = dbo.porcentaje * 10000
FROM #catalogo_maestro_farmacias_torres tor
INNER JOIN dboferta dbo ON dbo.codigo = tor.codigo AND sucursal = 1 AND dbo.BOLSA = 'LIBRE'
--WHERE tor.status <> 'B'


/*
UPDATE #catalogo_maestro_farmacias_torres SET 
	descto2 = dbo.porcentaje * 10000,
	p_costo = 0
FROM #catalogo_maestro_farmacias_torres tor
INNER JOIN dboferta dbo ON tor.codigo = dbo.codigo AND dbo.sucursal = 1 AND dbo.bolsa = 'LIBRE'
*/

--	SELECT * FROM #catalogo_maestro_farmacias_torres	---


SELECT 
  LEFT(mayorista  + REPLICATE(' ',10),10)	mayorista,																						--	 1
  status,																																												--	 2
  LEFT (cod_barras + REPLICATE(' ',15),15 ) cod_barras,																					--	 3
  LEFT (cod_torres + REPLICATE(' ',20),20 ) cod_torres,																					--	 4
  farmaceutico,																																									--	 5
  LEFT(descripcion  + REPLICATE(' ',50),50 ) descripcion,																				--	 6
  RIGHT(REPLICATE(' ', 8) + CONVERT(VARCHAR(8), CONVERT(INT,prec_pub    ) )  , 8 ) prec_pub,		--	 7
  RIGHT(REPLICATE(' ', 8) + CONVERT(VARCHAR(8), CONVERT(INT,prec_farm   ) )  , 8 ) prec_farm,		--	 8
  RIGHT(REPLICATE(' ', 8) + CONVERT(VARCHAR(8), CONVERT(INT,descto      ) )  , 8 ) descto,			--	 9
  RIGHT(REPLICATE(' ', 8) + CONVERT(VARCHAR(8), CONVERT(INT,descto2     ) )  , 8 ) descto2,			--	10
  RIGHT(REPLICATE(' ', 8) + CONVERT(VARCHAR(8), CONVERT(INT,descto3     ) )  , 8 ) descto3,			--	11
  RIGHT(REPLICATE(' ', 8) + CONVERT(VARCHAR(8), CONVERT(INT,p_costo     ) )  , 8 ) p_costo,			--	12
  RIGHT(REPLICATE(' ', 2) + CONVERT(VARCHAR(2), CONVERT(INT,iva         ) )  , 2 ) iva,					--	13
  unidad,
	codigo
INTO #formateado
FROM #catalogo_maestro_farmacias_torres
order by status,descripcion

--------------	SELECT * FROM #catalogo_maestro_farmacias_torres	-----------------

set @sep = ''

SELECT	
  LEFT(mayorista  + REPLICATE(' ',10),10) + @sep +																						--	1
  status + @sep +																																							--	2
  LEFT (cod_barras + REPLICATE(' ',15),15 ) + @sep +																					--	3
  LEFT (cod_torres + REPLICATE(' ',20),20 ) + @sep +																					--	4
  farmaceutico + @sep +																																				--	5
  LEFT(descripcion  + REPLICATE(' ',50),50 ) + @sep +																					--	6
  RIGHT(REPLICATE(' ', 8) + CONVERT(VARCHAR(8), CONVERT(INT,prec_pub    ) )  , 8 ) + @sep +		--	7
  RIGHT(REPLICATE(' ', 8) + CONVERT(VARCHAR(8), CONVERT(INT,prec_farm   ) )  , 8 ) + @sep +		--	8
  RIGHT(REPLICATE(' ', 8) + CONVERT(VARCHAR(8), CONVERT(INT,descto      ) )  , 8 ) + @sep +		--	9
  RIGHT(REPLICATE(' ', 8) + CONVERT(VARCHAR(8), CONVERT(INT,descto2     ) )  , 8 ) + @sep +		--	10
  RIGHT(REPLICATE(' ', 8) + CONVERT(VARCHAR(8), CONVERT(INT,descto3     ) )  , 8 ) + @sep +		--	11
  RIGHT(REPLICATE(' ', 8) + CONVERT(VARCHAR(8), CONVERT(INT,p_costo     ) )  , 8 ) + @sep +		--	12
  RIGHT(REPLICATE(' ', 2) + CONVERT(VARCHAR(2), CONVERT(INT,iva         ) )  , 2 ) + @sep +		--	13
  unidad layout,																																							--	14
	status,
	codigo
FROM #formateado

DROP TABLE #formateado

DROP TABLE #cambios
DROP TABLE #catalogo_maestro_farmacias_torres

GO

