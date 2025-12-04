USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_inserta_pedidos_solicitud_klyns]
	@codigo varchar(7),
	@cod_barras varchar(13),
	@cant_ped int,
	@arch_cliente varchar(50),
	@orden varchar(50),
	@hash_md5 varchar(50),
	@codigo_farmacia varchar(20),
	@eindicador	char(10),
	@noenvio char(10),
	@folio char (10),
	@dindicador char (10),
	@refklyns varchar(20),
	@preciofact money,
	@preciofinal money
WITH ENCRYPTION
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
	--declare @codigo_farmacia varchar(20),
	--declare @noenvio varchar(10),
	--declare @folio varchar(10),
	--declare @refklyns varchar(20),
	--declare @preciofact varchar(15),
	--declare @preciofinal varchar(15)

	--set @sucursal = 1
	--set @cliente = '84260' 
	--set @cod_barras = '7501314705313'
	--set @cant_ped = 1
	--set @arch_cliente = 'PMAA1637.DAT'
	--set @orden = '000000000AA1637'
	--set @hash_md5 = '483e3f5cba098f1cb2118880bc19a42a'
	--set @enviado_ftp = '0'
	--set @codigo_farmacia = ''
	--set @noenvio = ''
	--set @folio = ''
	--set @refklyns = ''
	--set @preciofact = ''
	--set @preciofinal = ''
		
	select	@x_Sucursal = sucursal
	from	klyns_cat_cuentas
	where	nodo = @codigo_farmacia
	
	select	@x_Cliente = cliente
	from	klyns_cat_cuentas
	where	nodo = @codigo_farmacia
	
	insert into	pedidos_solicitud_klyns
					(
						sucursal, 
						cliente,
						codigo,
						cod_barras, 
						cant_ped, 
						arch_cliente, 
						orden, 
						hash_md5, 
						fecha_pedido,
						codigo_farmacia,
						eindicador,
						noenvio,
						folio,
						dindicador,
						refklyns,
						preciofact,
						preciofinal
					) 
	values		
					(
						@x_Sucursal, 
						@x_Cliente,
						@codigo,
						@cod_barras, 
						@cant_ped, 
						@arch_cliente, 
						@orden, 
						@hash_md5, 
						current_timestamp,
						@codigo_farmacia,
						@eindicador,
						@noenvio,
						@folio,
						@dindicador,
						@refklyns,
						@preciofact,
						@preciofinal
					)

GO
