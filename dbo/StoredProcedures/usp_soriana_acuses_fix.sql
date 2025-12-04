--SELECT * FROM CatTiendasSoriana WHERE numTienda = 1026

CREATE	--	CREATE 
PROCEDURE [dbo].[usp_soriana_acuses_fix]

--DECLARE
--@fecha_paquete VARCHAR(10)
--@reporte INT
--SET @fecha_paquete = '2011-04-02'

AS

UPDATE cfd_soriana_acuses_de_recibo SET 
	sucursal = s.sucursal
FROM cfd_soriana_acuses_de_recibo a 
INNER JOIN CatTiendasSoriana s ON s.numTienda = a.numTienda
WHERE a.sucursal IS NULL
	--AND fecha_paquete = CONVERT(SMALLDATETIME,@fecha_paquete,121)
----and reporte = @reporte

UPDATE cfd_soriana_acuses_de_recibo SET 
	serie_cfd = CASE WHEN fecha_paquete >= fecha_ibs THEN s.serie_cfd ELSE s.serie_cfd_old END
FROM cfd_soriana_acuses_de_recibo a 
INNER JOIN sucursales s ON s.sucursal = a.sucursal
--WHERE 
--	fecha_paquete  = CONVERT(SMALLDATETIME,@fecha_paquete,121)
--AND a.serie_cfd IS NULL OR a.serie_cfd = '' OR LEN(a.serie_cfd) = 1


--CREATE TABLE #acuses (
--documento_soriana VARCHAR(20) PRIMARY KEY, 
--sucursal INT, serie_cfd VARCHAR(2), folio_fiscal VARCHAR(8), ordering INT )


UPDATE cfd_soriana_acuses_de_recibo SET 
	folio_fiscal = NULL,
	usr = 'FXD' 
WHERE 
	--fecha_paquete = CONVERT(SMALLDATETIME,@fecha_paquete,121) AND 
	addenda = 0

DECLARE @documento VARCHAR(20), @sucursal INT, @serie_cfd VARCHAR(2), @folio_fiscal VARCHAR(8)
DECLARE @es_remision BIT, @contador INT

DECLARE acuses CURSOR FOR --FAST_FORWARD
	SELECT documento_soriana, serie_cfd, sucursal 
	FROM cfd_soriana_acuses_de_recibo 
	WHERE 
		--fecha_paquete = CONVERT(SMALLDATETIME,@fecha_paquete,121) AND 
		addenda = 0

OPEN acuses 
FETCH NEXT FROM acuses INTO @documento, @serie_cfd, @sucursal

SET @contador = 1
WHILE @@FETCH_STATUS = 0
BEGIN
	DECLARE @cfds INT
	SET @cfds = 0
	SET @es_remision = 0
	IF ISNUMERIC(@documento) = 1
		BEGIN
			SET @folio_fiscal = RIGHT(REPLICATE('0',8) + @documento , 8)
		END

	IF SUBSTRING(@documento,2,1) = '-'
		BEGIN
			SET @folio_fiscal = RIGHT(REPLICATE('0',8) + SUBSTRING(@documento,3,10) , 8)
		END

	IF SUBSTRING(@documento,3,1) = '-'
		BEGIN
			SET @folio_fiscal = RIGHT(REPLICATE('0',8) + SUBSTRING(@documento,4,10) , 8)
		END

	IF SUBSTRING(@documento,4,1) = '-'
		BEGIN
			SET @folio_fiscal = RIGHT(REPLICATE('0',8) + SUBSTRING(@documento,5,10) , 8)
		END

	SET @cfds = (SELECT COUNT(*) FROM encabezado_soriana WHERE sucursal = @sucursal AND folio_fiscal = @folio_fiscal)
		
	IF @cfds = 0
		SET @es_remision = 1

	IF @es_remision = 1 
	BEGIN
		DECLARE @remisiones INT
		SET @remisiones = 0
		SET @remisiones = (SELECT COUNT(*) FROM encabezado_soriana WHERE sucursal = @sucursal AND factura = @folio_fiscal)

		IF @sucursal <> 4 AND @remisiones = 1
			BEGIN
				SET @folio_fiscal = (SELECT folio_fiscal FROM encabezado_soriana WHERE sucursal = @sucursal AND factura = @folio_fiscal)
				SET @remisiones = 1
			END

		IF @sucursal = 4 
			BEGIN
				SET @folio_fiscal = (SELECT folio_fiscal FROM encabezado_soriana WHERE sucursal = @sucursal AND SUBSTRING(factura,2,7) = SUBSTRING(@folio_fiscal,2,7))
				SET @remisiones = 1
			END

		IF (@es_remision = 1 AND @remisiones = 1)
			UPDATE cfd_soriana_acuses_de_recibo SET 
				remision = @folio_fiscal ,
				usr = 'XYZ' 
			WHERE documento_soriana = @documento	;

	END

	IF ( @cfds = 1 OR @remisiones = 1)	
--				SELECT @folio_fiscal, @cfds, @remisiones
		UPDATE cfd_soriana_acuses_de_recibo SET 
			folio_fiscal = @folio_fiscal ,
			usr = 'FXD' 
		WHERE documento_soriana = @documento	;
	
	--INSERT INTO #acuses
	--	SELECT @documento, @sucursal, @serie_cfd, @folio_fiscal, @contador	;

		PRINT @documento + ' ' + @folio_fiscal


	FETCH NEXT FROM acuses INTO @documento, @serie_cfd, @sucursal
	SET @contador = @contador + 1
END

CLOSE acuses
DEALLOCATE acuses

--SELECT a.documento_soriana, a.sucursal, a.serie_cfd, a.folio_fiscal, e.farmacia, a.ordering FROM #acuses a
--LEFT OUTER JOIN encabezado_soriana e ON e.sucursal = a.sucursal AND e.folio_fiscal = a.folio_fiscal
--ORDER BY a.ordering

--drop table #acuses


UPDATE bitacora_soriana_cfd SET 
	folio_entrada = a.folio_acuse
FROM bitacora_soriana_cfd b
INNER JOIN cfd_soriana_acuses_de_recibo a ON a.serie_cfd = b.serie_cfd
	AND a.folio_fiscal = b.folio_fiscal
WHERE --b.fecha = CONVERT(SMALLDATETIME,@fecha_paquete,121) AND 
	b.folio_entrada IS NULL OR b.folio_entrada = '0'

/*
SELECT * FROM cfd_soriana_acuses_de_recibo b WITH (NOLOCK)
WHERE 
	fecha_paquete = @fecha_paquete
*/	
	
	
	
	
/*	
	select * from historica.dbo.encabezado--_soriana
with (nolock)
where 
sucursal > 0 and
--folio_fiscal = RIGHT(
--REPLICATE('0',8) + '336150' , 8)

--or
factura = RIGHT(
REPLICATE('0',8) + '336150' , 8)
*/

GO

