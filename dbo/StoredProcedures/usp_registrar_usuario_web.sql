-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [usp_registrar_usuario_web] @usuario varchar(50)=''
           ,@acceso varchar(50)=''
           ,@contrasena varchar(50)=''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    
INSERT INTO [dbo].[usuarioReprocesos]
           ([usuario]
           ,[acceso]
           ,[contrasena]
           ,[fecha_registro])
     VALUES
           (@usuario,@acceso,@contrasena,getdate())
END

GO

