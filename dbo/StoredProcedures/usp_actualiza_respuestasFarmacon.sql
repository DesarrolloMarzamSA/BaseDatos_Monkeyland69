
-- =============================================
-- Author:		MANDRADE
-- Create date: 03012014
-- Description:	ACTUALIZAR
-- =============================================
CREATE PROCEDURE [dbo].[usp_actualiza_respuestasFarmacon]
AS
BEGIN
	SET NOCOUNT ON;
--	declare @Cantidad tinyint
--	declare @codigo varchar(8)
--	declare @num_pedido varchar(20)
--	declare @cuenta varchar(20)
--	declare @cuenta1 varchar(8)
--	declare @sucursal int
--	declare cursor_tmp_pedidos cursor fast_forward for select p.codigo,p.num_pedido,s.ibs_letra+p.cuenta as cuenta,p.cuenta as cuenta1,p.sucursal from [pedidos_farmacon_historia] p   inner join sucursales s on p.sucursal=s.sucursal
--	 where  p.num_pedido='4500851544' --and p.codigo='2089004' and p.sucursal=17
--open cursor_tmp_pedidos
--fetch next from cursor_tmp_pedidos into @codigo, @num_pedido, @cuenta,@cuenta1,@sucursal
--while @@fetch_status = 0
--begin

--	select @Cantidad = (select IDSQTY FROM AS400.[S101FEBT].MA4620EF04.SRBISD  
--						INNER JOIN AS400.[S101FEBT].MA4620EF04.SRBSOH ON IDORNO = OHORNO 
--						WHERE  IDIDAT>=convert(varchar,GETDATE()-1,112) and OHSURF IN (''+@num_pedido+'') AND IDPRDC IN (''+@codigo+'') AND IDCUNO IN (''+@cuenta+'')	)
--	if(@@rowcount = 1)
--		begin			
--				update [pedidos_farmacon_historia] set cantidad_surtida = @Cantidad  where  convert(varchar,FechaPedido,112)>= convert(varchar,GETDATE()-1,112) and num_pedido=''+@num_pedido+''  and  codigo=''+@codigo+'' and sucursal=@sucursal and cuenta=''+@cuenta1+''
--			end
--	fetch next from cursor_tmp_pedidos into @codigo, @num_pedido, @cuenta,@cuenta1,@sucursal
--end
--close cursor_tmp_pedidos
--deallocate cursor_tmp_pedidos    
END

GO

