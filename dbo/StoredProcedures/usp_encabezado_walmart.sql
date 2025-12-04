-- =============================================
-- Author:		mandrade
-- Create date: 09-10-2015
-- Description:	inserta encabezado pedido walmart
-- =============================================
CREATE PROCEDURE [dbo].[usp_encabezado_walmart]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

INSERT INTO [dbo].[pedidoEncabezado_walmart]
           ([encabezadoMasteredi]
           ,[numeroReferenciaMnsj]
           ,[numeroOrden]
           ,[fechaDocumento]
           ,[fechaCancelacion]
           ,[fechaSolicitud]
           ,[numeroDepartamento]
           ,[numRefMutua]
           ,[numRefAcuPromo]
           ,[numRefProveedor]
           ,[embarqueA]
           ,[facturarA]
           ,[embarqueDesde]
           ,[mensajeDe]
		   ,[comprador]
		   ,[tiendaNueva]
           ,[calCondPago]
           ,[tiempoPago]
           ,[ralacTiempoPago]
           ,[tipoPeriodoPago]
           ,[numPeriodoPago]
           ,[importeTotalMsj]
           ,[lineaTotalArticulo]
		   ,[pieMasteredi]
           ,[estatus]
           ,[hashMD5]
           ,[fechaPedido]
           ,[mansajeOriginal]
		   ,nombreArchivo
		   ,nombreArchivoMarzam)
  
SELECT distinct p1.[encabezadoMasteredi]
      ,p1.[numeroReferenciaMnsj]
      ,p1.[numeroOrden]
      ,p1.[fechaDocumento]
      ,p1.[fechaCancelacion]
      ,p1.[fechaSolicitud]
      ,p1.[numeroDepartamento]
      ,p1.[numRefMutua]
      ,p1.[numRefAcuPromo]
      ,p1.[numRefProveedor]
      ,p1.[embarqueA]
      ,p1.[facturarA]
      ,p1.[embarqueDesde]
      ,p1.[mensajeDe]
	  ,p1.comprador
	  ,p1.tiendaNueva
      ,p1.[calCondPago]
      ,p1.[tiempoPago]
      ,p1.[ralacTiempoPago]
      ,p1.[tipoPeriodoPago]
      ,p1.[numPeriodoPago]
      ,p1.[importeTotalMsj]
      ,p1.[lineaTotalArticulo]
	  ,p1.[pieMasteredi]
      ,p1.[estatus]
      ,p1.[hashMD5]
      ,p1.[fechaPedido]
      ,p1.[mansajeOriginal]
	  ,p1.nombreArchivo
	  ,p1.nombreArchivoMarzam
  FROM [pedidoEncabezado_walmart_temp] p1  
  left join pedidoEncabezado_walmart p2 on p1.numeroOrden=p2.numeroOrden
  and p1.numeroReferenciaMnsj=p2.numeroReferenciaMnsj and p1.hashMD5=p2.hashMD5
  where p1.estatus=30 and p2.hashMD5 is null

  truncate table [pedidoEncabezado_walmart_temp]
END

GO

