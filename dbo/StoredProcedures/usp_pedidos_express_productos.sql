
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[usp_pedidos_express_productos]
WITH ENCRYPTION
as
set nocount on
declare @sucursal tinyint
declare @codigo char(7)
declare @cod_barras varchar(13)
declare @descripcion varchar(50)
declare @prec_farm money
declare @prec_pub money
declare @clas_fis varchar(2)
declare @clas_ssa varchar(1)
declare @derecho_devolucion int
declare @desc_sus_act1 varchar(60)
declare @desc_sus_act2 varchar(60)
declare @num_cuenta varchar(4)
declare @indicacion_terapeutica varchar(50)
declare @clas_promocion varchar(30)

declare @sucursal_checa tinyint
declare @codigo_checa char(7)
declare @cod_barras_checa varchar(13)
declare @descripcion_checa varchar(50)
declare @prec_farm_checa money
declare @prec_pub_checa money
declare @clas_fis_checa varchar(2)
declare @clas_ssa_checa varchar(1)
declare @derecho_devolucion_checa int
declare @desc_sus_act1_checa varchar(60)
declare @desc_sus_act2_checa varchar(60)
declare @num_cuenta_checa varchar(4)
declare @indicacion_terapeutica_checa varchar(50)
declare @clas_promocion_checa varchar(30)

create table #productos(
sucursal tinyint NOT NULL,
codigo char(7) NOT NULL,
cod_barras varchar(13) NULL,
descripcion varchar(50) NULL,
prec_farm money NULL,
prec_pub money NULL,
clas_fis varchar(2) NULL,
clas_ssa varchar(1) NULL,
derecho_devolucion int NULL,
desc_sus_act1 varchar(60) NULL,
desc_sus_act2 varchar(60) NULL,
num_cuenta varchar(4) NULL,
indicacion_terapeutica varchar(50) NULL,
clas_promocion varchar(30) NULL,
primary key(sucursal, codigo))

insert into #productos
select 
t2.sucursal,
t1.codigo, 
t1.cod_barras,
t1.descripcion,
t1.prec_farm,
t1.prec_pub,
t1.clas_fis,
case t1.clas_ssa when 0 then 9 else t1.clas_ssa end clas_ssa,
t2.derecho_devolucion,
t1.desc_sus_act1,
t1.desc_sus_act2,
t1.cod_lab num_cuenta,
t1.desc_grupo_est indicacion_terapeutica,
t1.clas_promocion 
from 
monkeyland.dbo.maestro_productos_baan t1 inner join monkeyland.dbo.inventario_baan_sin_filtro t2 on t1.codigo = t2.codigo
where convert(int, t2.codigo) < dbo.gobierno() and substring(t2.status, 1, 1) <> 'B'
	
declare cursor_productos cursor fast_forward for select
												sucursal,
												codigo,
												cod_barras,
												left(descripcion + replicate(' ', 30), 28) + right('  ' + clas_fis, 2) descripcion,
												prec_farm,
												prec_pub,
												clas_fis,
												clas_ssa,
												derecho_devolucion,
												desc_sus_act1,
												desc_sus_act2,
												num_cuenta,
												indicacion_terapeutica,
												clas_promocion
												from
												#productos

open cursor_productos
fetch next from cursor_productos into @sucursal, @codigo, @cod_barras, @descripcion, @prec_farm, @prec_pub, @clas_fis, @clas_ssa, @derecho_devolucion, @desc_sus_act1, @desc_sus_act2, @num_cuenta, @indicacion_terapeutica, @clas_promocion
while @@fetch_status = 0
begin
	select
	@sucursal_checa = sucursal,
	@codigo_checa = codigo,
	@cod_barras_checa = cod_barras,
	@descripcion_checa = descripcion,
	@prec_farm_checa = prec_farm,
	@prec_pub_checa = prec_pub,
	@clas_fis_checa = clas_fis,
	@clas_ssa_checa = clas_ssa,
	@derecho_devolucion_checa = derecho_devolucion,
	@desc_sus_act1_checa = desc_sus_act1,
	@desc_sus_act2_checa = desc_sus_act2,
	@num_cuenta_checa = num_cuenta,
	@indicacion_terapeutica_checa = indicacion_terapeutica,
	@clas_promocion_checa = clas_promocion
	from
	pedidos_express.dbo.productos
	where
	sucursal = @sucursal and
	codigo = @codigo
	
	if @@rowcount > 0
		begin
			 if (@cod_barras_checa <> @cod_barras) or
				(@descripcion_checa <> @descripcion) or
				(@prec_farm_checa <> @prec_farm) or
				(@prec_pub_checa <> @prec_pub) or
				(@clas_fis_checa <> @clas_fis) or
				(@clas_ssa_checa <> @clas_ssa) or
				(@derecho_devolucion_checa <> @derecho_devolucion) or
				(@desc_sus_act1_checa <> @desc_sus_act1) or
				(@desc_sus_act2_checa <> @desc_sus_act2) or
				(@num_cuenta_checa <> @num_cuenta) or
				(@indicacion_terapeutica_checa <> @indicacion_terapeutica) or
				(@clas_promocion_checa <> @clas_promocion)
			 begin
				update pedidos_express.dbo.productos set
				cod_barras = @cod_barras,
				descripcion = @descripcion,
				prec_farm = @prec_farm,
				prec_pub = @prec_pub,
				clas_fis = @clas_fis,
				clas_ssa = @clas_ssa,
				derecho_devolucion = @derecho_devolucion,
				desc_sus_act1 = @desc_sus_act1,
				desc_sus_act2 = @desc_sus_act2,
				num_cuenta = @num_cuenta,
				indicacion_terapeutica = @indicacion_terapeutica,
				clas_promocion = @clas_promocion
				where
				sucursal = @sucursal and
				codigo = @codigo
			 end
		end
	else
		begin
			insert into pedidos_express.dbo.productos(sucursal,
						codigo,
						cod_barras,
						descripcion,
						prec_farm,
						prec_pub,
						clas_fis,
						clas_ssa,
						derecho_devolucion,
						desc_sus_act1,
						desc_sus_act2,
						num_cuenta,
						indicacion_terapeutica,
						clas_promocion)
						values(
						@sucursal,
						@codigo,
						@cod_barras,
						@descripcion,
						@prec_farm,
						@prec_pub,
						@clas_fis,
						@clas_ssa,
						@derecho_devolucion,
						@desc_sus_act1,
						@desc_sus_act2,
						@num_cuenta,
						@indicacion_terapeutica,
						@clas_promocion)
		end
	fetch next from cursor_productos into @sucursal, @codigo, @cod_barras, @descripcion, @prec_farm, @prec_pub, @clas_fis, @clas_ssa, @derecho_devolucion, @desc_sus_act1, @desc_sus_act2, @num_cuenta, @indicacion_terapeutica, @clas_promocion
end
close cursor_productos
deallocate cursor_productos

declare cursor_limpia_productos cursor fast_forward for select t1.sucursal, t1.codigo from pedidos_express.dbo.productos t1 left outer join #productos t2 on t1.sucursal = t2.sucursal and t1.codigo = t2.codigo where t2.prec_farm is null
open cursor_limpia_productos
fetch next from cursor_limpia_productos into @sucursal, @codigo 
while @@fetch_status = 0
begin
	delete from pedidos_express.dbo.productos where sucursal = @sucursal and codigo = @codigo
	fetch next from cursor_limpia_productos into @sucursal, @codigo 
end

close cursor_limpia_productos
deallocate cursor_limpia_productos

drop table #productos

set nocount off
	
GO
