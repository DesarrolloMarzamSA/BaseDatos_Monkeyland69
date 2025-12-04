
--	CREATE
CREATE
PROCEDURE [dbo].[usp_pemex_consulta_folios_cfd]
@fecha0 VARCHAR(10), @fecha1 VARCHAR(10), @orden VARCHAR(10)
AS

--	@suc INT, 


/*
	DECLARE @fecha0 VARCHAR(10), @fecha1 VARCHAR(10), @orden VARCHAR(10)

	SET @fecha0 = '2010-01-01'
	SET @fecha1 = '2010-05-31'
	SET @orden = ''
*/

/*
usp_pemex_consulta_folios_cfd '2011-01-01','2011-02-15', '2000052720'
usp_pemex_consulta_folios_cfd '2011-02-12','2011-02-20', ''
*/

/*
CREATE TABLE #cfd_pemex	(	
	sucursal			INT,
	iata					VARCHAR( 3),
	serie_cfd			VARCHAR( 2),
	folio_fiscal	VARCHAR(10),
	fecha_factura	DATETIME,
	Cliente				VARCHAR( 5),
	Remision			VARCHAR(10),
	orden_compra	VARCHAR(10),
	copade				VARCHAR(10),
	Importe_Bruto	MONEY,
	encontrado		BIT
)

INSERT INTO #cfd_pemex
*/
	SELECT 
		f.sucursal,
		s.iata,
		s.serie_cfd, 
		folio_fiscal, 
		f.fechaprog fecha,				--	CONVERT(VARCHAR(10),f.fecha_factura,121)
		f.Cliente, 
		f.factura Remision, 
		f.orden orden_compra, 
		ISNULL(p.copade,'') copade,
		0 Importe_Bruto,
		--SUM(f.importe_bruto) Importe_Bruto,
		CONVERT(BIT,0) encontrado			
	FROM --monkeyland.dbo.facturacion_electronica_estandar f
	encabezado f with(nolock) 
	INNER JOIN sucursales s		with(nolock) 				ON f.sucursal = s.sucursal 
	LEFT OUTER JOIN pemex_oc p	with(nolock) 			ON f.orden		= p.orden_sap
	WHERE 
		f.segto = 'G1' AND f.ctepadre = '017' 
		AND f.fechaprog BETWEEN CONVERT(DATETIME,@fecha0,121) AND CONVERT(DATETIME,@fecha1,121)
--	AND SUCURSAL = 7
---		AND (f.folio_fiscal IS NOT NULL OR CONVERT(BIGINT,f.folio_fiscal) > 0)
	--AND f.factura != folio_fiscal
/*	GROUP BY 
		f.fecha_factura,
		f.sucursal,
		s.iata,
		f.Cliente, 
		s.serie_cfd, 
		f.factura, 
		f.folio_fiscal, 
		f.orden , 
		p.copade
	ORDER BY
		f.fecha_factura,
		f.sucursal,
		s.iata,
		f.Cliente, 
		s.serie_cfd, 
		f.factura, 
		f.folio_fiscal, 
		f.orden, 
		p.copade

*/

GO

