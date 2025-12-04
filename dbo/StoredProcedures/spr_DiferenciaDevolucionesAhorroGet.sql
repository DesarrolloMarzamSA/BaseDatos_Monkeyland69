-- [dbo].[spr_DiferenciaDevolucionesAhorroGet] '249'
CREATE PROCEDURE [dbo].[spr_DiferenciaDevolucionesAhorroGet]
 @Periodo  VARCHAR(20)
AS
BEGIN
  	    
	SELECT 
	 [Dia],[FechaCierre],[Proveedor],[Sucursal],[DireccionSucursal],[Folio],[CodigoMovimiento],[TipoDocumento]
    ,[Producto],[DescripcionProducto],[Indicadores],[Unidades],[CostoNeto],[IVA],[CostoTotal],[Periodo]
    FROM [dbo].[DiferenciaDevolucionesAhorro] WHERE [Periodo]= @Periodo
END

GO

