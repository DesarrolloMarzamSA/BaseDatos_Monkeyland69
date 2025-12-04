SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_bazar_bonificaciones]
as
set nocount on

create table #bazar_bonificaciones(
segto char(2) not null,
ctepadre char(3) not null,
codigo char(7) not null,
bonificacion money,
techo money,
primary key(segto, ctepadre, codigo))

insert into #bazar_bonificaciones
select
'C2' segto,
'468' ctepadre,
t1.codigo,
case t1.descto_prod
	 when 5 then 0.1157
	 when 11 then 0.0561
	 else 0
	 end
bonificacion,
0.16 techo
from
maestro_productos_baan t1 inner join bazar_lacteos t2 on t1.codigo = t2.codigo left outer join bazar_excepciones t3 on t1.codigo = t3.codigo where t3.codigo is null

union

select
'C2' segto,
'468' ctepadre,
t1.codigo,
0.0366 bonificacion,
0.99 techo
from
maestro_productos_baan t1 left outer join bazar_lacteos t2 on t1.codigo = t2.codigo left outer join bazar_excepciones t3 on t1.codigo = t3.codigo 
where clas_fis in ('B', 'BA') and t2.codigo is null and t3.codigo is null

union

select
'C2' segto,
'468' ctepadre,
t1.codigo,
case t1.lab_corto 
when 'ASTRAZ' then 0 
else case t1.descto_prod
	 when 5 then 0.1157
	 when 6 then 0.1063
	 when 8 then 0.0869
	 when 10 then 0.0666
	 when 11 then 0.0561
	 when 15 then 0.0117
	 else 0
	 end
end bonificacion,
0.16 techo
from
maestro_productos_baan t1 left outer join bazar_lacteos t2 on t1.codigo = t2.codigo left outer join bazar_excepciones t3 on t1.codigo = t3.codigo 
where clas_fis in ('H', 'HA') and t2.codigo is null and t1.clas_ssa not in (1,2,3) and t3.codigo is null

union

select
'C2' segto,
'468' ctepadre,
t1.codigo,
0.16 bonificacion,
0.16 techo
from
maestro_productos_baan t1 left outer join bazar_excepciones t2 on t1.codigo = t2.codigo  where clas_ssa in (1,2,3) and t2.codigo is null




declare @segto char(2)
declare @ctepadre char(3)
declare @codigo char(7)
declare @bonificacion money
declare @techo money
declare @bonificacion_checa money
declare @techo_checa money

declare cur_bonificaciones_bazar cursor fast_forward for
select segto, ctepadre, codigo, bonificacion, techo from #bazar_bonificaciones

open cur_bonificaciones_bazar

fetch next from cur_bonificaciones_bazar into @segto, @ctepadre, @codigo, @bonificacion, @techo

while @@fetch_status = 0
begin
	select @bonificacion_checa = bonificacion, @techo_checa = techo from bazar_bonificaciones where segto = @segto and ctepadre =  @ctepadre and codigo = @codigo
	if(@@rowcount=1)
		begin
			if(@bonificacion_checa <> @bonificacion) or (@techo_checa <> @techo)
			begin
				update bazar_bonificaciones set timestamp = current_timestamp,  bonificacion = @bonificacion, techo = @techo  where segto = @segto and ctepadre =  @ctepadre and codigo = @codigo
			end
		end
	else
		begin
			insert into bazar_bonificaciones(segto, ctepadre, codigo, bonificacion, techo) values(@segto, @ctepadre, @codigo, @bonificacion, @techo)	
		end
	
	fetch next from cur_bonificaciones_bazar into @segto, @ctepadre, @codigo, @bonificacion, @techo
end


close cur_bonificaciones_bazar 
deallocate cur_bonificaciones_bazar

--LIMPIEZA
declare cur_bonificaciones_bazar cursor fast_forward for
select t1.segto, t1.ctepadre, t1.codigo, t1.bonificacion, t1.techo from bazar_bonificaciones t1 left outer join #bazar_bonificaciones t2 on t1.segto = t2.segto and t1.ctepadre = t2.ctepadre and t1.codigo = t2.codigo where t2.codigo is null

open cur_bonificaciones_bazar

fetch next from cur_bonificaciones_bazar into @segto, @ctepadre, @codigo, @bonificacion, @techo

while @@fetch_status = 0
begin
	delete from bazar_bonificaciones where segto = @segto and ctepadre =  @ctepadre and codigo = @codigo
	fetch next from cur_bonificaciones_bazar into @segto, @ctepadre, @codigo, @bonificacion, @techo
end
close cur_bonificaciones_bazar 
deallocate cur_bonificaciones_bazar


drop table #bazar_bonificaciones

GO
