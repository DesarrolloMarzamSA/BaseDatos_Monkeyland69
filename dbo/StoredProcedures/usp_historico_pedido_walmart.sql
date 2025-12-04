-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_historico_pedido_walmart]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	insert into [dbo].[pedidoDetalle_walmart_historico]
	select d.*
	from [dbo].[pedidoEncabezado_walmart] e
	inner join [dbo].[pedidoDetalle_walmart] d on e.numeroOrden=d.numeroOrden and
	e.numeroReferenciaMnsj=d.numeroReferenciaMnsj
	where e.estatus=60


	INSERT INTO [dbo].[pedidoEncabezado_walmart_historico]  ([encabezadoMasteredi],[numeroReferenciaMnsj],[numeroOrden],[fechaDocumento],[fechaCancelacion]
	,[fechaSolicitud],[numeroDepartamento],[numRefMutua],[numRefAcuPromo],[numRefProveedor],[embarqueA],[facturarA],[embarqueDesde],[mensajeDe],[comprador],[tiendaNueva],[calCondPago],[tiempoPago],[ralacTiempoPago],[tipoPeriodoPago],[numPeriodoPago]
	,[importeTotalMsj],[lineaTotalArticulo],[pieMasteredi],[estatus],[hashMD5],[fechaPedido],[mansajeOriginal],[nombreArchivo],[nombreArchivoMarzam])

	select distinct e.[encabezadoMasteredi],e.[numeroReferenciaMnsj],e.[numeroOrden],e.[fechaDocumento],e.[fechaCancelacion]
	,e.[fechaSolicitud],e.[numeroDepartamento],e.[numRefMutua],e.[numRefAcuPromo],e.[numRefProveedor],e.[embarqueA],e.[facturarA],e.[embarqueDesde],e.[mensajeDe]
	,e.[comprador],e.[tiendaNueva],e.[calCondPago],e.[tiempoPago],e.[ralacTiempoPago],e.[tipoPeriodoPago],e.[numPeriodoPago]
	,e.[importeTotalMsj],e.[lineaTotalArticulo],e.[pieMasteredi],e.[estatus],e.[hashMD5],e.[fechaPedido],e.[mansajeOriginal]
	,e.[nombreArchivo],e.[nombreArchivoMarzam]
	from [dbo].[pedidoEncabezado_walmart] e
	inner join [dbo].[pedidoDetalle_walmart] d on e.numeroOrden=d.numeroOrden and
	e.numeroReferenciaMnsj=d.numeroReferenciaMnsj
	where e.estatus=60

	truncate table [dbo].[pedidoDetalle_walmart]
	truncate table [dbo].[pedidoEncabezado_walmart]
END

GO

