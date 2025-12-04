
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Ahorro].[obtenerArchivoHH]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	declare @hashMD5 as varchar(50)

	update [Ahorro].[encabezadoPedidosFiliales]
	set estatus=30, @hashMD5=hashMd5
	where hashMd5 in(select top 1 hashMd5 from [Ahorro].[encabezadoPedidosFiliales] where estatus=20 and fechaGeneracionHandHeld<DATEADD(minute,-1,getdate()))
	
    SELECT [hashMd5],[nombreArchivo],[nombreHandHeld],[archivoHandHeld],[letraSucursal] as [sucursal]
	FROM [Ahorro].[encabezadoPedidosFiliales]
	where hashMd5=@hashMD5 

END

GO

