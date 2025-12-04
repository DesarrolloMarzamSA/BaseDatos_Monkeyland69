-- =============================================
-- Author:,,mandrade
-- Create date: 05/06/2015
-- Description:,obtiene archivo pedido san pablo
-- =============================================
CREATE PROCEDURE [dbo].[usp_pedido_san_pablo] @hashMd5 varchar(350),@archivoPedido varchar(350)
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

	SELECT '0137980'+REPLICATE('0',13-len(codigoBarras))+codigoBarras+REPLICATE('0',3-len(cast(cantidad as varchar)))+cast(cantidad as varchar)
	+SUBSTRING([numeroOrden],2,10)+'00000000'+'000000000'+'0000000000'+'00000000000000000000'
    FROM [monkeyland].[dbo].[pedidoRamaSanPablo] 
	where hashMd5=@hashMd5

	insert into monkeyland..pedidoRamaSanPablo_historia ([lineaPedido],[numeroOrden],[fechaOrden],[numeroCita],[fechaCita],[horaCita],[item],[articulo],[codigoBarras],[unidadMedida],[cantidad],[descripcion],[precioEFE],[zDE1],[zDE2],[zDE3],[fechaRegistro],[estatus],[hashMd5],[archivoPedido])
	select	lineaPedido,numeroOrden,fechaOrden,numeroCita,fechaCita,horaCita,item,articulo,
		codigoBarras,unidadMedida,cantidad,descripcion,precioEFE,zDE1,zDE2,zDE3,fechaRegistro,1,hashMd5,@archivoPedido
	from monkeyland..[pedidoRamaSanPablo]
	where estatus=0 and hashMd5=@hashMd5

	delete from [monkeyland]..[pedidoRamaSanPablo] where estatus=0 and hashMd5=@hashMd5

END

GO

