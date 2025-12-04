-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ObtenerCartaPorte]
@Fecha			date=null,
@IdCartaPorte   int = NULL,
@Folio			bigint = NULL,
@Sucursal		varchar(5) = NULL,
@Cliente		varchar(15) = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT [Sucursal],[Folio],[Serie],Ruta, FechaEmision,'Traslado' as tipoMsj,cast(xmlFile as varchar(max)) as archivoXml
	FROM [192.168.90.190].[ETI_DatosCE].[dbo].[CFDIS_Emitidos]
	--[dbo].[CFDIS_CartaPorte] 
	where convert(date,[FechaEmision]) = ISNULL(@Fecha, convert(date,GETDATE()))
		--and [Id_CartaPorte] = ISNULL(@IdCartaPorte, [Id_CartaPorte])
		AND [Folio] = ISNULL(@Folio, [Folio])
		AND [Sucursal] = ISNULL(@Sucursal, [Sucursal])
		AND [NoClienteProveedor] = ISNULL(@Cliente, [NoClienteProveedor])
		and Serie in ('CP','CP21')
END

GO

