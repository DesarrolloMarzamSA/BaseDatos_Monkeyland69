

CREATE PROCEDURE [dbo].[usp_futurama_ofertas] 

AS

/*declare @sep varchar(1)
SET @sep = '|'*/

CREATE TABLE #temp_futurama (
  codigo varchar(7),
  dv varchar(1),
  ean varchar(14),
  ean_sub_empaque varchar(14),
  ean_empaque varchar(14),
  tipo_prod varchar(2),
  descripcion varchar(35),
  prec_farm varchar(14),
  cant_base varchar(3),
  porc_dcto_pre_1a_esc varchar(3),
  porc_dcto_pre_2a_esc varchar(3), 
  cant_oferta varchar(2),
  pzas_1a_esc varchar(2),
  pzas_2a_esc varchar(2) )

insert into #temp_futurama
  SELECT 
    ofe.codigo,
    ' ' dv,
    '0'+mbp.cod_barras ean,
    space(14) ean_sub_empaque,
    space(14) ean_empaque,
    ' ' tipo_prod,
    left( mbp.descripcion +space(35),35 ) descripcion,
    right('000000000' + convert(varchar(9),convert(int,mbp.prec_farm * 100)),9) prec_farm, 
    right('000'+convert(varchar(3),ofe.cant_base),3) cant_base,
    right('000' + convert(varchar(3),convert(int,ofe.porcentaje * 100)),3) porc_dcto_pre_1a_esc,
    '   ' porc_dcto_pre_2a_esc,
    right('00'+convert(varchar(2),ofe.cant_oferta),2) cant_oferta,
    '  ' pzas_1a_esc,
    '  ' pzas_2a_esc
  FROM dboferta ofe
  INNER JOIN maestro_productos_baan mbp on ofe.codigo = mbp.codigo
  WHERE 
  convert(int, mbp.codigo) < dbo.gobierno() and
  substring(mbp.status, 1, 1) <> 'B' and
  bolsa = 'E2845'
  

SELECT codigo + 
  dv + 
  ean + 
  ean_sub_empaque + 
  ean_empaque + 
  tipo_prod + 
  descripcion + 
  prec_farm + 
  cant_base + 
  porc_dcto_pre_1a_esc + 
  porc_dcto_pre_2a_esc + 
  cant_oferta + 
  pzas_1a_esc + 
  pzas_2a_esc  
FROM #temp_futurama 
--WHERE

drop table #temp_futurama

GO

