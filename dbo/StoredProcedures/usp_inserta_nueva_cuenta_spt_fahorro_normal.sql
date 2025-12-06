
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_inserta_nueva_cuenta_spt_fahorro_normal]
	@sucursal_remision varchar(100), 
	@cuenta_remision varchar(5), 
	@sucursal_factura varchar(100), 
	@cuenta_factura varchar(5)
WITH ENCRYPTION
as
--declare @cuenta_estilo_ahorro varchar(9)
--declare @sucursal_remision varchar(100)
--declare @cuenta_remision varchar(5)
--declare @sucursal_factura varchar(100) 
--declare @cuenta_factura varchar(5)
--declare @sucursalremision tinyint
--declare @sucursalfactura tinyint
--declare @cedis tinyint
--set @sucursal_remision = 'Metro Sur'
--set @cuenta_remision = '11111'
--set @sucursal_factura = 'Metro Sur'
--set @cuenta_factura = '11112'
declare @cuenta_estilo_ahorro varchar(9)
declare @sucursalremision tinyint
declare @sucursalfactura tinyint
declare @cedis tinyint
set @sucursalremision = ''
set @sucursalfactura = ''

select	@sucursalremision = sucursal
from	sucursales
where	descripcion = @sucursal_remision
select	@sucursalfactura = sucursal
from	sucursales
where	descripcion = @sucursal_factura
select	@cuenta_estilo_ahorro = right('00' + convert(varchar(2), @sucursalremision), 2) + @cuenta_factura + '-' + dbo.fn_digito_verificador(@cuenta_factura)
select	@cedis = cedis 
from	cat_cuentas_spt_fahorro 
where	sucursal_remision = @sucursalremision
insert into	cat_cuentas_spt_fahorro 
			(
				cuenta_estilo_ahorro, 
				sucursal_remision, 
				cuenta_remision, 
				sucursal_factura, 
				cuenta_factura, 
				cedis, 
				timestamp
			) 
values		
			(
				@cuenta_estilo_ahorro, 
				@sucursalremision, 
				@cuenta_remision, 
				@sucursalfactura, 
				@cuenta_factura, 
				@cedis, 
				current_timestamp
			)
select	cuenta_estilo_ahorro 
from	cat_cuentas_spt_fahorro 
where	cuenta_remision = @cuenta_remision
GO
