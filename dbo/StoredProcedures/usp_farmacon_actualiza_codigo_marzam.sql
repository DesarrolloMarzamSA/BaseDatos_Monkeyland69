
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_farmacon_actualiza_codigo_marzam] 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	update pedidos_farmacon
	set codigo=[monkeyland].[dbo].EantoMarzam(cod_barras)

END

GO
