CREATE PROCEDURE [dbo].[usp_ofertas_fmedina]
AS

/*DECLARE @porcentaje decimal(5,2)

SET @porcentaje = 
	(SELECT descuento FROM clientes_baan 
		WHERE sucursal = 24 AND cliente = '50323')
*/

CREATE TABLE #ofertas_fmedina (
	codigo              VARCHAR( 7),
	descripcion         VARCHAR(31),
  lab_corto           VARCHAR(20),
	cant_base           INT,
	cant_oferta         INT,
	porcentaje          MONEY,		vigencia_inicial    VARCHAR(10),
	vigencia_final      VARCHAR(10),
	cod_barras          VARCHAR(14),
  clas_fis            VARCHAR( 2),
  descto              MONEY,
  bolsa               VARCHAR( 5),
  status              VARCHAR( 1)
)

/* INSERT INTO #ofertas_fmedina
SELECT
	REPLICATE('0', 6) codigo,
	mpb.descripcion,
  lab_corto proveedor,
	ofe.cant_base,
	ofe.cant_oferta,
	ofe.porcentaje,
	convert(varchar(10),ofe.vigencia_inicial,112) AS vigencia_inicial,
	convert(varchar(10),ofe.vigencia_final  ,112) AS vigencia_final,
	mpb.cod_barras,
  mpb.clas_fis,
  mpb.descto,
  ofe.bolsa,
  ofe.status
FROM
	dboferta ofe 
		INNER JOIN maestro_productos_baan mpb 
		ON ofe.codigo = mpb.codigo 
WHERE
	bolsa = 'LIBRE' 
	AND SUCURSAL = 24 */

insert INTO #ofertas_fmedina
SELECT
	mpb.codigo,		mpb.descripcion,
  lab_corto,
	ofe.cant_base,
	ofe.cant_oferta,
	ofe.porcentaje,
	convert(varchar(10),ofe.vigencia_inicial,112) AS vigencia_inicial,
	convert(varchar(10),ofe.vigencia_final  ,112) AS vigencia_final,
	mpb.cod_barras,
  mpb.clas_fis,
  mpb.descto,
  ofe.bolsa,
  ofe.status
FROM dboferta ofe 
INNER JOIN inventario_baan ib ON ofe.sucursal = ib.sucursal AND ofe.codigo = ib.codigo AND ib.piezas > 0
INNER JOIN maestro_productos_baan mpb ON ofe.codigo = mpb.codigo 
WHERE ofe.bolsa = 'C2717'	AND ofe.SUCURSAL = 24	--	AND ofe.cant_base > 5
ORDER by mpb.descripcion	


--	COMPUTE W-DESC-COM-TOTAL =(W-DESC-ENTERO * 100 )+ (W-DESC-DECIMAL / 10 )

UPDATE #ofertas_fmedina SET porcentaje = (cant_base + cant_oferta) 
UPDATE #ofertas_fmedina SET porcentaje = (cant_oferta / porcentaje) * 100  where porcentaje > 0 
UPDATE #ofertas_fmedina SET cant_base = 0
UPDATE #ofertas_fmedina SET cant_oferta = 0

DECLARE @sep varchar(1)
set @sep = ''

--SELECT * FROM #ofertas_fmedina


SELECT
 	REPLICATE('0', 6) + @sep + 
	LEFT(descripcion + REPLICATE(' ',30)                    ,30) + @sep + 
  LEFT(lab_corto + REPLICATE(' ', 4),4) + @sep + 
	RIGHT(REPLICATE('0', 3) + CONVERT(varchar,cant_base)  , 3) + @sep + 
	RIGHT(REPLICATE('0', 3) + CONVERT(varchar,cant_oferta), 3) + @sep + 
  RIGHT(REPLICATE('0', 7) + CONVERT(varchar,porcentaje ), 7) + @sep + 
	vigencia_inicial + @sep + 
	vigencia_final + @sep + 
	RIGHT(REPLICATE('0',13) + cod_barras                     ,13) + @sep + 
  LEFT(clas_fis + REPLICATE(' ', 2), 2)
/*,codigo + @sep + 
  LEFT(REPLICATE('0',4) + CONVERT(varchar,descto),4)  + @sep + 
  bolsa  + @sep + 
  status*/
FROM #ofertas_fmedina


DROP TABLE #OFERTAS_fmedina

/*     IF      OFE-ESTATUS OF OFE-REG     NOT = "A"             OR
           (OFE-FECTER OF OFE-REG          < WN-FECHA-Y2000  AND
            OFE-FECTER OF OFE-REG      NOT = ZEROS)          OR
           (OFE-FECBAJ OF OFE-REG          < WN-FECHA-Y2000  AND
            OFE-FECBAJ OF OFE-REG      NOT = ZEROS)          OR
            OFE-FECINI OF OFE-REG          <= ZEROS          OR
            OFE-FECINI OF OFE-REG          > WN-FECHA-Y2000  OR
           (OFE-CANT-OFE OF OFE-REG        = ZEROS           AND
            OFE-PORC-OFE OF OFE-REG        = ZEROS)          OR
 */

GO

