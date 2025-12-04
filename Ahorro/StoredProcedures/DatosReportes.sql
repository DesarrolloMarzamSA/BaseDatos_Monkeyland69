-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Ahorro].[DatosReportes]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

 declare @fechaInicio datetime

  select @fechaInicio=cast(max([timestamp]) as date)
  FROM [monkeyland].[dbo].[pedidos_spt_fahorro]

insert into [monkeyland].[dbo].[pedidos_spt_fahorro]
SELECT [cuentaEstiloAhorro]
      ,[hashMd5]
      ,[orden]
      ,[codigoBarras]
      ,[sucursal]
      ,[cuenta]
      ,[tipoPedido]
      ,[codigo]
      ,[cantidadPedida]
      ,[precioFarmacia]
      ,[importeOferta]
      ,[importeProntoPago]
      ,[tipoOferta]
      ,[porcentajeOferta]
      ,[archivoTandem]
      ,[status]
      ,[timestamp]
      ,[remisionado]
      ,[procesadoTraductor]
      ,[fechaTraductor]
      ,[cliente]
  FROM [monkeyland].[Ahorro].[pedidosFiliales]
  where cast(timestamp as date)>@fechaInicio


END

GO

