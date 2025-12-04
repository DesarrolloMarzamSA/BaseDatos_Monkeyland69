
CREATE PROCEDURE [dbo].[usp_genera_catalogo_oferta_fsanchez] (@sucursal int )
AS
-- usp_genera_catalogo_oferta_fsanchez 3
-- Generacion de Catalogo Oferta Farmacias Sanchez GDL
--  CLIENTE PADRE 232
-- SEGMENTO C2
-- FECHA ULTIMA MODIFICACION: 09 FEB 2008
--declare @sucursal int
--set @sucursal = 3
DECLARE @primer_bolsa  AS VARCHAR(5)
DECLARE @segunda_bolsa AS VARCHAR(5)
DECLARE @FACTOR AS int
set @FACTOR = 100
set @primer_bolsa = 'C2232'
set @segunda_bolsa = 'LIBRE'


create table #ofertas_fsanchez (
  codigo varchar(7),
  descripcion varchar(50),
  prec_farm money,
  cant_base int,
  cant_oferta int,
  porcentaje money,
  status varchar(1),
  cod_barras bigint,
  bolsa varchar(5),
  sucursal int)
  
insert into #ofertas_fsanchez 
  SELECT 
    ofe.codigo,
    mpb.descripcion,
    CASE mpb.grupo_est WHEN 'PC01A' THEN mpb.prec_farm + (mpb.prec_farm * 0.5)  
                                    ELSE mpb.prec_farm END prec_farm,
    ofe.cant_base,
    ofe.cant_oferta,
    ofe.porcentaje * @FACTOR porcentaje,
    ofe.status,
    convert(bigint   ,mpb.cod_barras) cod_barras,
    ofe.bolsa,
    ofe.sucursal
  FROM  dboferta ofe
  INNER JOIN maestro_productos_baan mpb ON ofe.codigo = mpb.codigo
  INNER JOIN inventario_baan ib ON ofe.codigo = ib.codigo 
    and ib.sucursal = @sucursal
  WHERE ofe.sucursal = @sucursal AND ofe.bolsa = @primer_bolsa
    --AND ofe.codigo not in (select codigo from dboferta  
    --WHERE bolsa = @segunda_bolsa and sucursal = @sucursal)
    AND CONVERT(INT, ofe.codigo) < dbo.gobierno()
    --and ofe.codigo not in (select codigo from #ofertas_fsanchez)

/*
insert into #ofertas_fsanchez 
  SELECT
    ofe.codigo,
    mpb.descripcion,
    CASE mpb.grupo_est WHEN 'PC01A' THEN mpb.prec_farm + (mpb.prec_farm * 0.5)  
                                    ELSE mpb.prec_farm END prec_farm,
    ofe.cant_base,
    ofe.cant_oferta,
    ofe.porcentaje * @FACTOR porcentaje,
    ofe.status,
    convert(bigint   ,mpb.cod_barras) cod_barras,
    ofe.bolsa,
    ofe.sucursal
  FROM  dboferta ofe
  INNER JOIN maestro_productos_baan mpb ON ofe.codigo = mpb.codigo
  INNER JOIN inventario_baan ib ON ofe.codigo = ib.codigo 
    and ib.sucursal = @sucursal
  WHERE ofe.sucursal = @sucursal AND ofe.bolsa = @segunda_bolsa
    AND ofe.codigo not in 
      (select codigo from dboferta  
        WHERE bolsa = @primer_bolsa and sucursal = @sucursal)
    AND CONVERT(INT, ofe.codigo) < dbo.gobierno()
--    and ofe.codigo not in (select codigo from #ofertas_fsanchez)
*/

--select * from #ofertas_fsanchez       --  PRUEBAS

SELECT
  codigo+  
  LEFT(descripcion+space(50),31)+
  RIGHT('000000' + CONVERT(VARChAR,prec_farm     ),7) +
  RIGHT('000000'  +convert(varchar(4),cant_base  ),4) +
  RIGHT('000000'  +convert(varchar(4),cant_oferta),4) +
  RIGHT('0000'    +CONVERT(varchar(9),porcentaje ),7) +  
  LEFT(status +'   ',2)+
  convert(varchar,cod_barras) col1,bolsa
FROM  #ofertas_fsanchez
order by bolsa,col1

drop table #ofertas_fsanchez

GO

