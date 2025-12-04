CREATE PROCEDURE [dbo].[usp_genera_fact_elect_det_fcias_leyva] --1,'FLE940304UC2','2016-12-21'
	@sucursal TINYINT,
	@rfc VARCHAR(20),
	@fecha DATETIME
AS
--[usp_genera_fact_elect_det_fcias_leyva] 1,'FLE940304UC2','2016-12-21'
--DECLARE @sucursal TINYINT
--DECLARE @rfc VARCHAR(20)
--DECLARE @fecha DATETIME
--SET @sucursal = 1
--SET @rfc = 'FLE940304UC2'
--SET @fecha = '2011-03-30'

--SELECT	RIGHT(REPLICATE('0', 5) + t1.cliente, 5) + 
--		LEFT(CONVERT(VARCHAR(12), CONVERT(BIGINT, t1.folio_fiscal)) + REPLICATE(' ', 12), 12) +
--		'0           ' +
--		RIGHT(REPLICATE('0', 4) + CONVERT(VARCHAR(4), DATEPART(YYYY,@fecha)), 4) +
--		RIGHT(REPLICATE('0', 2) + CONVERT(VARCHAR(2), DATEPART(MM,@fecha)), 2) +
--		RIGHT(REPLICATE('0', 2) + CONVERT(VARCHAR(2), DATEPART(DD,@fecha)), 2) +
--		LEFT(CONVERT(VARCHAR(13), CONVERT(BIGINT, t1.cod_barras)) + REPLICATE(' ', 13), 13) + 
--		RIGHT(REPLICATE(' ', 7) + CONVERT(VARCHAR(7), t1.piezas_surtidas_con_cargo), 7) +
--		RIGHT(REPLICATE(' ', 7) + CONVERT(VARCHAR(7), t1.piezas_surtidas_sin_cargo), 7) +
--		RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), t1.precio_farm_sin_imp), 9) +
--		RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), t1.porcentaje_descto_oferta), 6) +
--		RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), t1.porcentaje_descto_comercial), 6) +
--		RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), t1.porcentaje_iva), 9)
--FROM	facturacion_electronica_estandar t1 --INNER JOIN cat_farmatodo_facturacion t2 ON
--		--t1.cliente = t2.cliente
--WHERE	t1.sucursal in(1,21) and
--		--t1.ctepadre = @ctepadre AND 
--		T1.ctepadre='120' AND 
--		--t1.rfc = @rfc AND
--		--t1.fecha_factura = @fecha
--		fecha_tandem >= convert(datetime, convert(varchar(10), @fecha, 121), 121)
--ORDER BY t1.factura

declare @fecha_ datetime
declare @fecha_inicio varchar(10)
declare @fecha_final varchar(10)
declare @consulta_as400 varchar(max)
declare @consulta_sql varchar(max)

--select @fecha_entrada='2014-10-06'

select @fecha_=CONVERT(datetime,@fecha,120)

select @fecha_inicio=convert(varchar,DATEADD(DAY,-1,@fecha_),112),@fecha_final=convert(varchar,@fecha_,112)

--((IDITET+(IDITET*(COALESCE(RMPESI,0)/100))))+((IDNSVA+(IDNSVA*(COALESCE(RMPESI,0)/100)))*decimal((T17.CTVATP/100 ),5,2)) as TOTAL_FINAL,
select @consulta_as400='
select IDORNO,OHCUNO,IDINVN,idline,IDPRDC,decimal(PCXPRC,13,0) as PCXPRC,IDIDAT,
IDDESC,IDQTY,IDPCA5 as cf, IDSALP as farmacia, idnprc as unitario,
IDAMOU as precio_cantidad ,IDNSVA/IDQTY as neto_unitario,round(IDNSVA,2) as neto_cantidad,
T17.CTVATP as iva ,COALESCE(RMPESI,0) as IEPS ,(IDITET*(COALESCE(RMPESI,0)/100)) as IEPS_MONEDA,
(IDITET*(1+(COALESCE(RMPESI,0)/100))) as TOTAL_IEPS ,(IDNSVA*(1+(COALESCE(RMPESI,0)/100)))*decimal((T17.CTVATP/100 ),5,2) as IVA_MONEDA,
decimal((1+(COALESCE(RMPESI,0)/100)),10,2)*decimal((IDITET+(IDNSVA*decimal((T17.CTVATP/100 ),10,2))),10,2) as TOTAL_FINAL,
OHSURF,(SELECT TRIM(LEZ3ISKC)AS LEZ3ISKC  FROM MA4620EF04.Z3BCTLLE WHERE LEZ3LENT = NOI.noz3lent) SERIE,COALESCE(DTDCPR,0) AS oferta,
OHORDT
from MA4620EF04.SRBSOH
  LEFT join MA4620EF04.srbISD ON OHORNO=IDORNO
  LEFT JOIN MA4620EF04.Z3BNOI NOI ON IDCUNO=NOI.NONUM
  LEFT JOIN MA4620EF04.SROGDT ON DTGDSQ = IDGDSQ AND DTDITY = ''''1''''
  LEFT JOIN MA4620EF04.SROPCR ON IDPRDC=PCIPRC AND PCXRTY=''''IA''''
  LEFT JOIN MA4620EF04.SRBVHC ON IDVAHC=HCVAHC
  LEFT JOIN MA4620EF04.SROCTLFA T17 ON HCVATC=T17.CTVATC
  left join MA4620EF04.SRBRPM as IPESH on IPESH.RPPRDC=IDPRDC
  left join MA4620EF04.SRBCTLRM as IPESD on IPESD.RMMACO=IPESH.RPMACO
  where OHODAT ='+@fecha_inicio+' and OHOTME >=60000 AND IDTYPP=1 and IDCCA1 in (''''99120'''')
  
  union
  
select IDORNO,OHCUNO,IDINVN,idline,IDPRDC,decimal(PCXPRC,13,0) as PCXPRC,IDIDAT,
IDDESC,IDQTY,IDPCA5 as cf, IDSALP as farmacia, idnprc as unitario,
IDAMOU as precio_cantidad ,IDNSVA/IDQTY as neto_unitario,round(IDNSVA,2) as neto_cantidad,
T17.CTVATP as iva ,COALESCE(RMPESI,0) as IEPS ,(IDITET*(COALESCE(RMPESI,0)/100)) as IEPS_MONEDA,
(IDITET*(1+(COALESCE(RMPESI,0)/100))) as TOTAL_IEPS ,(IDNSVA*(1+(COALESCE(RMPESI,0)/100)))*decimal((T17.CTVATP/100 ),5,2) as IVA_MONEDA,
decimal((1+(COALESCE(RMPESI,0)/100)),10,2)*decimal((IDITET+(IDNSVA*decimal((T17.CTVATP/100 ),10,2))),10,2) as TOTAL_FINAL,
OHSURF,(SELECT TRIM(LEZ3ISKC)AS LEZ3ISKC  FROM MA4620EF04.Z3BCTLLE WHERE LEZ3LENT = NOI.noz3lent) SERIE,COALESCE(DTDCPR,0) AS oferta,
OHORDT
from MA4620EF04.SRBSOH
  LEFT join MA4620EF04.srbISD ON OHORNO=IDORNO
  LEFT JOIN MA4620EF04.Z3BNOI NOI ON IDCUNO=NOI.NONUM
  LEFT JOIN MA4620EF04.SROGDT ON DTGDSQ = IDGDSQ AND DTDITY = ''''1''''
  LEFT JOIN MA4620EF04.SROPCR ON IDPRDC=PCIPRC AND PCXRTY=''''IA''''
  LEFT JOIN MA4620EF04.SRBVHC ON IDVAHC=HCVAHC
  LEFT JOIN MA4620EF04.SROCTLFA T17 ON HCVATC=T17.CTVATC
  left join MA4620EF04.SRBRPM as IPESH on IPESH.RPPRDC=IDPRDC
  left join MA4620EF04.SRBCTLRM as IPESD on IPESD.RMMACO=IPESH.RPMACO
  where OHODAT ='+@fecha_final+' and OHOTME <60000 AND IDTYPP=1 and IDCCA1 in (''''99120'''')
'

/*

*/


--cast(IDINVN as varchar(20))+'' ''+
--el sistema de leyva no acepta fechas diferentes a la fecha actual, para que las facturas se reflejen en su sistema
--se necesita las fechas de los registros salgan con la fecha del dia en que se geenra el archivo
select @consulta_sql=
'select 
		LEFT(substring(OHCUNO,2,5) + REPLICATE('' '',5),5)+
		LEFT(ISNULL(CONVERT(VARCHAR,CONVERT(BIGINT,substring(cast(IDINVN as varchar),4,9))),'''') + REPLICATE('' '',12) ,12)+
		''0           '' +'''+
		--cast(IDIDAT as varchar(8))+
		@fecha_final+'''+'+
		'LEFT(cast(isnull(PCXPRC,''0'')  as varchar) + REPLICATE('' '',13),13)+
		RIGHT(REPLICATE('' '', 7)+CONVERT(VARCHAR,cast(IDQTY as int)),7)+
		RIGHT(REPLICATE('' '', 7)+''0'', 7)+
		RIGHT(REPLICATE('' '',9)+CONVERT(VARCHAR,cast(round(neto_unitario,2) as decimal(10,2))),9)+
		RIGHT(REPLICATE('' '', 9) + ''0.00'', 6) +
		RIGHT(REPLICATE('' '', 6) + ''0.00'', 6) +
		RIGHT(REPLICATE('' '', 6) + CONVERT(VARCHAR,cast(round(iva,2) as decimal(10,2))), 9)+
		RIGHT(REPLICATE('' '', 6) + CONVERT(VARCHAR,cast(round(IEPS,2) as decimal(10,2))), 9)+
		RIGHT(REPLICATE('' '', 11) + rtrim(OHSURF), 10)
 from openquery(AS400,'+''''+@consulta_as400+''''+') 
 where OHORDT like ''F%''
 order by OHCUNO,IDINVN'

execute(@consulta_sql)

--select @consulta_sql

GO

