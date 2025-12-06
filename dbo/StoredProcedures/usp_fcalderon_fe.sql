
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



CREATE	--	CREATE
PROCEDURE [dbo].[usp_fcalderon_fe] @fecha VARCHAR(10)	WITH ENCRYPTION
AS

/*
EXECUTE usp_fcalderon_fe '2011-03-30'
*/


--DECLARE @fecha VARCHAR(10)
--SET @fecha =	CONVERT(VARCHAR(10),GETDATE(),121)			--'2010-05-29'

SELECT 
	f.cod_barras,
	f.descripcion,
	f.fecha_factura		,
	s.serie_cfd,
	f.folio_fiscal,
	f.codigo,
	f.cod_barras,
	f.piezas_surtidas_con_cargo,
	f.precio_farm_sin_imp,
	f.importe_bruto,
	f.importe_neto,
	f.descto_comercial,
	f.iva,
	f.ieps,
	f.descripcion
FROM facturacion_electronica_estandar f
INNER JOIN sucursales s				ON	s.sucursal = f.sucursal
WHERE f.sucursal = 8
AND CONVERT(DATETIME,@fecha,121) = f.fecha_factura
AND segto = 'C2' AND ctepadre = '334'
--	AND rfc = 'FCA830210S82'
GO
