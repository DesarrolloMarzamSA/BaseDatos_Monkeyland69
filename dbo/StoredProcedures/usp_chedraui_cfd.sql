
--	MIGUEL SAMAYOA
--	2010-08-10	CREACION

/*
EXECUTE usp_chedraui_cfd 7,'2010-08-10'

La finalidad de este usp es encontrar el folio fiscal para poder 
buscar el archivo con nombre con el formato 'FACTURAnnnnnnnnaa*.XML'
en las carpetas de los servidores CFD definidos en la tabla cfd_servers

DEBIDO A LA CANTIDAD DE FACTURAS DE CHEDRAUI, se corre por sucursal

Donde 
	nnnnnnnn = foliofiscal (sin ceros)
	aa	=	serie_cfd
*/

CREATE
--CREATE
PROCEDURE [dbo].[usp_chedraui_cfd] 
--	DECLARE 
@suc INT, @fecha VARCHAR(10)
/*
SET @suc = 7
SET @fecha = '2010-07-14'
*/

AS

SELECT--	 TOP 20
																											e.sucursal				,
																											s.serie_cfd				, 
	CONVERT(VARCHAR, CONVERT(INT,e.folio_fiscal))				folio_fiscal			, 
																											s.IATA						,
																											e.factura remision, 
																											e.cliente					, 
	CASE 
		WHEN ISNUMERIC(LTRIM(RTRIM(e.orden))) = 1	THEN CONVERT(INT,e.orden)
		ELSE 0
	END																									orden						, 
	CONVERT(VARCHAR, CONVERT(INT,t.numTienda))					numTienda					, 
	ISNULL(MAX(f.porcentaje_iva				),				0)			porc_iva					,
	ISNULL(MAX(f.porcentaje_ieps			),				0)			porc_ieps					,
	ISNULL(SUM(f.piezas_surtidas_con_cargo + f.piezas_surtidas_sin_cargo				),				0)			piezas			,
	ISNULL(SUM(f.importe_bruto				),				0)			importe_bruto			,
	ISNULL(SUM(f.iva									),				0)			iva								,
	ISNULL(SUM(f.ieps									),				0)			ieps							,
	ISNULL(SUM(f.importe_neto					),				0)			importe_neto
FROM encabezado e with(nolock) 
LEFT OUTER JOIN facturacion_electronica_estandar f with(nolock) ON f.sucursal = e.sucursal 
	AND e.factura = f.factura
INNER JOIN sucursales s with(nolock) ON e.sucursal = s.sucursal 
LEFT OUTER JOIN CatTiendasSoriana t with(nolock) ON e.sucursal = t.Sucursal AND e.cliente = t.cliente 
WHERE e.sucursal = @suc
	AND e.fechaprog = CONVERT(DATETIME,@fecha,121) 
	AND e.segto = 'E1' AND e.ctepadre = '015'
	AND (e.folio_fiscal != 'N/A'	OR	e.folio_fiscal IS NOT NULL )

GROUP BY 	e.sucursal,	s.serie_cfd, 	e.folio_fiscal, 	s.IATA,	e.factura, 	e.cliente, 	e.orden, 	t.numTienda
ORDER BY 	e.sucursal,	s.serie_cfd, 	e.folio_fiscal, 	s.IATA,	e.factura, 	e.cliente, 	e.orden, 	t.numTienda

GO

