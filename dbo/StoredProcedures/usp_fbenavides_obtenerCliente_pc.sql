-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- usp_fbenavides_obtenerCliente_pc 'd1baf0db0da0f6f9e8194aa255d5efe4'
-- =============================================
CREATE PROCEDURE usp_fbenavides_obtenerCliente_pc @hash_md5 varchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   SELECT ped.sucursal, ped.letra, ped.cliente,ped.pedido,ped.arch_cliente,ped.hash_md5  
FROM pedidos_fbenavides_ci_pc  ped 
where ped.archivo_hh is null  and ped.cliente<>'00000' and ped.codigo<>'0000000' 
and hash_md5 in(@hash_md5) 
GROUP BY ped.sucursal, ped.letra, ped.pedido, ped.cliente,ped.arch_cliente,ped.hash_md5  
ORDER BY ped.sucursal, ped.letra, ped.pedido, ped.cliente,ped.arch_cliente,ped.hash_md5 
END

GO

