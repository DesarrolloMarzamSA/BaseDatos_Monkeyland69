
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE	--	CREATE	--	DROP
PROCEDURE	[dbo].[usp_lab_msd_cat_sucursales]
	@fecha VARCHAR(10)
WITH ENCRYPTION
AS	

/*
EXECUTE usp_lab_msd_cat_sucursales '2011-05-02'
*/
DECLARE @ejecucion VARCHAR(23)
SET @ejecucion = CONVERT(VARCHAR(23),GETDATE(),121)

CREATE TABLE #sucursales	(
	id_suc			VARCHAR(02),
	descripcion	VARCHAR(50),
	fecha				VARCHAR(10)
)

INSERT INTO #sucursales

SELECT
	RIGHT( REPLICATE('0',2) + CONVERT(VARCHAR,sucursal) , 2)	id_suc			,
	descripcion																								descripcion	,
	--CASE WHEN s.fisica = 1	THEN 'ALMACEN'	ELSE 'CR' END			clase				,
	@fecha																										fecha				
FROM sucursales s 
WHERE s.fisica = 1


DECLARE @total_registros	INT
SET @total_registros = (SELECT COUNT(*) FROM #sucursales)


SELECT
	id_suc			,
	descripcion	,
	--	clase				,
	fecha				
FROM #sucursales


DECLARE @estor VARCHAR(50)
SET @estor = 'usp_lab_msd_cat_sucursales '+@fecha
EXECUTE usp_estadisticas_samayoa @estor, @total_registros, @ejecucion

GO
