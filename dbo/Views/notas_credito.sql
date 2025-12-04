





CREATE view [dbo].[notas_credito]
as
select
t1.sucursal,
t1.serie,
t1.folio_docufact folio,
t1.cliente,
t1.segto,
t1.ctepadre,
t1.rfc,
t1.fecha_tandem fecha,
t1.timestamp
,t1.tipo_nota,
t3.farmacia
from
historica.dbo.notas_credito t1 
inner join sucursales t2 on t1.sucursal = t2.sucursal
inner join clientes_baan t3 on 
	t1.sucursal = t2.sucursal and t3.cliente = t1.cliente
--where
/*(t2.sistema = 'ibs'  and substring(tipo_nota, 1, 2) in ('NA', 'ND', 'NM', 'NH', 'NV', 'NZ', 'NR', 'NT', 'NF')) or
(t2.sistema = 'baan' and substring(tipo_nota, 1, 2) in ('C2', 'C3', 'C6'))
*/
--substring(tipo_nota, 1, 2) in ('NA', 'ND', 'NM', 'NH', 'NV', 'NZ', 'NR', 'NT', 'NF','C2', 'C3', 'C6')
--or substring(tipo_nota, 1, 2) in ('C2', 'C3', 'C6')

GO

