

CREATE	--	CREATE
PROCEDURE [dbo].[usp_constructor_metodos_ofertas]
	@cadena VARCHAR(20), @sucursal INT


AS
/*
EXECUTE usp_constructor_metodos_ofertas 'FUNION', 5
EXECUTE usp_constructor_metodos_ofertas 'FELTREBOL', 1
EXECUTE usp_constructor_metodos_ofertas 'FSFA', 3
EXECUTE usp_constructor_metodos_ofertas 'FELFENIX', 1
EXECUTE usp_constructor_metodos_ofertas 'FREGIS', 7
EXECUTE usp_constructor_metodos_ofertas 'FSMART', 24
EXECUTE usp_constructor_metodos_ofertas 'FMINNE', 24
*/


CREATE TABLE #ofertas	(
	sucursal						INT								,
	bolsa								VARCHAR(  5)			,
	codigo							VARCHAR(  7)			,
	cant_base						INT								,
	cant_oferta					INT								,
	porcentaje					MONEY							,
	vigencia_inicial		SMALLDATETIME			,
	vigencia_final			SMALLDATETIME			,
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




SET DATEFIRST 7	--	FIJA EL PRIMER DIA ES DOMINGO

--Sunday		 1 
--Monday		 2
--Tuesday		 3
--Wednesday	 4
--Thursday	 5
--Friday		 6
--Saturday	 7

DECLARE @dias INT
--	SI EL DIA ES LUNES LE RESTA 2 DIAS AL RANGO

SET @dias = --CASE WHEN DATEPART(DW,CONVERT(DATETIME,GETDATE(),121)) = 2 THEN -2 ELSE -1 END
-( DATEPART(DW,CONVERT(DATETIME,GETDATE(),121)) ) + 2

--SELECT @dias

DECLARE @fecha_inicial DATE 

SET @fecha_inicial = CONVERT(DATETIME,CONVERT(VARCHAR(10),DATEADD(DD, @dias, GETDATE() ),121),121) 

WHILE @@FETCH_STATUS = 0
BEGIN
	INSERT INTO #ofertas (
		sucursal, bolsa, codigo, cant_base, cant_oferta, porcentaje, vigencia_inicial, vigencia_final, disponible, timestamp
		) 
		SELECT 
			ofe.sucursal, ofe.metodo, ofe.codigo, ofe.cant_base, ofe.cant_oferta, ofe.porcentaje, ofe.vigencia_inicial, ofe.vigencia_final, ofe.disponible, ofe.timestamp
		FROM Capa_ibs.dbo.tbl_metodos_ofertas ofe WITH (NOLOCK)
		INNER JOIN maestro_productos_baan mpb ON mpb.codigo = ofe.codigo
		WHERE sucursal = @sucursal AND metodo = @bolsa  
			AND vigencia_inicial <= @fecha_inicial	--	CONVERT(DATETIME,CONVERT(VARCHAR(10),GETDATE(),121),121)
			AND vigencia_final >= @fecha_inicial	--	CONVERT(DATETIME,CONVERT(VARCHAR(10),GETDATE(),121),121)
			AND ofe.codigo NOT IN (SELECT codigo FROM #ofertas)
		AND	CONVERT(INT,ofe.codigo) < dbo.gobierno()
		AND ISNUMERIC(mpb.cod_barras) = 1
		group by ofe.sucursal, ofe.metodo, ofe.codigo, ofe.cant_base, ofe.cant_oferta, ofe.porcentaje, ofe.vigencia_inicial, ofe.vigencia_final, ofe.disponible, ofe.timestamp

	UPDATE bolsas_ofertas SET 
		unidades = (SELECT COUNT(*) FROM dboferta WHERE sucursal = @sucursal AND bolsa = @bolsa)
	WHERE sucursal = @sucursal AND bolsa = @bolsa 	

	FETCH NEXT FROM bolsas_ofertas INTO @sucursal, @bolsa
	
END

DEALLOCATE bolsas_ofertas

SELECT * FROM #ofertas

DROP TABLE #ofertas

GO

