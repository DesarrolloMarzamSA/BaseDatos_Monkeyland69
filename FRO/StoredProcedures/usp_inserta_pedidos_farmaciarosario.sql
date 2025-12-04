create procedure [FRO].[usp_inserta_pedidos_farmaciarosario]
	@sucursal tinyint,
	@cliente varchar(15),
	@cod_barras varchar(13),
	@cant_ped int,
	@arch_cliente varchar(50),
	@orden varchar(50),
	@hash_md5 varchar(50),
	@enviado_ftp char(10),
	@piezas_sin_cargo varchar(10),
	@precio_farmacia_sin_iva varchar(10),
	@importe_descuento_oferta_unitario varchar(10),
	@importe_descuento_financiero_unitario varchar(10)
as	
    declare @x_Sucursal tinyint
	declare @x_Cliente varchar(5)  
  
	
	select	@x_Sucursal = sucursal	
	
  	from capa_ibs..clientes_baan where cliente_ibs='G09614' and cliente= @cliente and letra ='7' 
	



	select	@x_Cliente = cliente
	from capa_ibs..clientes_baan where cliente_ibs='G09614' and cliente= @cliente and letra ='7'



	insert into	FRO.pedidos_FaRosario
					(
						sucursal, 
						cliente,
						cod_barras, 
						cant_ped, 
						arch_cliente, 
						orden, 
						hash_md5, 
						enviado_ftp, 
						fecha_pedido,
						piezas_sin_cargo,
						precio_farmacia_sin_iva,
						importe_descuento_oferta_unitario,
						importe_descuento_financiero_unitario
					) 
	values		
					(
						@x_Sucursal, 
						@x_Cliente,
						@cod_barras, 
						@cant_ped, 
						@arch_cliente, 
						@orden, 
						@hash_md5, 
						@enviado_ftp, 
						current_timestamp,
						@piezas_sin_cargo,
						@precio_farmacia_sin_iva,
						@importe_descuento_oferta_unitario,
						@importe_descuento_financiero_unitario
					)

GO

