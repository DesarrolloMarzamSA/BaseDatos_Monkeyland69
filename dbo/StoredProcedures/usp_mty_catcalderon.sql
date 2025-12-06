
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_mty_catcalderon]

as
set nocount on
create table #resultados(orden int identity(1,1), texto varchar(250))

insert into #resultados(texto) values('CODIGO,BARRAS,PRODUCTO,P. FARMACIA')

insert into #resultados
select 
t1.codigo + ',' +
t1.cod_barras + ',' +
replace(t1.descripcion, ',', ' ') + ',' +
convert(varchar(12), t1.prec_farm)
from
maestro_productos_baan t1 inner join inventario_baan t2 on t1.codigo = t2.codigo
where 
t2.sucursal = 7 and
t2.piezas > 0 and
t1.clas_ssa in ('1', '2', '3') and
convert(int, t1.codigo) < dbo.gobierno()
order by
t1.descripcion

select texto from #resultados

drop table #resultados

set nocount off
GO
