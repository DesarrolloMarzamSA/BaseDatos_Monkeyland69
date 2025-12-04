


CREATE	--	CREATE
PROCEDURE [dbo].[usp_minne_lista_facturas]
@fecha VARCHAR(10)

/*
usp_minne_lista_facturas '2012-04-11'
*/

AS
 declare @fechaAux varchar(10)
set @fechaAux =  convert(varchar,getdate()-1,111)
 select folio_fiscal,descripcion,fecha_factura
 FROM facturacion_electronica_estandar f 
 WHERE --sucursal = 24   AND
	ctepadre = '717' AND segto in('C2' ,'A2')
	AND fecha_factura >=CONVERT(datetime,@fechaAux,121) --BETWEEN CONVERT(datetime,'2014-10-01',121) and CONVERT(datetime,'2014-12-31',121)
 
 -- fecha_tandem BETWEEN CONVERT(datetime,'2013-04-01',121) and CONVERT(datetime,'2013-04-30',121) 

GO

