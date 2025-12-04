CREATE procedure usp_genera_reporte_venta_fahorro
	@fecha varchar(10),
	@segto varchar(12),
	@ctepadre varchar(3)
as
--declare @fecha varchar(10)
--declare @segto varchar(2)
--declare @ctepadre varchar(3)
--declare @sql varchar(2000)
--set @fecha = '2012-07-03' 
--set @segto = 'C1' 
--set @ctepadre = '007' 
--set @sql = ''
declare @sql varchar(2000)
set @sql = ''
select	t1.cuenta CLIENTE, 
		t1.sucursal, 
		t1.codigo CODIGO, 
		t1.cant_ped PIEZAS,
		t1.orden + '_' + t1.cuenta_estilo_ahorro + '.fac' ORDEN,
		@fecha FECHA
into	#t1
from	pedidos_spt_fahorro t1 inner join Capa_ibs.dbo.pedidos_traductor t2 on
		t1.sucursal = t2.sucursal and 
		t1.cuenta = t2.cliente and 
		t1.codigo = t2.codigo and 
		t1.arch_tandem = substring(archivo, 1, 8)
where	isnull(t2.motivo_no_surtido, '') = 'AAA' and
		convert(datetime, convert(varchar(10), timestamp, 121), 121) = convert(datetime, convert(varchar(10), dateadd(dd, -1, @fecha), 121), 121)
select	t1.cliente CLIENTE,
		t1.factura FACTURA,  
		t1.sucursal, 
		substring(t2.codigos, 3, 7) CODIGO, 
		t2.cant_surt PIEZAS,
		t2.prec_farm IMPORTE
into	#t2
from	encabezado t1 inner join detalle t2 on 
		t1.sucursal = t2.sucursal and 
		t1.factura = t2.factura
where	segto = @segto and ctepadre = @ctepadre and 
		fecha_tandem = convert(datetime, convert(varchar(10), @fecha, 121), 121)
select	@sql = '	SELECT	substring(SROLSTLS.LSCUNO, 2, 5) AS "CLIENTE",
							'''''''' AS "FACTURA",
							'''''''' ORDEN,
							SROLSTLS.LSPRDC AS "CODIGO",
							''''                                                  '''' AS "DESCRIPCION", 
							SROLSTLS.LSQTY  AS "PIEZAS",
							'''''''' AS "IMPORTE", 
							COALESCE(SROCTLLS.CTDESC,'''''''') AS "MOTIVO"
					FROM	MARZAMDES.Z1BLST AS SROLSTLS LEFT JOIN MA4620EF04.SROCTLLS AS SROCTLLS ON 
							SROCTLLS.CTLSRN = SROLSTLS.LSLSRN
					WHERE	SROLSTLS.LSLSDT >= '
		
select	@sql =	@sql + convert(varchar, dateadd(dd, -1,  convert(datetime, @fecha, 121)), 112) + 
				' AND SROLSTLS.LSLSDT < ' + convert(varchar, convert(datetime, @fecha, 121), 112) +
				' AND SROLSTLS.LSLSRN NOT IN (''''DIERR'''') AND SROLSTLS.LSCCA1 = ''''99007'''''
execute('select * into t1 from openquery(as400, ''' + @sql + ''')')
alter table t1
add FECHA varchar(10)
update	t1 set descripcion = t2.descripcion, fecha = @fecha 
from	t1 t1 inner join maestro_productos_baan t2 on
		t1.codigo = t2.codigo
select	t1.cliente CLIENTE,
		t2.factura FACTURA,
		t1.orden ORDEN,
		t1.codigo CODIGO, 
		t4.descripcion DESCRIPCION, 
		t1.piezas PIEZAS,
		t2.importe IMPORTE,
		'SURTIDO' MOTIVO,
		@fecha FECHA
from	#t1 t1 inner join #t2 t2 on
		t1.sucursal = t2.sucursal and
		t1.cliente = t2.cliente and
		t1.codigo = t2.codigo and
		t1.piezas = t2.piezas inner join sucursales t3 on
		t1.sucursal = t3.sucursal inner join maestro_productos_baan t4 on
		t1.codigo = t4.codigo
union all
select	* 
from	t1			  	
drop table #t1
drop table #t2
drop table t1

GO

