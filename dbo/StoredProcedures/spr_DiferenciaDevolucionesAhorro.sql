
CREATE PROCEDURE [dbo].[spr_DiferenciaDevolucionesAhorro]
 @DifAhorro  [TableTypeDifFarmaciasAhorro] READONLY,
 @Manual BIT = 0,
 @Ok VARCHAR(10) OUT
AS
BEGIN

  BEGIN TRY

		  -- SELECT [Dia],[FechaCierre],[Proveedor],[Sucursal],[DireccionSucursal],CAST([Folio] AS NUMERIC(18,0)) [Folio],[CodigoMovimiento],[TipoDocumento],CAST([Producto] AS NUMERIC(18,0)) [Producto],[DescripcionProducto]
		  --       ,[Indicadores],CAST(REPLACE([Unidades],'-','') AS INT) AS [Unidades],REPLACE([CostoNeto],'-','') AS [CostoNeto],REPLACE([IVA],'-','') AS [IVA],REPLACE([CostoTotal],'-','') AS [CostoTotal],[Periodo]
    --into tmpDemo
	   --    FROM @DifAhorro    
 
	  
	    MERGE INTO [dbo].[DiferenciaDevolucionesAhorro] T
		USING 
		(    SELECT [Dia],[FechaCierre],[Proveedor],[Sucursal],[DireccionSucursal],[Folio],[CodigoMovimiento],[TipoDocumento],[Producto],[DescripcionProducto]
		         ,[Indicadores],REPLACE([Unidades],'-','') AS [Unidades],REPLACE([CostoNeto],'-','') AS [CostoNeto],REPLACE([IVA],'-','') AS [IVA],REPLACE([CostoTotal],'-','') AS [CostoTotal],[Periodo]
	         FROM @DifAhorro    		    
	    )S
		ON (T.[Dia] = S.[Dia] AND T.[FechaCierre] = S.[FechaCierre] AND T.[Proveedor] = S.[Proveedor] AND T.[Sucursal] = S.[Sucursal] AND T.[Folio]= S.[Folio]
		   AND T.[CodigoMovimiento] =S.[CodigoMovimiento] AND T.[TipoDocumento] = S.[TipoDocumento]  AND T.[Producto] = S.[Producto]  AND T.[Unidades] = S.[Unidades] 
		   AND T.[CostoNeto] = S.[CostoNeto] AND T.[IVA] = S.[IVA] AND T.[CostoTotal] = S.[CostoTotal] AND T.[Periodo] = S.[Periodo] )				
	    WHEN NOT MATCHED BY TARGET THEN --No existe en el destino
	       INSERT  
		     ([Dia],[FechaCierre],[Proveedor],[Sucursal],[DireccionSucursal],[Folio],[CodigoMovimiento],[TipoDocumento]
		     ,[Producto],[DescripcionProducto],[Indicadores],[Unidades],[CostoNeto],[IVA],[CostoTotal],[Periodo],[Manual]) 
		   VALUES 
		    (S.[Dia],S.[FechaCierre],S.[Proveedor],S.[Sucursal],S.[DireccionSucursal],S.[Folio],S.[CodigoMovimiento],S.[TipoDocumento]
		     ,S.[Producto],S.[DescripcionProducto],S.[Indicadores],S.[Unidades],S.[CostoNeto],S.[IVA],S.[CostoTotal],S.[Periodo], @Manual) ;
       
	  SELECT @Ok='true'
  END TRY
  BEGIN CATCH	
      SELECT @Ok='false'
  END CATCH

 
END

GO

