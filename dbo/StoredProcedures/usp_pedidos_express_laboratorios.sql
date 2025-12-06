USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_pedidos_express_laboratorios]
WITH ENCRYPTION
as

declare @num_cuenta varchar(4)
declare @lab_corto varchar(16)
declare @descripcion varchar(50)

declare @num_cuenta_checa varchar(4)
declare @lab_corto_checa varchar(16)
declare @descripcion_checa varchar(50)

create table #laboratorios(
num_cuenta varchar(4) NOT NULL,
lab_corto varchar(16) NULL,
descripcion varchar(50) NULL,
primary key(num_cuenta))

insert into #laboratorios select distinct cod_lab, lab_corto, lab_largo from monkeyland.dbo.laboratorios_baan

declare cursor_laboratorios cursor fast_forward for select num_cuenta, lab_corto, descripcion from #laboratorios
open cursor_laboratorios
fetch next from cursor_laboratorios into @num_cuenta, @lab_corto, @descripcion

while @@fetch_status = 0
begin
	select @descripcion_checa = descripcion, @lab_corto_checa = lab_corto from pedidos_express.dbo.laboratorios where num_cuenta = @num_cuenta
	if @@rowcount > 0
		begin
			if(@descripcion_checa <> @descripcion) or (@lab_corto_checa <> @lab_corto)
				begin
					update pedidos_express.dbo.laboratorios set lab_corto = @lab_corto, descripcion = @descripcion where num_cuenta = @num_cuenta
				end
		end
	else
		begin
			insert into pedidos_express.dbo.laboratorios(num_cuenta, lab_corto, descripcion) values(@num_cuenta, @lab_corto, @descripcion)
		end
	fetch next from cursor_laboratorios into @num_cuenta, @lab_corto, @descripcion
end

close cursor_laboratorios
deallocate cursor_laboratorios

declare @seguro int
select @seguro = count(t1.num_cuenta) from pedidos_express.dbo.laboratorios t1 left outer join #laboratorios t2 on t1.num_cuenta = t2.num_cuenta where t2.descripcion is null

if @seguro < 10
begin

	declare cursor_limpia_laboratorios cursor fast_forward for select t1.num_cuenta from pedidos_express.dbo.laboratorios t1 left outer join #laboratorios t2 on t1.num_cuenta = t2.num_cuenta where t2.descripcion is null
	open cursor_limpia_laboratorios

	fetch next from cursor_limpia_laboratorios into @num_cuenta
	while @@fetch_status = 0
	begin
		delete from pedidos_express.dbo.laboratorios where num_cuenta = @num_cuenta
		fetch next from cursor_limpia_laboratorios into @num_cuenta
	end
	close cursor_limpia_laboratorios
	deallocate cursor_limpia_laboratorios

end
GO
