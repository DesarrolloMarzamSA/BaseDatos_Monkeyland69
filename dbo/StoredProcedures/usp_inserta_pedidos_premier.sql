
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_inserta_pedidos_premier]
	@sucursal tinyint,
	@cliente varchar(5),
	@cod_barras varchar(13),
	@cant_ped int,
	@arch_cliente varchar(50),
	@orden char(10),
	@hash_md5 varchar(50),
	@enviado_ftp char(10),
	@piezas_sin_cargo tinyint,
	@precio_farmacia_sin_iva money,
	@importe_descuento_oferta_unitario money,
	@importe_descuento_financiero_unitario money
WITH ENCRYPTION
AS	
	--declare @sucursal tinyint
	--declare @cliente varchar(5)
	--declare @cod_barras varchar(13)
	--declare @cant_ped int
	--declare @arch_cliente varchar(50)
	--declare @orden bigint
	--declare @hash_md5 varchar(50)
	--declare @enviado_ftp char(10)
	--declare @piezas_sin_cargo tinyint
	--declare @precio_farmacia_sin_iva money
	--declare @importe_descuento_oferta_unitario money
	--declare @importe_descuento_financiero_unitario money
	--set @sucursal = 1
	--set @cliente = '01819'
	--set @cod_barras = '12345678901234'
	--set @cant_ped = 123
	--set @arch_cliente = 'Premier.txt'
	--set @orden = '1234567890'
	--set @hash_md5 = '12345678901234567890123456789012'
	--set @enviado_ftp = 0
	--set @piezas_sin_cargo = 1,
	--set @precio_farmacia_sin_iva = 10.10,
	--set @importe_descuento_oferta_unitario = 20.20,
	--set @importe_descuento_financiero_unitario = 25.25
	insert into		pedidos_premier 
						(
							sucursal, 
							cliente,
							cod_barras,
							cant_ped,
							arch_cliente,
							fecha_pedido,
							orden,
							hash_md5,
							enviado_ftp,
							piezas_sin_cargo,
							precio_farmacia_sin_iva,
							importe_descuento_oferta_unitario,
							importe_descuento_financiero_unitario
						) 
	values			
						(
							@sucursal, 
							@cliente,
							@cod_barras,
							@cant_ped,
							@arch_cliente,
							current_timestamp,
							@orden,
							@hash_md5,
							@enviado_ftp,
							@piezas_sin_cargo,
							@precio_farmacia_sin_iva,
							@importe_descuento_oferta_unitario,
							@importe_descuento_financiero_unitario
						)
GO
