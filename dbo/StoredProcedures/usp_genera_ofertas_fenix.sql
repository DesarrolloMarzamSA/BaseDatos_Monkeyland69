--SELECT * from maestro_productos_baan where descripcion like '%kenolan%'
--SELECT * from maestro_productos_baan where cod_barras = '7501090520766'
--SELECT * from dboferta where sucursal = 17 and codigo = '0008402'
--exec usp_genera_ofertas_fenix 1, '78070', 'LIBRE', 'ZZZZZ'

--	HECHO POR MIGUEL SAMAYOA

--	MODIFICADO	2010-03-25	FUNCION GOBIERNO

CREATE PROCEDURE usp_genera_ofertas_fenix @sucursal 
int, @cliente varchar(5), @primer_bolsa varchar(5), @segunda_bolsa varchar(5)

as
declare @descuento money
SELECT @descuento = CONVERT(money, descuento) FROM clientes_baan WHERE sucursal = @sucursal AND cliente = @cliente

CREATE TABLE #ofe_fenix (
  sucursal INT,
  cod_barras  VARCHAR(13),
  descripcion VARCHAR(30),
  prec_farm   MONEY,
  descto      MONEY,
  pzas_c_cargo  INT,
  pzas_s_cargo  INT,
  lim_prod_sc   INT,
  descto_fin  MONEY,
  bolsa       VARCHAR(5)  )

INSERT INTO #ofe_fenix
  SELECT
    dbo.sucursal,
    mpb.cod_barras,
    mpb.descripcion,
    CASE WHEN mpb.grupo_est = 'PC01A' THEN mpb.prec_farm + (mpb.prec_farm * 0.5)
         ELSE mpb.prec_farm                                     END prec_farm,
    CASE WHEN dbo.cant_base = 0       THEN dbo.porcentaje 
         ELSE dbo.cant_oferta / dbo.cant_base + dbo.cant_oferta END descto,
    0 pzas_c_cargo,
    0 pzas_s_cargo,
    0 lim_prod_sc,
    CASE  WHEN mpb.clas_fis IN ('B','BA')  THEN @descuento
          WHEN mpb.clas_fis IN ('N','NA')  THEN 0
          WHEN mpb.clas_fis IN ('H','HA')  THEN mpb.descto_prod END descto_fin,
    dbo.bolsa
  FROM maestro_productos_baan mpb 
  INNER JOIN dboferta dbo ON mpb.codigo = dbo.codigo 
  WHERE dbo.sucursal = @sucursal 
  AND dbo.bolsa = @primer_bolsa
  AND CONVERT(INT, mpb.codigo ) < dbo.gobierno() 
  AND SUBSTRING(mpb.status, 1, 1) <> 'B' 
--union

INSERT INTO #ofe_fenix
  SELECT
    dbo.sucursal,
    mpb.cod_barras,
    mpb.descripcion,
    CASE WHEN mpb.grupo_est = 'PC01A' THEN mpb.prec_farm + (mpb.prec_farm * 0.5)
         ELSE mpb.prec_farm                                     END prec_farm,
    CASE WHEN dbo.cant_base = 0       THEN dbo.porcentaje 
         ELSE dbo.cant_oferta / dbo.cant_base + dbo.cant_oferta END descto,
    0 pzas_c_cargo,
    0 pzas_s_cargo,
    0 lim_prod_sc,
    CASE  WHEN mpb.clas_fis IN ('B','BA')  THEN @descuento
          WHEN mpb.clas_fis IN ('N','NA')  THEN 0
          WHEN mpb.clas_fis IN ('H','HA')  THEN mpb.descto_prod END descto_fin,
    dbo.bolsa
  FROM maestro_productos_baan mpb 
  INNER JOIN dboferta dbo ON mpb.codigo = dbo.codigo 
  WHERE dbo.sucursal = @sucursal 
  AND dbo.bolsa = @primer_bolsa
  AND CONVERT(INT, mpb.codigo ) < dbo.gobierno() 
  AND SUBSTRING(mpb.status, 1, 1) <> 'B' 
  AND dbo.codigo not in 
    (SELECT distinct codigo from dboferta 
      where sucursal = @sucursal and bolsa = @primer_bolsa)

--  SELECT * FROM #ofe_fenix  -- WHERE


SELECT
  LEFT(CONVERT(varchar, sucursal) + REPLICATE(' ',12),12) +
  RIGHT(REPLICATE('0',13) + cod_barras, 13) +
  LEFT(descripcion + REPLICATE(' ',30), 30) + 
  RIGHT(REPLICATE('0', 9) + CONVERT(varchar, CONVERT(money, prec_farm   )), 9) +
  RIGHT(REPLICATE('0', 6) + CONVERT(varchar, CONVERT(money, 100 * descto)), 6) +
  RIGHT(REPLICATE('0', 7) + CONVERT(varchar, pzas_c_cargo  ), 7) +
  RIGHT(REPLICATE('0', 7) + CONVERT(varchar, pzas_s_cargo  ), 7) +
  RIGHT(REPLICATE('0', 7) + CONVERT(varchar, lim_prod_sc   ), 7) +
  RIGHT(REPLICATE('0', 6) + CONVERT(varchar, descto_fin    ), 6) 
FROM #ofe_fenix


DROP TABLE #ofe_fenix

GO

