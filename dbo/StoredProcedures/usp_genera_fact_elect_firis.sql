
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_genera_fact_elect_firis] (@fecha VARCHAR(10)) 
WITH ENCRYPTION
AS

/*
EXEC usp_genera_fact_elect_firis '2011-03-10'
*/
--  SELECT * FROM clientes_baan WHERE sucursal = 17 AND farmacia like '%IRIS%'
SELECT 
  f.sucursal,
  f.cliente,
  f.digito_verificador dv,
  s.serie_cfd,
  f.folio_fiscal,
  f.serie,
  f.factura,
  CONVERT(VARCHAR(10),f.fecha_factura,112) fecha,
  f.codigo,
  f.descripcion,
  f.cod_barras,
  f.clas_fis,
  f.piezas_surtidas_con_cargo,
  f.piezas_surtidas_sin_cargo,
  f.precio_farm_sin_imp,
  f.precio_pub_con_imp,
  f.importe_bruto,
  f.porcentaje_descto_oferta,
  f.descto_oferta,
  f.descto_comercial,
  f.ieps,
  f.iva,
  f.importe_neto
INTO #fe_firis_format
FROM facturacion_electronica_estandar f
INNER JOIN sucursales s ON s.sucursal = f.sucursal
WHERE f.sucursal = 17
--AND segto = 'A1'  --  'D1'
--AND ctepadre = ''  --  '144'
AND cliente in (
'13487',
'21327'
)

AND f.fecha_tandem = CONVERT(SMALLDATETIME,@fecha,121)
ORDER BY folio_fiscal


SELECT 
  RIGHT(REPLICATE(' ',12) + CONVERT(VARCHAR,f.cliente                   ) ,12)  cliente,
  REPLICATE(' ', 1)  filler1,
  RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR,f.descto_comercial          ) , 6)  desc_com,
  REPLICATE(' ', 1)  filler2,
  RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR,f.porcentaje_descto_oferta  ) , 6)  porc_desc_ofert,
  f.cod_barras,
  f.fecha,
  REPLICATE(' ', 2)   filler3,
  RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR,f.iva                       ) , 9)  i_v_a,
  RIGHT(REPLICATE(' ',12) + CONVERT(VARCHAR,f.factura                   ) ,12)  factura,
  REPLICATE(' ', 1)  filler4,
  RIGHT(REPLICATE(' ', 7) + CONVERT(VARCHAR,f.piezas_surtidas_con_cargo ) , 7)  pza_surt_c_carg,
  REPLICATE(' ', 2)  filler5,
  RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR,f.precio_farm_sin_imp       ) , 9)  prec_farm_s_imp,
  RIGHT(REPLICATE(' ', 7) + CONVERT(VARCHAR,f.piezas_surtidas_sin_cargo ) , 7)  pza_surt_s_carg
FROM #fe_firis_format f

DROP TABLE #fe_firis_format
GO
