USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE 
PROCEDURE	[dbo].[usp_estadisticas_samayoa]
	@usp	VARCHAR(100), @registros	INT, @ejecucion VARCHAR(23)
WITH ENCRYPTION
AS

--SET @ejecucion = 


INSERT INTO tmp_estadisticas_usp_samayoa (fecha_hora, usp, registros, ejecución)
	VALUES (GETDATE(), @usp, @registros, CONVERT(DATETIME,@ejecucion,121))
GO
