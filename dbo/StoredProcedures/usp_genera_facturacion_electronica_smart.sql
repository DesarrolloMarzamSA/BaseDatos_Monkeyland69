

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
EXECUTE [dbo].[usp_genera_facturacion_electronica_smart] '2024-05-27'
*/

CREATE 
PROCEDURE [dbo].[usp_genera_facturacion_electronica_smart] @fecha varchar(10)
AS

SELECT        SUCURSAL, 
CASE WHEN SUCURSAL=7 THEN '07'
WHEN SUCURSAL=8 THEN '08'
WHEN SUCURSAL=24 THEN '0X'
WHEN SUCURSAL=23 THEN '0X'
END
 AS LETRA,
 RTRIM(CLIENTE) AS CLIENTE,
 RTRIM(FARMACIA) AS FARMACIA,
 RTRIM(POBLACION) AS POBLACION,
 ACTIVO, CLIENTE_IBS, TIMESTAMP, CTEPADRE
 INTO #cat_cuentasfsmart
FROM            OPENQUERY(AS400, 
                         '
SELECT 
CASE WHEN NOI.noz3lent=''821'' AND SUBSTRING(T2.NANUM,1,1)=''A'' THEN CAST(''01'' AS INT) 
WHEN NOI.noz3lent=''821'' AND SUBSTRING(T2.NANUM,1,1)=''D'' THEN CAST(''04'' AS INT) 
WHEN NOI.noz3lent=''807'' AND SUBSTRING(T2.NANUM,1,1)=''X'' AND TRIM(SR.CMCSTS)=''075'' THEN CAST(''24'' AS INT) 
WHEN NOI.noz3lent=''807'' AND SUBSTRING(T2.NANUM,1,1)=''X'' THEN CAST(''23'' AS INT) 
WHEN NOI.noz3lent=''808'' AND SUBSTRING(T2.NANUM,1,1)=''X'' THEN CAST(''24'' AS INT) 
WHEN NOI.noz3lent=''855'' THEN CAST(''09'' AS INT) 
ELSE CAST(SUBSTRING(NOI.noz3lent,2,3)AS INT) 
END SUCURSAL,
SUBSTRING(T2.NANUM,1,1) letra1,SUBSTRING(T2.NANUM,2,6) AS cliente
,t2.naname AS farmacia,t2.NAADR4 AS poblacion,''1'' as ACTIVO,T2.NANUM AS cliente_ibs,
TIMESTAMP(INSERT(INSERT(DIGITS(t2.NACRDT),5,0,''-''),8,0,''-'') || '' 00:00:00.000'') as timestamp,
SUBSTRING(t2.NANCA1,3,6) AS ctepadre
FROM MA4620EF04.SRBNAM T2 
INNER JOIN MA4620EF04.Z3BNOI NOI ON T2.NANUM=NOI.NONUM
INNER JOIN MA4620EF04.SRBCMA SR ON T2.NANUM=SR.CMCUNO 
WHERE t2.nanca1 in(''99715'', ''99338'',''99724'') and t2.NANUM not in(''G99338'',''X99338'',''X99715'',''G51925'') and t2.NATYPP=1 and t2.NASTAT='' ''')
                          AS derivedtbl_1



SELECT distinct
  f.sucursal,--VWERK
  CASE c.letra WHEN 'W' THEN '0X' ELSE RIGHT('0'+CONVERT(VARCHAR(2),c.letra),2) END letra,
  f.cliente,--ALTKN
	RIGHT(CASE WHEN folio_fiscal IS NOT NULL THEN folio_fiscal ELSE REPLICATE(' ',7) END,7) factura,--VBELN
  REPLICATE('0', 6)                   medipac,
  RIGHT(REPLICATE('0', 7)+CONVERT(VARCHAR,piezas_surtidas_con_cargo),7) cant_surt,--cantidad
  RIGHT(REPLICATE('0',10)+CONVERT(VARCHAR,CONVERT(INT,importe_neto/ piezas_surtidas_con_cargo  *  100)  ),  10) Prec_Farm				,--PRECIOFARMACIA
  RIGHT(REPLICATE('0',10)+CONVERT(VARCHAR,CONVERT(INT,descto_oferta                *  100)  ),  10) tot_oferta			,--OFERTAS
  RIGHT(REPLICATE('0',10)+CONVERT(VARCHAR,CONVERT(INT,descto_comercial             *  100)  ),  10) tot_desc				,--DESCUENTOS
  RIGHT(REPLICATE('0',10)+CONVERT(VARCHAR,CONVERT(INT,iva                          *  100)  ),  10) tot_iva					,--IVA
  RIGHT(REPLICATE('0',10)+CONVERT(VARCHAR,CONVERT(INT,importe_neto                 *  100)  ),  10) tot_importe			,--IMPORTE_NET
  RIGHT(REPLICATE('0',10)+CONVERT(VARCHAR,CONVERT(INT,porcentaje_descto_oferta     *  100)  ),   4) desc_porc				,--PORCENTAJE_OFERTAS
  RIGHT(REPLICATE('0',10)+CONVERT(VARCHAR,CONVERT(INT,porcentaje_descto_comercial  *  100)  ),   4) desc_p_p				,--PORCENTAJE_DESCUENTOS
  RIGHT(REPLICATE('0',13)+CONVERT(VARCHAR,cod_barras),																		13)+' '		cod_barras			,--EAN11
  RIGHT(REPLICATE('0',10)+CONVERT(VARCHAR,CONVERT(INT,precio_pub_con_imp           *  100)  ),  10) prec_publ				,--PRECIO_PUBLICO
  LEFT( REPLICATE('0',10)+ orden ,10)																																orden						,--BSTKD
  CONVERT(CHAR(8),	CONVERT(datetime,getdate(),121)				,	112)																			fecha_entrega		,							
  CONVERT(CHAR(8),	getdate()	,	112)																														fecha_fact			--,FKDAT
  --	A PETICION DE CLIENTE PARA QUE SU SISTEMA LOS ACEPTE
INTO #Temporal_FAEL_Smart
FROM facturacion_electronica_estandar F WITH (NOLOCK)
INNER JOIN sucursales s on f.sucursal = s.sucursal
inner join #cat_cuentasfsmart c on f.sucursal=c.sucursal and f.cliente=c.cliente
--SUBSTRING(rtrim(ltrim(c.cliente)),2,5)
WHERE f.fecha_factura between  CONVERT(datetime,@fecha,121)-1 and   CONVERT(datetime,@fecha,121)+1
  AND f.ctepadre IN ('715','338','716','724') 
  AND f.sucursal IN (24,23,7,8)

 

insert INTO #Temporal_FAEL_Smart
select distinct
	c.sucursal,
	CASE c.letra WHEN 'W' THEN '0X' ELSE RIGHT('0'+CONVERT(VARCHAR(2),isnull(c.letra,'')),2) END letra,
	substring(isnull(ltrim(p.ALTKN),''),2,6) cliente,-- preguntar si si se le quita la letra al cliente(R33306)y quede 33306
	RIGHT(CONVERT(VARCHAR,isnull(p.VBELN,'')) ,7)  factura,-- PREGUNTAR, ya que tiene mas de 7 digitos
	REPLICATE('0', 6) medipac,
	REPLICATE('0', 7-len(CONVERT(VARCHAR,Convert(int,isnull(p.cantidad ,0)))))+CONVERT(VARCHAR,Convert(int,isnull(p.cantidad ,0))) cant_surt,
	RIGHT(REPLICATE('0',10)+CONVERT(VARCHAR,Convert(int,isnull(p.PRECIOFARMACIA,'0')*100)),10) Prec_Farm,
	RIGHT(REPLICATE('0',10)+CONVERT(VARCHAR,Convert(int,isnull(p.OFERTAS,0)*100)), 10) tot_oferta,
	RIGHT(REPLICATE('0',10)+CONVERT(VARCHAR,Convert(int,isnull(p.DESCUENTOS,0)*100)),10) tot_desc,
	RIGHT(REPLICATE('0',10)+CONVERT(VARCHAR,Convert(int,isnull(p.IVA,'0')*100)),10)tot_iva,
	RIGHT(REPLICATE('0',10)+CONVERT(VARCHAR,Convert(int,isnull(p.IMPORTE_NETO,0)*100)),10) tot_importe,
	RIGHT(REPLICATE('0',10)+CONVERT(VARCHAR,Convert(int,isnull(p.PORCENTAJE_OFERTAS,0)*100)),4) desc_porc,
	RIGHT(REPLICATE('0',10)+CONVERT(VARCHAR,Convert(int,isnull(p.PORCENTAJE_DESCUENTOS,'0')*100)),4) desc_p_p,
	RIGHT(REPLICATE('0',13)+CONVERT(VARCHAR,isnull(p.EAN11,'')),13)+' ' cod_barras,
	RIGHT(REPLICATE('0',10)+CONVERT(VARCHAR,Convert(int,isnull(p.PRECIO_PUBLICO,'0')*100)),10) prec_publ,
	RIGHT(REPLICATE('0',10)+CONVERT(VARCHAR,isnull(p.BSTKD,'')) ,10)orden,
	CONVERT(CHAR(8),CONVERT(datetime,getdate(),121)	,112) fecha_entrega,							
    RIGHT(REPLICATE(' ', 8)+isnull(CONVERT(varchar,CONVERT(DATETIME, p.FKDAT, 121),112),''),8) fecha_fact
	--select *
from #cat_cuentasfsmart c
inner join [sap].[facturacion_fsmart_sap] p on rtrim(c.cliente)=rtrim(p.ALTKN)
where p.[FKDAT] between CONVERT(datetime,@fecha,121)-1 and   CONVERT(datetime,@fecha,121)+1 


UPDATE #Temporal_FAEL_Smart SET letra = 'OW' WHERE letra = 'OX'
UPDATE #Temporal_FAEL_Smart SET letra = '0G' WHERE cliente='1112' and letra='08'
UPDATE #Temporal_FAEL_Smart SET letra = '0G' WHERE cliente='11293' and letra='07'
UPDATE #Temporal_FAEL_Smart SET letra = '0G' WHERE cliente='11129' and letra='08' --modificacion 2024/05/27
UPDATE #Temporal_FAEL_Smart SET letra = '0G' WHERE cliente='11354' and letra='07' --Modificacon 2024/08/05
UPDATE #Temporal_FAEL_Smart SET letra = '0G' WHERE cliente='11375' and letra='07' --Modificacon 2024/09/04
SELECT distinct
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
DROP TABLE #cat_cuentasfsmart
--select * from hashes_md5

GO

