/*
usp_soriana_cfd_tbl_remision 'FC','01067777'
*/

CREATE
--	CREATE
PROCEDURE [dbo].[usp_soriana_cfd_tbl_remision]
--	DECLARE 
@serie_cfd VARCHAR(2), @folio_fiscal VARCHAR(8)
AS

DECLARE @tienda INT
SET @tienda = (SELECT numTienda FROM cfd_soriana_acuses_de_recibo WHERE serie_cfd = @serie_cfd AND folio_fiscal = @folio_fiscal)


/*
SET @folio_fiscal = '00316283'
set @serie_cfd = 'FG'
*/
SET @folio_fiscal = RIGHT(REPLICATE('0', 8) + @folio_fiscal,  8)

SELECT
	'21329'																														Proveedor							,
	s.serie_cfd + '-' + CONVERT(VARCHAR,CONVERT(INT,e.folio_fiscal))	Remision							,
	0																																	Consecutivo						,
	CONVERT(VARCHAR(19),GETDATE(),126)																FechaRemision					,
	CONVERT(VARCHAR,CONVERT(INT,@tienda))															Tienda								,
	1																																	TipoMoneda						,
	2																																	TipoBulto							,
	0																																	EntregaMercancia			,
	'true'																														CumpleReqFiscales			,
	1																																	CantidadBultos				,
	CONVERT(NUMERIC(10,2),SUM(f.importe_bruto		)	)										Subtotal							,
	CONVERT(NUMERIC(10,2),SUM(f.descto_comercial)	)										Descuentos						,
	CONVERT(NUMERIC(10,2),SUM(f.ieps						)	)										IEPS									,
	CONVERT(NUMERIC(10,2),SUM(f.iva							)	)										IVA										,
	0																																	OtrosImpuestos				,
	CONVERT(NUMERIC(10,2),SUM(f.importe_neto)	)												Total									,
	1																																	CantidadPedidos				,
	CONVERT(VARCHAR(19),DATEADD(DD, 1, GETDATE()),126)								FechaEntregaMercancia	,
	0																																	Cita									,
	ISNULL(n.folio_acuse,1100)																				FolioNotaEntrada	
--FROM encabezado e
FROM encabezado_soriana e
INNER JOIN sucursales s													ON	s.serie_cfd = @serie_cfd 
LEFT OUTER JOIN CatTiendasSoriana c							ON	e.sucursal = c.sucursal		AND e.cliente = c.cliente
LEFT OUTER JOIN cfd_soriana_acuses_de_recibo n	ON	n.serie_cfd = @serie_cfd	AND	n.folio_fiscal = CONVERT(INT,@folio_fiscal)
--INNER JOIN facturacion_electronica_estandar f		ON	f.sucursal = e.sucursal		AND f.factura = e.factura
INNER JOIN historica.dbo.fes f		ON	f.sucursal = e.sucursal		AND f.factura = e.factura
WHERE e.sucursal = s.sucursal
	AND e.folio_fiscal = @folio_fiscal
	AND e.segto = 'E1' AND e.ctepadre IN ('044','032')
	AND e.farmacia NOT LIKE '%ISSSTE%'
GROUP BY 
s.serie_cfd, e.folio_fiscal, e.fechaprog, c.numTienda, n.folio_acuse
--s.serie_cfd, e.folio_fiscal, e.fechaprog, n.numTienda, n.folio_acuse

GO

