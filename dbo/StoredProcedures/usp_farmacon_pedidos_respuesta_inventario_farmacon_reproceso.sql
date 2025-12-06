
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_farmacon_pedidos_respuesta_inventario_farmacon_reproceso]
	@x_ArchivoHH varchar(50)

as
update	pedidos_farmacon_historia
set		cantidad_surtida = t1.cantidad_pedida,
		motivo_no_surtido = 8,
		factura = '99999999'
from	pedidos_farmacon_historia t1 inner join #inventario_farmacon_actual t2 on
		t1.sucursal = t2.sucursal and
		t1.codigo = t2.codigo
where	t1.arch_tandem = @x_ArchivoHH and
		t1.cantidad_pedida > 0 and
		t1.motivonosurtido_preibs is null
GO
