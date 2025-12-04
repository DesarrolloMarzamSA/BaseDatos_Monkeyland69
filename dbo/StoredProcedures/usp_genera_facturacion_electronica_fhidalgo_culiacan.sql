USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE 
--  CREATE 
PROCEDURE [dbo].[usp_genera_facturacion_electronica_fhidalgo_culiacan] @fecha	varchar(10)
WITH ENCRYPTION
as

--PROCEDIMIENTO PARA FACTURACIÓN ELECTRÓNICA FCIAS. HIDALGO CULIACAN

--	fecha:	18 SEP 2009
--	PROGR:	MIGUEL SAMAYOA

--declare @fecha	varchar(10)
--set @fecha = '2009-07-10'

select
	f.cliente,
	REPLICATE('0',1) filler1,
	f.porcentaje_descto_comercial,
	REPLICATE('0',1) filler2,
	f.porcentaje_descto_oferta,
	f.cod_barras,
	f.fecha_factura,
	REPLICATE('0',2) filler3,
	f.iva,
	f.folio_fiscal,
	REPLICATE('0',1) filler4,
	f.piezas_surtidas_con_cargo,
	f.precio_farm_sin_imp,
	REPLICATE('0',1) filler5,
	f.precio_pub_sin_imp,
	REPLICATE('0',1) filler6,
	f.piezas_surtidas_sin_cargo,
	f.sucursal,
	f.factura
INTO #fe_fhidalgo
FROM facturacion_electronica_estandar f
WHERE	f.sucursal in (17,50)	--@sucursal 
AND	f.segto = 'D1'	--	@segto			'D1'
AND	f.ctepadre = '813'	--	@ctepadre			'813'
AND	f.fecha_factura =	CONVERT(DATETIME, @fecha, 121)	--	convert(datetime, convert(varchar(10), current_timestamp, 121), 121)
ORDER BY 	f.folio_fiscal, no_registro	--f.codigo	--	f.factura,,		f.factura

SELECT --	* 
	LEFT(f.cliente + REPLICATE(' ',12),12) +
	f.filler1 +
	RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR, f.porcentaje_descto_comercial), 6) +
	f.filler2 + 
	f.cod_barras + 
	CONVERT(VARCHAR(8), f.fecha_factura, 112) +
	f.filler3 + 
	RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR, f.iva								        ), 9) +
	f.filler4 + 
	RIGHT(REPLICATE(' ',12) + CONVERT(VARCHAR, f.folio_fiscal								),12) +
	f.filler5 + 
	RIGHT(REPLICATE(' ', 7) + CONVERT(VARCHAR, f.piezas_surtidas_con_cargo	), 7) +
	RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR, f.precio_farm_sin_imp        ), 9) +
	f.filler6 + 
	RIGHT(REPLICATE(' ', 7) + CONVERT(VARCHAR, f.piezas_surtidas_sin_cargo	), 7)
FROM #fe_fhidalgo f	-- WHERE

DROP TABLE #fe_fhidalgo
GO
