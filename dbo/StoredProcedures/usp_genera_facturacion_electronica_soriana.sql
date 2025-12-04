USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO




--usp_genera_facturacion_electronica_soriana '2009-05-08'

CREATE           procedure [dbo].[usp_genera_facturacion_electronica_soriana] (@fecha varchar(10))
WITH ENCRYPTION
as
begin
SET NOCOUNT OFF

declare @encabezado as varchar(500)
declare @sucursal tinyint
declare @factura varchar(8)
declare @fecha_entrega datetime





if(datepart(hh, current_timestamp)<3)
	begin
		select @fecha_entrega = current_timestamp
	end
else
	begin
		select @fecha_entrega = dateadd(dd, 1, convert(datetime, @fecha, 121))
	end


CREATE TABLE [#facturacion_electronica_estandar_soriana] (
	[sucursal] [tinyint] NOT NULL ,
	[cliente] [varchar] (5) COLLATE Modern_Spanish_CI_AS NOT NULL ,
	[digito_verificador] [varchar] (1) COLLATE Modern_Spanish_CI_AS NULL ,
	[serie] [varchar] (1) COLLATE Modern_Spanish_CI_AS NULL ,
	[factura] [varchar] (8) COLLATE Modern_Spanish_CI_AS NOT NULL ,
	[fecha_factura] [datetime] NULL ,
	[codigo] [varchar] (7) COLLATE Modern_Spanish_CI_AS NOT NULL ,
	[descripcion] [varchar] (40) COLLATE Modern_Spanish_CI_AS NULL ,
	[cod_barras] [varchar] (13) COLLATE Modern_Spanish_CI_AS NULL ,
	[clas_fis] [varchar] (2) COLLATE Modern_Spanish_CI_AS NULL ,
	[piezas_surtidas_con_cargo] [int] NULL ,
	[piezas_surtidas_sin_cargo] [int] NULL ,
	[precio_farm_sin_imp] [money] NULL ,
	[precio_pub_sin_imp] [money] NULL ,
	[precio_pub_con_imp] [money] NULL ,
	[importe_bruto] [money] NULL ,
	[porcentaje_descto_oferta] [money] NULL ,
	[descto_oferta] [money] NULL ,
	[porcentaje_descto_comercial] [money] NULL ,
	[descto_comercial] [money] NULL ,
	[ieps] [money] NULL ,
	[iva] [money] NULL ,
	[bonificacion_iva] [money] NULL ,
	[porcentaje_utilidad] [money] NULL ,
	[importe_neto] [money] NULL ,
	[orden] [varchar] (9) COLLATE Modern_Spanish_CI_AS NULL ,
	[porcentaje_iva] [money] NULL ,
	[filler] [varchar] (5) COLLATE Modern_Spanish_CI_AS NULL ,
	[no_registro] [int] NULL ,
	[desc_comerc_prod] [money] NULL ,
	[porcentaje_iva2] [money] NULL ,
	[iva2] [money] NULL ,
	[bonificacion_iva2] [money] NULL ,
	[porcentaje_ieps] [money] NULL ,
	[desc_comerc_ieps] [money] NULL ,
	[iva_del_iesps] [money] NULL ,
	[bonificacion_iva_del_iesps] [money] NULL ,
	[timestamp] [datetime] NULL CONSTRAINT [DF__facturaci__times__662CC1E9] DEFAULT (getdate()),
	[segto] [char] (2) COLLATE Modern_Spanish_CI_AS NULL ,
	[ctepadre] [char] (3) COLLATE Modern_Spanish_CI_AS NULL ,
	[rfc] [char] (13) COLLATE Modern_Spanish_CI_AS NULL ,
	[tipo_documento] [varchar] (1) COLLATE Modern_Spanish_CI_AS NULL ,
	 PRIMARY KEY  CLUSTERED 
	(
		[sucursal],
		[cliente],
		[factura],
		[codigo]
	)  ON [PRIMARY] 
) 


insert into #facturacion_electronica_estandar_soriana select sucursal,
cliente,
digito_verificador,
serie,
factura,
--fecha_factura,
convert(datetime, @fecha, 121), 
codigo,
descripcion,
cod_barras,
clas_fis,
piezas_surtidas_con_cargo,
piezas_surtidas_sin_cargo,
precio_farm_sin_imp,
precio_pub_sin_imp,
precio_pub_con_imp,
importe_bruto,
porcentaje_descto_oferta,
descto_oferta,
porcentaje_descto_comercial,
descto_comercial,
ieps,
iva,
bonificacion_iva,
porcentaje_utilidad,
importe_neto,
orden,
porcentaje_iva,
filler,
no_registro,
desc_comerc_prod,
porcentaje_iva2,
iva2,
bonificacion_iva2,
porcentaje_ieps,
desc_comerc_ieps,
iva_del_iesps,
bonificacion_iva_del_iesps,
timestamp,
segto,
ctepadre,
rfc,
tipo_documento from facturacion_electronica_estandar
where segto = 'E1' and ctepadre in ('044', '032') and fecha_factura >= convert(datetime, @fecha, 121)
--where segto = 'E1' and ctepadre = '044' and fecha_factura > convert(datetime, '2009-02-23', 121)

create table #resultados(linea int identity, col1 varchar(500))
declare  cur_encabezados cursor fast_forward for 
select 
t1.sucursal,
t1.factura,
'0000021329' +
t3.serie +
left(right(t1.factura, 7) + '         ', 9) +
convert(varchar(8), t1.fecha_factura, 112) +
t2.numtienda + '1BTS' +
--right('0000' + case t4.bulto when '0' then '1' else t4.bulto end, 4) +
'0001' +
left(right('0000000000' + cast((sum(round(cast(t1.importe_bruto as numeric(10,4)), 2, 1))) as varchar(23)), 15), 13) +
left(right('0000000000' + cast((sum(round(cast(t1.iva as numeric(10,4)), 2, 1))) as varchar(23)), 15), 13) +
left(right('0000000000' + cast((sum(round(cast(t1.importe_bruto + t1.iva as numeric(10,4)), 2, 1))) as varchar(23)), 15), 13) +
right('0000' + convert(varchar(4), count(t1.factura)), 4) +
convert(varchar(8), @fecha_entrega, 112) 
from 
#facturacion_electronica_estandar_soriana t1 inner join cattiendassoriana t2 on 
t1.sucursal= t2.sucursal and t1.cliente = t2.cliente and t1.segto = 'E1' and t1.ctepadre in ('044', '032')
inner join sucursales t3 on t1.sucursal = t3.sucursal
--inner join encabezado t4 on t1.sucursal = t4.sucursal and t1.factura = t4.factura
/*where 
t1.fecha_factura = convert(datetime, @fecha, 121) and
t1.segto = 'E1' and
t1.ctepadre = '044'*/
group by
t1.sucursal,
t1.factura,
t3.serie ,
t1.factura,
t1.fecha_factura, 
t2.numtienda
--,t4.bulto
order by
t1.sucursal,
t1.factura

open cur_encabezados

fetch next from cur_encabezados into @sucursal, @factura, @encabezado

while @@fetch_status = 0
begin
	insert into #resultados(col1) values(@encabezado)

	insert into #resultados(col1)	
	select 
	right('00000000000000' + replace(t1.cod_barras, ' ', ''), 14) +
	right('000000' + convert(varchar(6), t1.piezas_surtidas_con_cargo), 6) +
	left(right('0000000000' + cast((round(cast(cast(t1.importe_bruto as numeric(10,4)) / cast(t1.piezas_surtidas_con_cargo as numeric(10,4)) as numeric(10,4)), 2, 1)) as varchar(23)), 15), 13) +
	'00' +
	right('00' + convert(varchar(2), convert(int, t1.porcentaje_iva)), 2)
	from 
	#facturacion_electronica_estandar_soriana t1 where sucursal = @sucursal and factura = @factura
	
	insert into #resultados(col1)	
	select 
	right('0000000000' + replace(t1.orden, ' ', ''), 10) +
	right('000000' + convert(varchar(10), sum(convert(int, t1.piezas_surtidas_con_cargo))), 6)
	from 
	#facturacion_electronica_estandar_soriana t1
	where sucursal = @sucursal and factura = @factura
	group by 
	t1.orden

	fetch next from cur_encabezados into @sucursal, @factura, @encabezado
end

close cur_encabezados
deallocate cur_encabezados
select col1 from #resultados order by linea asc
drop table #resultados
drop table #facturacion_electronica_estandar_soriana
end







GO
