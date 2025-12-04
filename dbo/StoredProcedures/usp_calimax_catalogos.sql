
 CREATE procedure [dbo].[usp_calimax_catalogos]
 @tipo varchar(1)
 as
 
 --declare @tipo int
 --set @tipo=2
 if(@tipo='1')--catalogo de productos
 begin
 select 
 LEFT(CONVERT(VARCHAR,ltrim(CEAN)) + REPLICATE(' ',13) ,13) ean,
 LEFT(CONVERT(VARCHAR,CDESC) + REPLICATE(' ',40),40)descripcion,
 RIGHT(REPLICATE('0',10) + CONVERT(varchar,convert(decimal(14,2),CPRPU)),10)prec_publico,
 RIGHT(REPLICATE('0',10) + CONVERT(varchar,convert(decimal(14,2),CPRFA)),10)prec_farmacia,
 case
 when CCFISCO ='B' or CCFISCO ='BA' then '100.00'
 when CCFISCO ='H' or CCFISCO ='HA' then RIGHT(replicate('0',3) + convert(varchar,CDSCTLIM),3)+'.00'
 when CCFISCO ='N' or CCFISCO ='NA' then '000.00'
 --SE MODIFICA PARA CLASIFICACION FISCAL NUEVA F,FA FEE FOR SERVICE
 --se agrego la opcion para F,FA
 when CCFISCO ='F' or CCFISCO ='FA' then '000.00'
 end desc_comercial 
 from openquery(as400,'
select CEAN,CDESC,CPRPU,CPRFA,CCFISCO,case
when CDSCTLIM='''' then ''0''
else
decimal(CDSCTLIM)
end CDSCTLIM,CNCA1,CPER01R,CFECHA
From LIBARG.Z1OCATOFER')
WHERE CNCA1='99728' and CPER01R=1 and 
CONVERT(datetime,substring(cfecha,1,8))-- + ' ' + substring(cfecha,10,2) + ':' + substring(cfecha,12,2) + ':' + substring(cfecha,14,2)) 
>=CONVERT(varchar(10),GETDATE(),121)--DATEADD([minute], -50, GETDATE())
end
else if(@tipo='2')--catalogo de ofertas
begin
 select 
 LEFT(CONVERT(VARCHAR,ltrim(CEAN)) + REPLICATE(' ',13) ,13) ean,
 LEFT(CONVERT(VARCHAR,CDESC) + REPLICATE(' ',40),40)descripcion,
 RIGHT(REPLICATE('0',10) + CONVERT(varchar,convert(decimal(14,2),CPRPU)),10)prec_publico,
 RIGHT(REPLICATE('0',10) + CONVERT(varchar,convert(decimal(14,2),CPRFA)),10)prec_farmacia,
 case
 when CCFISCO ='B' or CCFISCO ='BA' then '100.00'
 when CCFISCO ='H' or CCFISCO ='HA' then RIGHT(replicate('0',3) + convert(varchar,CDSCTLIM),3)+'.00'
 when CCFISCO ='N' or CCFISCO ='NA' then '000.00'
  --SE MODIFICA PARA CLASIFICACION FISCAL NUEVA F,FA FEE FOR SERVICE
 --se agrego la opcion para F,FA
 when CCFISCO ='F' or CCFISCO ='FA' then '000.00'
 end desc_comercial,
 CDIS1 desc_oferta, 
 CDIFD fecha_inicio,
CDITD fecha_fin
 from openquery(as400,'
select CEAN,CDESC,CPRPU,CPRFA,CCFISCO,case
when CDSCTLIM='''' then ''0''
else
decimal(CDSCTLIM)
end CDSCTLIM,CDIS1,CDIFD,CDITD,CNCA1,CPER01R,CFECHA
From LIBARG.Z1OCATOFER')
WHERE CNCA1='99728' and CPER01R=1 and 
CONVERT(datetime,substring(cfecha,1,8) )--+ ' ' + substring(cfecha,10,2) + ':' + substring(cfecha,12,2) + ':' + substring(cfecha,14,2)) 
>=CONVERT(varchar(10),GETDATE(),121)--DATEADD([minute], -50, GETDATE())
end

GO

