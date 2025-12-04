
--	----------------------------------------------------------------------------------------------------
-- |	usp_genera_facturacion_electronica_smart																													|
-- |								FECHA						PROGRAMADOR:			DESCRIPCION:																			|
-- |	CREADO:				20 nov 2008			MIGUEL SAMAYOA		MIGRACION DE COBOL A SQL (AUTOMATIZACION EN C#)		|
-- |	MODIFICADO:		21 ABR 2009												CAMBIO DE FACTURA MARZAM A FOLIO C.F.D.						|
-- |	MODIFICADO:		08 MAR 2011												WHERE FECHA TANDEM	= @fecha											|
-- |	MODIFICADO:		09 MAR 2011												FECHA ENTREGA																			|
--	----------------------------------------------------------------------------------------------------
--select CONVERT(datetime,'2016-07-21',121)+1
/*
EXECUTE usp_genera_facturacion_electronica_smart '2016-07-23'
*/

CREATE 
PROCEDURE [dbo].[usp_genera_facturacion_electronica_smart_back] @fecha varchar(10)
AS
  
SELECT distinct
  f.sucursal,
  CASE c.letra WHEN 'W' THEN '0X' ELSE RIGHT('0'+CONVERT(VARCHAR(2),c.letra),2) END letra,
  f.cliente,
	RIGHT(CASE WHEN folio_fiscal IS NOT NULL THEN folio_fiscal ELSE REPLICATE(' ',7) END,7) factura,
  REPLICATE('0', 6)                   medipac,
  RIGHT(REPLICATE('0', 7)+CONVERT(VARCHAR,piezas_surtidas_con_cargo),7) cant_surt,
  RIGHT(REPLICATE('0',10)+CONVERT(VARCHAR,CONVERT(INT,importe_neto/ piezas_surtidas_con_cargo  *  100)  ),  10) Prec_Farm				,
  RIGHT(REPLICATE('0',10)+CONVERT(VARCHAR,CONVERT(INT,descto_oferta                *  100)  ),  10) tot_oferta			,
  RIGHT(REPLICATE('0',10)+CONVERT(VARCHAR,CONVERT(INT,descto_comercial             *  100)  ),  10) tot_desc				,
  RIGHT(REPLICATE('0',10)+CONVERT(VARCHAR,CONVERT(INT,iva                          *  100)  ),  10) tot_iva					,
  RIGHT(REPLICATE('0',10)+CONVERT(VARCHAR,CONVERT(INT,importe_neto                 *  100)  ),  10) tot_importe			,
  RIGHT(REPLICATE('0',10)+CONVERT(VARCHAR,CONVERT(INT,porcentaje_descto_oferta     *  100)  ),   4) desc_porc				,
  RIGHT(REPLICATE('0',10)+CONVERT(VARCHAR,CONVERT(INT,porcentaje_descto_comercial  *  100)  ),   4) desc_p_p				,
  RIGHT(REPLICATE('0',13)+CONVERT(VARCHAR,cod_barras),																		13)+' '		cod_barras			,
  RIGHT(REPLICATE('0',10)+CONVERT(VARCHAR,CONVERT(INT,precio_pub_con_imp           *  100)  ),  10) prec_publ				,
  LEFT( REPLICATE('0',10)+ orden ,10)																																orden						,
  CONVERT(CHAR(8),	CONVERT(datetime,getdate(),121)				,	112)																			fecha_entrega		,							
  CONVERT(CHAR(8),	getdate()	,	112)																														fecha_fact			--,
  --	A PETICION DE CLIENTE PARA QUE SU SISTEMA LOS ACEPTE
INTO #Temporal_FAEL_Smart
FROM facturacion_electronica_estandar F WITH (NOLOCK)
INNER JOIN sucursales s on f.sucursal = s.sucursal
inner join cat_cuentasfsmart c on f.sucursal=c.sucursal and f.cliente=SUBSTRING(rtrim(ltrim(c.cliente)),2,5)
--inner join [cat_cuentas_fsmart] c on f.sucursal=c.sucursal and f.cliente=SUBSTRING(rtrim(ltrim(c.cliente)),2,5)
WHERE f.fecha_factura between  CONVERT(datetime,@fecha,121)-1 and   CONVERT(datetime,@fecha,121)+1
  --AND f.segto = 'E2' 
  AND f.ctepadre IN ('715','338','716','724') 
  AND f.sucursal IN (24,23,7,8)
				 


UPDATE #Temporal_FAEL_Smart SET letra = 'OW' WHERE letra = 'OX'

SELECT 
	letra,
	cliente,
  letra + 
  cliente + 
  factura + 
  medipac + 
  cant_surt + 
  prec_farm + 
  tot_oferta + 
  tot_desc + 
  tot_iva + 
  tot_importe + 
  desc_porc + 
  desc_p_p + 
  cod_barras + 
  prec_publ + 
  orden + 
  fecha_fact +
  fecha_entrega	
  cadena
FROM #Temporal_FAEL_Smart
--ORDER by sucursal,cliente,factura
drop table #Temporal_FAEL_Smart
--select * from hashes_md5

GO

