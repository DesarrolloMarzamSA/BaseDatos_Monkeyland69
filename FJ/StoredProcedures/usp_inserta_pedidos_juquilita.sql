CREATE PROCEDURE [FJ].[usp_inserta_pedidos_juquilita] 
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
AS 		
	insert into FJ.pedidos_Juquilita (
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
		importe_descuento_financiero_unitario) 
	values (
		@sucursal,
		@cliente,
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
		@importe_descuento_financiero_unitario)

GO

