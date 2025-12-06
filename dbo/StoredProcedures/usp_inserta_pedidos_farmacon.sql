
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_inserta_pedidos_farmacon]
	@num_pedido varchar(12),
	@arch_cliente varchar(50), 
	@nombre varchar(50), 
	@orden bigint, 
	@hash_md5 varchar(50), 
	@fechapedido datetime, 
	@cuenta varchar(5) ,
	@cod_barras varchar(13), 
	@cantidad_pedida int, 
	@poferta money, 
	@pdescuento money, 
	@piva money, 
	@preciobasef money, 
	@indicadorfg char(2)
WITH ENCRYPTION
as
declare @x_sucursal tinyint
--declare  @x_sucursal as tinyint
--declare  @num_pedido  as varchar(12)
--declare  @arch_cliente as varchar(50)
--declare  @nombre as varchar(50)
--declare  @orden as bigint
--declare  @hash_md5 as varchar(50)
--declare  @fechapedido as datetime
--declare   @cuenta as varchar(5) 
--declare  @cod_barras as varchar(13)
--declare  @cantidad_pedida as int
--declare  @poferta as money
--declare  @pdescuento as money
--declare  @piva as money
--declare  @preciobasef as money
--declare  @indicadorfg as char(2)
--declare	@porcentaje_oferta_dboferta as money
--set @x_sucursal = 17
--set @num_pedido = '4500107711'
--set @arch_cliente = '0120100424100616.ped'
--set @nombre = '0120100424100616.ped'
--set @orden = '4500107711'
--set @hash_md5 = '8f18dbc5a23eed493acd83e2568a5931'
--set @cuenta = '11966'
--set @cod_barras = '7501022101407'
--set @cantidad_pedida = 1
--set @poferta = 7.02
--set @pdescuento = 99.99
--set @piva = 0
--set @preciobasef = 3.18
--set @indicadorfg = 'N' 
select	@x_sucursal = sucursal 
from		cat_farmacon 
where	cuenta = cast(@cuenta as int)
insert into	pedidos_farmacon
				(	
					sucursal, 
					num_pedido, 
					arch_cliente, 
					nombre, 
					orden, 
					hash_md5, 
					fechapedido, 
					cuenta, 
					cod_barras, 
					cantidad_pedida,
					poferta, 
					pdescuento, 
					piva, 
					preciobasef, 
					indicadorfg, 
					porcentaje_oferta_dboferta
				) 
values
				(	
					@x_sucursal, 
					@num_pedido, 
					@arch_cliente, 
					@nombre, 
					@orden,
					@hash_md5, 
					current_timestamp, 
					@cuenta, 	
					@cod_barras, 
					@cantidad_pedida, 
					@poferta, 
					@pdescuento, 
					@piva, 
					@preciobasef, 
					@indicadorfg, 
					0.00
				)
GO
