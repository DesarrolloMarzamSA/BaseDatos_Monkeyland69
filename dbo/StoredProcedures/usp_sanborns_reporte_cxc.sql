


CREATE	--	CREATE
PROCEDURE [dbo].[usp_sanborns_reporte_cxc]
AS

SELECT 
	CONVERT(VARCHAR(10),fecha,121)	fecha_factura	, 
	b.serie_cfd																		, 
	folio_fiscal																	,
	s.IATA													suc						,
	s.letra_baan  + b.cliente				cliente				, 
	confirmada											estatus				, 
	msg_error												mensaje_ws		, 
	importe																				, 
--	b.mostrador
	registro																			
FROM bitacora_sanborns_cfd b	WITH (NOLOCK)
INNER JOIN sucursales s				WITH (NOLOCK)	ON s.sucursal = b.sucursal
WHERE 
	fecha >= CONVERT(DATETIME,'2011-01-01',121)
	--fecha >= DATEADD(DD, -8, GETDATE())
ORDER BY fecha DESC

GO

