
/*
EXECUTE usp_woolworth_cfd  7, '2010-10-12'
*/

--	MIGUEL SAMAYOA
--	2010-10-12	CREACION

/*
EXECUTE usp_woolworth_cfd  1,'2010-09-01'

La finalidad de este usp es encontrar el folio fiscal para poder 
buscar el archivo con nombre con el formato 'FACTURAnnnnnnnnaa*.XML'
en las carpetas de los servidores CFD definidos en la tabla cfd_servers

Donde 
	nnnnnnnn = foliofiscal (sin ceros)
	aa	=	serie_cfd
*/

CREATE
--CREATE
PROCEDURE [dbo].[usp_woolworth_cfd] 
--	DECLARE 
@suc INT, @fecha VARCHAR(10)
/*
EXECUTE usp_woolworth_cfd  7, '2010-11-13'

SET @suc = 7
SET @fecha = '2010-07-14'
*/

AS

SELECT--	 TOP 20
	CONVERT(VARCHAR, CONVERT(VARCHAR(10),e.fechaprog,121))					factura						,
																																	e.sucursal				,
																																	s.serie_cfd				, 
	CONVERT(VARCHAR, CONVERT(INT,e.folio_fiscal))										folio_fiscal			, 
																																	s.IATA						,
	e.factura																												remision, 
																																	e.cliente					, 
	t.nombre																												farmacia					,
	CASE 
		WHEN ISNUMERIC(LTRIM(RTRIM(e.orden))) = 1	THEN CONVERT(BIGINT,e.orden)
--		ELSE NULL
	END																															orden							, 
	CONVERT(VARCHAR, t.numTienda			)															numTienda					,		--	CONVERT(INT,)
	ISNULL(MAX(f.porcentaje_iva				),				0)									porc_iva					,
	ISNULL(MAX(f.porcentaje_ieps			),				0)									porc_ieps					,
	ISNULL(SUM(f.piezas_surtidas_con_cargo + f.piezas_surtidas_sin_cargo				),				0)			piezas			,
	ISNULL(SUM(f.importe_bruto				),				0)									importe_bruto			,
	ISNULL(SUM(f.iva									),				0)									iva								,
	ISNULL(SUM(f.ieps									),				0)									ieps							,
	ISNULL(SUM(f.importe_neto					),				0)									importe_neto			--,
	--n.folio_acuse
FROM encabezado e with(nolock) 
LEFT OUTER JOIN facturacion_electronica_estandar f with(nolock) ON f.sucursal = e.sucursal 
	AND e.factura = f.factura
INNER JOIN sucursales s		with(nolock) 											ON	e.sucursal = s.sucursal 
INNER JOIN cat_tiendas_woolworth t		with(nolock) 					ON	e.sucursal = t.Sucursal		AND e.cliente = t.cliente 
--LEFT OUTER JOIN cfd_woolworth_acuses_de_recibo n	ON	n.serie_cfd = s.serie_cfd	AND	n.folio_fiscal = CONVERT(INT,e.folio_fiscal)
WHERE 
	e.sucursal = @suc																						AND 
	e.fechaprog = CONVERT(DATETIME,@fecha,121) 									AND 
	e.segto = 'C1'														 									AND 
	e.ctepadre = '011'																					AND	
	(e.folio_fiscal != 'N/A'	OR	e.folio_fiscal IS NOT NULL )
	--AND n.folio_acuse IS NOT NULL

GROUP BY 	e.fechaprog,	e.sucursal,	s.serie_cfd, 	e.folio_fiscal, 	s.IATA,	e.factura, 	e.cliente, 	t.nombre,	t.numTienda, 	e.orden--, n.folio_acuse
ORDER BY 	e.fechaprog,	e.sucursal,	s.serie_cfd, 	e.folio_fiscal, 	s.IATA,	e.factura, 	e.cliente, 	t.nombre,	t.numTienda, 	e.orden--, n.folio_acuse

GO

