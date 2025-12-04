CREATE PROCEDURE usp_ofertas_farmadrogueria_medina
AS

/*DECLARE @porcentaje decimal(5,2)

SET @porcentaje = 
	(SELECT descuento FROM clientes_baan 
		WHERE sucursal = 24 AND cliente = '50323')
*/

DECLARE @sucursal INT
DECLARE @porcentaje_iva MONEY
SET @sucursal = 1
SET @porcentaje_iva = (SELECT porcentaje_iva FROM sucursales WHERE sucursal = @sucursal)


CREATE TABLE #ofertas_fmedina (
  fecha              DATETIME,
	codigo             VARCHAR( 7),
	descripcion        VARCHAR(31),
  prec_farm          MONEY,
  prec_pub           MONEY,
  piva               MONEY,
  pieps              MONEY,
  pimpuesto3         MONEY,
	cant_base          INT,
	cant_oferta        INT,
	porcentaje         MONEY,	
	vigencia_inicial   DATETIME,
	vigencia_final     DATETIME,
	cod_barras         VARCHAR(14),
  tipo_oferta        VARCHAR( 1),
  bolsa              VARCHAR( 5),
  filler1            VARCHAR(20),
  contador           INT IDENTITY
)

INSERT INTO #ofertas_fmedina (
  fecha,
	codigo,
	descripcion,
  prec_farm,
  prec_pub,
  piva,
  pieps,
  pimpuesto3,
	cant_base,
	cant_oferta,
	porcentaje,
	vigencia_inicial,
	vigencia_final,
	cod_barras,
  tipo_oferta,
  bolsa,
  filler1   )

SELECT
  CURRENT_TIMESTAMP fecha,
	mpb.codigo,
	mpb.descripcion,
  CASE  WHEN mpb.grupo_est = 'PC01A'          THEN mpb.prec_farm * 0.5 
        ELSE mpb.prec_farm                                        END prec_farm,
  CASE  WHEN mpb.grupo_est = 'PC01A'          THEN mpb.prec_pub  * 0.5
        ELSE mpb.prec_pub                                         END prec_pub,
  CASE  WHEN mpb.clas_fis IN ('B' ,'N' ,'H' ) THEN  0   
        WHEN mpb.clas_fis IN ('BA','NA','HA') THEN CONVERT(CHAR(2),CONVERT(INT,@porcentaje_iva * 100)) END piva,  --  15
	CASE  WHEN mpb.grupo_est = 'PC01A' THEN 0.5 
        ELSE 0                                                    END pieps,
	CONVERT(DECIMAL( 5,2),0) pimpuesto3,
	ofe.cant_base,
	ofe.cant_oferta,
	ofe.porcentaje * 100,
	ofe.vigencia_inicial,
	ofe.vigencia_final,
	mpb.cod_barras,
  CASE WHEN ofe.cant_base   = 0 THEN 'P' 
       WHEN ofe.cant_oferta = 0 THEN 'D' ELSE ' ' END tipo_oferta,
  ofe.bolsa,
  REPLICATE(' ',20) filler1
FROM dboferta ofe 
INNER JOIN inventario_baan ib ON ofe.sucursal = ib.sucursal AND ofe.codigo = ib.codigo -- AND ib.piezas > 0
INNER JOIN maestro_productos_baan mpb ON ofe.codigo = mpb.codigo 
WHERE ofe.bolsa = 'LIBRE'	AND ofe.SUCURSAL = @sucursal	--	AND ofe.cant_base > 5 
ORDER by mpb.descripcion	

--	COMPUTE W-DESC-COM-TOTAL =(W-DESC-ENTERO * 100 )+ (W-DESC-DECIMAL / 10 )

--UPDATE #ofertas_fmedina SET porcentaje = (cant_base + cant_oferta) 
--UPDATE #ofertas_fmedina SET porcentaje = (cant_oferta / porcentaje) * 100  where porcentaje > 0 

DECLARE @sep varchar(1)
set @sep = ''

--SELECT * FROM #ofertas_fmedina


SELECT
  CONVERT(VARCHAR(8),fecha,112) fecha,  -- + @sep + 
 	RIGHT( REPLICATE('0', 9) + codigo, 9) codigo,  -- + @sep + 
	LEFT(descripcion + REPLICATE(' ',40)                  ,40) descripcion, -- + @sep + 
	RIGHT(REPLICATE(' ',10) + CONVERT(varchar,prec_farm)  ,10) prec_farm, -- + @sep + 
	RIGHT(REPLICATE(' ',10) + CONVERT(varchar,prec_pub)   ,10) prec_pub, -- + @sep + 
  RIGHT(REPLICATE(' ', 6) + CONVERT(varchar,piva)       , 6) piva, -- + @sep + 
  RIGHT(REPLICATE(' ', 6) + CONVERT(varchar,pieps)      , 6) pieps, -- + @sep + 
  RIGHT(REPLICATE(' ', 6) + CONVERT(varchar,pimpuesto3) , 6) pimpuesto3, -- + @sep + 
	RIGHT(REPLICATE(' ', 4) + CONVERT(varchar,cant_base)  , 4) cant_base, -- + @sep + 
	RIGHT(REPLICATE(' ', 4) + CONVERT(varchar,cant_oferta), 4) cant_oferta, -- + @sep + 
  RIGHT(REPLICATE(' ', 6) + CONVERT(varchar,porcentaje ), 6) porcentaje, -- + @sep + 
	CONVERT(VARCHAR(8),vigencia_inicial,112) vigencia_inicial, -- + @sep + 
	CONVERT(VARCHAR(8),vigencia_final,112) vigencia_final, -- + @sep + 
	RIGHT(REPLICATE('0',13) + cod_barras                  ,13) cod_barras,  -- + @sep + 
  tipo_oferta,
  bolsa,
  filler1,
  RIGHT(REPLICATE(' ', 5) + CONVERT(varchar,contador) , 5) contador
/*,codigo + @sep + 
  LEFT(REPLICATE('0',4) + CONVERT(varchar,descto),4)  + @sep + 
  bolsa  + @sep + 
  status*/
FROM #ofertas_fmedina

DROP TABLE #OFERTAS_fmedina

GO

