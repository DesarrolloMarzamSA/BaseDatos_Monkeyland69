-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Ahorro].[ObtenerCuentasNuevoFormato]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--SELECT [CuentasNuevoFormato]  FROM [monkeyland].[Ahorro].[CuentasNuevoFormato]

	--usar este query para cuando ahorro realice toda la migracion
	SELECT [cuenta_estilo_ahorro] as CuentasNuevoFormato  FROM [monkeyland].[dbo].[cat_cuentas_spt_fahorro]

END

GO

