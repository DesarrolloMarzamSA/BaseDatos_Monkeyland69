-- =============================================
-- Author:		Cesar Alejandro Hernandez Carachure
-- Create date: 30-03-2020
-- Description: Actualiza el registro del archivo enviado por correo
-- =============================================
CREATE PROCEDURE [SanJorge].[Sp_ActualizarEstatusArchivoEnviado]
@ruta  VARCHAR (200)

AS
BEGIN

	BEGIN TRY
	
	DECLARE @respuesta VARCHAR (100)

	UPDATE [SanJorge].[ControlEnvioCorreosCuentasMostrador] 
	SET  Enviado = 1
	WHERE RutaArchivo = @ruta

		SET @respuesta = '1'

	END TRY

	 BEGIN CATCH

	      SET @respuesta = 'Ocurrio un error al insertar la informacion'

	      DECLARE @ErroMensaje VARCHAR(300)
		  SELECT  @ErroMensaje = ERROR_MESSAGE()  

		  SET @ErroMensaje='Ocurrio un error al insertar la información. Error' + @ErroMensaje

	      RAISERROR(@ErroMensaje,16,1);

	 END CATCH

 SELECT @respuesta AS Respuesta

END

GO

