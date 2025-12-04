USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_genera_facturacion_electronica_fcias_carer_encabezado]
	@sucursal int,
	@fecha datetime,
	@segto varchar(10),
	@ctepadre varchar(10),
	@cliente varchar(5),
	@folio_fiscal varchar(10)
WITH ENCRYPTION
as
	declare @brutoieps varchar(12)
	declare @total_renglones char(3)

--declare @total_renglones char(3)
--declare @folio_fiscal varchar(10)	
--declare @brutoieps varchar(15) 
--declare @sucursal int
--declare @fecha datetime
--declare @segto varchar(10)
--declare @ctepadre varchar(10)
--declare @cliente varchar(5)
--set @sucursal = 7
--set @fecha = '2011-04-25'
--set @segto = 'C1'
--set @ctepadre = '868'
--set @cliente = '08033'
--set @folio_fiscal = '00564080'


select	@total_renglones = right(replicate('0', 3) + convert(varchar(3), count(*)), 3)
from		facturacion_electronica_estandar t1 --inner join maestro_productos t2 on
			--convert(bigint, t1.cod_barras) = convert(bigint, t2.cod_barras)
where 	--t1.fecha_factura = convert(datetime, convert(varchar(10), @fecha, 121), 121) and 
			t1.fecha_tandem = convert(datetime, convert(varchar(10), @fecha, 121), 121) and 
			t1.segto in('C1','A1') and 
			t1.ctepadre = @ctepadre and
			--t1.tipo_documento = 'r' and   
			t1.sucursal = @sucursal and
			t1.cliente = @cliente and
			isnumeric(t1.cod_barras)  = 1 and
			--isnumeric(t2.cod_barras)  = 1 and
			t1.folio_fiscal = @folio_fiscal 
			--and t2.cod_barras is not null 
			--and t2.grupo_est in ('PC01G', 'PC01A')
			
select	@brutoieps = right(replicate('0', 10) + convert(varchar, sum((convert(bigint, isnull(t1.importe_bruto,0) * 100) - convert(bigint, isnull(t1.descto_oferta, 0) * 100)) / 2)), 10)
from		facturacion_electronica_estandar t1 inner join maestro_productos t2 on
			convert(bigint, t1.cod_barras) = convert(bigint, t2.cod_barras)
where 	--t1.fecha_factura = convert(datetime, convert(varchar(10), @fecha, 121), 121) and 
			t1.fecha_tandem >= convert(datetime, convert(varchar(10), @fecha, 121), 121) and 
			t1.segto in('C1','A1') and 
			t1.ctepadre = @ctepadre and
			--t1.tipo_documento = 'r' and   
			t1.sucursal = @sucursal and
			t1.cliente = @cliente and
			isnumeric(t1.cod_barras)  = 1 and
			isnumeric(t2.cod_barras)  = 1 and
			t1.folio_fiscal = @folio_fiscal and
			t2.cod_barras is not null and
			t2.grupo_est in ('PC01G', 'PC01A')

select	'F' +
			right(replicate('0', 5) + t1.cliente, 5) +
			right(replicate('0', 8) + convert(varchar(8), convert(bigint, t1.folio_fiscal)), 8) +
			replace(convert(varchar(8), t1.fecha_factura, 3), '/', '') +
			--replace(convert(varchar(8), t1.fecha_factura + 30, 3), '/', '') +
			'000000' + 
			right(replicate('0', 8) + convert(varchar(8), substring(t1.orden, 3, 8)), 8) +
			--replicate('0', 8)  +
			@total_renglones + 
			right(replicate('0', 6) + convert(varchar(6), sum(t1.piezas_surtidas_con_cargo)), 6) +  
			right('0000000000' + convert(varchar, isnull(sum(case when t1.clas_fis = 'N' then isnull(convert(bigint, t1.importe_bruto*100),0)-isnull(convert(bigint, descto_oferta*100),0) end),0) +  
			isnull(sum(case when t1.clas_fis = 'B' then isnull(convert(bigint, t1.importe_bruto*100),0)-isnull(convert(bigint, t1.descto_oferta*100),0) end),0) +  
			isnull(sum(case when t1.clas_fis = 'H' then isnull(convert(bigint, t1.importe_bruto*100),0)-isnull(convert(bigint, t1.descto_oferta*100),0) end),0) +
			isnull(sum(case when t1.clas_fis = 'NA' then convert(bigint, t1.importe_bruto-descto_oferta*100) end),0) +
			isnull(sum(case when t1.clas_fis = 'BA' then convert(bigint, t1.importe_bruto-descto_oferta*100) end),0) +
			isnull(sum(case when t1.clas_fis = 'HA' then convert(bigint, t1.importe_bruto-descto_oferta*100) end),0) + 
			convert(bigint, sum(t1.iva)*100)), 10) + -- as grantotal , --gran total
			case
				when @brutoieps is not null then @brutoieps
				when @brutoieps is null then replicate('0', 8)
			end +
			right(replicate('0', 8) + convert(varchar, convert(bigint, sum(t1.iva) * 100)), 8) + --as iva15_2 , --iva 15%
			right(replicate('0', 8) + convert(varchar, convert(bigint, sum(t1.descto_comercial) * 100)), 8) +
			replicate('0', 8)
from		facturacion_electronica_estandar t1 
where	--	t1.fecha_factura = convert(datetime, convert(varchar(10), @fecha, 121), 121) and 
			t1.fecha_tandem >= convert(datetime, convert(varchar(10), @fecha, 121), 121) and 
			t1.segto in('C1','A1') and  
			t1.ctepadre = @ctepadre and
			--t1.tipo_documento = 'r' and   
			t1.sucursal = @sucursal and
			t1.cliente = @cliente and
			t1.folio_fiscal = @folio_fiscal
group by 
			t1.cliente,
			t1.folio_fiscal,
			t1.fecha_factura,
			t1.orden

GO
