
-- =============================================
-- Author:		<Author,,enrique galicia rodriguez>
-- Create date: <Create Date,13-01-2021,>
-- Description:	<Description,ingresa los pedidos que ya fueron enviados al ftp de marzam para su cembrado,>
-- =============================================
CREATE PROCEDURE [funion].[IngresoHandHell] 
@nombre varchar(50),
@rutalocal varchar(600),
@rutaserver varchar(600),
@enviado int,
@compania varchar(5),
@error varchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    begin try

	    if  not EXISTS (  select nombre from funion.PedidosTransmitidos b where b.nombre=@nombre)		
		begin
			insert into  funion.PedidosTransmitidos (nombre,rutalocal,rutaserver,enviado,fechaenvio,compania,error)
			values (@nombre,@rutalocal,@rutaserver,@enviado,getdate(),@compania,@error)
		end
		else
		begin
		update funion.PedidosTransmitidos set enviado=@enviado,fechaenvio=getdate() where nombre=@nombre
		end
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

