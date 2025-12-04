

CREATE
--	CREATE
PROCEDURE [dbo].[usp_fidealessureste_cfd]	
--	DECLARE 
@fecha VARCHAR(10)
AS
--	SET @fecha = '2010-05-31'

/*
usp_fidealessureste_cfd '2010-05-31'
*/

--------------------------------------------------------------------------------------------------
--	HECHO POR:	 MIGUEL SAMAYOA

--	usp_fidealessureste_cfd 
--	2010-05-15	CREACION
--	2010-07-28	SE AGREGO CLIENTE PADRE 012


SELECT
																																		e.sucursal		,
																																		s.iata				,
																																		s.serie_cfd		, 
	ISNULL(e.folio_fiscal,'N/A')																			folio_fiscal	, 
																																		e.cliente			,
	ISNULL(SUM(f.importe_bruto),0)																		importe_bruto	,
	ISNULL(SUM(f.importe_neto	),0)																		importe_neto 	,
	ISNULL(SUM(f.iva					),0)																		iva						,
	ISNULL(SUM(f.ieps					),0)																		ieps					,
	e.factura																													Remision
FROM encabezado e with(nolock) 
INNER JOIN sucursales s with(nolock) ON e.sucursal = s.sucursal 
LEFT OUTER JOIN facturacion_electronica_estandar f with(nolock) ON f.sucursal = e.sucursal AND f.factura = e.factura 
WHERE CONVERT(VARCHAR(10),fechaprog,121) = @fecha  
	AND e.segto = 'C2' AND e.ctepadre IN ('571' , '012') and e.cliente in (select cliente from cat_cuentas_fidealessureste)
	AND (e.folio_fiscal != 'N/A'	OR	e.folio_fiscal IS NOT NULL )
GROUP BY
	e.sucursal			, 
	s.iata					,
	e.factura				,
	e.cliente				,
	e.folio_fiscal	, 
	s.serie_cfd
ORDER BY
	e.sucursal			, 
	s.iata					,
	e.factura				,
	e.cliente				,
	e.folio_fiscal	,
	s.serie_cfd

GO

