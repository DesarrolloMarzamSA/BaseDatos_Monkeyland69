


CREATE	--	CREATE
PROCEDURE [dbo].[usp_minne_lista_facturas_repross]  @fecha VARCHAR(10)
/*
[usp_minne_lista_facturas_repross] '2014-11-01'
*/
AS
 declare @fechaAux varchar(10)
set @fechaAux =  convert(varchar,getdate()-1,111)
 select folio_fiscal,descripcion,convert(varchar,fecha_factura,112)as fecha_factura--select distinct folio_fiscal
 FROM facturacion_electronica_estandar f 
 WHERE --sucursal = 24   AND
	ctepadre = '717' AND segto in('C2' ,'A2')
	AND f.folio_fiscal in('00096625','00105599')

GO

