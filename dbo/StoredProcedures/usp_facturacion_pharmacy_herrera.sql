-- =============================================
-- Author:		mandrade
-- Create date: 19-01-2018
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_facturacion_pharmacy_herrera]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

select distinct	convert(varchar(12), t1.serie+t1.folio_fiscal)+replicate(' ', 12-len(convert(varchar(12), t1.serie+t1.folio_fiscal))) +
			convert(varchar(11), rtrim(t1.cliente)) + replicate(' ', 11-len(convert(varchar(4), rtrim(t1.cliente)))) +
			convert(varchar(8), t1.fecha_factura,  112) +
			rtrim(t3.cod_barras_tandem)+  replicate(' ', 13-len(rtrim(t3.cod_barras_tandem))) +
			replicate(' ', 7-len(convert(varchar(7), t1.piezas_surtidas_con_cargo))) +  convert(varchar(7), t1.piezas_surtidas_con_cargo) +
			replicate(' ', 7-len(convert(varchar(7), t1.piezas_surtidas_sin_cargo))) +  convert(varchar(7), t1.piezas_surtidas_sin_cargo) +	
			replicate(' ', 9-len(convert(varchar(9), (t1.[importe_neto]/isnull(t1.[piezas_surtidas_con_cargo],0))))) +        convert(varchar(9),(t1.[importe_neto]/isnull(t1.[piezas_surtidas_con_cargo],0)))+						
			replicate(' ', 6-len('0')) + '0' +
			replicate(' ', 9-len('0')) + '0'+
			replicate(' ', 6-len(convert(varchar(6), t1.porcentaje_iva))) + convert(varchar(6), t1.porcentaje_iva) 			
from		facturacion_electronica_estandar t1 
			inner join maestro_productos_baan t3 on t1.codigo = t3.codigo
where		convert(varchar(10),t1.fecha_factura,112) >=  convert(varchar(10),GETDATE()-1,112) and  rtrim(t1.cliente)='86535'
END

GO

