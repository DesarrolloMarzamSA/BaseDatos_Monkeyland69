
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[usp_pedidos_express_ofertas]

as
set nocount on
declare @sucursal tinyint
declare @codigo varchar(7)
declare @bolsa varchar(5)
declare @cant_base int
declare @cant_oferta int
declare @porcentaje money

declare @sucursal_checa tinyint
declare @codigo_checa varchar(7)
declare @bolsa_checa varchar(5)
declare @cant_base_checa int
declare @cant_oferta_checa int
declare @porcentaje_checa money

create table #ofertas(
sucursal tinyint NOT NULL,
codigo varchar(7) NOT NULL,
bolsa varchar(5) NOT NULL,
cant_base int NULL,
cant_oferta int NULL,
porcentaje money NULL,
primary key(sucursal, codigo, bolsa))


insert into #ofertas
select 
sucursal, 
codigo, 
bolsa, 
cant_base, 
cant_oferta, 
porcentaje 
from 
monkeyland.dbo.dboferta


declare cursor_ofertas cursor fast_forward for select 
				sucursal, 
				codigo, 
				bolsa, 
				cant_base, 
				cant_oferta, 
				porcentaje 
				from #ofertas 
open cursor_ofertas
fetch next from cursor_ofertas into @sucursal, @codigo, @bolsa, @cant_base, @cant_oferta, @porcentaje 
while @@fetch_status = 0
begin
	select
	@cant_base_checa = cant_base,
	@cant_oferta_checa = cant_oferta,
	@porcentaje_checa = porcentaje
	from
	pedidos_express.dbo.ofertas
	where
	sucursal = @sucursal and
	codigo = @codigo and
	bolsa = @bolsa
	
	if @@rowcount > 0
		begin
		if(	(@cant_base_checa <> @cant_base) or
			(@cant_oferta_checa <> @cant_oferta) or
			(@porcentaje_checa <> @porcentaje))
			begin
				update pedidos_express.dbo.ofertas set
				cant_base = @cant_base,
				cant_oferta = @cant_oferta,
				porcentaje = @porcentaje
				where
				sucursal = @sucursal and
				codigo = @codigo and
				bolsa = @bolsa
			end
		end
	else
		begin
			insert into pedidos_express.dbo.ofertas(
			sucursal,
			codigo,
			bolsa,
			cant_base,
			cant_oferta,
			porcentaje)
			values(
			@sucursal,
			@codigo,
			@bolsa,
			@cant_base,
			@cant_oferta,
			@porcentaje)			
		end
	fetch next from cursor_ofertas into @sucursal, @codigo, @bolsa, @cant_base, @cant_oferta, @porcentaje 
end
close cursor_ofertas
deallocate cursor_ofertas

declare @suc_limpia tinyint
declare @contador int

declare cur_sucs_limpia_ofertas cursor fast_forward for select sucursal, count(codigo) contador from #ofertas group by sucursal
open cur_sucs_limpia_ofertas

fetch next from cur_sucs_limpia_ofertas into @suc_limpia, @contador
while @@fetch_status = 0
begin
	declare cursor_limpia_ofertas cursor fast_forward for select t1.sucursal, t1.codigo, t1.bolsa from pedidos_express.dbo.ofertas t1 left outer join #ofertas t2 on t1.sucursal = t2.sucursal and t1.codigo = t2.codigo and t1.bolsa = t2.bolsa where t1.sucursal = @suc_limpia and t2.porcentaje is null
	open cursor_limpia_ofertas
	fetch next from cursor_limpia_ofertas into @sucursal, @codigo, @bolsa
	while @@fetch_status = 0
	begin
		delete from pedidos_express.dbo.ofertas where sucursal = @sucursal and codigo = @codigo and bolsa = @bolsa
		fetch next from cursor_limpia_ofertas into @sucursal, @codigo, @bolsa
	end
	close cursor_limpia_ofertas
	deallocate cursor_limpia_ofertas
	fetch next from cur_sucs_limpia_ofertas into @suc_limpia, @contador
end

close cur_sucs_limpia_ofertas
deallocate cur_sucs_limpia_ofertas

drop table #ofertas

set nocount off
GO
