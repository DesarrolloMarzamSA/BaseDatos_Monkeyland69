USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE
--	CREATE
PROCEDURE [dbo].[usp_lab_az_cat_clientes]
WITH ENCRYPTION
AS


DECLARE @altas INT, @bajas INT, @cambios INT

SET @altas = -90
SET @bajas = -90
SET @cambios =-90

SELECT
	suc.AZM suc,
	cb.cliente,
	'' no_mbox,
	cb.farmacia,
	cb.farmacia Razon_Social,
	cb.farmacia Nombre_Corto,
	cb.direccion,
	'' NumExt,
	'' NumInt,
	cb.colonia,
	cb.codigo_postal,
	cb.poblacion,
	'MEX' pais,
	es.descripcion,
	'' telefono,
	CASE 
	WHEN LEFT(cb.segto,1) = 'G' THEN 'Gobierno'
	WHEN LEFT(cb.segto,1) = 'C' THEN 'Cadena'
	WHEN LEFT(cb.segto,1) = 'E' THEN 'Autoservicio'
	ELSE 'Independiente'	END tipo_pv,
	
	CASE 
		WHEN cb.fecha_alta BETWEEN DATEADD(DD, @altas,CONVERT(DATETIME, CURRENT_TIMESTAMP, 121)) 
			AND CONVERT(DATETIME, CURRENT_TIMESTAMP, 121)						THEN 'Alta' 
		WHEN cb.status LIKE '%BAJA%'
			AND (cb.timestamp BETWEEN DATEADD(DD, @bajas,CONVERT(DATETIME, CURRENT_TIMESTAMP, 121)) 
			AND CONVERT(DATETIME, CURRENT_TIMESTAMP, 121) )					THEN 'Baja'
		ELSE 'Camb'																								END ult_dat_mod,
		
	CASE 
		WHEN cb.fecha_alta BETWEEN DATEADD(DD, @altas,CONVERT(DATETIME, CURRENT_TIMESTAMP, 121)) 
			AND CONVERT(DATETIME, CURRENT_TIMESTAMP, 121)						THEN CONVERT(VARCHAR(10), cb.fecha_alta,121) 
		WHEN cb.status LIKE '%BAJA%'
			AND (cb.timestamp BETWEEN DATEADD(DD, @bajas,CONVERT(DATETIME, CURRENT_TIMESTAMP, 121)) 
			AND CONVERT(DATETIME, CURRENT_TIMESTAMP, 121) )					THEN CONVERT(VARCHAR(10), cb.timestamp,121)
		ELSE CONVERT(VARCHAR(10), cb.timestamp,121)								END fec_hor_mod,
		
	CASE 
		WHEN cb.status LIKE '%BAJA%'															THEN 'Baja'
		WHEN cb.status LIKE '%SUSPENDIDO%'												THEN 'Suspendido'
		WHEN cb.status LIKE '%NORMAL%'														THEN 'Activo'
		ELSE 'Otro' END Tipo_Movi,
	'' Canal,
	'' SucFarm,
	'' SubGpo,
	cb.segto,
	cb.rfc
	--,cb.status	
FROM clientes_baan cb
INNER JOIN sucursales suc ON suc.sucursal = cb.sucursal
INNER JOIN estados es			ON CONVERT(INT,cb.cve_estado) = es.cve_estado
WHERE 
(
cb.fecha_alta BETWEEN DATEADD(DD, @altas ,CONVERT(DATETIME, CURRENT_TIMESTAMP, 121)) AND CONVERT(DATETIME, CURRENT_TIMESTAMP, 121)  
OR (cb.status LIKE '%BAJA%' AND
	cb.timestamp BETWEEN DATEADD(DD, @bajas ,CONVERT(DATETIME, CURRENT_TIMESTAMP, 121)) AND CONVERT(DATETIME, CURRENT_TIMESTAMP, 121)  )
	)

ORDER BY
	ult_dat_mod,
	suc.AZM,
	cb.cliente

--	ORDER BY Tipo_Movi






/*
CREATE TABLE #pva_az (
	sucursal		INT					,
	cliente			VARCHAR(5)	,
	estatus			VARCHAR(1)
	)

INSERT INTO #pva_az
	SELECT
		cb.sucursal,
		cb.cliente,
		'A'
	FROM clientes_baan cb
	WHERE
(
cb.fecha_alta BETWEEN DATEADD(DD, @altas ,CONVERT(DATETIME, CURRENT_TIMESTAMP, 121)) AND CONVERT(DATETIME, CURRENT_TIMESTAMP, 121)	
)

INSERT INTO #pva_az
	SELECT
		cb.sucursal,
		cb.cliente,
		'B'
	FROM clientes_baan cb
	WHERE
(
LEFT(cb.status,1) = 'B'
AND (cb.timestamp BETWEEN DATEADD(DD, -120 ,CONVERT(DATETIME, CURRENT_TIMESTAMP, 121)) AND CONVERT(DATETIME, CURRENT_TIMESTAMP, 121)
)
)


SELECT * FROM #pva_az

DROP TABLE #pva_az
	*/
GO
