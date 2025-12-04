CREATE PROCEDURE usp_genera_catalogo_ofertas_fcuauhtemoc
AS

/*DECLARE @porcentaje decimal(5,2)

SET @porcentaje = 
	(SELECT descuento FROM clientes_baan 
		WHERE sucursal = 24 AND cliente = '50323')
*/

CREATE TABLE #ofertas_fcuauhtemoc (
	codigo              VARCHAR( 7),
	descripcion         VARCHAR(31),
  lab_corto           VARCHAR(20),
	cant_base           INT,
	cant_oferta         INT,
	porcentaje          MONEY,	--	DECIMAL(14,2)
	vigencia_inicial    VARCHAR(10),
	vigencia_final      VARCHAR(10),
	cod_barras          VARCHAR(14),
  clas_fis            VARCHAR( 2),
  descto              MONEY,
  bolsa               VARCHAR( 5),
  status              VARCHAR( 1)
)

insert INTO #ofertas_fcuauhtemoc
SELECT
	mpb.codigo,	--	
	mpb.descripcion,
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
ORDER by mpb.descripcion	--	ofe.codigo



--	COMPUTE W-DESC-COM-TOTAL =(W-DESC-ENTERO * 100 )+ (W-DESC-DECIMAL / 10 )

UPDATE #ofertas_fcuauhtemoc SET porcentaje = (cant_base + cant_oferta) 
UPDATE #ofertas_fcuauhtemoc SET porcentaje = (cant_oferta / porcentaje) * 100  where porcentaje > 0 
UPDATE #ofertas_fcuauhtemoc SET cant_base = 0
UPDATE #ofertas_fcuauhtemoc SET cant_oferta = 0

DECLARE @sep varchar(1)
set @sep = ''

--SELECT * FROM #ofertas_fcuauhtemoc


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
FROM #ofertas_fcuauhtemoc


DROP TABLE #OFERTAS_fcuauhtemoc

GO

