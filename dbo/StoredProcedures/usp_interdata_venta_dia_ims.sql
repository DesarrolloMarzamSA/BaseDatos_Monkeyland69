CREATE procedure [dbo].[usp_interdata_venta_dia_ims]
	@fecha datetime,
	@sucursal_interdata tinyint WITH RECOMPILE
as
declare @x_Dummy varchar(50)

--declare @x_Dummy varchar(50)
--declare @fecha datetime
--declare @sucursal_interdata tinyint
--set @fecha = '2011-06-29'
--set @sucursal_interdata =2

select	t3.suc_interdata suc_interdata,
			t1.cliente cliente,
			t2.codigos codigos,
			sum(t2.cant_ped) cant_ped,
			sum(	case 
						t2.cant_base when 0 then 0 
						else (t2.cant_ped / t2.cant_base) * t2.cant_ofert 
					end) cant_ofertada,
			t4.cod_barras 
into		#x_tabla1
from		encabezado t1 inner join detalle t2 on 
			t1.sucursal = t2.sucursal and 
			t1.factura = t2.factura inner join sucursales t3 on 
			t1.sucursal = t3.sucursal inner join maestro_productos_baan t4 on
			substring(t2.codigos, 3, 7) = t4.codigo
where	t1.cliente <> '00000' and
			substring(t2.codigos, 3, 2) <> '99' and 
			fechaprog  = convert(datetime, convert(varchar(10), @fecha, 121), 121) and 
			t2.dest_det = 'AAA' and 
			t3.suc_interdata = @sucursal_interdata and
			not ((t1.sucursal = 17 and t1.cliente = '12385') or
			(t1.sucursal = 18 and t1.cliente = '32165') or
			(t1.sucursal = 19 and t1.cliente = '32128'))
group by 
			t1.fechaprog,
			t3.suc_interdata,
			t1.cliente, 
			t2.codigos,
			t4.cod_barras
having	sum(t2.cant_ped) > 0
select	@x_Dummy = (	select	distinct 
												case
													when t1.suc_interdata = 2 then '  A'
													else right(replicate('0', 3) + convert(varchar(3), t1.suc_interdata), 3)
												end + 
												replicate('0', 8) +
												right(replicate('0', 6) + convert(varchar(6), count(t1.suc_interdata)), 6) +
												right(replicate('0', 7) + convert(varchar(7), sum(t1.cant_ped)), 7) +
												right(replicate('0', 6) + convert(varchar(6), convert(int, sum(t1.cant_ofertada))), 6)
									from		#x_tabla1 t1
									group by 
												t1.suc_interdata)
select	case
				when t1.suc_interdata = 2 then '  A'
				else right(replicate('0', 3) + convert(varchar(3), t1.suc_interdata), 3)
			end + 
			left(t1.cliente + replicate('0', 7), 7) + 
			right(replicate('0', 7) + t1.codigos, 7) + 
			right(replicate('0', 7) + convert(varchar(7), convert(int, t1.cant_ped)), 7) + 
			right(replicate('0', 6) + convert(varchar(6), convert(int, cant_ofertada)), 6) x_Valor
			--left(convert(varchar(13), convert(bigint, t1.cod_barras)) + replicate(' ', 13), 13) x_Valor
into		#x_tabla2
from		#x_tabla1 t1
order by
			t1.cliente, t1.codigos
select	@x_Dummy
union all
select	* 
from		#x_tabla2

drop table #x_tabla1
drop table #x_tabla2

GO

