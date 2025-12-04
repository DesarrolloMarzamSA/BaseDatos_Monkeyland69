-- =============================================
-- Author:		mandrade
-- Create date: 17-10-2014
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_facturacion_pharmacy_floresRegalos]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

select distinct	convert(varchar(12), t1.serie+cast(cast(t1.folio_fiscal as numeric)as varchar)) + replicate(' ', 12-len(convert(varchar(12), t1.serie+cast(cast(t1.folio_fiscal as numeric)as varchar)))) +
			convert(varchar(11), t1.cliente) + replicate(' ', 11-len(convert(varchar(4), t1.cliente))) +
			convert(varchar(8), t1.fecha_factura,  112) +
			t3.cod_barras_tandem + replicate(' ', 13-len(t3.cod_barras_tandem)) +  
			replicate(' ', 7-len(convert(varchar(7), t1.piezas_surtidas_con_cargo))) +  convert(varchar(7), t1.piezas_surtidas_con_cargo) +
			replicate(' ', 7-len(convert(varchar(7), t1.piezas_surtidas_sin_cargo))) +  convert(varchar(7), t1.piezas_surtidas_sin_cargo) +
			replicate(' ', 9-len(convert(varchar(9), t1.precio_farm_sin_imp))) +        convert(varchar(9), t1.precio_farm_sin_imp) +
			replicate(' ', 6-len(convert(varchar(6), 0))) +   convert(varchar(6), 0) +
			replicate(' ', 6-len(convert(varchar(6), 0))) +convert(varchar(6), 0) +		
			replicate(' ', 9-len(convert(varchar(6), t1.porcentaje_iva))) +             convert(varchar(9), t1.porcentaje_iva)	
from		facturacion_electronica_estandar t1 
			inner join maestro_productos_baan t3 on t1.codigo = t3.codigo
where		t1.fecha_factura >= GETDATE()-2 and 
			t1.ctepadre='577'
END

GO

