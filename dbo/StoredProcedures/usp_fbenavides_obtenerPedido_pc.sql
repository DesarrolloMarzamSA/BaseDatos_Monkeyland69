-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- usp_fbenavides_obtenerPedido_pc 'd1baf0db0da0f6f9e8194aa255d5efe4'
-- =============================================
CREATE PROCEDURE usp_fbenavides_obtenerPedido_pc  @hash_md5 varchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT sucursal, letra, cliente, arch_cliente,hash_md5, pedido, codigo, SUM(cantidad_pedida) cantidad 
FROM pedidos_fbenavides_ci_pc  ped 
WHERE 
 ped.archivo_hh is null 
AND ped.hash_md5 in(@hash_md5)   and ped.cliente<>'00000' and ped.codigo<>'0000000' 
GROUP BY sucursal, letra, cliente, arch_cliente,hash_md5, pedido, codigo 
ORDER BY sucursal, letra, cliente, arch_cliente,hash_md5, pedido, codigo 
END

GO

