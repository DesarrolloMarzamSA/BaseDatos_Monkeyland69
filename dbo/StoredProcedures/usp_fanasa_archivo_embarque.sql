-- =============================================
-- Author:		mandrade
-- Create date: 20130430
-- Description:	genera Archivos de embarque Farmacos
-- =============================================
--[usp_fanasa_archivo_embarque] '20130515'
CREATE PROCEDURE [dbo].[usp_fanasa_archivo_embarque] 
AS
BEGIN
declare @cadena_sql varchar(max)
declare @fecha varchar(max)
set @fecha=  CONVERT(varchar,getdate()-1,112)
set @cadena_sql='
select DISTINCT trim(T1.IDINVN) IDINVN,right(''''000000000000'''' || CAST(T1.IDINVN AS varchar(12)), 8) AS FACTURA,trim(T1.IDCUNO) IDCUNO,trim(T1.IDIDAT) IDIDAT,trim(T1.IDPRDC) IDPRDC,trim(T1.IDSALP) IDSALP,CAST(trim(T1.IDSQTY)as int) IDSQTY,
(SELECT COALESCE(SUM(SROGDT.DTDCPR),0) 
               FROM   MA4620EF04.SRBGDT AS SROGDT 
               WHERE  SROGDT.DTGDSQ = ISDPL.IDGDSQ AND 
                      SROGDT.DTDITY = ''''H'''')AS DESC_COMERCIAL,trim(T6.IHORNO) IBS_ORNO,trim(oh.OHSURF) OHSURF,
                       (SELECT TRIM(LEZ3ISKC)AS LEZ3ISKC  FROM MA4620EF04.Z3BCTLLE WHERE LEZ3LENT = noi.noz3lent) SERIE, trim(T1.IDAREA) IDAREA, trim(noi.noz3lent) noz3lent,
                       TIMESTAMP(INSERT(INSERT(DIGITS(oh.OHODAT),5,0,''''-''''),8,0,''''-'''') || '''' '''' || INSERT(INSERT(DIGITS(oh.OHOTME), 3, 0, '''':''''), 6, 0, '''':'''') || ''''.000'''') HORAFACTURA,trim(e.pjeanp) pjeanp,
                       trim(N.NACOUN) NACOUN
from MARZAMDES.Z1BISD T1
inner join ma4620ef04.SRBNAM N ON T1.IDCUNO=N.NANUM  
inner join ma4620ef04.Z3BNOI noi on n.nanum=noi.nonum
INNER JOIN MA4620EF04.SRBSOH oh on t1.IDORNO=oh.OHORNO
INNER JOIN MA4620EF04.Z117ISD AS ISDPL
ON T1.IDCUNO=ISDPL.IDCUNO AND T1.IDINVN=ISDPL.IDINVN  and t1.IDORNO=ISDPL.IDORNO and ISDPL.IDPRDC=t1.IDPRDC
INNER JOIN MA4620EF04.SRBISH T6 ON T1.IDINVN = T6.IHINVN
inner join ma4620ef04.SROEAN e on t1.IDPRDC=e.pjprdc
 where N.NANCA1=''''99496'''' AND t1.IDIDAT>='''''+@fecha+''''' and  oh.OHOTME between 1 and 235959
 AND T1.IDTYPP=1 AND SUBSTRING(T1.IDORDT,1,1)=''''F'''' order by TIMESTAMP(INSERT(INSERT(DIGITS(oh.OHODAT),5,0,''''-''''),8,0,''''-'''') || '''' '''' || INSERT(INSERT(DIGITS(oh.OHOTME), 3, 0, '''':''''), 6, 0, '''':'''') || ''''.000'''') '
--execute('select * into facturacion_fanasa from openquery(as400, ''' + @cadena_sql + ''')')
--drop table facturacion_fanasa
--select * from facturacion_fanasa
delete from facturacion_fanasa
insert into facturacion_fanasa execute('select * from openquery(as400, ''' + @cadena_sql + ''')')

select distinct 
LEFT(convert(varchar, f.SERIE) +convert(varchar,convert(bigint,ltrim(rtrim(f.factura))))+replicate(' ',15-LEN(convert(varchar, f.SERIE) +convert(varchar,convert(bigint,ltrim(rtrim(f.factura)))))),15) factura,
'    'esp1,--4
replicate(' ',7-LEN(substring(f.idcuno,2,len(f.idcuno))))+substring(f.idcuno,2,len(f.idcuno)) farmacia,
' '+convert(varchar,f.ididat,8)fecha,
'   'esp2,--3
--LEFT(ltrim(isnull(f.PJEANP,m.cod_barras)),20)+replicate(' ',20-LEN(LEFT(ltrim(isnull(f.PJEANP,m.cod_barras)),20))) codean,
substring(isnull(f.PJEANP,m.cod_barras)+replicate(' ',20),1,20) codean,
'     'esp3,--5
REPLICATE('0',10-LEN(convert(varchar,convert(decimal(10,4),f.idsalp))))+convert(varchar,convert(decimal(10,4),f.idsalp)) pre_farmacia,
' ' +replicate('0',7-LEN(convert(varchar,convert(int,f.idsqty)))) +convert(varchar,convert(int,f.idsqty)) cant_surtida,
' '+'0000' const,
' ' + replace(RIGHT(convert(varchar,isnull(m.iva,0)*100),5),'.','') + replicate('0',4-LEN(replace(RIGHT(convert(varchar,isnull(m.iva,0)*100),5),'.','')))iva,
' ' + REPLICATE('0',5-LEN(RIGHT(CONVERT(varchar,convert(decimal(10,2),isnull(fm.desc_oferta,'0'))),5)))+RIGHT(CONVERT(varchar,convert(decimal(10,2),isnull(fm.desc_oferta,'0'))),5)desc_oferta,
'    'esp4,--4
REPLICATE('0',5-LEN(RIGHT(CONVERT(varchar,convert(decimal(10,2),isnull(f.DESC_COMERCIAL,'0'))),5)))+RIGHT(CONVERT(varchar,convert(decimal(10,2),isnull(f.DESC_COMERCIAL,'0'))),5)desc_comer,
'   'esp5,--3
replicate(' ',15-LEN(RIGHT(rtrim(isnull(f.OHSURF,'000000000000')),15)))+RIGHT(rtrim(isnull(f.OHSURF,'000000000000')),15) pedido
from facturacion_fanasa f
left join maestro_productos_baan m on convert(int,f.idprdc)=convert(int,m.codigo) 
left join fanasa_catalogo_manual fm on convert(int,f.idprdc)=convert(int,fm.codigo)
where len(ohsurf)>0
order by LEFT(convert(varchar, f.SERIE) +convert(varchar,convert(bigint,ltrim(rtrim(f.factura))))+replicate(' ',15-LEN(convert(varchar, f.SERIE) +convert(varchar,convert(bigint,ltrim(rtrim(f.factura)))))),15)

END

--select * from facturacion_fanasa where len(ohsurf)=0
--select * from ArchivoFanasa order by envio

--delete from ArchivoFanasa where convert(varchar,envio,112)=convert(varchar,GETDATE()-1,112)
--select convert(varchar,GETDATE()-1,112)
--delete from ArchivoFanasa where idArchivo=10

GO

