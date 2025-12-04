
CREATE		--	CREATE	--	DROP
PROCEDURE [dbo].[usp_soriana_cfd_acuses_insert]


--DECLARE 

@reporte						INT, 
@pagina							INT, 
@fecha_recibo				DATE, 
@fecha_factura			DATE,
@numTienda					INT, 
@folio_acuse				INT, 
@documento_soriana	VARCHAR(20), 
@importe_bruto			MONEY, 
@fecha_paquete			DATE, 
@timestamp					DATETIME, 
@usr 								VARCHAR(20),
@linea							INT

AS

DECLARE 
@cliente_ibs		VARCHAR( 6)	,
@sucursal				INT					,
@serie_cfd			VARCHAR( 2)	, 
@folio_fiscal		VARCHAR(10)	,
@cliente				VARCHAR( 5)

SET @serie_cfd = UPPER(LEFT(@documento_soriana,2))

SET @folio_fiscal = RIGHT(REPLICATE('0',8)+
SUBSTRING(@documento_soriana, 4, 8) ,8 )



IF (SELECT COUNT(*) FROM encabezado_soriana e 
	WHERE e.serie_cfd = @serie_cfd AND e.folio_fiscal = @folio_fiscal) = 1
	
	BEGIN
		SET @cliente = (SELECT cliente FROM encabezado_soriana e 
		WHERE e.serie_cfd = @serie_cfd AND e.folio_fiscal = @folio_fiscal)
		
		SET @sucursal = (SELECT sucursal FROM encabezado_soriana e 
		WHERE e.serie_cfd = @serie_cfd AND e.folio_fiscal = @folio_fiscal)
		
		SET @cliente_ibs = (SELECT cliente_ibs FROM encabezado_soriana e 
		WHERE e.serie_cfd = @serie_cfd AND e.folio_fiscal = @folio_fiscal)

	END
	
ELSE
	
	BEGIN
		SET @serie_cfd = NULL
		SET @folio_fiscal = NULL
		SET @cliente_ibs = NULL
		SET @cliente = NULL

		SET @sucursal = (
			SELECT TOP 1 sucursal FROM CatTiendasSoriana 
			WHERE numTienda = @numTienda
		ORDER BY timestamp DESC
		)

		SET @cliente = (
			SELECT TOP 1 cliente FROM CatTiendasSoriana 
				WHERE numTienda = @numTienda
		ORDER BY timestamp DESC
		)
		
		SET @cliente_ibs = (SELECT cliente_ibs FROM clientes_baan
			WHERE sucursal = @sucursal AND cliente = @cliente )

		SET @serie_cfd = (
			SELECT serie_cfd FROM sucursales 
			WHERE sucursal = @sucursal)


		SET @folio_fiscal = (
		SELECT folio_fiscal  FROM encabezado_soriana 
		WHERE sucursal = @sucursal AND 
		folio_fiscal = RIGHT(REPLICATE('0',8)+
		SUBSTRING(@documento_soriana, 4, 8) ,8 )
		)

		IF(@folio_fiscal IS NULL )	--	AND @sucursal = 4
		SET @folio_fiscal = (
			SELECT folio_fiscal  FROM encabezado_soriana 
			WHERE sucursal = @sucursal AND 
			factura = RIGHT(REPLICATE('0',8)+
			SUBSTRING(@documento_soriana, 5, 8) ,8 )
			)

		IF(@folio_fiscal IS NULL)
			SET @folio_fiscal = (
				SELECT folio_fiscal  FROM encabezado_soriana 
				WHERE sucursal = @sucursal AND 
				factura = RIGHT(REPLICATE('0',8)+
				@documento_soriana, 8)
				)

		IF(@folio_fiscal IS NULL)
			SET @folio_fiscal = (
			SELECT b.folio_fiscal FROM bitacora_soriana_cfd b	
			WHERE b.sucursal = @sucursal AND b.cliente = @cliente 
			AND b.fecha BETWEEN 
				DATEADD(dd, -3 , @fecha_factura) 
				AND DATEADD(dd, 3 , @fecha_factura) 
			AND	b.importe = @importe_bruto
		)
	END


INSERT INTO cfd_soriana_acuses_de_recibo 
(
	reporte							, 
	pagina							, 
	addenda							,
	fecha_recibo				, 
	fecha_factura				, 
	numTienda						, 
	folio_acuse					,
	documento_soriana		,
	importe_bruto				,
	fecha_paquete				,
	timestamp						,
	usr									,
	serie_cfd						,
	folio_fiscal				,
	sucursal						,
	cliente							,
	linea								,
	cliente_ibs
) 
VALUES ( 
	@reporte						, 
	@pagina							,
	@linea							,
	@fecha_recibo				,
	@fecha_factura			,
	@numTienda					, 
	@folio_acuse				, 
	@documento_soriana	, 
	@importe_bruto			, 
	@fecha_paquete			, 
	@timestamp					, 
	@usr								,
	@serie_cfd					,
	@folio_fiscal				,
	@sucursal						,
	@cliente						,
	@linea							,
	@cliente_ibs
)

/*
IF	(SELECT COUNT(*) FROM cfd_soriana_acuses_de_recibo_control 
			WHERE fecha_paquete = @fecha_paquete) = 0
	BEGIN
		INSERT INTO cfd_soriana_acuses_de_recibo_control 
		(
			fecha_paquete, lineas
		) 
		VALUES 
		(
			@fecha_paquete, 1
		)
	END
ELSE
	BEGIN
		UPDATE cfd_soriana_acuses_de_recibo_control SET
			lineas = lineas + 1
		WHERE fecha_paquete = @fecha_paquete
	END
	*/

GO

