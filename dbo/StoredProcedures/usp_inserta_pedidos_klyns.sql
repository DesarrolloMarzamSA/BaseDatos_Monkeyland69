
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_inserta_pedidos_klyns]
	--@sucursal tinyint,
	--@cliente varchar(15),
	@cod_barras varchar(13),
	@cant_ped int,
	@codigo varchar(7),
	@arch_cliente varchar(50),
	@orden varchar(50),
	@hash_md5 varchar(50),
	@enviado_ftp char(10),
	@codigo_farmacia varchar(20),
	@eindicador char(10),
	@efecha char(10),
	@esucursal char(10),
	@eordencompra varchar(20),
	@eproveedor varchar(20),
	@erenglones varchar(20),
	@eimportesiva varchar(50),
	@eimporteiva varchar(50),
	@eimporteciva varchar(50),
	@dindicador char(10),
	@drenglon char(10),
	@drefklyns varchar(20),
	@dprecio money,
	@dpordescto1 money,
	@dpordescto2 money,
	@dpordescto3 money,
	@dporoferta money,
	@diva money,
	@dpreciounitsiva money,
	@dimportesiva money,
	@dimporteciva money
WITH ENCRYPTION
as	
    declare @x_Sucursal tinyint
	declare @x_Cliente varchar(5)  
		
	select	@x_Sucursal = sucursal
	from	klyns_cat_cuentas
	where	nodo = @codigo_farmacia
	
	select	@x_Cliente = cliente
	from	klyns_cat_cuentas
	where	nodo = @codigo_farmacia
	
	insert into	pedidos_klyns
					(
						sucursal,
						cliente,
						cod_barras,
						cant_ped,
						codigo,
						arch_cliente,
						orden,
						hash_md5,
						fecha_pedido,
						enviado_ftp,
						codigo_farmacia,
						eindicador,
						efecha,
						esucursal,
						eordencompra,
						eproveedor,
						erenglones,
						eimportesiva,
						eimporteiva,
						eimporteciva,
						dindicador,
						drenglon,
						drefklyns,
						dprecio,
						dpordescto1,
						dpordescto2,
						dpordescto3,
						dporoferta,
						diva,
						dpreciounitsiva,
						dimportesiva,
						dimporteciva					
					) 
	values		
					(
						@x_Sucursal,
						@x_Cliente,
						@cod_barras,
						@cant_ped,
						@codigo,
						@arch_cliente,
						@orden,
						@hash_md5,
						current_timestamp,
						@enviado_ftp,
						@codigo_farmacia,
						@eindicador,
						@efecha,
						@esucursal,
						@eordencompra,
						@eproveedor,
						@erenglones,
						@eimportesiva,
						@eimporteiva,
						@eimporteciva,
						@dindicador,
						@drenglon,
						@drefklyns,
						@dprecio,
						@dpordescto1,
						@dpordescto2,
						@dpordescto3,
						@dporoferta,
						@diva,
						@dpreciounitsiva,
						@dimportesiva,
						@dimporteciva	
					)
GO
