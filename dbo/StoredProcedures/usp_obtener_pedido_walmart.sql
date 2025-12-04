-- =============================================
-- Author:		mandrade
-- Create date: 12/10/2015
-- Description:	obtner pedido
-- =============================================
CREATE PROCEDURE [dbo].[usp_obtener_pedido_walmart]-- '310562380~EDIFACT~D96A~ORDERS~OUT-3.080080425.1481847053','1f244128fc2dc02fc9fbe296bb63d7c0'
@nombreArchivo varchar(350), @hashMD5 varchar(350)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--[usp_obtener_pedido_walmart] '310562380~EDIFACT~D96A~ORDERS~OUT-3.080080425.1481847053','1f244128fc2dc02fc9fbe296bb63d7c0'

	INSERT INTO [dbo].[pedidoWalmartConsec] ([nombreArchivo],[hashMD5],[fechaRegistro])
	select  top 1 nombreArchivo,hashMD5,getdate()
	from [dbo].[pedidoEncabezado_walmart] e
	where e.nombreArchivo=@nombreArchivo and e.hashMD5=@hashMD5 and e.estatus=30
	 
    select distinct --* 
	'000099004'+
	REPLICATE('0',10-len(e.numeroOrden))+e.numeroOrden+
	'00000'+
	d.glnTienda+REPLICATE(' ',20-len(d.glnTienda))+
	cast(cast(d.codigoEAN as numeric )as varchar)+REPLICATE(' ',13-len(cast(cast(d.codigoEAN as numeric )as varchar)))+
	REPLICATE('0',7-len(cast(cast(d.cantidadPedida as int )as varchar)))+cast(cast(d.cantidadPedida as int )as varchar)+
	'000000000'+'00000'+'0000'+
	e.fechaSolicitud as PEDIDO
	from [dbo].[pedidoEncabezado_walmart] e
	inner join pedidoDetalle_walmart d on e.numeroOrden=d.numeroOrden and
	e.numeroReferenciaMnsj=d.numeroReferenciaMnsj and e.[hashMD5]=d.hashMD5
	where e.nombreArchivo=@nombreArchivo and e.hashMD5=@hashMD5
	and e.estatus=30
END

GO

