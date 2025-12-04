USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE	--	CREATE	--	DROP
PROCEDURE [dbo].[usp_fardemex_pedidos_lineas]

@sucursal INT,
@cliente	VARCHAR(5),
@pedido		VARCHAR(10)

WITH ENCRYPTION
AS

SELECT sucursal, letra, cliente, arch_cliente, pedido, codigo, SUM(cantidad_pedida) cantidad 
FROM pedidos_fardemex  ped 
WHERE ped.sucursal = @sucursal 
	AND ped.pedido = @pedido 
	AND ped.cliente = @cliente 
GROUP BY sucursal, letra, cliente, arch_cliente, pedido, codigo 
ORDER BY sucursal, letra, cliente, arch_cliente, pedido, codigo 
GO
