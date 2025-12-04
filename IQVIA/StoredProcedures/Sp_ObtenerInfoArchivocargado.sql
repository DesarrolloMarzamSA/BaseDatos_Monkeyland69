-- =============================================
-- Author:		Cesar Alejandro Hernandez Carachure
-- Create date: 05-02-20
-- Description:	Selecciona el estatus del registro del archivo cargado al FTP IQVIA 
-- =============================================
CREATE PROCEDURE [IQVIA].[Sp_ObtenerInfoArchivocargado]
@nombreArchivo  VARCHAR (30),
@rutaFTP VARCHAR (100),
@fechaCarga DATETIME

AS
BEGIN

	BEGIN TRY
	
	DECLARE @respuesta VARCHAR (100)

	SET @respuesta = (SELECT CONCAT([Estatus],'/',[NoCorrida]) FROM [IQVIA].[ControlArchivosFTP] 
    WHERE  [FechaCarga] = @fechaCarga AND [NombreArchivo] = @nombreArchivo AND [RutaFTP] = @rutaFTP) 

	END TRY

	 BEGIN CATCH
	      SET @respuesta = '0'
	      DECLARE @ErroMensaje VARCHAR(300)
		  SELECT  @ErroMensaje = ERROR_MESSAGE()  

		  SET @ErroMensaje='Ocurrio un error al seleccionar la información. Error' + @ErroMensaje

	      RAISERROR(@ErroMensaje,16,1);

	 END CATCH

 SELECT @respuesta AS Respuesta

END

GO

