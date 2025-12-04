CREATE procedure [dbo].[usp_reporte_agentes]
as

set nocount on


select * into #pedidos_hist from openquery(marzamtij, 'select * from pedidos_hist where ped_fecha >= dateadd(day, -1, getdate())')
select * into #detalle_pedidos_hist from openquery(marzamtij, 'select t2.* from pedidos_hist t1 inner join detalle_pedidos_hist t2 on t1.suc_id = t2.suc_id and t1.agen_id = t2.agen_id and t1.ped_id = t2.ped_id where t1.ped_fecha >= dateadd(day, -1, getdate())')
select * into #agente from openquery(marzamtij, 'select * from agente')
select * into #clientes from openquery(marzamtij, 'select * from clientes')
select * into #sucursal from openquery(marzamtij, 'select * from sucursal')
select * into #productos_v from openquery(marzamtij, 'select * from productos_v')

create index idx_tmp_agente1 on #agente(suc_id, agen_id)
create index idx_tmp_agente2 on #agente(agen_nombre)
create index idx_tmp_agente3 on #agente(ultima_sinc)
create index idx_tmp_clientes1 on #clientes(suc_id, agen_id, cte_id)
create index idx_tmp_clientes2 on #clientes(cte_cod)
create index idx_tmp_clientes3 on #clientes(cte_status)
create index idx_tmp_clientes4 on #clientes(suc_id, agen_id)
create index idx_tmp_clientes5 on #clientes(cte_nombre)
create index idx_tmp_clientes6 on #clientes(suc_id, cte_id, agen_id, cte_nombre, cte_cod)
create index idx_tmp_clientes7 on #clientes(suc_id, agen_id, cte_nombre, cte_cod)
create index idx_tmp_pedidos_hist1 on #pedidos_hist(suc_id, agen_id, ped_id)
create index idx_tmp_pedidos_hist2 on #pedidos_hist(suc_id, agen_id, cte_id)
create index idx_tmp_sucursal on #sucursal(suc_id)
create index idx_tmp_detalle_pedidos_hist1 on #detalle_pedidos_hist(suc_id, agen_id, ped_id)
create index idx_tmp_detalle_pedidos_hist2 on #detalle_pedidos_hist(prod_id)
create index idx_tmp_productos_v on #productos_v(suc_id, prod_id)


select 
t4.suc_descripcion [Sucursal], 
t1.agen_cod [Agente], 
t1.agen_nombre [Nombre], 
t2.cte_cod [Cliente], 
t2.cte_nombre [Farmacia], 
t3.ped_captura [Fecha y hora], 
t1.ultima_sinc [Ultima sincronizacion], 
sum(t6.prod_pre_far * t5.cantidad) [Monto bruto aproximado] 
into #temporal 
from 
#agente t1 inner join #clientes t2 on t1.suc_id = t2.suc_id and t1.agen_id = t2.agen_id 
inner join #pedidos_hist t3 on t2.suc_id = t3.suc_id and t2.agen_id = t3.agen_id and t2.cte_id = t3.cte_id 
inner join #sucursal t4 on t1.suc_id = t4.suc_id 
inner join #detalle_pedidos_hist t5 on t3.suc_id = t5.suc_id and t3.agen_id = t5.agen_id and t3.ped_id = t5.ped_id 
inner join #productos_v t6 on t5.suc_id = t6.suc_id and t5.prod_id = t6.prod_id 
group by 
t4.suc_descripcion, 
t1.agen_cod, 
t1.agen_nombre, 
t2.cte_cod, 
t2.cte_nombre, 
t3.ped_captura, 
t1.ultima_sinc 
order by 
t4.suc_descripcion, 
t1.agen_cod, 
t3.ped_captura

select 
t4.suc_descripcion [Sucursal],  
t1.agen_cod [Agente],  
t1.agen_nombre [Nombre],
t2.cte_cod [Cliente], 
t2.cte_nombre [Farmacia], 
t5.[Fecha y hora], 
t1.ultima_sinc [Ultima sincronizacion], 
t5.[Monto bruto aproximado] 
from 
#agente t1 inner join #clientes t2 on t1.suc_id = t2.suc_id and t1.agen_id = t2.agen_id 
inner join #sucursal t4 on t1.suc_id = t4.suc_id 
left outer join #temporal t5 on t1.agen_cod = t5.agente and t2.cte_cod = t5.cliente 
where t2.cte_status = 'A' and t1.agen_nombre <> 'AGENTE BAJA' and t1.ultima_sinc > dateadd(dd, -5, getdate())

drop table #temporal
drop table #pedidos_hist 
drop table #detalle_pedidos_hist 
drop table #agente
drop table #clientes
drop table #sucursal
drop table #productos_v

set nocount off

GO

