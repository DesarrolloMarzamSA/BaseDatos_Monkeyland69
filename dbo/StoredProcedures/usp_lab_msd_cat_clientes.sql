
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE	--	CREATE	--	drop
PROCEDURE [dbo].[usp_lab_msd_cat_clientes]
	@fecha VARCHAR(10)
WITH ENCRYPTION
AS

/*
EXECUTE usp_lab_msd_cat_clientes '2011-02-28'
*/

DECLARE @ejecucion VARCHAR(23)
SET @ejecucion = CONVERT(VARCHAR(23),GETDATE(),121)


CREATE TABLE #pva_az (
	sucursal		INT					,
	cliente			VARCHAR(5)	,
	estatus			VARCHAR(1)
	)

DECLARE @altas INT, @bajas INT, @cambios INT			,	@sucursal INT

--SET @altas = -90
--SET @bajas = -90
--SET @cambios = -90


--INSERT INTO #pva_az
--	SELECT
--		cb.sucursal,
--		cb.cliente,
--		'A'
--	FROM clientes_baan cb
--	WHERE
--(
--cb.fecha_alta BETWEEN DATEADD(DD, @altas ,CONVERT(DATETIME, CURRENT_TIMESTAMP, 121)) AND CONVERT(DATETIME, CURRENT_TIMESTAMP, 121)	
--)

--INSERT INTO #pva_az
--	SELECT
--		cb.sucursal,
--		cb.cliente,
--		'B'
--	FROM clientes_baan cb
--	WHERE
--(
--LEFT(cb.status,1) = 'B'
--AND (cb.timestamp BETWEEN DATEADD(DD, -120 ,CONVERT(DATETIME, CURRENT_TIMESTAMP, 121)) AND CONVERT(DATETIME, CURRENT_TIMESTAMP, 121)
--)
--)


----SELECT * FROM #pva_az

--DROP TABLE #pva_az



DECLARE cursor_sucursales CURSOR forward_only FOR 
	SELECT sucursal FROM SUCURSALES WHERE fisica = 1

--IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES 
--    WHERE TABLE_TYPE='BASE TABLE' AND TABLE_NAME='lab_msd_control_facturas') 
--	DROP TABLE lab_msd_control_facturas


CREATE TABLE #tmp_pva	(
suc									VARCHAR( 2),			--		 1
cliente							VARCHAR( 6),			--		 2
--no_mbox							VARCHAR(10),			--		 3
farmacia						VARCHAR(50),			--		 4
--razon_social				VARCHAR(50),			--		 5
--nombre_corto				VARCHAR(50),			--		 6
direccion						VARCHAR(50),			--		 7
NumExt							VARCHAR(50),			--		 8
NumInt							VARCHAR(50),			--		 9
colonia							VARCHAR(50),			--		10
codigo_postal				VARCHAR(50),			--		11
poblacion						VARCHAR(50),			--		12
pais								VARCHAR(50),			--		13
descripcion					VARCHAR(50),			--		14
telefono						VARCHAR(50),			--		15
tipo_pv							VARCHAR(50),			--		16
ult_dat_mod					VARCHAR(50),			--		17
fecha_alta					VARCHAR(50),			--		18
timestamp						VARCHAR(50),			--		19
fec_hor_mod					VARCHAR(50),			--		20
Tipo_Movi						VARCHAR(50),			--		21
Canal								VARCHAR(50),			--		22
SucFarm							VARCHAR(50),			--		23
SubGpo							VARCHAR(50),			--		24
segto								VARCHAR(50),			--		25
rfc									VARCHAR(50),			--		26
status							VARCHAR(50)				--		27
)

OPEN cursor_sucursales
FETCH FROM cursor_sucursales INTO @sucursal

WHILE @@fetch_status = 0
BEGIN
	PRINT @sucursal

	INSERT INTO #tmp_pva
	SELECT	--		TOP 25 
		RIGHT(REPLICATE('0',2) + CONVERT(VARCHAR,suc.sucursal) ,2) suc,		--		 1
		suc.ibs_letra + cb.cliente			,		--		 2
		--'' no_mbox,													--		 3
		cb.farmacia,												--		 4
		--cb.farmacia Razon_Social,						--		 5
		--cb.farmacia Nombre_Corto,						--		 6
		cb.direccion,												--		 7
		'' NumExt,													--		 8
		'' NumInt,													--		 9
		cb.colonia,													--		10
		cb.codigo_postal,										--		11
		cb.poblacion,												--		12
		'MEX' pais,													--		13
		es.descripcion,											--		14
		'' telefono,												--		15
		CASE 
		WHEN LEFT(cb.segto,1) = 'G' THEN 'Gobierno'
		WHEN LEFT(cb.segto,1) = 'C' THEN 'Cadena'
		WHEN LEFT(cb.segto,1) = 'E' THEN 'Autoservicio'
		ELSE 'Independiente'	END tipo_pv,	--		16
		
		CASE 
			WHEN cb.fecha_alta BETWEEN DATEADD(DD, @altas,CONVERT(DATETIME, CURRENT_TIMESTAMP, 121)) 
				AND CONVERT(DATETIME, CURRENT_TIMESTAMP, 121)						THEN 'Alta' 
			WHEN cb.status LIKE '%BAJA%'
				AND (cb.timestamp BETWEEN DATEADD(DD, @bajas,CONVERT(DATETIME, CURRENT_TIMESTAMP, 121)) 
				AND CONVERT(DATETIME, CURRENT_TIMESTAMP, 121) )					THEN 'Baja'
			ELSE 'Camb'																								END ult_dat_mod,		--	17
		
		CASE 
			WHEN cb.fecha_alta BETWEEN DATEADD(DD, @altas,CONVERT(DATETIME, CURRENT_TIMESTAMP, 121)) 
				AND CONVERT(DATETIME, CURRENT_TIMESTAMP, 121)						THEN cb.timestamp 
			WHEN cb.status LIKE '%BAJA%'
				AND (cb.timestamp BETWEEN DATEADD(DD, @bajas,CONVERT(DATETIME, CURRENT_TIMESTAMP, 121)) 
				AND CONVERT(DATETIME, CURRENT_TIMESTAMP, 121) )					THEN cb.fecha_alta
			ELSE cb.timestamp																					END fecha_alta,		--	18

		GETDATE(),																																			--	19

		CASE 
			WHEN cb.fecha_alta BETWEEN DATEADD(DD, @altas,CONVERT(DATETIME, CURRENT_TIMESTAMP, 121)) 
				AND CONVERT(DATETIME, CURRENT_TIMESTAMP, 121)						THEN CONVERT(VARCHAR(10), cb.fecha_alta,121)
			WHEN cb.status LIKE '%BAJA%'
				AND (cb.timestamp BETWEEN DATEADD(DD, @bajas,CONVERT(DATETIME, CURRENT_TIMESTAMP, 121)) 
				AND CONVERT(DATETIME, CURRENT_TIMESTAMP, 121) )					THEN CONVERT(VARCHAR(10), cb.timestamp,121)
			ELSE CONVERT(VARCHAR(10), cb.timestamp,121)								END fec_hor_mod,		--	20

		CASE 
			WHEN cb.status LIKE '%BAJA%'															THEN 'Baja'
			WHEN cb.status LIKE '%SUSPENDIDO%'												THEN 'Suspendido'
			WHEN cb.status LIKE '%NORMAL%'														THEN 'Activo'
			ELSE 'Otro' END Tipo_Movi								,																			--	21
		'' Canal,
		'' SucFarm,
		'' SubGpo,
		cb.segto,
		cb.rfc,
		cb.status	
	FROM clientes_baan cb
	INNER JOIN sucursales suc ON suc.sucursal = cb.sucursal
	INNER JOIN estados es			ON CONVERT(INT,cb.cve_estado) = es.cve_estado
	WHERE 
	cb.sucursal =  @sucursal --AND 
	--(
	--cb.fecha_alta BETWEEN DATEADD(DD, @altas ,CONVERT(DATETIME, CURRENT_TIMESTAMP, 121)) AND CONVERT(DATETIME, CURRENT_TIMESTAMP, 121)  
	--OR (cb.status LIKE '%BAJA%' AND
	--	cb.timestamp BETWEEN DATEADD(DD, @bajas ,CONVERT(DATETIME, CURRENT_TIMESTAMP, 121)) AND CONVERT(DATETIME, CURRENT_TIMESTAMP, 121)  )
	--	)

	ORDER BY
		ult_dat_mod,
		suc.AZM,
		cb.cliente


--	ORDER BY Tipo_Movi

	FETCH NEXT FROM cursor_sucursales INTO @sucursal
END

CLOSE cursor_sucursales
DEALLOCATE cursor_sucursales

DECLARE @total_registros INT
SET @total_registros = (SELECT COUNT(*) FROM #pva_az)

DECLARE @estor VARCHAR(50)
SET @estor = 'usp_lab_msd_cat_clientes '+@fecha
EXECUTE usp_estadisticas_samayoa @estor, @total_registros, @ejecucion


SELECT 
	suc									,
	cliente							,
	--no_mbox							,
	farmacia						,
	--razon_social				,
	--nombre_corto				,
	direccion						,
	--NumExt							,
	--NumInt							,
	colonia							,
	codigo_postal				,
	poblacion						,
	pais								,
	descripcion					,
	telefono						,
	tipo_pv							,
	ult_dat_mod					,
	fecha_alta					,
	timestamp						,
	fec_hor_mod					,
	Tipo_Movi						
	--Canal								,
	--SucFarm							,
	--SubGpo
FROM #tmp_pva
GO
