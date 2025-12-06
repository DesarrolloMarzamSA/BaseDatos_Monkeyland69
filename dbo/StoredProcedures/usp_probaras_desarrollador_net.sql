
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE 
--	CREATE
PROCEDURE [dbo].[usp_probaras_desarrollador_net] (@fecha VARCHAR(10)) 

--@sucursal INT, 

WITH ENCRYPTION
as	

/*
usp_probaras_desarrollador_net '2010-06-01'
*/

DECLARE @contador INT
SET @contador = 1
CREATE TABLE #resultados (fecha DATETIME,contador INT)	--	suc INT,

WHILE @contador <= 10
BEGIN
	INSERT INTO #resultados
	--	@sucursal,
		SELECT CONVERT(DATETIME,@fecha,121),@contador
		SET @contador = @contador + 1
END
SELECT * FROM #resultados
GO
