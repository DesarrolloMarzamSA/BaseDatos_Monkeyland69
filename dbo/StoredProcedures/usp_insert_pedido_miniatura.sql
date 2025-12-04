-- =============================================
-- Author:		mandrade
-- Create date: 18-11-2014
-- Description:	pedidos Miniatura
-- =============================================
CREATE PROCEDURE [dbo].[usp_insert_pedido_miniatura] @cliInterno varchar(10),@numeroOrden varchar(10),@codigoArticulo varchar(20),@proveedor varchar(10),@cantidad int,@cargoUnidad int,@sinCargoUnidad int,@archivoClt varchar(50),@hashmd5 varchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	INSERT INTO [dbo].[pedidos_miniatura] ([clienteInterno],[numeroOrden],[codigoArticulo],[proveedor],[cantidad],[cargoUnidad],[sinCargoUnidad],[fechaRegistro],[archivoCliente],[hashmd5])
     VALUES (@cliInterno,@numeroOrden,@codigoArticulo,@proveedor,@cantidad,@cargoUnidad,@sinCargoUnidad,getdate(),@archivoClt,@hashmd5)

	 INSERT INTO [dbo].[pedidos_miniatura_historia] ([clienteInterno],[numeroOrden],[codigoArticulo],[proveedor],[cantidad],[cargoUnidad],[sinCargoUnidad],[fechaRegistro],[archivoCliente],[hashmd5])
     VALUES (@cliInterno,@numeroOrden,@codigoArticulo,@proveedor,@cantidad,@cargoUnidad,@sinCargoUnidad,getdate(),@archivoClt,@hashmd5)
END

GO

