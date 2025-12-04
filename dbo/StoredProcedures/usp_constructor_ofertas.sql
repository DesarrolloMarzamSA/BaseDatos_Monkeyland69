

CREATE	--	CREATE
PROCEDURE [dbo].[usp_constructor_ofertas] 
	@cadena VARCHAR(20), @sucursal INT


AS
/*
EXECUTE usp_constructor_ofertas 'FUNION', 5
EXECUTE usp_constructor_ofertas 'FELTREBOL', 1
EXECUTE usp_constructor_ofertas 'FSFA', 3
EXECUTE usp_constructor_ofertas 'FELFENIX', 1
EXECUTE usp_constructor_ofertas 'FREGIS', 7
EXECUTE usp_constructor_ofertas 'FSMART', 24
EXECUTE usp_constructor_ofertas 'FMINNE', 24
*/


CREATE TABLE #ofertas	(
	sucursal						INT								,
	bolsa								VARCHAR(  5)			,
	codigo							VARCHAR(  7)			,
	cant_base						INT								,
	cant_oferta					INT								,
	porcentaje					MONEY							,
	vigencia_inicial		DATE			,	--SMALLDATETIME
	vigencia_final			DATE			,	--SMALLDATETIME
	disponible					INT								,
	timestamp						DATETIME
	PRIMARY KEY (codigo)	
)

DECLARE @bolsa VARCHAR(5)

DECLARE bolsas_ofertas CURSOR FAST_FORWARD FOR
	SELECT sucursal, bolsa FROM bolsas_ofertas WITH (NOLOCK)
	WHERE cadena = @cadena	AND sucursal = @sucursal
	ORDER BY orden	
OPEN bolsas_ofertas

FETCH FROM bolsas_ofertas INTO @sucursal, @bolsa

DECLARE @hoy DATE 
SET @hoy = CONVERT(DATETIME,CONVERT(VARCHAR(10),GETDATE(),121),121)

--SET @hoy = CONVERT(DATETIME,CONVERT(VARCHAR(10),DATEADD(DD, @dias, GETDATE() ),121),121) 

WHILE @@FETCH_STATUS = 0
BEGIN
	INSERT INTO #ofertas (
		sucursal, bolsa, codigo, cant_base, cant_oferta, porcentaje, vigencia_inicial, vigencia_final, disponible, timestamp
		) 
		SELECT 
			ofe.sucursal, ofe.bolsa, ofe.codigo, ofe.cant_base, ofe.cant_oferta, ofe.porcentaje, ofe.vigencia_inicial, ofe.vigencia_final, ofe.disponible, ofe.timestamp
		FROM dboferta ofe WITH (NOLOCK)
		INNER JOIN maestro_productos_baan mpb ON mpb.codigo = ofe.codigo
		WHERE sucursal = @sucursal AND bolsa = @bolsa  
			AND vigencia_inicial <= @hoy	
			AND vigencia_final >= @hoy	
			AND ofe.codigo NOT IN (SELECT codigo FROM #ofertas)
		AND	CONVERT(INT,ofe.codigo) < dbo.gobierno()
		AND ISNUMERIC(mpb.cod_barras) = 1

	UPDATE bolsas_ofertas SET 
		unidades = (SELECT COUNT(*) FROM dboferta WHERE sucursal = @sucursal AND bolsa = @bolsa),
		timestamp = GETDATE()
	WHERE sucursal = @sucursal AND bolsa = @bolsa 	

	FETCH NEXT FROM bolsas_ofertas INTO @sucursal, @bolsa
	
END

DEALLOCATE bolsas_ofertas

SELECT * FROM #ofertas

DROP TABLE #ofertas

GO

