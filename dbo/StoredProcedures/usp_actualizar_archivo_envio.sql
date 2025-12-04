-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE usp_actualizar_archivo_envio
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

     update [monkeyland].[dbo].[pedidoHEB_Encabezado] set [EstatusEnvio]=60 where EstatusEnvio=0
END

GO

