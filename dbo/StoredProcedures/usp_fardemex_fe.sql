


CREATE	--	CREATE	--	DROP
PROCEDURE [dbo].[usp_fardemex_fe]
	@fecha VARCHAR(10)

AS

/*
EXECUTE usp_fardemex_fe '2015-02-27'
*/


SELECT 
	LEFT (CASE WHEN FE.sucursal=4 THEN 'FU' else s.serie_cfd end  + CONVERT(VARCHAR,CONVERT(INT,fe.factura)) + REPLICATE(' ', 12), 12)		AS factura	, 
	RIGHT(REPLICATE(' ', 12)  + fe.cliente, 12)		AS cliente	,
	CONVERT(CHAR(8), fe.fecha_factura, 112)				AS fecha		,
	fe.cod_barras	,
	RIGHT(REPLICATE(' ',  7)  + CONVERT(VARCHAR, fe.piezas_surtidas_con_cargo)	,  7)	as pzas_cc	,
	RIGHT(REPLICATE(' ',  7)  + CONVERT(VARCHAR, fe.piezas_surtidas_sin_cargo)	,  7)	as pzas_sc	,
	RIGHT(REPLICATE(' ',  9)  + CONVERT(VARCHAR, fe.precio_farm_sin_imp)				,  9)	as pfarm		,
	RIGHT(REPLICATE(' ',  7)  + CONVERT(VARCHAR, fe.porcentaje_descto_oferta)		,  6)	as desc_ofe	,
	--RIGHT(REPLICATE(' ',  9)  + CONVERT(VARCHAR, fe.descto_comercial)						,  6)	as desc_fin	,
	RIGHT(REPLICATE(' ',  9)  + CONVERT(VARCHAR, fe.porcentaje_descto_comercial)						,  6)	as desc_fin	,
	RIGHT(REPLICATE(' ',  9)  + CONVERT(VARCHAR, fe.porcentaje_iva)							,  9)	as tasa_iva	
FROM facturacion_electronica_estandar fe
INNER JOIN sucursales s ON s.sucursal = fe.sucursal 
WHERE 
	fe.fecha_factura >= CONVERT(DATETIME, @fecha, 121)-1
	AND fe.ctepadre = '052'	
ORDER BY fe.sucursal, fe.folio_fiscal
--select * from facturacion_electronica_estandar where factura='03929650'

GO

