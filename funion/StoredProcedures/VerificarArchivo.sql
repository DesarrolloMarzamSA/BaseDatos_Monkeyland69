
-- =============================================
-- Author:		<Author,,enrique galicia rodriguez>
-- Create date: <Create Date,13-01-2021,>
-- Description:	<Description,Verifico los archivos a consultar para ver si se mandaron,>
-- =============================================
CREATE PROCEDURE [funion].[VerificarArchivo] 
@nombre varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    begin try
		select a.nombre,a.rutalocal,a.rutaserver,a.enviado,a.compania from funion.PedidosTransmitidos a where a.nombre =@nombre
		
		
	end try
	begin catch
	declare @errorMessage varchar(max)
	declare @ErrorState varchar(max)
	declare @ErrorSeverity varchar(max)

		--este trycatch es para el manejo de errores
		SELECT @errorMessage = ERROR_MESSAGE(),@ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();	
		
		RAISERROR (@errorMessage,@ErrorSeverity,@ErrorState);
	end catch
END

GO

