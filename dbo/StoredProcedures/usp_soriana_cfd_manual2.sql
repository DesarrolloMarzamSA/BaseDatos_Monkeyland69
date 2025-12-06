
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE
--CREATE
PROCEDURE [dbo].[usp_soriana_cfd_manual2]
--	[usp_soriana_cfd_manual] '2013-01-25','2013-01-25','FM','' 
--@fecha VARCHAR(10),@fechaFin VARCHAR(10),@serie varchar(2)='',@mensaje varchar(100)='' 

AS

SELECT distinct
e.sucursal,
	e.fechaprog	fecha,
	CASE 
		WHEN e.fechaprog < s.fecha_ibs THEN s.serie_cfd_old
		when s.serie_cfd='FD' THEN 'FU' ELSE s.serie_cfd end	as 	serie_cfd	, 
	e.folio_fiscal	folio_fiscal	, 
	s.IATA					,
	n.documento_soriana remision   	, 
	e.cliente				, 
	e.rfc					,
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

FROM  [monkeyland].[dbo].[encabezado_soriana2] e WITH (nolock)
INNER JOIN sucursales s	WITH (nolock)	ON	s.sucursal = e.sucursal 
LEFT OUTER JOIN CatTiendasSoriana t	WITH (nolock)	ON	t.sucursal = e.Sucursal
aND t.cliente = e.cliente 
LEFT OUTER JOIN cfd_soriana_acuses_de_recibo n	WITH (nolock)	
ON	n.serie_cfd = s.serie_cfd	AND	n.folio_fiscal = 	e.folio_fiscal
LEFT OUTER JOIN bitacora_soriana_cfd b	WITH (nolock) ON b.sucursal = e.sucursal
AND b.remision  = e.factura
where e.factura='02449704'
--ORDER BY e.sucursal, folio_fiscal
	
GO
