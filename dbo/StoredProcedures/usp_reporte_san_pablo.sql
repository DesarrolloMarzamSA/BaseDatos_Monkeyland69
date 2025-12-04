-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE usp_reporte_san_pablo @hasmd5 varchar(350)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT numeroOrden,fechaOrden,count(codigoBarras)as productoPedidos, sum(cantidad)as cantidadPedida
    FROM [monkeyland].[dbo].pedidoRamaSanPablo_historia 
	where estatus=1 and  hashMd5=@hasmd5
	group by numeroOrden,fechaOrden
END

GO

