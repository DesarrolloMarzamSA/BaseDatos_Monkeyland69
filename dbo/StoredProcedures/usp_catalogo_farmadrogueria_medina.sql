CREATE PROCEDURE usp_catalogo_farmadrogueria_medina
AS

--  usp_catalogo_farmadrogueria_medina

--2009-10-14	CREACION													MIGUEL SAMAYOA
--2009-12-30  IVA Sucursales 2010								MIGUEL SAMAYOA
--2010-03-26	FUNCION GOBIERNO									MIGUEL SAMAYOA


DECLARE @sucursal INT
DECLARE @p_iva MONEY
SET @sucursal = 1
SET @p_iva = (SELECT porcentaje_iva FROM sucursales WHERE sucursal = @sucursal)

SELECT 
	CONVERT(VARCHAR(10),CURRENT_TIMESTAMP,112) fecha,
	mpb.codigo,
	mpb.descripcion,
	CONVERT(DECIMAL(10,2),mpb.prec_farm) prec_farm,
	CONVERT(DECIMAL(10,2),mpb.prec_pub) prec_pub,
	CONVERT(DECIMAL( 5,2),
  CASE  WHEN mpb.clas_fis IN ('B' ,'N' ,'H' ) THEN  0   
        WHEN mpb.clas_fis IN ('BA','NA','HA') THEN (@p_iva * 100) END) piva,
	CASE WHEN mpb.grupo_est = 'PC01A' THEN 0.5 ELSE 0 END pieps,
	CONVERT(DECIMAL( 5,2),0) impuesto,
  CASE  WHEN mpb.clas_ssa    IN(1,2,3)     THEN 'CO'    
        WHEN mpb.clas_ssa    = 4           THEN 'ET'  
        WHEN mpb.clas_ssa    IN(5,6)       THEN 'OT'  
        WHEN mpb.clas_ssa    = 7           THEN 'MC'  
        WHEN mpb.clas_ssa    = 8           THEN 'PF'  
				ELSE																		'VA'	end tipo_prod,
	mpb.lab_largo,
	mpb.clas_fis,
	UPPER(terap.descripcion) descrip_terap,
	mpb.sus_act1,
	mpb.refrigerado,
  CASE  WHEN mpb.clas_ssa    IN(1,2,3)     THEN 'P'	ELSE ' ' END controlado,
	mpb.cod_barras,
	'PZA' unidad,
	'19000101' fecha_caducidad,	--	19000101 = INDICA QUE NO TIENE CADUCIDAD
	mpb.clas_ssa,
	CASE	WHEN LEFT(mpb.status,1) = 'A' THEN 'A'
				WHEN LEFT(mpb.status,1) = 'B' THEN 'B'
				ELSE 'C' END	status,
	mpb.pzas_empaque_original,
	CASE	WHEN ib.piezas = 0							THEN '0' 
				WHEN ib.piezas BETWEEN 1 AND 50 THEN '1' 
				WHEN ib.piezas > 50							THEN '2' END	filler1
INTO #catalogo_medina
FROM maestro_productos_baan mpb
INNER JOIN maestro_grupos_estadisticos_baan terap ON mpb.grupo_est = terap.grupo_est
INNER JOIN inventario_baan ib ON mpb.codigo = ib.codigo and ib.sucursal = 1 AND ib.piezas > 0
WHERE CONVERT(INT,mpb.codigo) < dbo.gobierno()
--and LEFT(mpb.status,1) != 'B'

CREATE TABLE #resultado (
--  columna1  VARCHAR(255),
--  columna2  VARCHAR(255),
  fecha VARCHAR(10),
  codigo        VARCHAR(100),
  descripcion        VARCHAR(100),
  prec_farm        VARCHAR(100),
  prec_pub        VARCHAR(100),
  piva        VARCHAR(100),
  pieps        VARCHAR(100),
  impuesto        VARCHAR(100),
  tipo_prod        VARCHAR(100),
  lab_largo        VARCHAR(100),
  clas_fis        VARCHAR(100),
  descrip_terap        VARCHAR(100),
  sus_act1        VARCHAR(100),
  refrigerado        VARCHAR(100),
  controlado        VARCHAR(100),
  cod_barras        VARCHAR(100),
  unidad        VARCHAR(100),
  fecha_caducidad        VARCHAR(100),
  clas_ssa        VARCHAR(100),
  status        VARCHAR(100),
  pzas_empaque_original        VARCHAR(100),
  filler1        VARCHAR(100),
  rownum  INT IDENTITY  )


INSERT INTO #resultado -- (columna1,columna2)
  SELECT --	*
    fecha, 
    RIGHT(REPLICATE('0', 9) + codigo										, 9), 
    LEFT(descripcion		+ REPLICATE(' ',40)	,40), 
    RIGHT(REPLICATE('0',10) + CONVERT(VARCHAR,prec_farm),10), 
    RIGHT(REPLICATE('0',10) + CONVERT(VARCHAR,prec_pub)	,10), 
    RIGHT(REPLICATE('0', 6) + CONVERT(VARCHAR,piva)			, 6), 
    RIGHT(REPLICATE('0', 6) + CONVERT(VARCHAR,pieps)		, 6), 
    RIGHT(REPLICATE('0', 6) + CONVERT(VARCHAR,impuesto)	, 6), 
    tipo_prod, 
    LEFT(lab_largo			+ REPLICATE(' ',40),40), 
    LEFT(clas_fis				+ REPLICATE(' ', 2), 2), 
    LEFT(descrip_terap	+ REPLICATE(' ',40),40), 
    LEFT(sus_act1				+ REPLICATE(' ',40),40), 
    LEFT(refrigerado		+ REPLICATE(' ', 1), 1), 
    LEFT(controlado			+	REPLICATE(' ', 1), 1), 
    cod_barras, 
    unidad, 
    fecha_caducidad, 
    LEFT(clas_ssa + REPLICATE(' ', 2), 2), 
    status, 
    RIGHT(REPLICATE('0', 4) + CONVERT(VARCHAR,pzas_empaque_original), 4), 
    LEFT(filler1				+ REPLICATE('0',20),20) 
  --	SELECT @@ROWCOUNT
  --INTO #resultado
  FROM #catalogo_medina

/*
SELECT --	*
	fecha ,
	RIGHT(REPLICATE('0', 9) + codigo										, 9) ,
	LEFT(descripcion		+ REPLICATE('0',40)	,40) ,
	RIGHT(REPLICATE('0',10) + CONVERT(VARCHAR,prec_farm),10) ,
	RIGHT(REPLICATE('0',10) + CONVERT(VARCHAR,prec_pub)	,10) ,
  RIGHT(REPLICATE('0', 6) + CONVERT(VARCHAR,piva)			, 6) ,
	RIGHT(REPLICATE('0', 6) + CONVERT(VARCHAR,pieps)		, 6) ,
	RIGHT(REPLICATE('0', 6) + CONVERT(VARCHAR,impuesto)	, 6) ,
  tipo_prod ,
	LEFT(lab_largo			+ REPLICATE('0',40),40) ,
	LEFT(clas_fis				+ REPLICATE('0', 2), 2) ,
	LEFT(descrip_terap	+ REPLICATE('0',40),40) ,
	LEFT(sus_act1				+ REPLICATE('0',40),40) ,
	LEFT(refrigerado		+ REPLICATE('0', 1), 1) ,
  LEFT(controlado			+	REPLICATE('0', 1), 1) ,
	cod_barras ,
	unidad + @sep ,	--	SEPARADOR
	fecha_caducidad ,
	LEFT(clas_ssa + REPLICATE('0', 2), 2),
	status ,
	RIGHT(REPLICATE('0', 4) + CONVERT(VARCHAR,pzas_empaque_original), 4) ,
	LEFT(filler1				+ REPLICATE('0',20),20)
FROM #catalogo_medina
*/

drop table #catalogo_medina

--  SELECT columna1,columna2 + RIGHT(REPLICATE('0',5) + CONVERT(VARCHAR,rownum), 5) FROM #resultado
SELECT * FROM #resultado

GO

