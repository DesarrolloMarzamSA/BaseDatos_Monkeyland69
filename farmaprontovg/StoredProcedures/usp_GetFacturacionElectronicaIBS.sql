




-- =============================================

-- Author:		<Author,,Name>

-- Create date: <Create Date,,>

-- Description:	<Description,,>

-- =============================================

CREATE PROCEDURE [farmaprontovg].[usp_GetFacturacionElectronicaIBS] --1,

	-- Add the parameters for the stored procedure here

	@AS400 as int,

	@fecha_inicio as varchar(10),

	@fecha_fin as varchar(10)

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

	[uuid] [varchar](50) NULL

) ON [PRIMARY]



if(@AS400=1)

begin

	 select @consulta='

	 Insert into [#facturas] ([orden],[factura],[cuenta],[fecha],[uuid])

	 select rtrim(CEORNO) as orden,

            rtrim(CECSTS) + RIGHT(''000000000''+rtrim(CEINVN),9) as factura,

     	   rtrim(CEDENO) as cuenta,

     	   convert(datetime, cast(CEFECH as varchar),112) as fecha,

     	   rtrim(CEUUID) as uuid

     from openquery(AS400,''select CEORNO,CECSTS,CEINVN,CEDENO,CEFECH,CEUUID,CETIPO from marzamprd.Z3OUUIDS where CEFECH>='+@fecha_inicio+' and CEFECH<='+@fecha_fin+''')'



	 exec(@consulta)

end

else

begin



     Insert into [#facturas] ([orden],[factura],[cuenta],[fecha],[uuid])

     SELECT [Remision]

           ,rtrim([Sucursal]) + RIGHT('000000000'+rtrim([Folio]),9) as factura

     	  ,[NoClienteProveedor]

     	  ,[FechaEmision]

     	  ,[UUID]

       FROM [192.168.90.190].[ETI_DatosCE].[dbo].[CFDIS_Emitidos]

       where [FechaEmision]>convert(datetime,@fecha_inicio,112) and [FechaEmision]<dateadd(day,1,convert(datetime,@fecha_fin,112))



end



      select @consulta='

      select   case when sucursal_traductor=1 then 21 else sucursal_traductor end as sucursal,

	           substring(IHCUNO,2,5) as cliente,

        	   SUBSTRING(cast(IHINVN as varchar(20)),5,8) as factura,

      	   SUBSTRING(cast(IHINVN as varchar(20)),5,8) as folio_fiscal,

      	   case Rtrim(OHSURF) when '''' then ''999999999999999'' else SUBSTRING(Rtrim(OHSURF),2,15) end as ref,

      	   IHINVN,

      	   isnull(uuid,'''') as UUID,

      	   convert(varchar(10),fecha,112) as fecha_UUID

      from openquery(AS400,''

             SELECT IHINVN,IHCUNO,ADWHCD,OHSURF,IHTYPP,OHORDT

      	   FROM MA4620EF04.SRBISH

      	   inner join MA4620EF04.SRONAD on IHCUNO=ADNUM and ADADNO=2

      	   inner join MA4620EF04.SRBSOH on IHORNO=OHORNO

      	   INNER JOIN MA4620EF04.SRONAM ON OHCUNO=NANUM AND NANCA1 IN (''''99292'''')

      	   where (OHODAT ='+@fecha_inicio+' and OHOTME >=60000 and IHTYPP=1) or 

				 (OHODAT ='+@fecha_fin+' and OHOTME < 60000 and IHTYPP=1)

      	   union all

      	   SELECT IHINVN,IHCUNO,ADWHCD,OHSURF,IHTYPP,OHORDT

      	   FROM MA4620EF11.SRBISH

      	   inner join MA4620EF11.SRONAD on IHCUNO=ADNUM and ADADNO=2

      	   inner join MA4620EF11.SRBSOH on IHORNO=OHORNO

      	   INNER JOIN MA4620EF11.SRONAM ON OHCUNO=NANUM AND NANCA1 IN (''''99292'''')

      	   WHERE (OHODAT ='+@fecha_inicio+' and OHOTME >=60000 and IHTYPP=1) or 

				 (OHODAT ='+@fecha_fin+' and OHOTME < 60000 and IHTYPP=1)

				 '') as x

			 left join [#facturas] on cast(IHINVN as varchar(20))=factura

      	     left join (

      	                 select 26 as sucursal_traductor,''V'' as ibs_letra

						 union

						 SELECT sucursal_traductor,ibs_letra

      	                 FROM [capa_ibs].[dbo].[sucursales]

      	                 where sistema=''ibs''

						 group by sucursal_traductor,ibs_letra

      	                ) as y on substring(IHCUNO,1,1)=y.ibs_letra

		   where rtrim(OHORDT) like ''F%''

      	   order by IHINVN'



		   exec (@consulta)



drop table [#facturas]



END

GO

