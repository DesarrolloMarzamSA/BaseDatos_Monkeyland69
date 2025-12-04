-- =============================================
-- Author:		Cesar Alejandro Hernandez Carachure
-- Create date: 05-02-20
-- Description:	Actualiza el registro del archivo cargado al FTP IQVIA 
-- =============================================
CREATE PROCEDURE [IQVIA].[Sp_ActualizaInfoArchivocargado]
@nombreArchivo  VARCHAR (30),
@rutaFTP VARCHAR (100),
@estatus VARCHAR (100),
@NoCorrida INT

AS
BEGIN

	BEGIN TRY
	
	DECLARE @respuesta VARCHAR (100)

	UPDATE [IQVIA].[ControlArchivosFTP] SET [Estatus] = @estatus, [NoCorrida] = @NoCorrida
	WHERE [NombreArchivo] = @nombreArchivo AND [RutaFTP] = @rutaFTP 

		SET @respuesta = '1'

	END TRY

	 BEGIN CATCH
	      SET @respuesta = 'Ocurrio un error al actualizar la informacion'
	      DECLARE @ErroMensaje VARCHAR(300)
		  SELECT  @ErroMensaje = ERROR_MESSAGE()  

		  SET @ErroMensaje='Ocurrio un error al actualizar la información. Error' + @ErroMensaje

	      RAISERROR(@ErroMensaje,16,1);

	 END CATCH

 SELECT @respuesta AS Respuesta

END

GO

