
CREATE PROCEDURE [dbo].[spr_DiferenciaDevolucionesAhorroDelete]
 @Periodo  VARCHAR(20),
 @Ok VARCHAR(10) OUT
AS
BEGIN
  	    
	    DELETE [dbo].[DiferenciaDevolucionesAhorro] WHERE [Periodo]= @Periodo

		IF EXISTS(SELECT TOP 1 1 FROM [dbo].[DiferenciaDevolucionesAhorro] WITH(NOLOCK)  WHERE [Periodo]= @Periodo)       
	       SELECT @Ok='false'
	    ELSE
           SELECT @Ok='true' 
END

GO

