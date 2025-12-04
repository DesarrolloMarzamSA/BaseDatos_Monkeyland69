CREATE view [dbo].[encabezado_cm]
as
select 
	CONVERT(DATE,e.fechaprog) AS fechaprog,
	e.sucursal,
	e.factura,
	e.cliente,
	CASE 
		WHEN e.fechaprog < s.fecha_fusion THEN s.serie_cfd_old 
		ELSE s.serie_cfd END serie_cfd,
	e.folio_fiscal,
	e.farmacia,
	CONVERT(DATE,e.fecha_tandem) AS fecha_tandem,
	c.cliente_ibs,
	r.numTienda,
	e.orden,
	e.segto,
	e.ctepadre,
	e.timestamp,
	c.rfc				,
	s.IATA
from
Historica.dbo.encabezado e with(nolock) 
inner join sucursales s with(nolock) ON s.sucursal = e.sucursal
inner join clientes_baan c with(nolock) ON 
	c.sucursal = e.sucursal AND c.cliente = e.cliente
left outer join CatTiendasSoriana r ON 
	r.sucursal = e.sucursal AND r.cliente = e.cliente
where
	e.fechaprog >= CONVERT(SMALLDATETIME,'2012-01-01',121) AND
	e.segto = 'E1' AND
	e.ctepadre = '009'
	AND e.cliente <> '99099' 
	--AND	e.farmacia NOT LIKE '%ISSSTE%'

GO

