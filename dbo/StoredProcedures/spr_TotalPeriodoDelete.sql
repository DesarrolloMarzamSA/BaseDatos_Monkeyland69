-- [dbo].[spr_TotalPeriodoDelete] '249'
CREATE PROCEDURE [dbo].[spr_TotalPeriodoDelete]
 @Periodo  VARCHAR(20),
 @Ok VARCHAR(10) OUT
AS
BEGIN
  
    DELETE [dbo].[TotalPeriodoAhorro] WHERE [Periodo]= @Periodo

	IF EXISTS(SELECT TOP 1 1 FROM [dbo].[TotalPeriodoAhorro] WITH(NOLOCK)  WHERE [Periodo]= @Periodo)       
	    SELECT @Ok='false'
	ELSE
        SELECT @Ok='true' 
END

GO

