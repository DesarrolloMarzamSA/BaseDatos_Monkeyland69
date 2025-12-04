
CREATE	--	CREATE
PROCEDURE [dbo].[usp_hmuguerza_registra_bitacora] 
	@fecha VARCHAR(10),	--	SMALLDATETIME, --
	@serie_cfd VARCHAR(2),
	@folio_fiscal VARCHAR(10),
	@confirmada INT,
	@msg VARCHAR(255),
	@archivo_xml VARCHAR(100),
	@archivo_pdf VARCHAR(100),
	@sucursal INT,
	@cliente VARCHAR(5)
AS

/*
EXECUTE usp_hmuguerza_registra_bitacora '2011-07-28', 'FX', '12345678', 1, 'OK', 'XYZ', 'ZYX'
SELECT  * FROM bitacora_muguerza_cfd ORDER BY registro DESC
*/

DECLARE @orden CHAR(9)
DECLARE @clienteAux VARCHAR(5)
DECLARE @fechaAux varchar(8)
SET @orden = (SELECT orden FROM encabezado WHERE sucursal = @sucursal AND folio_fiscal = @folio_fiscal)
SET @clienteAux =(SELECT cliente FROM encabezado WHERE sucursal = @sucursal AND folio_fiscal = @folio_fiscal)
SET @fechaAux =(SELECT fechaprog FROM encabezado WHERE sucursal = @sucursal AND folio_fiscal = @folio_fiscal)


IF (SELECT COUNT(*) FROM bitacora_muguerza_cfd WHERE serie_cfd = @serie_cfd AND folio_fiscal = @folio_fiscal ) = 0
	INSERT INTO bitacora_muguerza_cfd (
		fecha, 
		registro, 
		serie_cfd, 
		folio_fiscal, 
		confirmada, 
		msg_error, 
		intento, 
		archivo_xml, 
		archivo_pdf, 
		sucursal			,
		cliente,
		orden
	) VALUES (
		CONVERT(SMALLDATETIME,@fechaAux,121), 
		GETDATE(), 
		@serie_cfd, 
		@folio_fiscal, 
		@confirmada, 
		@msg, 
		1, 
		@archivo_xml, 
		@archivo_pdf,
		@sucursal			,
		@clienteAux,
		@orden
		)
ELSE
	UPDATE bitacora_muguerza_cfd SET
		confirmada = @confirmada	, 
		archivo_xml = @archivo_xml	, 
		archivo_pdf = @archivo_pdf	,
		orden = @orden				,
		msg_error = @msg			,
		registro = GETDATE()		,
		intento = intento + 1		,
		cliente = @clienteAux	
	WHERE serie_cfd = @serie_cfd AND folio_fiscal = @folio_fiscal

GO

