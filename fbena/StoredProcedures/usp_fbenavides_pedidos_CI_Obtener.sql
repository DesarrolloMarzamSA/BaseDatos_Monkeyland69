
-- =============================================
-- Author:		<Author,,Francisco Roberto Martínez Hernández>
-- Create date: <Create Date,22-03-2023,>
-- Description:	<Description,Se obtiene los pedidos faltantes de transmitir agrupados por Sucursal,Cliente,Pedido>
-- =============================================
create PROCEDURE [fbena].[usp_fbenavides_pedidos_CI_Obtener]

AS
BEGIN
    
	
     --DELETE FROM pedidos_fbenavides_ci WHERE cliente = REPLICATE('0',5) OR codigo = REPLICATE('0',7) 
     
     
     SELECT ped.sucursal, ped.letra, ped.cliente, ped.pedido,ped.arch_cliente 
     FROM pedidos_fbenavides_ci  ped 
     --where ped.archivo_hh is null   
     GROUP BY ped.sucursal, ped.letra, ped.pedido, ped.cliente,ped.arch_cliente 
     ORDER BY ped.sucursal, ped.letra, ped.pedido, ped.cliente,ped.arch_cliente 

END

GO

