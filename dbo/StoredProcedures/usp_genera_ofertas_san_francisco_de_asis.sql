
CREATE PROCEDURE [dbo].[usp_genera_ofertas_san_francisco_de_asis] @sucursal int
AS


--2010-03-26	FUNCION GOBIERNO									MIGUEL SAMAYOA



--declare @sucursal INT
--SET @sucursal = 3
declare @sep varchar(1)

DECLARE @primer_bolsa  AS VARCHAR(5)
DECLARE @segunda_bolsa AS VARCHAR(5)
DECLARE @tercera_bolsa AS VARCHAR(5)
DECLARE @FACTOR AS int
set @FACTOR = 100
set @primer_bolsa = 'C2231'
set @segunda_bolsa = 'LIBRE'
set @tercera_bolsa = 'ESP'

CREATE TABLE #temp_san_fco_asis (
  sucursal int,
  codigo varchar(7),
  descripcion varchar(35),
  prec_farm money,
  cant_base varchar(4),
  cant_oferta varchar(4),
  porc_dcto varchar(3),
  tipo_oferta varchar(2),
  cod_barras varchar(13),
  crlf_a varchar(4),
  grupo_est varchar(10) )

--empieza codigo mquiroz
  insert into #temp_san_fco_asis
    SELECT 
      ofe.sucursal,
      ofe.codigo,
      mpb.descripcion,
      CASE mpb.grupo_est 
          WHEN 'PC01A' THEN mpb.prec_farm + (mpb.prec_farm * 0.5) 
          ELSE mpb.prec_farm END prec_farm,
      convert(varchar,ofe.cant_base   ) cant_base,
      convert(varchar,ofe.cant_oferta ) cant_oferta,
      convert(varchar,convert(int,ofe.porcentaje * @FACTOR)) porc_dcto,
      tipo_oferta,
      cod_barras,
      space( 4) crlf_a,
      grupo_est
    FROM dboferta ofe
    INNER JOIN maestro_productos_baan mpb on ofe.codigo = mpb.codigo
    INNER JOIN inventario_baan ib ON ofe.codigo = ib.codigo and ib.sucursal = @sucursal
    WHERE ofe.sucursal = @sucursal AND bolsa = @primer_bolsa
      AND CONVERT(INT, ofe.codigo) < dbo.gobierno()

/*
  insert into #temp_san_fco_asis
    SELECT 
      ofe.sucursal,
      ofe.codigo,
      mpb.descripcion,
      CASE mpb.grupo_est WHEN 'PC01A' 
        THEN mpb.prec_farm + (mpb.prec_farm * 0.5) 
        ELSE mpb.prec_farm END prec_farm,
      convert(varchar,ofe.cant_base   ) cant_base,
      convert(varchar,ofe.cant_oferta ) cant_oferta,
      convert(varchar,convert(int,ofe.porcentaje * @FACTOR)) porc_dcto,
      tipo_oferta,
      cod_barras,
      space( 4) crlf_a,
      grupo_est
    FROM dboferta ofe
    INNER JOIN maestro_productos_baan mpb on ofe.codigo = mpb.codigo
    INNER JOIN inventario_baan ib ON ofe.codigo = ib.codigo and ib.sucursal = @sucursal
    WHERE ofe.sucursal = @sucursal AND bolsa = @segunda_bolsa
      AND CONVERT(INT, ofe.codigo) < dbo.gobierno()
      and ofe.codigo not in (select codigo from #temp_san_fco_asis) --la segunda bolsa sin que estén en la primera
*/

create table #tabla_salida (columna1 varchar(500))

set @sep = ''

insert into #tabla_salida 
  SELECT
    codigo + @sep +
    LEFT(descripcion +space(31),31 ) + @sep + 
    RIGHT('0000000'+convert(varchar(15),prec_farm)  ,7) + @sep + 
    right('0000' + cant_base   ,4) + @sep + 
    right('0000' + cant_oferta ,4) + @sep + 
    right('00'   + porc_dcto   ,2) + @sep +
    tipo_oferta + @sep + 
    ' ' + @sep + 
    cod_barras + @sep + 
    crlf_a columna1
  FROM #temp_san_fco_asis 

SELECT * FROM #tabla_salida

drop table #tabla_salida
drop table #temp_san_fco_asis

GO

