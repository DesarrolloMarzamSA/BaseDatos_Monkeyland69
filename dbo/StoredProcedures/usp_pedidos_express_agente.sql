USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_pedidos_express_agente]
WITH ENCRYPTION
as
set nocount on
declare @sucursal tinyint
declare @agen_cod char(5)
declare @agen_nombre varchar(50)

declare @sucursal_checa tinyint
declare @agen_cod_checa char(5)
declare @agen_nombre_checa varchar(50)

create table #agente(
sucursal tinyint not null,
agen_cod char(5) not null,
agen_nombre varchar(50),
primary key(sucursal, agen_cod))

insert into #agente(sucursal, agen_cod, agen_nombre) 
select
distinct
t1.sucursal,
t1.agen_cod,
max(t1.agen_nombre) agen_nombre
from
monkeyland.dbo.clientes_baan t1
where
t1.agen_cod not like '%BAJA%'
group by 
t1.sucursal,
t1.agen_cod

declare cursor_agente cursor fast_forward for select sucursal, agen_cod, agen_nombre from #agente
open cursor_agente
fetch next from cursor_agente into @sucursal, @agen_cod, @agen_nombre

while @@fetch_status = 0
begin
	select @agen_nombre_checa = agen_nombre from pedidos_express.dbo.agente where sucursal = @sucursal and agen_cod = @agen_cod
	if @@rowcount > 0
		begin
			if (@agen_nombre_checa <> @agen_nombre)
			begin
				update pedidos_express.dbo.agente set agen_nombre = @agen_nombre where sucursal = @sucursal and agen_cod = @agen_cod
			end
		end
	else
		begin
			insert into pedidos_express.dbo.agente(sucursal, agen_cod, agen_nombre) values(@sucursal, @agen_cod, @agen_nombre)
		end
	fetch next from cursor_agente into @sucursal, @agen_cod, @agen_nombre
end

close cursor_agente
deallocate cursor_agente


declare @bandera int
select @bandera = count(*) from #agente
if @bandera > 500 
begin
	declare cursor_limpia_agente cursor fast_forward for select t1.sucursal, t1.agen_cod from pedidos_express.dbo.agente t1 left outer join #agente t2 on t1.sucursal = t2.sucursal and t1.agen_cod = t2.agen_cod where t2.agen_nombre is null
	open cursor_limpia_agente


	fetch next from cursor_limpia_agente into @sucursal, @agen_cod
	while @@fetch_status = 0
	begin
		delete from pedidos_express.dbo.agente where sucursal = @sucursal and agen_cod = @agen_cod
		fetch next from cursor_limpia_agente into @sucursal, @agen_cod
	end

	close cursor_limpia_agente
	deallocate cursor_limpia_agente
end

drop table #agente

set nocount off
GO
