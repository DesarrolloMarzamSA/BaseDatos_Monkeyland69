CREATE PROCEDURE [dbo].[usp_genera_facturacion_electronica_fregis] @fecha	varchar(10)--	@sucursal int, @segto varchar(2), @ctepadre varchar(3)
as
--PROCEDIMIENTO PARA FACTURACIÓN ELECTRÓNICA FCIAS. REGIS REYNOSA
select
	f.cliente +
	--	LEFT(CONVERT(VARCHAR(8), CONVERT(BIGINT, f.factura)) + REPLICATE(' ',12), 12) +
	LEFT(CONVERT(VARCHAR(8), CONVERT(BIGINT, f.folio_fiscal)) + REPLICATE(' ',12), 12) +
	LEFT('0' + REPLICATE(' ',12), 12) + 
	CONVERT(VARCHAR(10), f.fecha_factura, 112) +
	f.cod_barras +
	RIGHT(REPLICATE(' ', 7) + CONVERT(VARCHAR, f.piezas_surtidas_con_cargo  ), 7) +
	RIGHT(REPLICATE(' ', 7) + CONVERT(VARCHAR, f.piezas_surtidas_sin_cargo  ), 7) +
	RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR, f.precio_farm_sin_imp        ), 9) +
	RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR, f.porcentaje_descto_oferta   ), 6) +
	RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR, f.porcentaje_descto_comercial), 6) +
	RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR, f.iva                        ), 9)
FROM facturacion_electronica_estandar f
WHERE	f.sucursal = 8	--@sucursal 
AND	f.segto = 'C2'	--	@segto 
AND	f.ctepadre in('165','175')	--	@ctepadre 
--AND	f.fecha_factura =	CONVERT(DATETIME, @fecha, 121)	--	convert(datetime, convert(varchar(10), current_timestamp, 121), 121)
AND	f.fecha_tandem >=	CONVERT(DATETIME, @fecha, 121)	--	convert(datetime, convert(varchar(10), current_timestamp, 121), 121)
ORDER BY 	f.folio_fiscal, no_registro	--f.codigo	--	f.factura,,		f.factura

GO

