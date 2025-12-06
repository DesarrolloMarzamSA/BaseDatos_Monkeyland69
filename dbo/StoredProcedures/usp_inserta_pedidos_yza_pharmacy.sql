
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_inserta_pedidos_yza_pharmacy]
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
    --declare @x_Dummy tinyint
	--declare @sucursal tinyint
	--declare @cliente varchar(5)
	--declare @cod_barras varchar(13)
	--declare @cant_ped int
	--declare @arch_cliente varchar(50)
	--declare @orden varchar(50)
	--declare @hash_md5 varchar(50)
	--declare @enviado_ftp	char(10)
	--declare @piezas_sin_cargo varchar(10)
	--declare @precio_farmacia_sin_iva varchar(10)
	--declare @importe_descuento_oferta_unitario varchar(10)
	--declare @importe_descuento_financiero_unitario varchar(10)

	--set @sucursal = 1
	--set @cliente = '84260' 
	--set @cod_barras = '7501314705313'
	--set @cant_ped = 1
	--set @arch_cliente = 'PMAA1637.DAT'
	--set @orden = '000000000AA1637'
	--set @hash_md5 = '483e3f5cba098f1cb2118880bc19a42a'
	--set @enviado_ftp = '0'
	--set @piezas_sin_cargo = 1
	--set @precio_farmacia_sin_iva = 1
	--set @importe_descuento_oferta_unitario = 1
	--set @importe_descuento_financiero_unitario = 1
	
	select	@x_Sucursal = sucursal
	from		cat_yza_pharmacy
	where	mostrador = @cliente
	
	select	@x_Cliente = cliente
	from		cat_yza_pharmacy
	where	mostrador = @cliente
	
	insert into	pedidos_yza_pharmacy
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
