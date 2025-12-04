-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE usp_ObtenerManualFarmaprontoFacturacion @segmento varchar(50)='',@ctePadre varchar(50)='',@fecha varchar(50)='' AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  select distinct t1.sucursal, t1.cliente, t1.factura, t1.folio_fiscal,
   isnull(t2.orden, replicate('9', 15)) 
   from facturacion_electronica_estandar t1
    left join pedidos_farmapronto_facturacion t2 
	on t1.sucursal = t2.sucursal and t1.cliente = t2.cliente and t1.factura = t2.factura
	 where t1.segto = @segmento and t1.ctepadre = @ctePadre and t1.fecha_tandem = @fecha 
	 order by t1.sucursal
END

GO

