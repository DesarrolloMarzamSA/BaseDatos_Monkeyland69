
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE --	CREATE
PROCEDURE [dbo].[usp_chedraui_pedidos_lineas]
@sucursal INT, @cliente VARCHAR(5), @pedido VARCHAR(16)

AS



SELECT sucursal, letra, cliente, arch_cliente, pedido, codigo, SUM(cantidad_pedida) cantidad 
FROM pedidos_chedraui_v3  ped 
WHERE ped.sucursal = @sucursal
AND ped.pedido =  @pedido
AND ped.cliente =  @cliente
GROUP BY sucursal, letra, cliente, arch_cliente, pedido, codigo 
ORDER BY sucursal, letra, cliente, arch_cliente, pedido, codigo 
GO
