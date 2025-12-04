
-- =============================================
-- Author:		<Author,,Francisco Roberto Martínez Hernández>
-- Create date: <Create Date,22-03-2023,>
-- Description:	<Description,Se obtiene detalle de los pedidos faltantes de transmitir agrupados por Sucursal,Cliente,Pedido>
-- =============================================
CREATE PROCEDURE [fbena].[usp_fbenavides_pedidos_CI_ObtenerDetalle]
@Sucursal int,
@Pedido varchar(15),
@Cliente varchar(10),
@ArchCliente varchar(75)
AS
BEGIN
    
	SELECT  ped.sucursal, ped.letra, ped.pedido, ped.cliente,ped.arch_cliente, codigo, SUM(cantidad_pedida) AS cantidad_pedida
    FROM pedidos_fbenavides_ci  ped
    WHERE ped.sucursal = @Sucursal 
    AND ped.pedido =     @Pedido
    AND ped.cliente =    @Cliente
    AND ped.archivo_hh is null
    AND PED.arch_cliente = @ArchCliente
    GROUP BY sucursal, letra, cliente, arch_cliente, pedido, codigo 
    ORDER BY sucursal, letra, cliente, arch_cliente, pedido, codigo 

END

GO

