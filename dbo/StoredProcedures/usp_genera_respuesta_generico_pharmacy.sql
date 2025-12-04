-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_genera_respuesta_generico_pharmacy]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
select SUCURSAL,SERIE,	IDCUNO,	IDINVN	,FACTURA,	IDLINE,	IDPRDC,	PCXPRC,	IDQTY,	IHIDAT,	IHOREF  
into #surtido
from openquery(as400, '
select CASE WHEN NOI.noz3lent=''821'' AND SUBSTRING(IDCUNO,1,1)=''D'' THEN CAST(''04'' AS INT) 
WHEN NOI.noz3lent=''807'' AND SUBSTRING(IDCUNO,1,1)=''X'' AND TRIM(SR.CMCSTS)=''075'' THEN CAST(''24'' AS INT) 
WHEN NOI.noz3lent=''807'' AND SUBSTRING(IDCUNO,1,1)=''X'' THEN CAST(''23'' AS INT) 
WHEN NOI.noz3lent=''808'' AND SUBSTRING(IDCUNO,1,1)=''X'' THEN CAST(''24'' AS INT) 
WHEN NOI.noz3lent=''855'' THEN CAST(''09'' AS INT) 
ELSE CAST(SUBSTRING(NOI.noz3lent,2,3)AS INT) 
END SUCURSAL,
(SELECT TRIM(LEZ3ISKC)AS LEZ3ISKC  FROM MA4620EF04.Z3BCTLLE WHERE LEZ3LENT = NOI.noz3lent) SERIE,
TRIM(IDCUNO) AS IDCUNO,IDINVN,
right(''000000000000'' || CAST(IDINVN AS varchar(12)), 8)as factura,
idline,IDPRDC
,decimal(PCXPRC,13,0) as PCXPRC,IDQTY,
IHIDAT ,
TRIM(IFNULL(OHSURF,'''')) AS IHOREF
from  MA4620EF04.SRBISD  
inner join MA4620EF04.SRBISH on IHINVN=IDINVN and IDCUNO=IHCUNO
inner join MA4620EF04.SRBSOH on IDORNO= OHORNO AND OHCUNO=IHCUNO 
inner join MA4620EF04.SRONAM ON IDCUNO=NANUM
INNER JOIN MA4620EF04.Z3BNOI NOI ON IDCUNO=NOI.NONUM
INNER JOIN MA4620EF04.SRBCMA SR ON IDCUNO=SR.CMCUNO 
LEFT JOIN MA4620EF04.SRBGDT AS SROGDT ON SROGDT.DTGDSQ = IDGDSQ AND SROGDT.DTDITY = ''1'' 
 LEFT JOIN MA4620EF04.SROPCR ON IDPRDC=PCIPRC AND PCXRTY=''IA'' 
 LEFT JOIN MA4620EF04.SRBVHC ON IDVAHC=HCVAHC 
 LEFT JOIN MA4620EF04.SROCTLFA T17 ON HCVATC=T17.CTVATC 
 left join MA4620EF04.SRBRPM as IPESH on IPESH.RPPRDC=IDPRDC 
 left join MA4620EF04.SRBCTLRM as IPESD on IPESD.RMMACO=IPESH.RPMACO 
 where IHTYPP=1 and  NANCA1 in(''99210'') and IHIDAT >= VARCHAR_FORMAT(CURRENT TIMESTAMP, ''YYYYMMDD'') - 1  
 and IDNSVA<>0 and IDQTY <>0 and SUBSTRING(IDORDT,1,1) IN(''F'',''R'')
   order by IDINVN,IDLINE')

   update p set p.cant_surt=s.idqty 
		from #surtido s
		inner join [monkeyland].[FSM].[pedidos_FaSantaMaria] p
		on SUBSTRING(s.IDCUNO,2,LEN(s.IDCUNO))=p.cliente and s.IDPRDC=p.codigo 
		
	select	distinct rtrim(cod_barras)+ replicate(' ', 13-len(rtrim(cod_barras)))+
			cast(cant_ped as varchar)+replicate(' ', 7-len(cast(cant_ped as varchar))) +
			cast(cant_ped-isnull(cant_surt,0) as varchar)+replicate(' ', 7-len(cast(cant_ped-isnull(cant_surt,0) as varchar)))+
			replicate(' ', 10-len(orden))+orden+
			cliente+replicate(' ', 12-len(cliente))+
			replicate(' ', 2-len(convert(varchar,sucursal)))+convert(varchar,sucursal)
	FROM [monkeyland].[FSM].[pedidos_FaSantaMaria] 
	where CONVERT(varchar,fecha_pedido,112)>=CONVERT(varchar,GETDATE()-1,112)	and DATEPART(hour,fecha_pedido)>=18

END

GO

