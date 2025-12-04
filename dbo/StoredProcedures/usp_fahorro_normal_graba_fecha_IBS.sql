CREATE PROCEDURE usp_fahorro_normal_graba_fecha_IBS
	@fecha varchar(10), 
	@segto varchar(2),
	@ctepadre varchar(3)
as
--declare @fecha varchar(10) 
--declare @segto varchar(2)
--declare @ctepadre varchar(3)
--set @fecha = '2012-07-10'
--set @segto = 'C1'
--set @ctepadre = '007'
select	distinct 
		cuenta_estilo_ahorro,
		cuenta cliente, 
		convert(int, orden) orden, 
		sucursal
into	#t1
from	pedidos_spt_fahorro 
where	remisionado = 1 and 
		timestamp between dateadd(dd, -1, convert(datetime, @fecha, 121)) and convert(datetime, @fecha)
select	distinct 
		sucursal,
		factura,
		cliente,
		convert(int, orden) orden
into	#t2
from	encabezado t1
where	segto = @segto and ctepadre = @ctepadre and fecha_tandem = @fecha
select	t3.ibs_letra + t1.cliente, 
		t2.factura 
from	#t1 t1 inner join #t2 t2 on
		t1.sucursal = t2.sucursal and
		t1.cliente = t2.cliente and
		t1.orden = t2.orden inner join sucursales t3 on
		t1.sucursal = t3.sucursal
drop table #t1		
drop table #t2

GO

