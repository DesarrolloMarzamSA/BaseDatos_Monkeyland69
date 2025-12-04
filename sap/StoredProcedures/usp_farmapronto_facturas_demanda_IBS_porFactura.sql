


-- =============================================

-- Author:		<Author,,Name>

-- Create date: <Create Date,,>

-- Description:	<Description,,>
-- exec [sap].[usp_farmapronto_facturas_demanda] 0, '20210913','20210913'
-- =============================================
--EXEC [sap].[usp_farmapronto_facturas] @AS400 = 0, @fecha_inicio = N'20210515', @fecha_fin = N'20210517'
CREATE PROCEDURE [sap].[usp_farmapronto_facturas_demanda_IBS_porFactura] 
	-- Add the parameters for the stored procedure here
	@AS400 as int=null,@factura varchar(50)
	--@fecha_inicio as varchar(10)=null,
	--@fecha_fin as varchar(10)=null

AS

BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from

	-- interfering with SELECT statements.

	SET NOCOUNT ON;

declare @consulta as varchar(max)

CREATE TABLE [dbo].[#facturas](
	[orden] [varchar](10) NULL,
	[factura] [varchar](15) NULL,
	[cuenta] [varchar](15) NULL,
	[fecha] [datetime] NULL,
	[uuid] [varchar](50) NULL,
	[ceserie] varchar(50) null
) ON [PRIMARY]

declare @Salida_temporal table(
	sucursal varchar(10), 
	cliente varchar(7),
	factura varchar(8),
	folio_fiscal varchar(8),
	rfc varchar(20),
	IHINVN varchar(15),
	UUID varchar(150),
	fecha_UUID varchar(10),
	serie varchar(50)
)
declare @UUID_temporal table(
	[Remision] [varchar](10) NULL,
	[Folio] [varchar](15) NULL,
	[NoClienteProveedor] [varchar](15) NULL,
	[FechaEmision] [datetime] NULL,
	[UUID] [varchar](50) NULL
)

declare @extraccionEmbarque table(
			VWERK varchar(8), 
			PARTNE varchar(20),
			XBLNR varchar(32), 
			VBELN varchar(20),
			FKDAT datetime, 
			POSNR datetime,
			MATNR bigint, 
			ARKTX varchar(80),
			CHARG varchar(20), 
			EAN11 varchar(36), 
			KONDM varchar(4),
			CANTIDAD decimal(13,3),
			PRECIOFARMACIA decimal(15,2),
			PRECIO_PUBLICO decimal(13,2),
			PRECIO_PUBLICO_IMP decimal(13,2), 
			IMPORTE_BRUTO decimal(13,2),
			PORCENTAJE_OFERTAS decimal(13,2),
			OFERTAS decimal(13,2), 
			PORCENTAJE_DESCUENTOS decimal(13,2), 
			DESCUENTOS decimal(13,2),
			IEPS decimal(13,2), 
			IVA decimal(13,2),
			IMPORTE_NETO decimal(13,2),
			BSTKD varchar(70),
			PORC_TMX1 decimal(10,2), 
			PORC_TMX2 decimal(10,2),
			IND_SECTOR varchar(20), 
			KNRZE varchar(20),
			TAXNUM varchar(40), 
			IDNUMBER varchar(120),
			ALTKN varchar(20)
		)
		


if(@AS400=1)

begin

	 select @consulta='
	 Insert into [#facturas] ([orden],[factura],[cuenta],[fecha],[uuid])
	 select rtrim(CEORNO) as orden,
            rtrim(CECSTS) + RIGHT(''000000000''+rtrim(CEINVN),9) as factura,
     	   rtrim(CEDENO) as cuenta,
     	   convert(datetime, cast(CEFECH as varchar),112) as fecha,
     	   rtrim(CEUUID) as uuid
     from openquery(AS400,''select CEORNO,CECSTS,CEINVN,CEDENO,CEFECH,CEUUID,CETIPO,ceserie from marzamprd.Z3OUUIDS)'
	 --exec(@consulta)
--ceserie campo serie
end

else
declare @foliocortado varchar(max);
set @foliocortado=(select SUBSTRING ( @factura ,5 ,12 ));
--select @foliocortado;
     Insert into [#facturas] ([orden],[factura],[cuenta],[fecha],[uuid],[ceserie])
     SELECT [Remision]
           ,rtrim([Sucursal]) + RIGHT('000000000'+rtrim([Folio]),9) as factura
     	  ,[NoClienteProveedor]
     	  ,[FechaEmision]
     	  ,[UUID]
     	  ,[serie]
       from [192.168.90.190].[ETI_DatosCE].[dbo].[CFDIS_Emitidos]
       where [FechaEmision]>='2023-01-01' and [Folio]=(select @foliocortado);


--8030

--declare @consulta as varchar(max)
      select @consulta='select   
				case when sucursal_traductor=1 then 21 else sucursal_traductor end as sucursal,
				substring(IHCUNO,2,5) as cliente,
        		SUBSTRING(cast(IHINVN as varchar(20)),5,8) as factura,
      			SUBSTRING(cast(IHINVN as varchar(20)),5,8) as folio_fiscal,
      			case Rtrim(OHSURF) when '''' then ''999999999999999'' else SUBSTRING(Rtrim(OHSURF),2,15) end as ref,
      			IHINVN,
      			isnull(uuid,'''') as UUID,
      			convert(varchar(10),fecha,112) as fecha_UUID,
      			ceserie
			from openquery(AS400,''
				SELECT IHINVN,IHCUNO,ADWHCD,OHSURF,IHTYPP,OHORDT
				FROM MA4620EF04.SRBISH
      			inner join MA4620EF04.SRONAD on IHCUNO=ADNUM and ADADNO=2
      			inner join MA4620EF04.SRBSOH on IHORNO=OHORNO
      			INNER JOIN MA4620EF04.SRONAM ON OHCUNO=NANUM AND NANCA1 IN (''''99292'''')
      			where IHINVN in (
'''+(select ''''+@factura+'''')+'''

)
			'') as x
			left join [#facturas] on cast(IHINVN as varchar(20))=factura
			left join (
      			select 26 as sucursal_traductor,''V'' as ibs_letra
				union
				SELECT sucursal_traductor,ibs_letra FROM [capa_ibs].[dbo].[sucursales] where sistema=''ibs''
				group by sucursal_traductor,ibs_letra
			) as y on substring(IHCUNO,1,1)=y.ibs_letra
			where rtrim(OHORDT) like ''F%''
			order by IHINVN'
--select @consulta
		   --meter a tabla temporal #UUID_temporal
		 
		   insert into @Salida_temporal 
		   exec (@consulta)

		 -- 2.- Usar la tabla temporal @extraccionEmbarque para los UUID
--		 insert into @UUID_temporal
--		 SELECT [Remision]  ,[Folio]  ,[NoClienteProveedor] ,[FechaEmision] ,[UUID] 
--		 FROM [192.168.90.190].[ETI_DatosCE].[dbo].[CFDIS_Emitidos]
----		 where folio in (select distinct VBELN from extraccionEmbarqueFarmapronto)
--		 where folio in (select distinct VBELN from @extraccionEmbarque)
		 
		 --[FechaEmision]>convert(datetime,@fecha_inicio,112) and [FechaEmision]<dateadd(day,1,convert(datetime,@fecha_fin,112))

		--- llenar a una temporal exec [IEmbarque].[ExtraccionEmbarque] 
		 --exec  [192.168.90.209].[MiddleWare].[IEmbarque].[ExtraccionEmbarque] @fecha_inicio,'0011000142'

		/*
		insert into @extraccionEmbarque exec  [192.168.90.209].[MiddleWare].[IEmbarque].[ExtraccionEmbarque] @fecha_inicio,'0011000142'
		insert into @extraccionEmbarque exec  [192.168.90.209].[MiddleWare].[IEmbarque].[ExtraccionEmbarque] @fecha_fin,'0011000142' --se toma encuenta la facturacion que salio tarde
		
		insert into @extraccionEmbarque exec  [192.168.90.209].[MiddleWare].[IEmbarque].[ExtraccionEmbarque] @fecha_inicio,'','0011000142'
		insert into @extraccionEmbarque exec  [192.168.90.209].[MiddleWare].[IEmbarque].[ExtraccionEmbarque] @fecha_inicio,'','0016001800'
		*/
				
		-- union por numero factura con UUID a #UUID_temporal on [Folio] =VBELN sacar [UUID] 
		--meter en la tabla temporal #A case when VWERK='1108' then '18' when VWERK='1105' then '13' when VWERK='1109' then '05' 
		--insert into @Salida_temporal
		--select distinct case when VWERK='1108' then '18' 
		--		when VWERK='1105' then '13' 
		--		when VWERK='1109' then '05'
		--		when VWERK='1102' then '03' else VWERK end,
		--		right(ALTKN,5),
		--		right(VBELN,8),
		--		right(VBELN,8),
		--		--TAXNUM,
		--		--BSTKD,
		--		CASE WHEN LEN(BSTKD)=16 THEN SUBSTRING(BSTKD,2,15) ELSE BSTKD END AS BSTKD,
		--		VBELN, 
		--		u.UUID,
		--		isnull(CONVERT(VARCHAR(8), u.FechaEmision, 112),u.FechaEmision)
		--		--into FacturasFarmapronto
		--		from --extraccionEmbarqueFarmapronto as e
		--		@extraccionEmbarque e 
		--		left join @UUID_temporal u on u.Folio=cast(e.VBELN as bigint)
		--   --meter en tabla temporal #A
		 
	select * from @Salida_temporal

drop table [#facturas]

END

GO

