-- =============================================
-- Author:		Cesar Alejandro Hernandez Carachure
-- Create date: 05-02-20
-- Description:	Inserta el registro del archivo cargado al FTP IQVIA 
-- =============================================
CREATE PROCEDURE [IQVIA].[Sp_InsertarInfoArchivocargado]
@nombreArchivo  VARCHAR (30),
@rutaFTP VARCHAR (100),
@fechaCarga DATETIME,
@estatus VARCHAR (100),
@NoCorrida INT

AS
BEGIN

	BEGIN TRY
	
	DECLARE @respuesta VARCHAR (100)

	INSERT INTO [IQVIA].[ControlArchivosFTP] ([NombreArchivo], [RutaFTP], [FechaCarga], [Estatus], [NoCorrida])
	VALUES (@nombreArchivo, @rutaFTP, @fechaCarga, @estatus, @NoCorrida)

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

