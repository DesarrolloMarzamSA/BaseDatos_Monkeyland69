
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO




CREATE	--	CREATE	--	DROP
PROCEDURE [dbo].[usp_fyza_pharmacy_inserta_cuentas]

@mostrador	VARCHAR(10),
@sucursal		INT,
@cliente		VARCHAR(5)


AS


--EXECUTE usp_fyza_pharmacy_inserta_cuentas '1306264',  5, '06264'


INSERT INTO cat_yza_pharmacy	
	(mostrador, sucursal, cliente, timestamp)
VALUES
	(@mostrador, @sucursal, @cliente, GETDATE())


SELECT * FROM cat_yza_pharmacy
WHERE mostrador = @mostrador
GO
