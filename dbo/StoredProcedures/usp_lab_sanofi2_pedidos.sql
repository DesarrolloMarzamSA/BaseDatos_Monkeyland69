
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_lab_sanofi2_pedidos] @fecha VARCHAR(10)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @consulta varchar(max)
	declare @openquery varchar(max)


	CREATE TABLE [dbo].[#ventas_sanofi](
	[IDINVN] [varchar](12) NOT NULL,
	[IDORNO] [numeric](12, 0) NOT NULL,
	[IDIDAT] [numeric](8, 0) NOT NULL,
	[IDCUNO] [char](11) NOT NULL,
	[IDPRDC] [char](35) NOT NULL,
	[IDDESC] [char](50) NOT NULL,
	[IDQTY] [numeric](15, 3) NOT NULL,
	[IDSQTY] [numeric](15, 3) NOT NULL,
	[SURTIDO] [numeric](15, 3) NOT NULL,
	[FALTANTE] [numeric](15, 3) NOT NULL,
	[SUCURSAL] [varchar](3),
	[MOTIVO] [varchar](10),
	[IDSALP] [float],
	[IDAMOU] [float],
	[serie] [varchar](10)
	) ON [PRIMARY]

	CREATE TABLE [dbo].[#ventas_sanofi_temp](
	[IDORNO] [numeric](12, 0) NOT NULL,
	[IDIDAT] [numeric](8, 0) NOT NULL,
	[IDCUNO] [char](11) NOT NULL,
	[IDPRDC] [char](35) NOT NULL,
	[IDDESC] [char](50) NOT NULL,
	[IDQTY] [numeric](15, 3) NOT NULL,
	[IDSQTY] [numeric](15, 3) NOT NULL,
	[SURTIDO] [numeric](15, 3) NOT NULL,
	[FALTANTE] [numeric](15, 3) NOT NULL,
	[SUCURSAL] [varchar](3),
	[MOTIVO] [varchar](10),
	[IDSALP] [float],
	[IDAMOU] [float],
	[serie] [varchar](10)
	) ON [PRIMARY]

select @consulta='select IDINVN,
IDORNO,IDIDAT,IDCUNO,IDPRDC,IDDESC,IDQTY,IDSQTY,IDQTY SURTIDO,0 FALTANTE,
CASE 
WHEN NOI.noz3lent=''''821'''' AND SUBSTRING(IDCUNO,1,1)=''''D'''' THEN ''''04''''
WHEN NOI.noz3lent=''''807'''' AND SUBSTRING(IDCUNO,1,1)=''''X'''' AND TRIM(SR.CMCSTS)=''''075'''' THEN ''''24''''
WHEN NOI.noz3lent=''''807'''' AND SUBSTRING(IDCUNO,1,1)=''''X'''' THEN ''''23''''
WHEN NOI.noz3lent=''''808'''' AND SUBSTRING(IDCUNO,1,1)=''''X'''' THEN ''''24'''' 
WHEN NOI.noz3lent=''''855'''' THEN ''''09'''' ELSE SUBSTRING(NOI.noz3lent,2,3) 
END SUCURSAL,
 '''''''' MOTIVO,IDSALP,IDAMOU,
 (SELECT TRIM(LEZ3ISKC)AS LEZ3ISKC  FROM MA4620EF04.Z3BCTLLE WHERE LEZ3LENT = NOI.noz3lent) SERIE
from MA4620EF04.Z117ISD
left JOIN MA4620EF04.Z3BNOI NOI ON IDCUNO=NOI.NONUM
left JOIN MA4620EF04.SRBCMA SR ON IDCUNO=SR.CMCUNO
where ididat=' + REPLACE(@fecha,'-','')  +'
and IDPCA1 in (''''2941'''',''''2943'''',''''2946'''',''''2947'''',''''2948'''',''''2949'''')
and IDCCA1 not in (''''99995'''',''''99998'''')
and SUBSTRING(IDORDT,1,1)=''''F'''' and IDTYPP=1
UNION
select IDINVN,IDORNO,IDIDAT,IDCUNO,IDPRDC,IDDESC,IDQTY,IDSQTY,IDQTY SURTIDO,0 FALTANTE,
CASE 
WHEN NOI.noz3lent=''''821'''' AND SUBSTRING(IDCUNO,1,1)=''''D'''' THEN ''''04''''
WHEN NOI.noz3lent=''''807'''' AND SUBSTRING(IDCUNO,1,1)=''''X'''' AND TRIM(SR.CMCSTS)=''''075'''' THEN ''''24''''
WHEN NOI.noz3lent=''''807'''' AND SUBSTRING(IDCUNO,1,1)=''''X'''' THEN ''''23''''
WHEN NOI.noz3lent=''''808'''' AND SUBSTRING(IDCUNO,1,1)=''''X'''' THEN ''''24'''' 
WHEN NOI.noz3lent=''''855'''' THEN ''''09'''' ELSE SUBSTRING(NOI.noz3lent,2,3) 
END SUCURSAL,
 '''''''' MOTIVO,IDSALP,IDAMOU,
 (SELECT TRIM(LEZ3ISKC)AS LEZ3ISKC  FROM MA4620EF11.Z3BCTLLE WHERE LEZ3LENT = NOI.noz3lent) SERIE
from MA4620EF11.Z117ISD
left JOIN MA4620EF11.Z3BNOI NOI ON IDCUNO=NOI.NONUM
left JOIN MA4620EF11.SRBCMA SR ON IDCUNO=SR.CMCUNO
where ididat=' + REPLACE(@fecha,'-','') +'
and IDPCA1 in (''''2941'''',''''2943'''',''''2946'''',''''2947'''',''''2948'''',''''2949'''')
and IDCCA1 not in (''''99995'''',''''99998'''')
and SUBSTRING(IDORDT,1,1)=''''F'''' and IDTYPP=1
WITH UR'

--select @consulta='select IDINVN,
--IDORNO,IDIDAT,IDCUNO,IDPRDC,IDDESC,IDQTY,IDSQTY,IDQTY SURTIDO,0 FALTANTE,
--CASE 
--WHEN NOI.noz3lent=''''821'''' AND SUBSTRING(IDCUNO,1,1)=''''D'''' THEN ''''04''''
--WHEN NOI.noz3lent=''''807'''' AND SUBSTRING(IDCUNO,1,1)=''''X'''' AND TRIM(SR.CMCSTS)=''''075'''' THEN ''''24''''
--WHEN NOI.noz3lent=''''807'''' AND SUBSTRING(IDCUNO,1,1)=''''X'''' THEN ''''23''''
--WHEN NOI.noz3lent=''''808'''' AND SUBSTRING(IDCUNO,1,1)=''''X'''' THEN ''''24'''' 
--WHEN NOI.noz3lent=''''855'''' THEN ''''09'''' ELSE SUBSTRING(NOI.noz3lent,2,3) 
--END SUCURSAL,
-- '''''''' MOTIVO,IDSALP,IDAMOU,
-- (SELECT TRIM(LEZ3ISKC)AS LEZ3ISKC  FROM MA4620EF04.Z3BCTLLE WHERE LEZ3LENT = NOI.noz3lent) SERIE
--from MA4620EF04.Z117ISD
--left JOIN MA4620EF04.Z3BNOI NOI ON IDCUNO=NOI.NONUM
--left JOIN MA4620EF04.SRBCMA SR ON IDCUNO=SR.CMCUNO
--where ididat=' + REPLACE(@fecha,'-','')  +'
--and IDPCA1 in (''''2941'''',''''2943'''',''''2946'''',''''2947'''',''''2948'''',''''2949'''')
--and SUBSTRING(IDORDT,1,1)=''''F'''' and IDTYPP=1
--WITH UR'



select @openquery='INSERT INTO #ventas_sanofi
 select 
	[serie]+cast(cast(right(replicate(''0'',12)+ cast([IDINVN] as varchar),9) as bigint) as varchar) [IDINVN],
	[IDORNO],
	[IDIDAT],
	[IDCUNO],
	[IDPRDC],
	[IDDESC],
	[IDQTY],
	[IDSQTY],
	[SURTIDO],
	[FALTANTE],
	[SUCURSAL],
	[MOTIVO],
	[IDSALP],
	[IDAMOU],
	[serie]
 from openquery(AS400,'''+@consulta+''')'

--select @openquery
exec(@openquery)

select @consulta='select LSORNO,LSLSDT,LSCUNO,LSPRDC,LSDESC,LSQTY IDQTY,LSQTY IDSQTY,0 SURTIDO,LSQTY FALTANTE,
CASE 
WHEN NOI.noz3lent=''''821'''' AND SUBSTRING(LSCUNO,1,1)=''''D'''' THEN ''''04''''
WHEN NOI.noz3lent=''''807'''' AND SUBSTRING(LSCUNO,1,1)=''''X'''' AND TRIM(SR.CMCSTS)=''''075'''' THEN ''''24''''
WHEN NOI.noz3lent=''''807'''' AND SUBSTRING(LSCUNO,1,1)=''''X'''' THEN ''''23''''
WHEN NOI.noz3lent=''''808'''' AND SUBSTRING(LSCUNO,1,1)=''''X'''' THEN ''''24'''' 
WHEN NOI.noz3lent=''''855'''' THEN ''''09'''' ELSE SUBSTRING(NOI.noz3lent,2,3) 
END SUCURSAL,LSLSRN MOTIVO,LSSALP,LSAMOU,'''''''' serie
from MA4620EF04.SRBLSTSL
left JOIN MA4620EF04.Z3BNOI NOI ON LSCUNO=NOI.NONUM
left JOIN MA4620EF04.SRBCMA SR ON LSCUNO=SR.CMCUNO
where LSLSDT=' + REPLACE(@fecha,'-','') +'
AND LSPCA1 IN  (''''2941'''',''''2943'''',''''2946'''',''''2947'''',''''2948'''',''''2949'''')
AND LSCCA1 not in (''''99995'''',''''99998'''')
AND SUBSTRING(LSORDT,1,1)=''''F'''' and LSLSRN IN (''''FEA'''',''''FEP'''',''''AAA'''')
UNION
select LSORNO,LSLSDT,LSCUNO,LSPRDC,LSDESC,LSQTY IDQTY,LSQTY IDSQTY,0 SURTIDO,LSQTY FALTANTE,
CASE 
WHEN NOI.noz3lent=''''821'''' AND SUBSTRING(LSCUNO,1,1)=''''D'''' THEN ''''04''''
WHEN NOI.noz3lent=''''807'''' AND SUBSTRING(LSCUNO,1,1)=''''X'''' AND TRIM(SR.CMCSTS)=''''075'''' THEN ''''24''''
WHEN NOI.noz3lent=''''807'''' AND SUBSTRING(LSCUNO,1,1)=''''X'''' THEN ''''23''''
WHEN NOI.noz3lent=''''808'''' AND SUBSTRING(LSCUNO,1,1)=''''X'''' THEN ''''24'''' 
WHEN NOI.noz3lent=''''855'''' THEN ''''09'''' ELSE SUBSTRING(NOI.noz3lent,2,3) 
END SUCURSAL,LSLSRN MOTIVO,LSSALP,LSAMOU,'''''''' serie
from MA4620EF11.SRBLSTSL
left JOIN MA4620EF11.Z3BNOI NOI ON LSCUNO=NOI.NONUM
left JOIN MA4620EF11.SRBCMA SR ON LSCUNO=SR.CMCUNO
where LSLSDT=' + REPLACE(@fecha,'-','') +'
AND LSPCA1 IN  (''''2941'''',''''2943'''',''''2946'''',''''2947'''',''''2948'''',''''2949'''')
AND LSCCA1 not in (''''99995'''',''''99998'''')
AND SUBSTRING(LSORDT,1,1)=''''F'''' and LSLSRN IN (''''FEA'''',''''FEP'''',''''AAA'''')
WITH UR'

--select @consulta='select LSORNO,LSLSDT,LSCUNO,LSPRDC,LSDESC,LSQTY IDQTY,LSQTY IDSQTY,0 SURTIDO,LSQTY FALTANTE,
--CASE 
--WHEN NOI.noz3lent=''''821'''' AND SUBSTRING(LSCUNO,1,1)=''''D'''' THEN ''''04''''
--WHEN NOI.noz3lent=''''807'''' AND SUBSTRING(LSCUNO,1,1)=''''X'''' AND TRIM(SR.CMCSTS)=''''075'''' THEN ''''24''''
--WHEN NOI.noz3lent=''''807'''' AND SUBSTRING(LSCUNO,1,1)=''''X'''' THEN ''''23''''
--WHEN NOI.noz3lent=''''808'''' AND SUBSTRING(LSCUNO,1,1)=''''X'''' THEN ''''24'''' 
--WHEN NOI.noz3lent=''''855'''' THEN ''''09'''' ELSE SUBSTRING(NOI.noz3lent,2,3) 
--END SUCURSAL,LSLSRN MOTIVO,LSSALP,LSAMOU,'''''''' serie
--from MA4620EF04.SRBLSTSL
--left JOIN MA4620EF04.Z3BNOI NOI ON LSCUNO=NOI.NONUM
--left JOIN MA4620EF04.SRBCMA SR ON LSCUNO=SR.CMCUNO
--where LSLSDT=' + REPLACE(@fecha,'-','') +'
--AND LSPCA1 IN  (''''2941'''',''''2943'''',''''2946'''',''''2947'''',''''2948'''',''''2949'''')
--AND SUBSTRING(LSORDT,1,1)=''''F'''' and LSLSRN IN (''''FEA'''',''''FEP'''',''''AAA'''')
--WITH UR'

select @openquery='INSERT INTO #ventas_sanofi_temp select * from openquery(AS400,'''+@consulta+''')'

--select @openquery
exec(@openquery)

--SELECT sum(IDQTY) as IDQTY,sum(IDSQTY) as IDSQTY, sum(FALTANTE) as FALTANTE,sum(SURTIDO) as SURTIDO
--FROM(
--SELECT [IDORNO]
--      ,[IDPRDC]
--      ,SUM(IDQTY) AS IDQTY
--      ,SUM(IDSQTY) AS IDSQTY
--	  ,sum(SURTIDO) as SURTIDO
--      ,SUM(FALTANTE) AS FALTANTE
--  FROM #ventas_sanofi
--  GROUP BY [IDORNO],[IDPRDC]
--) AS X

/*Traer todas las facturas*/
SELECT IDINVN,IDORNO 
into #numero_facturas
FROM #ventas_sanofi
where IDINVN<>'0'
group by IDINVN,IDORNO

insert into #ventas_sanofi
SELECT isnull([IDINVN],'0') as IDINVN
	  ,a.[IDORNO]
      ,[IDIDAT]
      ,[IDCUNO]
      ,[IDPRDC]
      ,[IDDESC]
      ,[IDQTY]
      ,[IDSQTY]
      ,[SURTIDO]
      ,[FALTANTE]
      ,[SUCURSAL]
      ,[MOTIVO]
	  ,[IDSALP]
	  ,[IDAMOU]
	  ,serie
  FROM #ventas_sanofi_temp as a
  inner join #numero_facturas as b
  on  a.idorno=b.idorno

--select * into ventas_sanofi2 from #ventas_sanofi

select 'MARZAM    ' ClaveDist,'        '+desplazados.SUCURSAL ClaveSucDist,
		convert(varchar(10) ,cast(Rtrim(desplazados.IDIDAT) as datetime),104) FechaDoc,
		IDINVN+' ' Numero,'         '+ rtrim(desplazados.IDCUNO) ClaveCliente,
		'        NA' ClaveSubd,' NA' MotCancel,cast(cast(Rtrim(desplazados.IDPRDC)as bigint) as char(15) )CodigoMat,
		cast(cod_barras as char(18)) CodigoEAN,
	    cast(cast(desplazados.IDQTY as int) as char(11)) CantSolic,'PZA' UnidadMedida,
		RIGHT(REPLICATE(' ',18)+cast(IDSALP as varchar),18) PrecioUnit,
		IDAMOU as Valor,
		'         '+cast(cast(desplazados.FALTANTE as int) as varchar) CantFaltante,
		CASE	WHEN ISNULL(venta.MOTIVO,'') = 'FEA' THEN ' AG'
				WHEN ISNULL(venta.MOTIVO,'') = 'FEP' THEN ' FA' 
				WHEN ISNULL(venta.MOTIVO,'') = '' THEN ' NA'
				ELSE ' ND'
		END	    MotFaltante
from (
		SELECT SUBSTRING(IDCUNO,1,1) letra,IDINVN, IDORNO,IDIDAT,IDCUNO,IDPRDC,sucursal,IDSALP,IDAMOU,
			   sum(IDQTY) IDQTY,sum(IDSQTY) IDSQTY,sum(SURTIDO) SURTIDO,sum(FALTANTE)FALTANTE
		FROM #ventas_sanofi
		group by IDINVN,IDORNO,IDIDAT,IDCUNO,IDPRDC,sucursal,IDSALP,IDAMOU
	 ) as desplazados
	left join [capa_ibs].[dbo].[maestro_productos] as productos
	on  cast(Rtrim(IDPRDC)as int)=cast(productos.codigo as int)
	left JOIN (	SELECT IDORNO,IDPRDC,MOTIVO
				FROM #ventas_sanofi_temp
				where motivo <>''
				group by [IDORNO],[IDPRDC],[MOTIVO]
			  ) AS venta
	on desplazados.IDORNO=venta.IDORNO and desplazados.IDPRDC=venta.IDPRDC
	order by IDINVN,IDCUNO


DROP TABLE #ventas_sanofi
DROP TABLE #numero_facturas
DROP TABLE #ventas_sanofi_temp

END

GO
