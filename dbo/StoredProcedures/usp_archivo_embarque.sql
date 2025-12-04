SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_archivo_embarque]
AS
BEGIN
	
declare @cadena_sql varchar(max)
set @cadena_sql='
select DISTINCT T1.IDINVN,right(''''000000000000'''' || CAST(T1.IDINVN AS varchar(12)), 8) AS FACTURA,T1.IDCUNO,T1.IDIDAT,T1.IDPRDC,T1.IDSALP,T1.IDSQTY,
(SELECT COALESCE(SUM(SROGDT.DTDCPR),0) 
               FROM   MA4620EF04.SROGDT AS SROGDT 
               WHERE  SROGDT.DTGDSQ = ISDPL.IDGDSQ AND 
                      SROGDT.DTDITY = ''''H'''')AS DESC_COMERCIAL,T6.IHORNO IBS_ORNO,oh.OHSURF,
                      (SELECT LEZ3ISKC FROM MA4620EF04.Z3BCTLLE WHERE LEZ3LENT = T1.IDAREA) SERIE, T1.IDAREA
from MARZAMDES.Z1BISD T1
inner join ma4620ef04.SRBNAM N ON T1.IDCUNO=N.NANUM AND N.NANCA1=''''99496''''
INNER JOIN MA4620EF04.SRBSOH oh on t1.IDORNO=oh.OHORNO
INNER JOIN MA4620EF04.Z117ISD AS ISDPL
ON T1.IDCUNO=ISDPL.IDCUNO AND T1.IDINVN=ISDPL.IDINVN  and t1.IDORNO=ISDPL.IDORNO and ISDPL.IDPRDC=t1.IDPRDC
INNER JOIN MA4620EF04.SRBISH T6 ON T1.IDINVN = T6.IHINVN
 where  t1.IDIDAT=''''20130506'''' 
  and T1.IDTYPP=1 AND SUBSTRING(T1.IDORDT,1,1)=''''F'''''

--select COUNT(*) from facturacion_fanasa
--select * from sucursales


delete from facturacion_fanasa
insert into facturacion_fanasa execute('select * from openquery(as400, ''' + @cadena_sql + ''')')

select distinct 
LEFT('F' + 
case
when 
s.ibs_letra='A' or s.ibs_letra='D' then 'U' 
else s.ibs_letra end 
+ convert(varchar,convert(int,f.factura))+
replicate(' ',15-LEN('F' + 
case
when 
s.ibs_letra='A' or s.ibs_letra='D' then 'U' 
else s.ibs_letra end 
+ convert(varchar,convert(int,f.factura)))),15)factura,
'    'esp1,--4
replicate(' ',7-LEN(substring(f.idcuno,2,len(f.idcuno))))+substring(f.idcuno,2,len(f.idcuno)) farmacia,
convert(varchar,f.ididat,8)fecha,
'   'esp2,--3
+LEFT(m.cod_barras,20)+replicate(' ',20-LEN(LEFT(m.cod_barras,20))) codean,
'     'esp3,--5
REPLICATE('0',10-LEN(convert(varchar,convert(decimal(10,4),f.idsalp))))+convert(varchar,convert(decimal(10,4),f.idsalp)) pre_farmacia,
' ' +replicate('0',7-LEN(convert(varchar,convert(int,f.idsqty)))) +convert(varchar,convert(int,f.idsqty)) cant_surtida,
' '+'0000' const,
' ' + replace(RIGHT(convert(varchar,m.iva*100),5),'.','') + replicate('0',4-LEN(replace(RIGHT(convert(varchar,m.iva*100),5),'.','')))iva,
' ' + REPLICATE('0',5-LEN(RIGHT(CONVERT(varchar,convert(decimal(10,2),isnull(fm.desc_oferta,'0'))),5)))+RIGHT(CONVERT(varchar,convert(decimal(10,2),isnull(fm.desc_oferta,'0'))),5)desc_oferta,
'    'esp4,--4
REPLICATE('0',5-LEN(RIGHT(CONVERT(varchar,convert(decimal(10,2),isnull(f.DESC_COMERCIAL,'0'))),5)))+RIGHT(CONVERT(varchar,convert(decimal(10,2),isnull(f.DESC_COMERCIAL,'0'))),5)desc_comer,
'   'esp5,--3
replicate(' ',15-LEN(RIGHT(rtrim(isnull(f.OHSURF,'000000000000')),15)))+RIGHT(rtrim(isnull(f.OHSURF,'000000000000')),15) pedido
from facturacion_fanasa f
left join maestro_productos_baan m on convert(int,f.idprdc)=convert(int,m.codigo) 
left join fanasa_catalogo_manual fm on convert(int,f.idprdc)=convert(int,fm.codigo)
left join sucursales s on SUBSTRING(f.idcuno,1,1)=s.ibs_letra
--where f.idinvn in(821000417859)
order by LEFT('F' + 
case
when 
s.ibs_letra='A' or s.ibs_letra='D' then 'U' 
else s.ibs_letra end 
+ convert(varchar,convert(int,f.factura))+
replicate(' ',15-LEN('F' + 
case
when 
s.ibs_letra='A' or s.ibs_letra='D' then 'U' 
else s.ibs_letra end 
+ convert(varchar,convert(int,f.factura)))),15)

END
GO
