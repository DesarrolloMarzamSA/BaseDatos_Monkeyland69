-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE usp_fahorro_obtiene_encabezadoPago
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   SELECT top 1 [cliente]
      ,[clientePadre]
      ,[ingreso]
      ,[formaPago]
      ,[regimenConsolidacion]
      ,[metodoPago]
      ,[usoCFDI]
      ,[fechaActualizacion]
  FROM [monkeyland].[dbo].[complementoSATFahorro] where clientePadre='99007'

END

GO

