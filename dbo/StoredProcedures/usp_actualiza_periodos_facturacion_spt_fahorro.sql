SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO

CREATE  procedure [dbo].[usp_actualiza_periodos_facturacion_spt_fahorro]
as
begin
declare mi_cursor cursor fast_forward for select id, inicio, dateadd(dd, 1, termino) from periodos_facturacion_spt_fahorro
declare @id int, @inicio datetime, @termino datetime, @hoy datetime
update periodos_facturacion_spt_fahorro set activo = 0
select @hoy = current_timestamp
open mi_cursor
fetch next from mi_cursor into @id, @inicio, @termino
while @@fetch_status = 0
begin
	if ((@hoy >= @inicio) and (@hoy <= @termino))
	begin
		update periodos_facturacion_spt_fahorro set activo = 1 where id = @id
	end
	fetch next from mi_cursor into @id, @inicio, @termino
end
close mi_cursor
deallocate mi_cursor
end


GO
