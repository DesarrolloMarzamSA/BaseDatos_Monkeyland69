-- =============================================
-- Author:		Cesar Alejandro Hernandez Carachure
-- Create date: 30-03-2020
-- Description:	Inserta el registro del archivo enviado por correo
-- =============================================
CREATE PROCEDURE [SanJorge].[Sp_InsertarEstatusArchivoEnviado]
@cliente  VARCHAR (10),
@ruta VARCHAR (200),
@estatus bit

AS
BEGIN

	BEGIN TRY
	
	DECLARE @respuesta VARCHAR (100)

	INSERT INTO [SanJorge].[ControlEnvioCorreosCuentasMostrador] (Cliente, RutaArchivo, Enviado)
	VALUES (@cliente, @ruta, @estatus)

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

