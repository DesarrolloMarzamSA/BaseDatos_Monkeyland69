
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_ibs_etiquetas] @nombre varchar(25) 
WITH ENCRYPTION
as
--exec [usp_ibs_etiquetas] 'rosales'
--drop table parametros_etiquetas_estandar
--create table parametros_etiquetas_estandar(nombre varchar(25) not null, leyenda varchar(19), 
--descuento money, query varchar(250), direcciones varchar(250), timestamp datetime default current_timestamp, primary key(nombre))

--insert into parametros_etiquetas_estandar values('rosales', 'PMAXPUBROSALES     ', 0.3, 't1.sucursal = 4 and 
--	t1.cliente in (''77420'', ''26864'')', 'mquiroz@marzam.com.mx', current_timestamp)


declare @leyenda varchar(19)
declare @descuento money
declare @query varchar(250)
declare @direcciones varchar(250)
declare @sentencia_sql varchar(2000)


select
@leyenda = leyenda,
@descuento = descuento,
@query = query,
@direcciones = direcciones 
from
parametros_etiquetas_estandar
where 
nombre = @nombre

if datepart(hh, current_timestamp) > 12
begin
	select @sentencia_sql = '
	select 
	substring(t2.nom_prod, 1, 10) +
	substring(t2.codigos, 3, 7) +
	right(''0000000000'' + convert(varchar(10), convert(int, round(t2.prec_pub, 2, 1) * 100)), 10) +
	''' + @leyenda + ''' +
	right(''0000000000'' + convert(varchar(10), convert(int, round(t2.prec_pub - (t2.prec_pub * ' + convert(varchar(10), @descuento) + '), 2, 1) * 100)), 10) +
	right(''0000'' + convert(varchar(6), t2.cant_ped), 4) +
	convert(varchar(6), t1.fecha_tandem, 12) +
	''              ''
	from 
	encabezado t1 inner join detalle t2 on t1.sucursal = t2.sucursal and t1.factura = t2.factura
	where
	t2.dest_det = ''AAA'' and
	t1.fecha_tandem > convert(smalldatetime, convert(varchar(10), current_timestamp, 121), 121) and
	' + @query
end
else
begin
	select @sentencia_sql = '
	select 
	substring(t2.nom_prod, 1, 10) +
	substring(t2.codigos, 3, 7) +
	right(''0000000000'' + convert(varchar(10), convert(int, round(t2.prec_pub, 2, 1) * 100)), 10) +
	''' + @leyenda + ''' +
	right(''0000000000'' + convert(varchar(10), convert(int, round(t2.prec_pub - (t2.prec_pub * ' + convert(varchar(10), @descuento) + '), 2, 1) * 100)), 10) +
	right(''0000'' + convert(varchar(6), t2.cant_ped), 4) +
	convert(varchar(6), t1.fecha_tandem, 12) +
	''              ''
	from 
	encabezado t1 inner join detalle t2 on t1.sucursal = t2.sucursal and t1.factura = t2.factura
	where
	t2.dest_det = ''AAA'' and
	t1.fecha_tandem = convert(smalldatetime, convert(varchar(10), current_timestamp, 121), 121) and
	' + @query

end

exec(@sentencia_sql)
GO
