USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO




CREATE	--	CREATE	--	DROP
PROCEDURE [dbo].[usp_fyza_inserta_cuentas]

@cuenta_estilo_yza	VARCHAR(10),
@sucursal						INT,
@cliente						VARCHAR(5)

WITH ENCRYPTION
AS


--EXECUTE usp_fyza_inserta_cuentas '1317862',  5, '17862'


INSERT INTO cat_cuentas_yza	
	(cuenta_estilo_yza, sucursal, cliente, timestamp)
VALUES
	(@cuenta_estilo_yza, @sucursal, @cliente, GETDATE())


SELECT * FROM cat_cuentas_yza
WHERE cuenta_estilo_yza = @cuenta_estilo_yza
GO
