USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_fanasa_pedidos_embarque]
@orno varchar(20),@cliente varchar(20),@compania varchar(20)
WITH ENCRYPTION
as
declare @cadena_sql as varchar(1000),
@fac varchar(20)
--select @cliente='A64160'
--select @orno='7804639'

select @cadena_sql = 

'Select RIGHT(''''00000000'''' || TRIM(CAST(IHINVN AS VARCHAR(25))), 8) as IHINVN,IHORNO from '+ @compania + '.SRBISH where IHORNO=' +@orno+ ' and IHCUNO=''''' +@cliente+ ''''''

create table #fanasa_fac(nfac varchar(20), orno varchar(20))

insert into #fanasa_fac execute('select * from openquery(AS400, ''' + @cadena_sql + ''')')

select @fac=(select  nfac from #fanasa_fac)
if (@fac<>'')
begin
create table #fanasa_detalle_fac(orno varchar(20),codigo varchar(20),desc_comer money,desc_oferta money)

select @cadena_sql = 'SELECT 
  ISDPL.IDORNO  AS "Orden", 
  --ISDPL.IDCUNO  AS "Cliente", 
  --ISDPL.IDINVN  AS "Factura", 
  --ISDPL.IDIDAT  AS "Fecha Fac.", 
  ISDPL.IDPRDC  AS "Código", 
  --ISDPL.IDGDSQ  AS "Llave Desctos", 
(SELECT COALESCE(SUM(SROGDT.DTDCPR),0) 
               FROM   '+ @compania + '.SROGDT AS SROGDT 
               WHERE  SROGDT.DTGDSQ = ISDPL.IDGDSQ AND 
                      SROGDT.DTDITY = ''''H'''')AS DESC_COMERCIAL  , 
(SELECT COALESCE(SUM(ISDPL.IDQTY * 
                      SROGDT.DTDCAM),0) 
               FROM   '+ @compania + '.SROGDT AS SROGDT 
               WHERE  SROGDT.DTGDSQ = ISDPL.IDGDSQ AND 
                      SROGDT.DTDITY <> ''''H'''' AND 
                      SROGDT.DTDITY <> ''''O'''')AS DES_OFERTA
FROM      '+ @compania + '.Z117ISD AS ISDPL 
WHERE     IDINVN = ' + @fac + ' 
      AND IDCUNO = '''''+@cliente+''''' FOR READ ONLY WITH UR '

insert into #fanasa_detalle_fac execute('select * from openquery(as400, ''' + @cadena_sql + ''')')

select 
LEFT('F' + --replace(s2.ibs_letra,'A','U') 
case
when 
s2.ibs_letra='A' or s2.ibs_letra='D' then 'U' 
else s2.ibs_letra end 
+ convert(varchar,convert(int,SUBSTRING(@fac,0,10))) + replicate(' ',15),15)factura,
'    'esp,--4
RIGHT(replicate(' ',7) +  p.cuenta,7)cuenta,
' ' + RIGHT(REPLICATE(' ',8) + convert(varchar,YEAR(p.fecha_pedido))+ RIGHT(REPLICATE('0',2) + convert(varchar,MONTH(p.fecha_pedido)),2) +  RIGHT(REPLICATE('0',2) + convert(varchar,DAY(p.fecha_pedido)),2),8)fecha,
'   'esp,--3
LEFT(p.codigo_barras + REPLICATE(' ',20),20),
'     'esp,--5
RIGHT(replicate('0',10) + convert(varchar,convert(decimal(10,4),p.precio_farm)),10)pre_farmacia,
' ' + RIGHT(replicate('0',7) + convert(varchar,cantidad_surtida),7) cant_surtida,
' ' + '0000' const,
' ' + replace(RIGHT(REPLICATE('0',5) + convert(varchar,m.iva*100),5),'.','') iva,


' ' + RIGHT(REPLICATE('0',5) + CONVERT(varchar,convert(decimal(10,2),isnull(fm.desc_oferta,'0'))),5)desc_oferta,
'    'esp,--4
RIGHT(REPLICATE('0',5) + CONVERT(varchar,convert(decimal(10,2),isnull(d.desc_comer,'0'))),5)desc_comer,
'   'esp,--3
RIGHT(REPLICATE(' ',15) + rtrim(p.pedido),15) pedido
from pedidos_fanasa_historia p
inner join maestro_productos_baan m on convert(int,p.codigo)=convert(int,m.codigo) and convert(int,p.orno)=convert(int,@orno) AND p.cantidad_surtida>0
left join #fanasa_detalle_fac d on convert(int,d.orno)=convert(int,p.orno) and convert(int,d.codigo)=convert(int,p.codigo)
left join fanasa_catalogo_manual fm on convert(int,p.codigo)=convert(int,fm.codigo)
inner join sucursales s on p.sucursal=s.sucursal
inner join sucursales s2 on s.ibs=s2.ibs and SUBSTRING(s.ibs,2,2)=s2.sucursal
--group by p.letra,p.cuenta,p.fecha_pedido,p.codigo_barras,p.precio_farm,p.cantidad_surtida,m.iva,fm.desc_oferta,d.desc_comer,pedido
drop table #fanasa_detalle_fac
end
drop table #fanasa_fac 


GO
