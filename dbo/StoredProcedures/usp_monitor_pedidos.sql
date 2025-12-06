
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
/*
select cb.ctepadre , sg.descripcion,	--	isnull(sg.descripcion, cb.farmacia) as cadena, 
COUNT(p.codigo) as lineas, SUM(p.cantidad_pedida + p.precio)
--p.* --	delete 
from pedidos_servidor_ftp p
with (nolock)
left outer join clientes_baan cb on cb.sucursal = p.sucursal and cb.cliente = p.cuenta
left outer join segmentos sg on sg.ctepadre = cb.ctepadre
--where cantidad_surtida is null
--codigo is null
--p.arch_tandem is null
group by cb.ctepadre, sg.descripcion
order by cb.ctepadre, sg.descripcion
--order by fecha_pedido
*/

/*
select sg.ctepadre, ISNULL(cb.farmacia, sg.ctepadre) from segmentos sg 
with (nolock)
left outer join clientes_baan cb with (nolock) on cb.ctepadre = sg.ctepadre
inner join pedidos_servidor_ftp p on p.sucursal = cb.sucursal and p.cuenta = cb.cliente
*/

CREATE	--	CREATE	--	DROP
PROCEDURE [dbo].[usp_monitor_pedidos]	
--@inicio VARCHAR, @fin VARCHAR(
WITH ENCRYPTION
AS


IF(SELECT COUNT(*) FROM sys.sysobjects WHERE name = 'monitor_pedidos')=0
BEGIN
	CREATE --	DROP	--	TRUNCATE
	TABLE monitor_pedidos	(
		fecha_hora							SMALLDATETIME	,
		nombre									VARCHAR(50)		,
		ctepadre								VARCHAR( 3)		,
		cliente_ibs							VARCHAR( 6)		,
		lineas									INT						,
		pzas_solicitado					INT						,
		importe_solicitado			MONEY					,
		pzas_surtidas						INT						,
		importe_surtidas				MONEY				
		PRIMARY KEY	(fecha_hora, nombre, ctepadre,	cliente_ibs)
	)
END

--TRUNCATE TABLE monitor_pedidos
CREATE --	DROP	--	TRUNCATE
TABLE #monitor_pedidos	(
	fecha_hora							SMALLDATETIME	,
	nombre									VARCHAR(50)		,
	ctepadre								VARCHAR( 3)		,
	cliente_ibs							VARCHAR( 6)		,
	lineas									INT						,
	pzas_solicitado					INT						,
	importe_solicitado			MONEY					,
	pzas_surtidas						INT						,
	importe_surtidas				MONEY				
	PRIMARY KEY	(fecha_hora, nombre, ctepadre,	cliente_ibs)
)


INSERT INTO #monitor_pedidos
SELECT 
	CONVERT(VARCHAR(16), p.fecha_pedido, 121) fecha,
	--p.fecha_pedido,
	p.nombre, 
	cb.ctepadre,
	cb.cliente_ibs,
	COUNT(p.codigo												) as lineas							, 
	SUM(p.cantidad_pedida									) as pzas_solicitadas		,
	SUM(p.cantidad_pedida * mp.prec_farm	) as importe_solicitado	,
	SUM(p.cantidad_surtida								) as pzas_surtidas				,
	SUM(p.cantidad_pedida * p.precio			) as importe_facturado		
FROM pedidos_servidor_ftp p
WITH (NOLOCK)
INNER JOIN clientes_baan cb on cb.sucursal = p.sucursal and cb.cliente = p.cuenta
INNER JOIN maestro_productos_baan mp on mp.codigo = p.codigo
WHERE 
--p.nombre like '%SUFACE%' AND
--p.fecha_pedido >= DATEADD( MI, -1500, GETDATE() )
	p.fecha_pedido >= DATEADD( HH, -6 , GETDATE() )
GROUP BY 
	CONVERT(VARCHAR(16), p.fecha_pedido, 121), 
	p.nombre, 
	cb.ctepadre,
	cb.cliente_ibs
ORDER BY 
	CONVERT(VARCHAR(16), p.fecha_pedido, 121), 
	p.nombre, 
	cb.ctepadre,
	cb.cliente_ibs

--SELECT CONVERT(DATETIME, CONVERT(VARCHAR(10), GETDATE() , 121) + ' 12:00:00.000' ,121)

INSERT INTO monitor_pedidos
SELECT 
		mt.fecha_hora							,
		mt.nombre									,
		mt.ctepadre								,
		mt.cliente_ibs							,
		mt.lineas									,
		mt.pzas_solicitado					,
		mt.importe_solicitado			,
		mt.pzas_surtidas						,
		mt.importe_surtidas				
FROM #monitor_pedidos mt
LEFT OUTER JOIN monitor_pedidos mp ON 
	mp.fecha_hora = mt.fecha_hora AND
	mp.nombre = mt.nombre AND
	mp.ctepadre = mt.ctepadre AND
	mp.cliente_ibs = mt.cliente_ibs	
WHERE mp.fecha_hora IS NULL
ORDER BY mp.fecha_hora

DROP TABLE #monitor_pedidos

/*
SELECT 
		mp.fecha_hora							,
		mp.nombre									,
		mp.ctepadre								,
		mp.cliente_ibs							,
		RIGHT(REPLICATE(' ', 10) + CONVERT(VARCHAR,mp.lineas								,1) , 10)	as lineas							,
		RIGHT(REPLICATE(' ', 10) + CONVERT(VARCHAR,mp.pzas_solicitado				,1) , 10)	as pzas_solicitadas		,
		RIGHT(REPLICATE(' ', 10) + CONVERT(VARCHAR,mp.importe_solicitado		,1) , 10)	as importe_solicitado	,
		RIGHT(REPLICATE(' ', 10) + CONVERT(VARCHAR,mp.pzas_surtidas					,1) , 10)	as pzas_surtidas			,
		RIGHT(REPLICATE(' ', 10) + CONVERT(VARCHAR,mp.importe_surtidas			,1) , 10)	as importe_facturado	,
		pt.ibs_orno, 
		ISNULL(dd.descripcion, pt.motivo_no_surtido)  AS  motivo_no_surtido
		--motivo_no_surtido
FROM monitor_pedidos mp
INNER JOIN sucursales s ON s.ibs_letra = LEFT(mp.cliente_ibs, 1)
INNER JOIN Capa_ibs.dbo.pedidos_traductor pt ON 
	pt.sucursal = s.sucursal AND pt.cliente = SUBSTRING(mp.cliente_ibs, 2,5)
INNER JOIN dest_det_descripciones dd ON dd.dest_det = pt.motivo_no_surtido
--WHERE 
	--mp.nombre like '%CASA%' --AND
	--mp.cliente_ibs = 'P43280'
ORDER BY 
		fecha_hora							DESC,
		nombre									,
		ctepadre								,
		cliente_ibs							

*/
GO
