
-- =============================================
-- Author:		<Author,,Francisco Roberto Martínez Hernández>
-- Create date: <Create Date,22-03-2023,>
-- Description:	<Description,Asigna el nombre del archivoHH generado por la App de consola al pedido del cliente>
-- =============================================
CREATE PROCEDURE [fbena].[usp_fbenavides_pedidos_CI_SetArchivoHH]
@Sucursal int,
@Arch_cliente varchar(75),
@Cliente varchar(10),
@Codigo varchar(7),
@Pedido varchar(10),
@Archivo_hh  varchar(20)
AS
BEGIN
    	
      UPDATE [dbo].[pedidos_fbenavides_ci] 
	    SET tftp = GETDATE(), archivo_hh = @Archivo_hh,	estatus = '2'
      WHERE sucursal = @Sucursal AND arch_cliente = @Arch_cliente AND cliente = @Cliente
             AND codigo = @Codigo AND pedido = @Pedido AND archivo_hh is null 

END

GO

