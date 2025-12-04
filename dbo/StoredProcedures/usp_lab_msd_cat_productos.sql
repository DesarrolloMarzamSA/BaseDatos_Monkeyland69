USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE --	CREATE	--	DROP
PROCEDURE [dbo].[usp_lab_msd_cat_productos]
	@fecha VARCHAR(10)
WITH ENCRYPTION
AS

/*
EXECUTE usp_lab_msd_cat_productos '2011-02-28'
*/

DECLARE @ejecucion VARCHAR(23)
SET @ejecucion = CONVERT(VARCHAR(23),GETDATE(),121)

CREATE TABLE #productos (
	codigo									VARCHAR( 7),
	cod_barras							VARCHAR(13),
	descripcion							VARCHAR(50), 
	lab_corto								VARCHAR( 6),
	estatus									VARCHAR(10),
	fecha										VARCHAR(10),
	)

INSERT INTO #productos
SELECT 
	codigo,
	cod_barras,
	descripcion, 
	mpb.lab_corto, 
	CASE 
	WHEN LEFT(mpb.status,1) = 'B' THEN 'Baja'  
	--WHEN LEFT(mpb.status,1) = 'C' THEN 'Cambio'  
	ELSE 'Activo' END	estatus,			
	CASE 
	WHEN LEFT(mpb.status,1) = 'B' THEN ISNULL(CONVERT(VARCHAR(10),mpb.fecha_baja,121),'')	
	--ISNULL(CONVERT(VARCHAR(10),mpb.fecha_alta,121),'')	
	ELSE '' END fecha
	--,status
--	INTO #lab_msd_productos 
--, p_costo 
FROM maestro_productos_baan mpb 
WHERE 
	mpb.lab_corto IN (SELECT lab_corto FROM lab_fusiones WHERE id_lab = 'MSD')
 AND LEFT(mpb.status ,1) <> 'B'
--AND (mpb.fecha_alta >= DATEADD(dd, -30, GETDATE() )
--OR mpb.fecha_baja >= DATEADD(dd, -30, GETDATE() ) )
ORDER BY lab_corto, codigo

DECLARE @total_registros INT
SET @total_registros = (SELECT COUNT(*) FROM #productos)


DECLARE @estor VARCHAR(50)
SET @estor = 'usp_lab_msd_cat_productos '+@fecha
EXECUTE usp_estadisticas_samayoa @estor, @total_registros, @ejecucion

SELECT 
	codigo				,
	cod_barras		,
	descripcion		,
	lab_corto			,
	estatus				,
	fecha					
FROM #productos
GO
