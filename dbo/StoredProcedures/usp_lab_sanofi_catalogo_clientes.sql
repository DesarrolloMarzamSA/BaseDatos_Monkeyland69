
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
/*	
usp_lab_sanofi_catalogo_clientes 18, '2011-02-11'
*/

--	HECHO POR MIGUEL SAMAYOA
--	
--	2010-02-04	FECHA DE CREACION
--	

CREATE 
--	CREATE
PROCEDURE [dbo].[usp_lab_sanofi_catalogo_clientes] 
--	DECLARE
@almacen INT, @fecha VARCHAR(10)
WITH ENCRYPTION
AS

DECLARE @sep VARCHAR(1)
SET @sep ='|'

CREATE TABLE #cat_ctes_sanofi		(
Sucursal													INT												,
Nombre_Cliente										VARCHAR(100)							,
Codigo_Cliente										VARCHAR(100)							,
Tipo_Cliente											VARCHAR(100)							,
SoldTo_Address1										VARCHAR(100)							,
SoldTo_Address2										VARCHAR(100)							,
SoldTo_Address3										VARCHAR(100)							,
SoldTo_City												VARCHAR(100)							,
SoldTo_State											VARCHAR(100)							,
SoldTo_Postal_Code								VARCHAR(100)							,
SoldTo_Country										VARCHAR(100)							,

BillTo_Address1										VARCHAR(100)							,
BillTo_Address2										VARCHAR(100)							,
BillTo_Address3										VARCHAR(100)							,
BillTo_City												VARCHAR(100)							,
BillTo_State											VARCHAR(100)							,
BillTo_Postal_Code								VARCHAR(100)							,
BillTo_Country										VARCHAR(100)							,

ShipTo_Address1										VARCHAR(100)							,
ShipTo_Address2										VARCHAR(100)							,
ShipTo_Address3										VARCHAR(100)							,
ShipTo_City												VARCHAR(100)							,
ShipTo_State											VARCHAR(100)							,
ShipTo_Postal_Code								VARCHAR(100)							,
ShipTo_Country										VARCHAR(100)							,
CUFA															VARCHAR(100)							,
rfc																VARCHAR(100)
PRIMARY KEY (sucursal, Codigo_Cliente)
)

INSERT INTO #cat_ctes_sanofi
SELECT
	cb.sucursal																															Sucursal					,
	RTRIM(cb.farmacia)																											Nombre_Cliente		,
	RIGHT(REPLICATE('0', 2)+ CONVERT(VARCHAR,cb.sucursal), 2) +	cb.cliente	Codigo_Cliente		,
	CASE	WHEN LEFT(cb.segto,1) = 'C'	THEN 'Chain POS'
				WHEN LEFT(cb.segto,1) = 'E'	THEN 'Supermarket'
				ELSE 'Point of sale'				END																		Tipo_Cliente			,
	RTRIM(cb.direccion)																											SoldTo_Address1		,
	RTRIM(cb.colonia)																												SoldTo_Address2		,
	RTRIM(cb.poblacion)																											SoldTo_Address3		,
	RTRIM(cb.poblacion)																											SoldTo_City				,
	RTRIM(LTRIM(es.sanofi))																									SoldTo_State			,
	RTRIM(LTRIM(cb.codigo_postal))																					SoldTo_Postal_Code,
	'MX'																																		SoldTo_Country		,
	
	CONVERT(VARCHAR,'')																											BillTo_Address1		,
	CONVERT(VARCHAR,'')																											BillTo_Address2		,
	CONVERT(VARCHAR,'')																											BillTo_Address3		,
	CONVERT(VARCHAR,'')																											BillTo_City				,
	CONVERT(VARCHAR,'')																											BillTo_State			,
	CONVERT(VARCHAR,'')																											BillTo_Postal_Code,
	CONVERT(VARCHAR,'')																											BillTo_Country		,
	
	CONVERT(VARCHAR,'')																											ShipTo_Address1		,
	CONVERT(VARCHAR,'')																											ShipTo_Address2		,
	CONVERT(VARCHAR,'')																											ShipTo_Address3		,
	CONVERT(VARCHAR,'')																											ShipTo_City				,
	CONVERT(VARCHAR,'')																											ShipTo_State			,
	CONVERT(VARCHAR,'')																											ShipTo_Postal_Code,
	CONVERT(VARCHAR,'')																											ShipTo_Country		,
	ISNULL(sc.cufa,'')																											CUFA							,
	RTRIM(LTRIM(cb.rfc))																										rfc
FROM clientes_baan cb			WITH(NOLOCK)
INNER JOIN estados es 		WITH(NOLOCK)	ON CONVERT(INT,cb.cve_estado) = es.cve_estado
INNER JOIN sucursales s 	WITH(NOLOCK)	ON s.almacen = @almacen AND s.sucursal = cb.sucursal
LEFT OUTER JOIN clientes_cufa sc ON sc.sucursal = cb.sucursal AND sc.cliente = cb.cliente
WHERE 
--	cb.sucursal = @almacen	AND 
	cb.status NOT like '%BAJA%' --OR 
	--cb.tipo = 'NOR' OR
	--(cb.status like '%BAJA%'	AND cb.timestamp >= DATEADD(DD,  -60, GETDATE() ) )

ORDER BY cb.sucursal, cb.cliente

/*
UPDATE #cat_ctes_sanofi SET 
	sucursal = suc.almacen
FROM #cat_ctes_sanofi cb
INNER JOIN sucursales suc ON CONVERT(INT,cb.sucursal) = suc.sucursal
*/

SELECT	--	*
--	ccs.sucursal							,	--	NO SE MANDA, SOLO ES PARA REVISAR LA CONSOLIDACION DE SUCURSALES
	ccs.Nombre_Cliente				,	
	ccs.Codigo_Cliente				,	
	ccs.Tipo_Cliente					,	
	ccs.SoldTo_Address1		 	 	,	
	ccs.SoldTo_Address2		 	 	,	
	ccs.SoldTo_Address3		 	 	,	
	ccs.SoldTo_City						,	
	ccs.SoldTo_State					,	
	ccs.SoldTo_Postal_Code		,	
	ccs.SoldTo_Country				,	
	ccs.BillTo_Address1		  	,	
	ccs.BillTo_Address2		  	,	
	ccs.BillTo_Address3		  	,	
	ccs.BillTo_City				  	,	
	ccs.BillTo_State					,	
	ccs.BillTo_Postal_Code		,	
	ccs.BillTo_Country				,	
	ccs.ShipTo_Address1		  	,	
	ccs.ShipTo_Address2		  	,	
	ccs.ShipTo_Address3		  	,	
	ccs.ShipTo_City				  	,	
	ccs.ShipTo_State					,	
	ccs.ShipTo_Postal_Code		,	
	ccs.ShipTo_Country				,	
	ccs.CUFA									,	
	ccs.rfc                	
FROM #cat_ctes_sanofi ccs		WITH(NOLOCK)

DROP TABLE #cat_ctes_sanofi
GO
