-- =============================================
-- Author:		mandrade
-- Create date: 09-10-2015
-- Description:	inserta detalle pedido walmart
-- =============================================
CREATE PROCEDURE [dbo].[usp_detalle_walmart]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
INSERT INTO [dbo].[pedidoDetalle_walmart]
           ([numeroReferenciaMnsj]
           ,[numeroOrden]
           ,[numeroLinea]
           ,[codigoEAN]
           ,[codigoArticulo]
           ,[codigoAsignado]
           ,[importeArticulo]
           ,[importeBruto]
           ,[cantidadTotalPedida]
           ,[glnTienda]
           ,[cantidadPedida]
		   ,[hashMD5])
SELECT p1.[numeroReferenciaMnsj]
      ,p1.[numeroOrden]
      ,p1.[numeroLinea]
      ,p1.[codigoEAN]
      ,p1.[codigoArticulo]
      ,p1.[codigoAsignado]
      ,p1.[importeArticulo]
      ,p1.[importeBruto]
      ,p1.[cantidadTotalPedida]
      ,p1.[glnTienda]
      ,p1.[cantidadPedida]
	  ,p1.hashMD5
  FROM [pedidoDetalle_walmart_temp] p1
  left join pedidoDetalle_walmart p2 on
    p1.[numeroReferenciaMnsj]= p2.[numeroReferenciaMnsj] and
    p1.[numeroOrden]= p2.[numeroOrden] and
    p1.[numeroLinea]= p2.[numeroLinea] and
    p1.[codigoEAN] =p2.[codigoEAN] and
    p1.[glnTienda]= p2.[glnTienda] and
    p1.[cantidadPedida]= p2.[cantidadPedida] and
    p1.hashMD5= p2.hashMD5
	where p2.hashMD5 is null

	 truncate table [pedidoDetalle_walmart_temp]
END

GO

