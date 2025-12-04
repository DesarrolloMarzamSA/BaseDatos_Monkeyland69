CREATE	--	CREATE	--
VIEW pedidos_traducidos 
AS



SELECT TOP 30
fecha_pedido	,
suc					,
lineas		
FROM capa_ibs.dbo.pedidos_traducidos


ORDER BY fecha_pedido DESC

GO

