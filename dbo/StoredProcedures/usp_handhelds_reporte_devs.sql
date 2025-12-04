
CREATE procedure [dbo].[usp_handhelds_reporte_devs]
as

select suc_descripcion, agen_cod, agen_nombre, cte_cod, cte_nombre, dev_num_marzam into #devs from openquery([marzamtij], '
select 
t4.suc_descripcion,
t3.agen_cod,
convert(varchar(100), replace(t3.agen_nombre, '','', '''')) agen_nombre,
t2.cte_cod,
convert(varchar(100), replace(t2.cte_nombre, '','', '''')) cte_nombre,
t1.dev_num_marzam
from
devoluciones t1 inner join clientes t2 on t1.suc_id = t2.suc_id and t1.cte_id = t2.cte_id
inner join agente t3 on t2.suc_id = t3.suc_id and t2.agen_id = t3.agen_id
inner join sucursal t4 on t1.suc_id = t4.suc_id
where
t1.dev_captura > dateadd(day, -1, getdate())')



select t1.suc_descripcion, t1.agen_cod, t1.agen_nombre, t1.cte_cod, t1.cte_nombre, t1.dev_num_marzam, isnull(t2.ruta, '    ') ruta from #devs t1 left outer join clientes_baan t2 on t1.cte_cod = t2.letra + t2.cliente order by t1.suc_descripcion, t2.ruta



drop table #devs

GO

