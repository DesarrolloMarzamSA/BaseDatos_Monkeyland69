-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_obtener_archivo_benavides_web]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    select distinct nombre_archivo,firma from [hashes_md5_benavides] 
where convert(varchar,fecha,112)>=convert(varchar,getdate(),112)
END

GO

