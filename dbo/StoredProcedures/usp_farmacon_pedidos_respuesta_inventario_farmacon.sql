CREATE procedure [dbo].[usp_farmacon_pedidos_respuesta_inventario_farmacon]
	@x_ArchivoHH varchar(50)
as
update	pedidos_farmacon
set		cantidad_surtida = cantidad_pedida,
		motivo_no_surtido = 8,
		factura = '99999999'
from	pedidos_farmacon t1 
where	t1.arch_tandem = @x_ArchivoHH and
		t1.cantidad_pedida > 0 and
		t1.motivonosurtido_preibs is null

GO

