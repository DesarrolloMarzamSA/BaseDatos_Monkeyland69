CREATE	--	create	--	drop
procedure usp_fes_concentrado
as

--select * from segmentos with (nolock)
--order by orden



select vip.ctepadre, n_corto cliente_vip, COUNT(e.factura) facturas, COUNT(f.factura) lineas 
from segmentos vip with (nolock)
inner join encabezado e on e.fecha_tandem = '2012-09-29' and 
	e.segto = vip.segto AND e.ctepadre = vip.ctepadre
inner join facturacion_electronica_estandar f on f.fecha_tandem = '2012-09-29' and 
	f.segto = vip.segto AND f.ctepadre = vip.ctepadre
where vip.monitorear = 1 
group by vip.ctepadre, n_corto
order by vip.ctepadre, n_corto

GO

