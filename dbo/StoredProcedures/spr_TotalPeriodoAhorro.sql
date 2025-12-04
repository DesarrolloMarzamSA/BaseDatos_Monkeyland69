
CREATE PROCEDURE [dbo].[spr_TotalPeriodoAhorro]
 @TotalPeriodoAhorro  [TableTypeTotalPeriodoAhorro] READONLY,
 @Manual BIT = 0,
 @Ok VARCHAR(10) OUT
AS
BEGIN

  BEGIN TRY
	   
	    MERGE INTO [dbo].[TotalPeriodoAhorro] T
		USING 
		(   				    
		   SELECT [remision], CAST([totalIVA] AS NUMERIC(18,2)) AS [totalIVA], CAST([totalRemision] AS NUMERIC(18,2)) AS [totalRemision]
		         , CAST([totalRemisionIVA] AS NUMERIC(18,2)) AS [totalRemisionIVA],CAST([periodo] AS INT) AS [periodo] 
		   FROM @TotalPeriodoAhorro    
	    )S
		ON (T.[remision] = S.[remision] AND T.[totalIVA] = S.[totalIVA] AND T.[totalRemision] = S.[totalRemision] 
		AND T.[totalRemisionIVA] = S.[totalRemisionIVA] AND  T.[Periodo] = S.[Periodo] )				
	    WHEN NOT MATCHED BY TARGET THEN --No existe en el destino
	       INSERT  
		     ([remision],[totalIVA],[totalRemision],[totalRemisionIVA],[periodo])
		   VALUES 
		   (S.[remision],S.[totalIVA],S.[totalRemision],S.[totalRemisionIVA],S.[periodo]);

	  SELECT @Ok='true'
  END TRY
  BEGIN CATCH	
      SELECT @Ok='false'
  END CATCH
  
END

GO

