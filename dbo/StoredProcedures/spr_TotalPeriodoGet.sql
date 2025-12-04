-- [dbo].[spr_TotalPeriodoGet] '249'
CREATE PROCEDURE [dbo].[spr_TotalPeriodoGet]
 @Periodo  VARCHAR(20)
AS
BEGIN
  	    
	SELECT [remision],[totalIVA],[totalRemision],[totalRemisionIVA],[periodo]
	FROM [dbo].[TotalPeriodoAhorro] WHERE [Periodo]= @Periodo
END

GO

