CREATE procedure usp_inserta_pedidos_casa_ley
	@sucursal tinyint,
	@cliente varchar(15),
	@codigo varchar(7),
	@cod_barras varchar(13),
	@cant_ped int,
	@arch_cliente varchar(50),
	@orden varchar(50),
	@hash_md5 varchar(50),
	@enviado_ftp char(10),
	@codigo_farmacia varchar(20),
	@filler01 varchar(8),
	@filler02 varchar(10),
	@filler03 varchar(20)
as	
	--declare @sucursal tinyint
	--declare @cliente varchar(5)
	--declare @codigo varchar(7)
	--declare @cod_barras varchar(13)
	--declare @cant_ped int
	--declare @arch_cliente varchar(50)
	--declare @orden varchar(50)
	--declare @hash_md5 varchar(50)
	--declare @enviado_ftp	char(10)
	--declare @codigo_farmacia varchar(20),
	--declare @filler01 varchar(8),
	--declare @filler02 varchar(10),
	--declare @filler03 varchar(10)

	--set @sucursal = 1
	--set @cliente = '84260' 
	--set @cod_barras = '7501314705313'
	--set @cant_ped = 1
	--set @arch_cliente = 'PMAA1637.DAT'
	--set @orden = '000000000AA1637'
	--set @hash_md5 = '483e3f5cba098f1cb2118880bc19a42a'
	--set @enviado_ftp = '0'
	--set @codigo_farmacia = ''
	--set @filler01 = ''
	--set @filler02 = ''
	--set @filler03 = ''
		
	insert into	pedidos_casa_ley
					(
						sucursal, 
						cliente,
						codigo,
						cod_barras, 
						cant_ped, 
						arch_cliente, 
						orden, 
						hash_md5, 
						enviado_ftp, 
						fecha_pedido,
						codigo_farmacia,
						filler01,
						filler02,
						filler03
					) 
	values		
					(
						@sucursal, 
						@cliente,
						@codigo,
						@cod_barras, 
						@cant_ped, 
						@arch_cliente, 
						@orden, 
						@hash_md5, 
						@enviado_ftp, 
						current_timestamp,
						@codigo_farmacia,
						@filler01,
						@filler02,
						@filler03
					)

GO

