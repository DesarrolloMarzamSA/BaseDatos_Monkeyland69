CREATE procedure [dbo].[usp_interdata_catalogo_clientes_ims]
	@x_FechaInicial datetime,
	@x_FechaFinal datetime WITH RECOMPILE
as
--declare @x_FechaInicial datetime
--declare @x_FechaFinal datetime
--set @x_FechaInicial = '31-07-2010'
--set @x_FechaFinal = '31-07-2010'
/*
select	t3.suc_interdata sucursal,
			t1.cliente cliente
into		#x_table1			
from		encabezado t1 inner join detalle t2 on t1.sucursal = t2.sucursal 
			and t1.factura = t2.factura inner join sucursales t3 on 
			t1.sucursal = t3.sucursal 
where	t1.cliente <> '00000' and
			substring(t2.codigos, 3, 2) <> '99' and
			fechaprog between convert(datetime, convert(varchar(10), @x_FechaInicial, 121), 121) and convert(datetime, convert(varchar(10), @x_FechaFinal, 121), 121) and
			t2.dest_det = 'AAA' and 
			not ((t1.sucursal = 17 and t1.cliente = '12385') or
			(t1.sucursal = 18 and t1.cliente = '32165') or
			(t1.sucursal = 19 and t1.cliente = '32128'))
group by 
			t1.fechaprog,
			t3.suc_interdata,
			t1.cliente, 
			t2.codigos
having	sum(t2.cant_ped) > 0
select	t2.suc_interdata sucursal, 
			t1.cliente cliente,
			t1.farmacia farmacia,
			t1.direccion direccion,
			t1.colonia colonia,
			t1.poblacion poblacion, 
			t1.cve_estado cve_estado, 
			t1.codigo_postal codigo_postal,
			t1.rfc rfc
into 		#x_table2	
from		clientes_baan t1 inner join sucursales t2 on
			t1.sucursal = t2.sucursal
where	t1.cliente <> '00000'
select	distinct
			right('000' + convert(varchar(3), case convert(varchar(3), t1.sucursal) when 2 then '  A' else convert(varchar(3), t1.sucursal) end), 3) + 
			t1.cliente +
			left(t2.farmacia + replicate(' ', 40), 40) +
			left(t2.direccion + replicate(' ', 40), 40) +
			left(t2.colonia +replicate(' ', 25), 25) +
			left(t2.poblacion + replicate(' ', 15), 15) +
			right(replicate('0', 3) + replace(t2.cve_estado, ' ', ''), 3) +
			right(replicate('0', 5) + replace(t2.codigo_postal, ' ', ''), 5) +
			'00' + 
			right(replicate(' ', 13) + replace(t2.rfc, ' ', ''), 13) x_Dummy
into		#x_table3
from		#x_table1 t1 inner join #x_table2 t2 on 
			t1.sucursal = t2.sucursal and 
			t1.cliente = t2.cliente
select	*
from		#x_table3
order by
			substring(x_dummy, 1, 3)

drop table #x_table1
drop table #x_table2
drop table #x_table3
*/

select	t3.suc_interdata sucursal,
			t1.cliente cliente
into		#x_table1			
from		encabezado t1 inner join detalle t2 on t1.sucursal = t2.sucursal 
			and t1.factura = t2.factura inner join sucursales t3 on 
			t1.sucursal = t3.sucursal 
where	t1.cliente <> '00000' and
			substring(t2.codigos, 3, 2) <> '99' and
			fechaprog between convert(datetime, convert(varchar(10), @x_FechaInicial, 121), 121) and convert(datetime, convert(varchar(10), @x_FechaFinal, 121), 121) and
			t2.dest_det = 'AAA' and 
			not ((t1.sucursal = 17 and t1.cliente = '12385') or
			(t1.sucursal = 18 and t1.cliente = '32165') or
			(t1.sucursal = 19 and t1.cliente = '32128'))
group by 
			t1.fechaprog,
			t3.suc_interdata,
			t1.cliente, 
			t2.codigos
having	sum(t2.cant_ped) > 0
select	t2.suc_interdata sucursal, 
			t1.cliente cliente,
			t1.farmacia farmacia,
			de.direccion  direccion,			
			--de.degmun poblacion, 
			t1.poblacion poblacion,
			t1.cve_estado cve_estado, 
			t1.codigo_postal codigo_postal,
			t1.rfc rfc
into 		#x_table2	
from		clientes_baan t1 inner join sucursales t2 on
			t1.sucursal = t2.sucursal inner join vw_direccionentrega de on t1.cliente_ibs=de.decliente_ibs
where	t1.cliente <> '00000' 

select	distinct
			right('000' + convert(varchar(3), case convert(varchar(3), t1.sucursal) when 2 then '  A' else convert(varchar(3), t1.sucursal) end), 3) + 
			t1.cliente +
			left(t2.farmacia + replicate(' ', 40), 40) +
			left(t2.direccion + replicate(' ', 65), 65) +			
			left(t2.poblacion + replicate(' ', 15), 15) +
			right(replicate('0', 3) + replace(t2.cve_estado, ' ', ''), 3) +
			right(replicate('0', 5) + replace(t2.codigo_postal, ' ', ''), 5) +
			'00' + 
			right(replicate(' ', 13) + replace(t2.rfc, ' ', ''), 13) x_Dummy
into		#x_table3
from		#x_table1 t1 inner join #x_table2 t2 on 
			t1.sucursal = t2.sucursal and 
			t1.cliente = t2.cliente
select	*
from		#x_table3
order by
			substring(x_dummy, 1, 3)

drop table #x_table1
drop table #x_table2
drop table #x_table3

GO

