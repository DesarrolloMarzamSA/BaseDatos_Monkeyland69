
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



CREATE procedure [dbo].[usp_fabc_mty_fact_elec] @fecha as char(10)
WITH ENCRYPTION
as
set nocount on
create table #resultados_pre(texto varchar(150))
create table #resultados(texto varchar(150))

declare @encabezadoa varchar(150)
declare @encabezadoe varchar(150)

declare @sucursal tinyint
declare @folio_fiscal char(8)
declare @fecha_tandem datetime
declare @cliente char(5)
declare @farmacia varchar(50)
declare @orden varchar(25)
declare @Total_Factura_Iva money
declare @Bonf_IEPS money
declare @piezas_surtidas_con_cargo int
declare @bonificacion_iva money
declare @descto_comercial money
declare @articulos int

declare @registros int


select 
t1.sucursal, 
t1.folio_fiscal,
t1.fecha_tandem,
t1.cliente,
t1.importe_bruto - t1.descto_oferta [Total Factura – Iva],
t1.iva,
t1.piezas_surtidas_con_cargo,
t1.bonificacion_iva,
t1.descto_comercial,
t2.farmacia,
t1.orden,
'D' +
right(t1.folio_fiscal, 7) +
right('0000000' + convert(varchar(6), t1.piezas_surtidas_con_cargo), 7) +
right('0000000000' + convert(varchar(10), convert(int, t1.precio_farm_sin_imp * 100)), 10) +
right('0000' + convert(varchar(5), convert(int, t1.porcentaje_descto_oferta * 100)), 4) +
right('0000' + convert(varchar(5), convert(int, t1.porcentaje_descto_comercial)), 4) + 
right('0000000000' + convert(varchar(10), convert(int, t1.iva * 100)), 10) + 
'0000000000' +
right('0000000000' + convert(varchar(10), convert(int, t1.importe_bruto * 100)), 10) +
right('0000000000000' + t1.cod_barras, 13) +
' ' +
right('0000000000' + convert(varchar(10), convert(int, t1.precio_pub_sin_imp * 100)), 10) +
right('00000' + convert(varchar(5), t1.piezas_surtidas_sin_cargo), 5) +
right(t1.folio_fiscal, 7) +
left(t1.descripcion + replicate(' ', 30), 30) texto
into #feabc
from facturacion_electronica_estandar t1 with(nolock) inner join clientes_baan t2 with(nolock) on t1.sucursal = t2.sucursal and t1.cliente = t2.cliente
--from historica.dbo.fes t1 with(nolock) inner join clientes_baan t2 with(nolock) on t1.sucursal = t2.sucursal and t1.cliente = t2.cliente
where 
t1.segto = 'C2' and 
t1.ctepadre = '167' and
t1.fecha_tandem = convert(smalldatetime, @fecha, 121)

declare cursor_fabc cursor fast_forward for select 
sucursal, 
folio_fiscal,
fecha_tandem,
cliente,
farmacia,
orden,
sum([Total Factura – Iva]) [Total Factura – Iva],
sum([iva]) [iva],
sum(piezas_surtidas_con_cargo) piezas_surtidas_con_cargo,
sum(bonificacion_iva) bonificacion_iva,
sum(descto_comercial) descto_comercial,
count(*) articulos
from
#feabc
group by
sucursal, 
folio_fiscal,
fecha_tandem,
cliente,
farmacia,
orden

open cursor_fabc
fetch next from cursor_fabc into @sucursal, @folio_fiscal, @fecha_tandem, @cliente, @farmacia, @orden, @Total_Factura_Iva, @Bonf_IEPS, @piezas_surtidas_con_cargo, @bonificacion_iva, @descto_comercial, @articulos

while @@fetch_status = 0
begin
	insert into #resultados_pre values('E' + 
	'00' + @cliente + 
	right(@folio_fiscal, 7) + 
	right('0000000000' + convert(varchar(10), convert(int, @Total_Factura_Iva * 100)), 10) +
	right('0000000000' + convert(varchar(10), convert(int, @Bonf_IEPS * 100)), 10) +
	'0000000000' +
	right('000000' + convert(varchar(6), @articulos), 6) +
	right('0000000000' + convert(varchar(10), convert(int, @bonificacion_iva * 100)), 10) +
	right('0000000000' + convert(varchar(10), convert(int, @descto_comercial * 100)), 10) +
	left(@farmacia + replicate(' ', 40), 39) +
	right('00000000' + ltrim(rtrim(@orden)), 8))
	
	insert into #resultados_pre select texto from #feabc where sucursal = @sucursal and folio_fiscal = @folio_fiscal
	
	fetch next from cursor_fabc into @sucursal, @folio_fiscal, @fecha_tandem, @cliente, @farmacia, @orden, @Total_Factura_Iva, @Bonf_IEPS, @piezas_surtidas_con_cargo, @bonificacion_iva, @descto_comercial, @articulos
end

close cursor_fabc
deallocate cursor_fabc

select @registros = count(*) from #resultados_pre

insert into #resultados values('A' + convert(varchar(8), convert(datetime, @fecha, 121), 11) + right('00000' + convert(varchar(5), @registros + 1), 5))
insert into #resultados select * from #resultados_pre

set nocount off
select * from #resultados




GO
