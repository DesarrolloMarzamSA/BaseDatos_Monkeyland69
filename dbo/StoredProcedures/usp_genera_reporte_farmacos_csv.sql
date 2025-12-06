
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_genera_reporte_farmacos_csv]

as

set nocount on
create table #resultado_rep_farmacos(id int identity(1,1), texto varchar(500))
insert into #resultado_rep_farmacos(texto) values(
'Mostrador,' +
'Codigo barras,' +
'Cantidad pedida,' +
'Numero pedido')

insert into #resultado_rep_farmacos(texto)
select right('00' + convert(varchar(2), sucursal), 2) + cuenta + ',' + cod_barras + ',' + convert(varchar(5), cantidad_pedida) + ',' + num_pedido  from pedidos_servidor_ftp_historia where nombre = 'FarmacosEsp' and fecha_pedido >= dateadd(d, -1, current_timestamp) order by right('00' + convert(varchar(2), sucursal), 2) + cuenta, cod_barras

select texto from #resultado_rep_farmacos
set nocount off
GO
