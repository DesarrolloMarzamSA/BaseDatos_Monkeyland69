



CREATE procedure [dbo].[usp_importa_canceladas_baan]
as
set nocount on

select t_cuno, t_ninv, right(t_pctf, 3) t_pctf into #baan from openquery([baan],'{set isolation to dirty read} select t_cuno, t_ninv, t_pctf from ttfcmg955080 where t_sta10 = ''CAN''')

declare @sucursal tinyint
declare @cliente varchar(5)
declare @factura varchar(8)
declare @ctepadre varchar(3)


declare mi_cursor cursor fast_forward for
select 
t2.sucursal,
right('00000000' + convert(varchar(8), convert(int, t1.t_ninv)), 8),
right(t1.t_cuno, 5),
t1.t_pctf
from
#baan t1 inner join monkeyland.dbo.sucursales t2 on left(t1.t_cuno, 1) = t2.letra

open mi_cursor

fetch next from mi_cursor into @sucursal, @factura, @cliente, @ctepadre
while @@fetch_status = 0
	begin
		if not exists(select * from facturas_reingresadas_almacen where sucursal = @sucursal and factura = @factura) 
		begin
			insert into facturas_reingresadas_almacen(sucursal, factura, cliente, ctepadre) values(@sucursal, @factura, @cliente, @ctepadre)
		end
	fetch next from mi_cursor into @sucursal, @factura, @cliente, @ctepadre
	end
close mi_cursor
deallocate mi_cursor


set nocount off

GO

