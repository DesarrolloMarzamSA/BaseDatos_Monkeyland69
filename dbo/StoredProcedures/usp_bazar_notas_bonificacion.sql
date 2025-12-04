SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_bazar_notas_bonificacion]  
as  
set nocount on

exec usp_bazar_bonificaciones
declare @cliente char(5)
declare @folio_fiscal char(8)
declare @encabezado char(250)
declare @pie char(250)
declare @monto money
declare @iva money

create table #resultados(orden int identity(1,1), cliente char(5), folio_fiscal char(8), monto money, iva money, reporte char(250))
create table #presentacion(orden int identity(1,1), reporte char(250))
select @encabezado = 'cliente,farmacia                           ,factura ,fecha     ,codigo ,cod_barras   ,nom_prod                           ,importe   ,desc.conf.,monto     ,iva       ,ieps      ,iva_ieps  '

insert into #resultados(cliente, folio_fiscal, monto, iva, reporte)
select  
t1.cliente,
t1.folio_fiscal,
convert(decimal(7, 2), round(round(convert(money, isnull(t2.bonificacion, 0) * (t1.importe_bruto - t1.descto_comercial - descto_oferta)), 2), 2)),
convert(decimal(7, 2), round(t1.iva, 2)),
t1.cliente + '  ,' +
left(replace(replace(t3.farmacia, ',', ''), '''', '') + replicate(' ', 35), 35) + ',' + 
t1.folio_fiscal + ',' +
convert(varchar(10), t1.fecha_factura, 121) + ',' +
t1.codigo + ',' +  
left(t1.cod_barras + '             ', 13) + ',' +  
left(replace(replace(t1.descripcion, ',', ''), '''', '') + replicate(' ', 35), 35) + ',' + 
right('          ' + convert(varchar(10), convert(decimal(7, 2), round(t1.importe_bruto - t1.descto_comercial - descto_oferta, 2))), 10) + ',' +
right('          ' + convert(varchar(10), convert(decimal(7, 2), round(isnull(t2.bonificacion, 0) * 100, 2))), 10) + ',' +
right('          ' + convert(varchar(10), convert(decimal(7, 2), round(round(convert(money, isnull(t2.bonificacion, 0) * (t1.importe_bruto - t1.descto_comercial - descto_oferta)), 2), 2))), 10) + ',' +
right('          ' + convert(varchar(10), convert(decimal(7, 2), round(t1.iva, 2))), 10) + ',' +
right('          ' + convert(varchar(10), convert(decimal(7, 2), round(t1.ieps, 2))), 10) + ',' +
right('          ' + convert(varchar(10), convert(decimal(7, 2), round(t1.iva_del_iesps, 2))), 10)
from  
facturacion_electronica_estandar  t1 left outer join bazar_bonificaciones_clientes t2 on t1.sucursal = t2.sucursal and t1.cliente = t2.cliente and t1.codigo = t2.codigo  
left outer join clientes_baan t3 on t1.sucursal = t3.sucursal and t1.cliente = t3.cliente  
where  
t1.fecha_tandem = convert(datetime, convert(varchar(10), current_timestamp, 121) , 121) and 
--t1.fecha_tandem = convert(datetime, '2011-07-05', 121) and 
t1.segto = 'C2' and t1.ctepadre = '468' and not (t1.sucursal = 13 and t1.cliente = '14530') 


declare cursor_resultados_bazar cursor fast_forward for select cliente, folio_fiscal, sum(monto) monto, sum(iva) iva from #resultados group by cliente, folio_fiscal
open cursor_resultados_bazar
fetch next from cursor_resultados_bazar into @cliente, @folio_fiscal, @monto, @iva

while @@fetch_status = 0
begin
	set @pie = '       ,      ,                            ,        ,          ,       ,                                   ,TOTAL     ,' + right('          ' + convert(varchar(10), convert(decimal(7, 2), round(@monto, 2))), 10) + ',' + right('          ' + convert(varchar(10), convert(decimal(7, 2), round(@iva, 2))), 10) + ',          ,          ,          '
	insert into #presentacion(reporte) values(@encabezado)
	insert into #presentacion(reporte) select reporte from #resultados where cliente = @cliente and folio_fiscal = @folio_fiscal
	insert into #presentacion(reporte) values(@pie)
	fetch next from cursor_resultados_bazar into @cliente, @folio_fiscal, @monto, @iva
end

close cursor_resultados_bazar 
deallocate cursor_resultados_bazar

select reporte from #presentacion order by orden

drop table #resultados
drop table #presentacion
set nocount off







GO
