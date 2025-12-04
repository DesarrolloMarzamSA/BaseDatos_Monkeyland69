-- =============================================
-- Author:		Cesar Alejandro Hernandez Carachure
-- Create date: 30-03-2020
-- Description: Obtiene el registro del archivo enviado por correo
-- =============================================
CREATE PROCEDURE [SanJorge].[Sp_ObtenerEstatusArchivoEnviado]

AS
BEGIN

	BEGIN TRY
	
	SELECT Id, Cliente, RutaArchivo FROM [SanJorge].[ControlEnvioCorreosCuentasMostrador]
	WHERE Enviado = 0

	END TRY

	 BEGIN CATCH

	      DECLARE @ErroMensaje VARCHAR(300)
		  SELECT  @ErroMensaje = ERROR_MESSAGE()  

		  SET @ErroMensaje='Ocurrio un error al insertar la información. Error' + @ErroMensaje

	      RAISERROR(@ErroMensaje,16,1);

	 END CATCH

END

GO

