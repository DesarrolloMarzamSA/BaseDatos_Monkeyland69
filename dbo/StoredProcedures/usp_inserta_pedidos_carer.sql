USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_inserta_pedidos_carer]
	@cliente varchar(5),
	@cant_ped int,
	@arch_cliente varchar(50),
	@orden varchar(50),
	@hash_md5 varchar(50),
	@enviado_ftp char(10),
	@codigo varchar(7)
WITH ENCRYPTION
AS	
	DECLARE @sucursal tinyint

	--declare @sucursal tinyint
	--declare @cliente varchar(5)
	--declare @cod_barras varchar(13)
	--declare @cant_ped int
	--declare @arch_cliente varchar(50)
	--declare @orden varchar(50)
	--declare @hash_md5 varchar(50)
	--declare @enviado_ftp	char(10)
	--declare @idproveedor char(10)
	--declare @fechadelpedido char(10) 

	--set @cliente = '84260' 
	--set @cod_barras = '7501314705313'
	--set @cant_ped = 0
	--set @arch_cliente = 'PMAA1637.DAT'
	--set @orden = '000000000AA1637'
	--set @hash_md5 = '483e3f5cba098f1cb2118880bc19a42a'
	--set @enviado_ftp = '0'
	--set @idproveedor  = 'M'
	--set @fechadelpedido = '20100720'
	
	
	select 		@sucursal = sucursal 
	from			cat_carer
	where  		cliente = cast(@cliente as int)
	
	insert into	pedidos_carer
					(
						sucursal, 
						cliente,
						codigo, 
						cant_ped, 
						arch_cliente, 
						orden, 
						hash_md5, 
						enviado_ftp, 
						fecha_pedido
					) 
	values		
					(
						@sucursal, 
						@cliente,
						@codigo, 
						@cant_ped, 
						@arch_cliente, 
						@orden, 
						@hash_md5, 
						@enviado_ftp, 
						current_timestamp
					)

GO
