-- =============================================
-- Author:		mandrade
-- Create date: 27/10/2015
-- Description:	obtener pedido resumen
-- =============================================
CREATE PROCEDURE [dbo].[usp_obtener_resumen_walmart] @nombreArchivo varchar(350), @hashMD5 varchar(350)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    select e.numeroReferenciaMnsj,e.numeroOrden,e.fechaDocumento,e.numeroDepartamento,
	d.glnTienda,count(d.codigoEAN)as totalProducto,sum(d.cantidadPedida)as totalPzPedidas
	into #resumen
	from [dbo].[pedidoEncabezado_walmart] e
	inner join pedidoDetalle_walmart d on e.numeroOrden=d.numeroOrden and
	e.numeroReferenciaMnsj=d.numeroReferenciaMnsj and e.[hashMD5]=d.hashMD5
	where e.nombreArchivo=@nombreArchivo and e.hashMD5=@hashMD5 and
	 e.estatus=60
	 group by e.numeroReferenciaMnsj,e.numeroOrden,e.fechaDocumento,e.numeroDepartamento,d.glnTienda
	
	select * from #resumen order by cast(rtrim(numeroReferenciaMnsj) as int)
	drop table #resumen
END

GO

