-- =============================================
-- Author:		mandrade
-- Create date: 24/06/2015
-- Description:	obtener respuesta san pablo
-- [usp_respuesta_san_pablo] '5dc3fba29d5be8d99c3b0956bcab303d'
-- =============================================
CREATE PROCEDURE [dbo].[usp_respuesta_san_pablo] @hashMd5 varchar(150)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		update	p set p.[cantidadConfirmada]= case when r.cantidadSurtida>[cantidad] then [cantidad] else r.cantidadSurtida end,
				p.[archivoRespuesta]=r.nombreArchivo,p.[fechaRespuesta]=getdate(),p.[estatus]=2
		FROM [monkeyland].[dbo].[pedidoRamaSanPablo_historia] p
		inner join monkeyland..[respuestaRamaSanPablo] r on rtrim(substring(p.numeroOrden,2,9))=rtrim(r.numeroPedido)
		and cast(p.codigoBarras as numeric(18,0))=cast(r.ean as numeric(18,0))
		where [estatus]=1 and [hashMd5]=@hashMd5

		insert into [dbo].[respuestaRamaSanPablo_historia] ([sucursal],[cliente],[ean],[cantidadSurtida],[numeroPedido],[filler],[codigoMarzam],[filler1],[filler2],[nombreArchivo],[fechaRegistro])
		select r.[sucursal],r.[cliente],r.[ean],r.[cantidadSurtida],r.[numeroPedido],r.[filler],r.[codigoMarzam],r.[filler1],r.[filler2],r.[nombreArchivo],r.[fechaRegistro]
		 from [monkeyland]..respuestaRamaSanPablo r
		left join monkeyland..respuestaRamaSanPablo_historia rh
		on r.numeroPedido=rh.numeroPedido and r.nombreArchivo=rh.nombreArchivo and r.ean=rh.ean and r.cliente=rh.cliente
		where rh.ean is null


		truncate table [monkeyland]..respuestaRamaSanPablo

		SELECT [numeroOrden],[fechaOrden],[horaCita],[item],[articulo],[cantidadConfirmada],[unidadMedida]
		FROM [monkeyland].[dbo].[pedidoRamaSanPablo_historia]
		where [estatus]=2 and [hashMd5]=@hashMd5
		order by [lineaPedido] 
END

GO

