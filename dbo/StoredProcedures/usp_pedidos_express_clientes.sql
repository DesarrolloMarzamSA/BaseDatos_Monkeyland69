
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



CREATE procedure [dbo].[usp_pedidos_express_clientes]
WITH ENCRYPTION
as
set nocount on
declare @sucursal tinyint
declare @cte_cod varchar(6)
declare @agen_cod varchar(10)
declare @agen_nombre varchar(60)
declare @cte_nombre varchar(50)
declare @direccion varchar(50)
declare @colonia varchar(50)
declare @municipio varchar(50)
declare @estado varchar(50)
declare @cred_limite money
declare @cred_usado money
declare @tipo varchar(50)
declare @rfc varchar(50)
declare @status varchar(50)

declare @sucursal_checa tinyint
declare @cte_cod_checa varchar(6)
declare @agen_cod_checa varchar(10)
declare @agen_nombre_checa varchar(60)
declare @cte_nombre_checa varchar(50)
declare @direccion_checa varchar(50)
declare @colonia_checa varchar(50)
declare @municipio_checa varchar(50)
declare @estado_checa varchar(50)
declare @cred_limite_checa money
declare @cred_usado_checa money
declare @tipo_checa varchar(50)
declare @rfc_checa varchar(50)
declare @autoservicio int
declare @autoservicio_checa int
declare @nivel_grupo_ssa varchar(9)
declare @nivel_grupo_ssa_checa varchar(9)

create table #clientes_baan(
	sucursal tinyint NOT NULL,
	cte_cod varchar(6) NOT NULL,
	agen_cod varchar(10) NULL,
	agen_nombre varchar(60) NULL,
	cte_nombre varchar(50) NULL,
	direccion varchar(50) NULL,
	colonia varchar(50) NULL,
	municipio varchar(50) NULL,
	estado varchar(50) NULL,
	cred_limite money NULL,
	cred_usado money NULL,
	tipo varchar(50) NULL,
	rfc varchar(50) NULL,
	status varchar(50) NULL,
	autoservicio int null,
	nivel_grupo_ssa varchar(9) null,
	primary key(cte_cod))  

create index idx_clientes_baan_temp1 on #clientes_baan(status)




declare cur_ctesbaanpe cursor fast_forward for
select
t3.almacen sucursal,
convert(varchar(6), t3.letra_baan + t1.cliente) cte_cod,
t1.agen_cod,
t1.agen_nombre,
t1.farmacia cte_nombre,
t1.direccion,
t1.colonia,
t1.poblacion municipio,
t2.descripcion estado,
t1.limite cred_limite,
t1.usado cred_usado,
t1.tipo,
t1.rfc,
t1.status,
case left(isnull(t1.segto, '  '), 1) when 'E' then 1 else 0 end,
convert(varchar(9), t1.vta_psicotropicos) vta_psicotropicos
from
monkeyland.dbo.clientes_baan t1 inner join monkeyland.dbo.estados t2 on convert(tinyint, t1.cve_estado) = t2.cve_estado
inner join monkeyland.dbo.sucursales t3 on t1.sucursal = t3.sucursal

open cur_ctesbaanpe

fetch next from cur_ctesbaanpe into 
@sucursal,
@cte_cod,
@agen_cod,
@agen_nombre,
@cte_nombre,
@direccion,
@colonia,
@municipio,
@estado,
@cred_limite,
@cred_usado,
@tipo,
@rfc,
@status,
@autoservicio,
@nivel_grupo_ssa

while @@fetch_status = 0
begin
	insert into #clientes_baan(sucursal,
								cte_cod,
								agen_cod,
								agen_nombre,
								cte_nombre,
								direccion,
								colonia,
								municipio,
								estado,
								cred_limite,
								cred_usado,
								tipo,
								rfc,
								status,
								autoservicio,
								nivel_grupo_ssa
								)
								values(
								@sucursal,
								@cte_cod,
								@agen_cod,
								@agen_nombre,
								@cte_nombre,
								@direccion,
								@colonia,
								@municipio,
								@estado,
								@cred_limite,
								@cred_usado,
								@tipo,
								@rfc,
								@status,
								@autoservicio,
								@nivel_grupo_ssa)
								
	fetch next from cur_ctesbaanpe into 
	@sucursal,
	@cte_cod,
	@agen_cod,
	@agen_nombre,
	@cte_nombre,
	@direccion,
	@colonia,
	@municipio,
	@estado,
	@cred_limite,
	@cred_usado,
	@tipo,
	@rfc,
	@status,
	@autoservicio,
	@nivel_grupo_ssa
end

close cur_ctesbaanpe
deallocate cur_ctesbaanpe

--delete from #clientes_baan where tipo not in('AGR','AUT','CAD','MAY','NOR','ES1','ES2','ESP','NAV')
--delete from #clientes_baan where((status like 'LEGAL%') or(status like 'COD (BAJ%') or (status like 'CREDITO (BAJA%') or(status like 'COD CHEQUE (BA%') or(status like 'COD (CHEQUE) B%'))
--delete from #clientes_baan where(tipo in('ES1','ES2','ESP')) and(status not in('CREDITO (FALTA','CREDITO (SUSPE','COD (NORMAL)','COD CHEQUE (NO','CREDITO','CREDITO (NORMAL)')) 
--delete from #clientes_baan where (tipo  = 'NAV' and cred_usado <= 0.01) 
--delete from #clientes_baan where agen_cod like '%BAJA%'
--delete from #clientes_baan where (convert(int, right(cte_cod, 5)) - (convert(int, right(cte_cod, 5))/100000)*100000)/1000 = 99


declare cursor_clientes cursor fast_forward for select sucursal,
cte_cod,
agen_cod,
agen_nombre,
cte_nombre,
direccion,
colonia,
municipio,
estado,
cred_limite,
cred_usado,
tipo,
rfc,
autoservicio,
nivel_grupo_ssa
from
#clientes_baan

open cursor_clientes
fetch next from cursor_clientes into @sucursal, @cte_cod, @agen_cod, @agen_nombre, @cte_nombre, @direccion, @colonia, @municipio, @estado, @cred_limite, @cred_usado, @tipo, @rfc, @autoservicio, @nivel_grupo_ssa


while @@fetch_status = 0
begin
	select
	@sucursal_checa = sucursal,
	@cte_cod_checa = cte_cod,
	@agen_cod_checa = agen_cod,
	@agen_nombre_checa = agen_nombre,
	@cte_nombre_checa = cte_nombre,
	@direccion_checa = direccion,
	@colonia_checa = colonia,
	@municipio_checa = municipio,
	@estado_checa = estado,
	@cred_limite_checa = cred_limite,
	@cred_usado_checa = cred_usado,
	@tipo_checa = tipo,
	@rfc_checa = rfc,
	@autoservicio_checa = autoservicio,
	@nivel_grupo_ssa_checa = nivel_grupo_ssa
	from
	pedidos_express.dbo.clientes
	where
	sucursal = @sucursal and
	cte_cod = @cte_cod

	if @@rowcount > 0
		begin
			if  (@agen_cod <> @agen_cod_checa) or
				(@agen_nombre <> @agen_nombre_checa) or
				(@cte_nombre <> @cte_nombre_checa) or
				(@direccion <> @direccion_checa) or
				(@colonia <> @colonia_checa) or
				(@municipio <> @municipio_checa) or
				(@estado <> @estado_checa) or
				(@cred_limite <> @cred_limite_checa) or
				(@cred_usado <> @cred_usado_checa) or
				(@tipo <> @tipo_checa) or
				(@rfc <> @rfc_checa) or
				(@autoservicio <> @autoservicio_checa) or
				(@nivel_grupo_ssa <> @nivel_grupo_ssa_checa)
			begin
				update pedidos_express.dbo.clientes set
				agen_cod = @agen_cod,
				agen_nombre = @agen_nombre,
				cte_nombre = @cte_nombre,
				direccion = @direccion,
				colonia = @colonia,
				municipio = @municipio,
				estado = @estado,
				cred_limite = @cred_limite,
				cred_usado = @cred_usado,
				tipo = @tipo,
				rfc = @rfc,
				autoservicio = @autoservicio,
				nivel_grupo_ssa = @nivel_grupo_ssa
				where
				sucursal = @sucursal and
				cte_cod = @cte_cod
			end
		end
	else
		begin
			insert into pedidos_express.dbo.clientes(
					sucursal,
					cte_cod,
					agen_cod,
					agen_nombre,
					cte_nombre,
					direccion,
					colonia,
					municipio,
					estado,
					cred_limite,
					cred_usado,
					tipo,
					rfc,
					autoservicio,
					nivel_grupo_ssa)
			values (@sucursal,
					@cte_cod,
					@agen_cod,
					@agen_nombre,
					@cte_nombre,
					@direccion,
					@colonia,
					@municipio,
					@estado,
					@cred_limite,
					@cred_usado,
					@tipo,
					@rfc,
					@autoservicio,
					@nivel_grupo_ssa)
		end
	fetch next from cursor_clientes into @sucursal, @cte_cod, @agen_cod, @agen_nombre, @cte_nombre, @direccion, @colonia, @municipio, @estado, @cred_limite, @cred_usado, @tipo, @rfc, @autoservicio, @nivel_grupo_ssa
end
close cursor_clientes
deallocate cursor_clientes


declare @seguro int
select @seguro = count(t1.sucursal) from pedidos_express.dbo.clientes t1 left outer join #clientes_baan t2 on t1.sucursal = t2.sucursal and t1.cte_cod = t2.cte_cod where t2.cte_nombre is null

if @seguro < 10000
begin

	declare cursor_limpia_clientes cursor fast_forward for select t1.sucursal, t1.cte_cod from pedidos_express.dbo.clientes t1 left outer join #clientes_baan t2 on t1.sucursal = t2.sucursal and t1.cte_cod = t2.cte_cod where t2.cte_nombre is null
	open cursor_limpia_clientes
	fetch next from cursor_limpia_clientes into @sucursal, @cte_cod
	while @@fetch_status = 0
	begin
		delete from pedidos_express.dbo.clientes where sucursal = @sucursal and cte_cod = @cte_cod
		fetch next from cursor_limpia_clientes into @sucursal, @cte_cod
	end
	close cursor_limpia_clientes
	deallocate cursor_limpia_clientes

end




--clientes sin filtro

truncate table #clientes_baan

declare cur_ctesbaanpe cursor fast_forward for
select
t3.almacen sucursal,
convert(varchar(6), t3.letra_baan + t1.cliente) cte_cod,
t1.agen_cod,
t1.agen_nombre,
t1.farmacia cte_nombre,
t1.direccion,
t1.colonia,
t1.poblacion municipio,
t2.descripcion estado,
t1.limite cred_limite,
t1.usado cred_usado,
t1.tipo,
t1.rfc,
t1.status,
case left(isnull(t1.segto, '  '), 1) when 'E' then 1 else 0 end,
convert(varchar(9), t1.vta_psicotropicos) vta_psicotropicos
from
monkeyland.dbo.clientes_baan t1 inner join monkeyland.dbo.estados t2 on convert(tinyint, t1.cve_estado) = t2.cve_estado
inner join monkeyland.dbo.sucursales t3 on t1.sucursal = t3.sucursal

open cur_ctesbaanpe

fetch next from cur_ctesbaanpe into 
@sucursal,
@cte_cod,
@agen_cod,
@agen_nombre,
@cte_nombre,
@direccion,
@colonia,
@municipio,
@estado,
@cred_limite,
@cred_usado,
@tipo,
@rfc,
@status,
@autoservicio,
@nivel_grupo_ssa

while @@fetch_status = 0
begin
	insert into #clientes_baan(sucursal,
								cte_cod,
								agen_cod,
								agen_nombre,
								cte_nombre,
								direccion,
								colonia,
								municipio,
								estado,
								cred_limite,
								cred_usado,
								tipo,
								rfc,
								status,
								autoservicio,
								nivel_grupo_ssa
								)
								values(
								@sucursal,
								@cte_cod,
								@agen_cod,
								@agen_nombre,
								@cte_nombre,
								@direccion,
								@colonia,
								@municipio,
								@estado,
								@cred_limite,
								@cred_usado,
								@tipo,
								@rfc,
								@status,
								@autoservicio,
								@nivel_grupo_ssa)
								
	fetch next from cur_ctesbaanpe into 
	@sucursal,
	@cte_cod,
	@agen_cod,
	@agen_nombre,
	@cte_nombre,
	@direccion,
	@colonia,
	@municipio,
	@estado,
	@cred_limite,
	@cred_usado,
	@tipo,
	@rfc,
	@status,
	@autoservicio,
	@nivel_grupo_ssa
end

close cur_ctesbaanpe
deallocate cur_ctesbaanpe





declare cursor_clientes cursor fast_forward for select sucursal,
cte_cod,
agen_cod,
agen_nombre,
cte_nombre,
direccion,
colonia,
municipio,
estado,
cred_limite,
cred_usado,
tipo,
rfc,
autoservicio,
nivel_grupo_ssa
from
#clientes_baan

open cursor_clientes
fetch next from cursor_clientes into @sucursal, @cte_cod, @agen_cod, @agen_nombre, @cte_nombre, @direccion, @colonia, @municipio, @estado, @cred_limite, @cred_usado, @tipo, @rfc, @autoservicio, @nivel_grupo_ssa


while @@fetch_status = 0
begin
	select
	@sucursal_checa = sucursal,
	@cte_cod_checa = cte_cod,
	@agen_cod_checa = agen_cod,
	@agen_nombre_checa = agen_nombre,
	@cte_nombre_checa = cte_nombre,
	@direccion_checa = direccion,
	@colonia_checa = colonia,
	@municipio_checa = municipio,
	@estado_checa = estado,
	@cred_limite_checa = cred_limite,
	@cred_usado_checa = cred_usado,
	@tipo_checa = tipo,
	@rfc_checa = rfc,
	@autoservicio_checa = autoservicio,
	@nivel_grupo_ssa_checa = nivel_grupo_ssa
	from
	pedidos_express.dbo.clientes_sin_filtro
	where
	sucursal = @sucursal and
	cte_cod = @cte_cod

	if @@rowcount > 0
		begin
			if  (@agen_cod <> @agen_cod_checa) or
				(@agen_nombre <> @agen_nombre_checa) or
				(@cte_nombre <> @cte_nombre_checa) or
				(@direccion <> @direccion_checa) or
				(@colonia <> @colonia_checa) or
				(@municipio <> @municipio_checa) or
				(@estado <> @estado_checa) or
				(@cred_limite <> @cred_limite_checa) or
				(@cred_usado <> @cred_usado_checa) or
				(@tipo <> @tipo_checa) or
				(@rfc <> @rfc_checa) or
				(@autoservicio <> @autoservicio_checa) or
				(@nivel_grupo_ssa <> @nivel_grupo_ssa_checa)
			begin
				update pedidos_express.dbo.clientes_sin_filtro set
				agen_cod = @agen_cod,
				agen_nombre = @agen_nombre,
				cte_nombre = @cte_nombre,
				direccion = @direccion,
				colonia = @colonia,
				municipio = @municipio,
				estado = @estado,
				cred_limite = @cred_limite,
				cred_usado = @cred_usado,
				tipo = @tipo,
				rfc = @rfc,
				autoservicio = @autoservicio,
				nivel_grupo_ssa = @nivel_grupo_ssa
				where
				sucursal = @sucursal and
				cte_cod = @cte_cod
			end
		end
	else
		begin
			insert into pedidos_express.dbo.clientes_sin_filtro(
					sucursal,
					cte_cod,
					agen_cod,
					agen_nombre,
					cte_nombre,
					direccion,
					colonia,
					municipio,
					estado,
					cred_limite,
					cred_usado,
					tipo,
					rfc,
					autoservicio,
					nivel_grupo_ssa)
			values (@sucursal,
					@cte_cod,
					@agen_cod,
					@agen_nombre,
					@cte_nombre,
					@direccion,
					@colonia,
					@municipio,
					@estado,
					@cred_limite,
					@cred_usado,
					@tipo,
					@rfc,
					@autoservicio,
					@nivel_grupo_ssa)
		end
	fetch next from cursor_clientes into @sucursal, @cte_cod, @agen_cod, @agen_nombre, @cte_nombre, @direccion, @colonia, @municipio, @estado, @cred_limite, @cred_usado, @tipo, @rfc, @autoservicio, @nivel_grupo_ssa
end
close cursor_clientes
deallocate cursor_clientes


drop table #clientes_baan

set nocount off
GO
