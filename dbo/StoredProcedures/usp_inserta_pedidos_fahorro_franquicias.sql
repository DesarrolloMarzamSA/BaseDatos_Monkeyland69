USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_inserta_pedidos_fahorro_franquicias]
	@id_pedido varchar(12),
	@cliente varchar(5),
	@cod_barras varchar(13),
	@cant_ped int,
	@arch_cliente varchar(50),
	@orden char(10),
	@hash_md5 varchar(50)
WITH ENCRYPTION
AS
	declare @sucursal tinyint	
	
	--declare @id_pedido varchar(12)
	--declare @sucursal tinyint
	--declare @cliente varchar(5)
	--declare @cod_barras varchar(13)
	--declare @cant_ped int
	--declare @arch_cliente varchar(50)
	--declare @orden bigint
	--declare @hash_md5 varchar(50)
	--set @id_pedido = '100629113356'
	--set @sucursal = 1
	--set @cliente = '02940'
	--set @cod_barras = '0300093370111'
	--set @cant_ped = 1
	--set @arch_cliente = '02940-8.ped'
	--set @orden = '02940'
	--set @hash_md5 = 'a1c6367624b65399134b6eeeb3c7a310'
	
	select	@sucursal = sucursal
	from		cat_fahorro_franquicias
	where	cliente = @cliente
	
	insert into		pedidos_fahorro_franquicias
						(
							id_pedido,
							sucursal, 
							cliente,
							cod_barras,
							cant_ped,
							arch_cliente,
							fecha_pedido,
							orden,
							hash_md5
						) 
	values			
						(
							@id_pedido,
							@sucursal, 
							@cliente,
							@cod_barras,
							@cant_ped,
							@arch_cliente,
							current_timestamp,
							@orden,
							@hash_md5
						)
GO
