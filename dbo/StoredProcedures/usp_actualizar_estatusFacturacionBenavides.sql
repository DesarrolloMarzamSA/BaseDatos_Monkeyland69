-- =============================================
-- Author:		mandrade
-- Create date: 13022015
-- Description:	actualiza estatus de enviados (2) a concluido (3)   
-- =============================================
CREATE PROCEDURE [dbo].[usp_actualizar_estatusFacturacionBenavides]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  update detalle_benavides set ESTATUSH=3 where ESTATUSH=2
  update detalle_benavides set ESTATUSD=3 where ESTATUSD=2
END

GO

