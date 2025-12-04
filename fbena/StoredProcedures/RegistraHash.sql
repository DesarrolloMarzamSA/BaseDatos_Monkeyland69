
-- =============================================
-- Author:		<Author,,Francisco Roberto Martínez Hernández>
-- Create date: <Create Date,15-03-2023,>
-- Description:	<Description,valida si existe el hash generado por el contenido del archivo>
-- =============================================
CREATE PROCEDURE [fbena].[RegistraHash] 
@programa varchar(150)      ,
@firma varchar(150)         ,
@fecha datetime   =NULL          ,
@nombre_archivo varchar(200),
@lineas int                 
AS
BEGIN

    INSERT INTO [dbo].[hashes_md5]
               ([programa],[firma],[fecha],[nombre_archivo],[lineas])
     VALUES     (@programa,@firma,GETDATE(),@nombre_archivo,@lineas)
	 
END

GO

