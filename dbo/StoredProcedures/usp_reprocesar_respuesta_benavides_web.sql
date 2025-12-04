-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE usp_reprocesar_respuesta_benavides_web  @hashmd5 varchar(250)=''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    --select hashmd5 
	delete from respuesta_benavides where hashmd5 =@hashmd5
END

GO

