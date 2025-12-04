CREATE PROCEDURE [dbo].[usp_facturacion_klyns]
	@sucursal int,
	@cliente varchar(5),
	@folio_fiscal varchar(10),
	@segto varchar(10),
	@ctepadre varchar(10),
	@orden char(16),
	@mafnarch char(8),
	@fecha datetime,
	@proveedor varchar(5)
as
	declare @total_renglones char(10)
	declare @importesiva varchar(20)
	declare @importeiva varchar(20)

--declare @total_renglones char(10)
--declare @folio_fiscal varchar(10)
--declare @importesiva varchar(20)
--declare @importeiva varchar(20)
--declare @sucursal int
--declare @fecha datetime
--declare @segto varchar(10)
--declare @ctepadre varchar(10)
--declare @cliente varchar(5)
--declare @orden char(16)
--declare @mafnarch char(8)
--declare @proveedor varchar(5)
--set @sucursal = 7
--set @cliente = '06296'
--set @folio_fiscal = '00909853'
--set @segto = 'C2'
--set @ctepadre = '325'
--set @orden = 'E000001938'
--set @mafnarch = 'PZ700701'
--set @fecha = '2012-02-24'
--set @proveedor = '34879'

select	@total_renglones = right(replicate('0', 10) + convert(varchar(10), count(*)), 10)
from	encabezado t1 inner join detalle t2 on
		t1.sucursal =  t2.sucursal and
		t1.factura = t2.factura
where	t1.sucursal = @sucursal and
		t1.cliente = @cliente and
		t2.factura = @folio_fiscal and
		t1.orden = @orden and
		t1.mafnarch = @mafnarch and
		t1.fecha_tandem = @fecha and
		t2.dest_det = 'AAA'
select	@importesiva = right(replicate('0', 20) + convert(varchar(20), isnull(sum(case when t1.clas_fis = 'N' then isnull(convert(bigint, t1.importe_bruto*100),0)-isnull(convert(bigint, descto_oferta*100),0) end),0) +  
		isnull(sum(case when t1.clas_fis = 'B' then isnull(convert(bigint, t1.importe_bruto*100),0)-isnull(convert(bigint, t1.descto_oferta*100),0) end),0) +  
		isnull(sum(case when t1.clas_fis = 'H' then isnull(convert(bigint, t1.importe_bruto*100),0)-isnull(convert(bigint, t1.descto_oferta*100),0) end),0) +
		isnull(sum(case when t1.clas_fis = 'NA' then convert(bigint, t1.importe_bruto - descto_oferta*100) end),0) +
		isnull(sum(case when t1.clas_fis = 'BA' then convert(bigint, t1.importe_bruto - descto_oferta*100) end),0) +
		isnull(sum(case when t1.clas_fis = 'HA' then convert(bigint, t1.importe_bruto - descto_oferta*100) end),0) + 
		convert(bigint, sum(t1.iva)*100)), 20) -- as grantotal
from	facturacion_electronica_estandar t1
where	t1.sucursal = @sucursal and
		t1.cliente = @cliente and
		t1.factura = @folio_fiscal and
		t1.orden = @orden and
		t1.fecha_tandem = @fecha
select	@importeiva = right(replicate('0', 20) + convert(varchar(20), convert(bigint, sum(t1.iva) * 100)), 20) --as iva15_2 , --iva 15%
from	facturacion_electronica_estandar t1
where	t1.sucursal = @sucursal and
		t1.cliente = @cliente and
		t1.factura = @folio_fiscal and
		t1.orden = @orden and
		t1.fecha_tandem = @fecha
select	'E', 'E' + 
		convert(varchar(8), @fecha, 112) +
		right(replicate('0', 14) + convert(varchar(14), t1.eordencompra), 14) +
		right(replicate('0', 4) + convert(varchar(4), t1.esucursal), 4) +
		right(replicate('0', 10) + convert(varchar(10), t1.codigo_farmacia), 10) +
		right(replicate('0', 10) + convert(varchar(10), t1.orden), 10) + 
		right(replicate('0', 15) + convert(varchar(15), t2.factura), 15) + 
		right(replicate('0', 10) + convert(varchar(10), @proveedor), 10) +
		@total_renglones +
		@importesiva +
		@importeiva +
		right(replicate('0', 20) + convert(varchar(20), ((convert(bigint, @importesiva)) + (convert(bigint, @importeiva)))), 20)
from	klyns_facturacion t1 inner join encabezado t2 on
		t1.sucursal = t2.sucursal and
		t1.cliente = t2.cliente and
		t1.arch_tandem = t2.mafnarch and
		t1.orden = t2.orden
where	t1.sucursal = @sucursal and
		t1.cliente = @cliente and
		t2.factura = @folio_fiscal and
		t1.orden = @orden and
		t2.mafnarch = @mafnarch
union all
select	'D',
		right(replicate('0', 16) + convert(varchar(16), isnull(t2.refklyns, '0000000000000000')), 16) +
		right(replicate('0', 16) + convert(varchar(16), t1.cod_barras), 16) +
		right(replicate('0', 16) + convert(varchar(16), t1.codigo), 16) +
		right(replicate('0', 18) + convert(varchar(18), t1.precio_farm_sin_imp), 18) +
		right(replicate('0', 5) + convert(varchar(5), t1.porcentaje_descto_comercial), 5) +
		'00.00' + 
		'00.00' +
		right(replicate('0', 5) + convert(varchar(5), t1.porcentaje_descto_oferta), 5) +
		right(replicate('0', 5) + convert(varchar(5), t1.porcentaje_iva), 5) +
		right(replicate('0', 10) + convert(varchar(10), convert(int, t1.piezas_surtidas_con_cargo)), 10) +
		right(replicate('0', 18) + convert(varchar(18), t1.precio_farm_sin_imp), 18) +
		right(replicate('0', 18) + convert(varchar(18), t1.precio_farm_sin_imp), 18) +
		case
			when t1.porcentaje_iva > 0.00 then right(replicate('0', 18) + convert(varchar(18), t1.precio_farm_sin_imp * (1 + (t1.porcentaje_iva / 100))), 18)
			else right(replicate('0', 18) + convert(varchar(18), t1.precio_farm_sin_imp), 18)
		end
from	facturacion_electronica_estandar t1 left join catalogo_klyns t2 on
		t1.codigo = t2.codigo
where	t1.sucursal = @sucursal and
		t1.cliente = @cliente and
		t1.factura = @folio_fiscal and
		t1.orden = @orden and
		t1.fecha_tandem = @fecha

GO

