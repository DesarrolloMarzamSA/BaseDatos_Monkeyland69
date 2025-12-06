
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[usp_migra_ahorrito]

as
declare @ped_id int  
declare @sucursal int  
declare @cliente varchar(10)  
declare @orden varchar(8)  
declare @tipo_pedido varchar(1) 
declare @codigo varchar(7) 
declare @cod_barras varchar(13)  
declare @cant_ped int  
declare @precio_far money 
declare @importe_oferta money 
declare @importe_pronto_pago money 
declare @tipo_oferta varchar(1) 
declare @porcentaje_oferta money 
declare @archivo varchar(10) 
declare @status varchar(1) 
declare @fecha datetime 
declare @remisionado int 


declare @contaras_cur int  
declare @ped_id_cur int
declare @sucursal_cur int
declare @cliente_cur varchar(10)  
declare @orden_cur varchar(8) 
declare @cod_barras_cur varchar(13) 

select
t1.ped_id,
t1.sucursal,
t1.cliente,
t1.orden,
t1.tipo_pedido,
t1.codigo,
t1.cod_barras,
t1.cant_ped,
t1.precio_far,
t1.importe_oferta,
t1.importe_pronto_pago,
t1.tipo_oferta,
t1.porcentaje_oferta,
t1.archivo,
t1.status,
t1.fecha,
t1.remisionado
into #hist
from
chimpmaster.dbo.historico_pedidos_spt_fahorro t1 left outer join historica.dbo.pedidos_spt_fahorro t2 
on t1.ped_id = t2.ped_id and t1.sucursal = t2.sucursal and t1.cliente = t2.cliente and t1.orden = t2.orden and t1.cod_barras = t2.cod_barras
where t2.fecha is null


declare mi_cursor cursor fast_forward for select ped_id, sucursal, cliente, orden, cod_barras, count(*) from #hist group by ped_id, sucursal, cliente, orden, cod_barras


open mi_cursor

fetch next from mi_cursor into @ped_id_cur, @sucursal_cur, @cliente_cur, @orden_cur, @cod_barras_cur, @contaras_cur
while @@fetch_status = 0
begin
	
	select
	@ped_id = ped_id,
	@sucursal = sucursal,
	@cliente = cliente,
	@orden = orden,
	@tipo_pedido = tipo_pedido,
	@codigo = codigo,
	@cod_barras = cod_barras,
	@cant_ped = cant_ped,
	@precio_far = precio_far,
	@importe_oferta = importe_oferta,
	@importe_pronto_pago = importe_pronto_pago,
	@tipo_oferta = tipo_oferta,
	@porcentaje_oferta = porcentaje_oferta,
	@archivo = archivo,
	@status = status,
	@fecha = fecha,
	@remisionado = remisionado
	from
	#hist
	where
	ped_id = @ped_id_cur and 
	sucursal = @sucursal_cur and 
	cliente = @cliente_cur and 
	orden = @orden_cur and 
	cod_barras = @cod_barras_cur
	
	insert into historica.dbo.pedidos_spt_fahorro values(
	@ped_id,
	@sucursal,
	@cliente,
	@orden,
	@tipo_pedido,
	@codigo,
	@cod_barras,
	@cant_ped,
	@precio_far,
	@importe_oferta,
	@importe_pronto_pago,
	@tipo_oferta,
	@porcentaje_oferta,
	@archivo,
	@status,
	@fecha,
	@remisionado)
	
	fetch next from mi_cursor into @ped_id_cur, @sucursal_cur, @cliente_cur, @orden_cur, @cod_barras_cur, @contaras_cur
end


close mi_cursor
deallocate mi_cursor
GO
