CREATE			--	CREATE
PROCEDURE usp_pemex_cfd
@tipo CHAR(2), @cadena VARCHAR(21)
AS

--	@suc INT, 


/*
	DECLARE @tipo VARCHAR(10), @cadena VARCHAR(10), @orden VARCHAR(10)

	SET @tipo = '2010-01-01'
	SET @cadena = '2010-05-31'
	SET @orden = ''
*/

/*
usp_pemex_cfd 'DT','2011-01-01 2011-03-08'
usp_pemex_cfd 'OC','329831'
usp_pemex_cfd 'CF','FE-483876'
usp_pemex_cfd 'RM','FE-483876'

*/

IF @tipo = 'DT'				--	FECHAS
BEGIN
	DECLARE @fecha0 CHAR(10), @fecha1 CHAR(10)
	SET @fecha0 = SUBSTRING(@cadena,  1,10)
	SET @fecha1 = SUBSTRING(@cadena, 12,10) 
	PRINT @fecha0
	PRINT @fecha1

	SELECT 
		CONVERT(BIT,0) recup					,
		f.sucursal,
		s.letra												,
		s.iata												,
		CASE WHEN r.fecha < s.fecha_ibs THEN s.serie_cfd_old ELSE s.serie_cfd END serie_cfd	, 
		--f.folio_fiscal								, 
		ISNULL(CONVERT(VARCHAR,CONVERT(INT,f.folio_fiscal)), CONVERT(VARCHAR,CONVERT(INT,r.folio_fiscal))) folio_fiscal,
		f.fechaprog fecha							,				
		f.Cliente											, 
		f.factura Remision						, 
		f.farmacia										,
		LTRIM(f.orden) orden_compra		, 
		p.orden_sap										,
		p.orden_siaf									,
		p.contrato										,
		ISNULL(p.copade,'') copade		,
		0 Importe_Bruto
	FROM 
	encabezado_pemex f															WITH (NOLOCK)
	INNER JOIN sucursales s													WITH (NOLOCK)	ON f.sucursal = s.sucursal 
	LEFT OUTER JOIN remisiones_facturas_docufact r	WITH (NOLOCK)	ON r.sucursal = f.sucursal AND r.remision = f.factura
	LEFT OUTER JOIN pemex_oc p											WITH (NOLOCK)	ON p.orden_siaf	= f.orden
	WHERE 
		f.segto = 'G1' AND f.ctepadre = '017' 
		AND f.fechaprog BETWEEN CONVERT(DATETIME,@fecha0,121) AND CONVERT(DATETIME,@fecha1,121)
	ORDER BY f.sucursal, f.folio_fiscal
END

IF @tipo = 'OC'				--	ORDEN DE COMPRA
BEGIN
	SELECT 
		CONVERT(BIT,0) recup					,
		f.sucursal,
		s.letra												,
		s.iata												,
		CASE WHEN r.fecha < s.fecha_ibs THEN s.serie_cfd_old ELSE s.serie_cfd END serie_cfd	, 
		--f.folio_fiscal								, 
		ISNULL(CONVERT(VARCHAR,CONVERT(INT,f.folio_fiscal)), CONVERT(VARCHAR,CONVERT(INT,r.folio_fiscal))) folio_fiscal,
--		ISNULL(f.folio_fiscal, r.folio_fiscal) folio_fiscal,
		f.fechaprog fecha							,				
		f.Cliente											, 
		f.factura Remision						, 
		f.farmacia										,
		LTRIM(f.orden) orden_compra		, 
		p.orden_sap										,
		p.orden_siaf									,
		p.contrato										,
		ISNULL(p.copade,'') copade		,
		0 Importe_Bruto
	FROM 
	encabezado_pemex f															WITH (NOLOCK)
	INNER JOIN sucursales s													WITH (NOLOCK)	ON s.sucursal	= f.sucursal 
	LEFT OUTER JOIN remisiones_facturas_docufact r	WITH (NOLOCK)	ON r.sucursal = f.sucursal AND r.remision = f.factura
	LEFT OUTER JOIN pemex_oc p											WITH (NOLOCK)	ON p.orden_siaf	= f.orden
	WHERE 
		f.segto = 'G1' AND f.ctepadre = '017' 
		AND f.orden LIKE '%'+RTRIM(@cadena)+'%'
	ORDER BY f.sucursal, f.folio_fiscal
END


IF @tipo = 'CF'				--	FOLIO FISCAL
BEGIN
	DECLARE @folio_fiscal char(8)
	SET @folio_fiscal = RIGHT( REPLICATE('0',8) + RTRIM( SUBSTRING( @cadena,4,8) )  ,8)
	--PRINT @folio_fiscal
	SELECT 
		CONVERT(BIT,0) recup					,
		ep.sucursal,
		s.letra												,
		s.iata												,
		CASE WHEN r.fecha < s.fecha_ibs THEN s.serie_cfd_old ELSE s.serie_cfd END serie_cfd	, 
		--ep.folio_fiscal								, 
		ISNULL(CONVERT(VARCHAR,CONVERT(INT,ep.folio_fiscal)), CONVERT(VARCHAR,CONVERT(INT,r.folio_fiscal))) folio_fiscal,
		--ISNULL(ep.folio_fiscal, r.folio_fiscal) folio_fiscal,
		ep.fechaprog	fecha							,				
		ep.cliente		cliente						, 
		ep.factura		remision					, 
		ep.farmacia		farmacia					, 
		LTRIM(ep.orden) orden_compra		, 
		op.orden_sap										,
		op.orden_siaf									,
		op.contrato										,
		ISNULL(op.copade,'') copade		,
		0 Importe_Bruto
	FROM 
	encabezado_pemex ep																	WITH (NOLOCK)
	INNER JOIN sucursales s															WITH (NOLOCK)	ON s.serie_cfd	=	LEFT(@cadena,2) AND s.sucursal  = ep.sucursal 
	LEFT OUTER JOIN remisiones_facturas_docufact r			WITH (NOLOCK)	ON ep.sucursal = r.sucursal AND ep.factura = r.remision
	LEFT OUTER JOIN pemex_oc op													WITH (NOLOCK)	ON op.orden_siaf	= ep.orden
	WHERE 
		--ep.segto = 'G1' AND ep.ctepadre = '017' 
		--ep.sucursal  = s.sucursal AND 
		ep.folio_fiscal = @folio_fiscal
	ORDER BY ep.sucursal, ep.folio_fiscal
END


IF @tipo = 'RM'				--	REMISION
BEGIN
	DECLARE @remision char(8)
	SET @remision = RIGHT( REPLICATE('0',8) + RTRIM( SUBSTRING( @cadena,4,8) )  ,8)
	--PRINT @remision
	SELECT 
		f.sucursal,
		s.iata,
		CASE WHEN r.fecha < s.fecha_ibs THEN s.serie_cfd_old ELSE s.serie_cfd END serie_cfd	, 
		--f.folio_fiscal, 
		ISNULL(CONVERT(VARCHAR,CONVERT(INT,f.folio_fiscal)), CONVERT(VARCHAR,CONVERT(INT,r.folio_fiscal))) folio_fiscal,
		--ISNULL(f.folio_fiscal, r.folio_fiscal) folio_fiscal,
		f.fechaprog fecha,				--	CONVERT(VARCHAR(10),f.fecha_factura,121)
		f.Cliente, 
		f.factura Remision, 
		f.farmacia										,
		f.orden orden_compra, 
		p.orden_sap,
		p.orden_siaf,
		p.contrato,
		ISNULL(p.copade,'') copade,
		0 Importe_Bruto,
		--SUM(f.importe_bruto) Importe_Bruto,
		CONVERT(BIT,0) encontrado			
	FROM
	encabezado_pemex f															WITH (NOLOCK)
	INNER JOIN sucursales s													WITH (NOLOCK)	ON s.serie_cfd	=	LEFT(@cadena,2) AND s.sucursal  = f.sucursal 
	LEFT OUTER JOIN remisiones_facturas_docufact r	WITH (NOLOCK)	ON r.sucursal = f.sucursal AND r.remision = f.factura
	LEFT OUTER JOIN pemex_oc p											WITH (NOLOCK)	ON p.orden_siaf	= f.orden
	WHERE 
		f.segto = 'G1' AND f.ctepadre = '017' 
		AND s.sucursal  = f.sucursal AND f.factura = @remision
	ORDER BY f.sucursal, f.folio_fiscal
END

GO

