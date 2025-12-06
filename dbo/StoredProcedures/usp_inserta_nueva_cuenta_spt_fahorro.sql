
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_inserta_nueva_cuenta_spt_fahorro] @sucursal_remision tinyint, @cuenta_remision varchar(5), @sucursal_factura tinyint, @cuenta_factura varchar(5)

as
declare @cuenta_estilo_ahorro varchar(9)
select @cuenta_estilo_ahorro = right('00' + convert(varchar(2), @sucursal_remision), 2) + @cuenta_factura + '-' + dbo.fn_digito_verificador(@cuenta_factura)
declare @cedis tinyint
select @cedis = cedis from cat_cuentas_spt_fahorro where sucursal_remision = @sucursal_remision

insert into cat_cuentas_spt_fahorro(cuenta_estilo_ahorro, sucursal_remision, cuenta_remision, sucursal_factura, cuenta_factura, cedis, timestamp) 
values(@cuenta_estilo_ahorro, @sucursal_remision, @cuenta_remision, @sucursal_factura, @cuenta_factura, @cedis, current_timestamp)

select * from cat_cuentas_spt_fahorro where cuenta_remision = @cuenta_remision

GO
