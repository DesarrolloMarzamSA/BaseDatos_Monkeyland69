--	MIGUEL SAMAYOA
--	2010-05-10	CREACION

/*
EXECUTE usp_soriana_cfd  1,'2010-09-01'

La finalidad de este usp es encontrar el folio fiscal para poder 
buscar el archivo con nombre con el formato 'FACTURAnnnnnnnnaa*.XML'
en las carpetas de los servidores CFD definidos en la tabla cfd_servers

Donde 
	nnnnnnnn = foliofiscal (sin ceros)
	aa	=	serie_cfd
*/

CREATE
--CREATE
PROCEDURE [dbo].[usp_soriana_cfd] 
--	DECLARE 
--@suc INT, 
@fecha VARCHAR(10)
/*
EXECUTE usp_soriana_cfd  1, '2011-01-03'
EXECUTE usp_soriana_cfd  '2012-04-17'

SET @suc = 7
SET @fecha = '2010-07-14'
*/
AS


SELECT distinct
	e.fechaprog																						fecha,
																												e.sucursal								,
	CASE 
		WHEN e.fechaprog < s.fecha_ibs THEN s.serie_cfd_old
		when s.serie_cfd='FD' THEN 'FU' ELSE s.serie_cfd end	as 	serie_cfd	, 
	--CONVERT(VARCHAR, CONVERT(INT,e.folio_fiscal))										folio_fiscal							, 
	e.folio_fiscal																				folio_fiscal	, 
																												s.IATA										,
																												e.factura remision				, 
																												e.cliente									, 
																												e.rfc											,
																												e.farmacia								,
	CASE 
		WHEN ISNUMERIC(LTRIM(RTRIM(e.orden))) = 1	THEN CONVERT(INT,e.orden)
		ELSE 0
	END																										orden											, 
	CONVERT(VARCHAR, CONVERT(INT,t.numTienda))						numTienda									, 
	0																											porc_iva									,
	0																											porc_ieps									,
	0																											piezas										,
	ISNULL(b.importe,0)																		importe_bruto			,
	0																											iva								,
	0																											ieps							,
	0																											importe_neto			,
	n.folio_acuse																																			,
	b.confirmada,
	b.archivo
--FROM encabezado e
FROM encabezado_soriana e		WITH (nolock)
INNER JOIN sucursales s													WITH (nolock)	ON	s.sucursal = e.sucursal 
LEFT OUTER JOIN CatTiendasSoriana t							WITH (nolock)	ON	t.sucursal = e.Sucursal		AND t.cliente = e.cliente 
LEFT OUTER JOIN cfd_soriana_acuses_de_recibo n	WITH (nolock)	ON	n.serie_cfd = s.serie_cfd	AND	
	n.folio_fiscal = 	e.folio_fiscal
	--n.folio_fiscal = CONVERT(INT,e.folio_fiscal)
	--right( replicate('0',8) + convert(varchar,n.folio_fiscal), 8) = 	e.folio_fiscal
LEFT OUTER JOIN bitacora_soriana_cfd b					WITH (nolock)	ON	b.sucursal = e.sucursal		AND b.remision  = e.factura
WHERE 
	--e.sucursal = @suc																							AND 
	e.fechaprog = CONVERT(DATETIME,@fecha,121)										--AND
	--e.segto = 'E1' AND e.ctepadre in  ('044','032') --	= '044'	
	--AND e.sucursal IN (18, 19)
	--AND (e.folio_fiscal != 'N/A'	OR	e.folio_fiscal IS NOT NULL )
	--AND n.folio_acuse IS NOT NULL

ORDER BY e.sucursal, folio_fiscal

GO

