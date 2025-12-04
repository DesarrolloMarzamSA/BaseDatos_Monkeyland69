USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_importa_fact_elec](@arch_encabezado varchar(100), @sucursal as tinyint )
WITH ENCRYPTION
as
set nocount on 
declare @objFSys int 
declare @objFile int 
declare @blnEndOfFile int
declare @buffer varchar(4000)
declare @arch_ruta_completo varchar(100)


declare @cliente varchar(5)
declare @digito_verificador varchar(1)
declare @serie varchar(1)
declare @factura varchar(8)
declare @tipo_documento varchar(1)
declare @fecha_factura datetime
declare @codigo varchar(7)
declare @descripcion varchar(40)
declare @cod_barras varchar(13)
declare @clas_fis varchar(2)
declare @piezas_surtidas_con_cargo int
declare @piezas_surtidas_sin_cargo int
declare @precio_farm_sin_imp money
declare @precio_pub_sin_imp money
declare @precio_pub_con_imp money
declare @importe_bruto money
declare @porcentaje_descto_oferta money
declare @descto_oferta money
declare @porcentaje_descto_comercial money
declare @descto_comercial money
declare @ieps money
declare @iva money
declare @bonificacion_iva money
declare @porcentaje_utilidad money
declare @importe_neto money
declare @orden varchar(10)
declare @porcentaje_iva money
declare @filler varchar(5)
declare @no_registro int
declare @desc_comerc_prod money
declare @porcentaje_iva2 money
declare @iva2 money
declare @bonificacion_iva2 money
declare @porcentaje_ieps money
declare @desc_comerc_ieps money
declare @iva_del_iesps money
declare @bonificacion_iva_del_iesps money
declare @segto char(2)
declare @ctepadre char(3)
declare @rfc char(13)
declare @folio_fiscal varchar(8)

declare @FECHA_TANDEM smalldatetime 

--if(datepart(hour, current_timestamp) > 5)
--	begin
--		select @FECHA_TANDEM = convert(datetime, convert(varchar(10), dateadd(dd, 1, current_timestamp), 121), 121)
--	end
--else
--	begin
--		select @FECHA_TANDEM = convert(datetime, convert(varchar(10), dateadd(dd, -1, current_timestamp), 121), 121)
--	end


exec sp_OACreate 'Scripting.FileSystemObject', @objFSys out 
set @arch_ruta_completo = @arch_encabezado

exec sp_OAMethod @objFSys, 'OpenTextFile', @objFile out, @arch_ruta_completo , 1
exec sp_OAMethod @objFile, 'AtEndOfStream', @blnEndOfFile out
while @blnEndOfFile=0 begin
exec sp_OAMethod @objFile, 'ReadLine', @buffer out

select @buffer = replace(@buffer, '''', ' ')



select @cliente  =  ''
select @digito_verificador  =  ''
select @serie  =  ''
select @factura  =  ''
select @tipo_documento  =  ''
select @fecha_factura  = convert(datetime, '2000-01-01', 121)
select @codigo  =  ''
select @descripcion  =  ''
select @cod_barras  =  ''
select @clas_fis  =  ''
select @piezas_surtidas_con_cargo  = 0
select @piezas_surtidas_sin_cargo  = 0
select @precio_farm_sin_imp  = 0
select @precio_pub_sin_imp  = 0
select @precio_pub_con_imp  = 0
select @importe_bruto  = 0
select @porcentaje_descto_oferta  = 0
select @descto_oferta  = 0
select @porcentaje_descto_comercial  = 0
select @descto_comercial  = 0
select @ieps  = 0
select @iva  = 0
select @bonificacion_iva  = 0
select @porcentaje_utilidad  = 0
select @importe_neto  = 0
select @orden  = ''
select @porcentaje_iva  = 0
select @filler  = 0
select @no_registro  = 0
select @desc_comerc_prod  = 0
select @porcentaje_iva2  = 0
select @iva2  = 0
select @bonificacion_iva2  = 0
select @porcentaje_ieps  = 0
select @desc_comerc_ieps  = 0
select @iva_del_iesps  = 0
select @bonificacion_iva_del_iesps  = 0
select @segto  =  ''
select @ctepadre  =  ''
select @rfc  =  ''
select @folio_fiscal  =  ''





select @cliente = substring(@buffer, 3, 5)
select @digito_verificador = substring(@buffer, 8, 1)
select @serie = substring(@buffer, 9, 1)
--if(@sucursal = 4) --porque norte es de 8 dígitos comenzando por cinco
--	begin
--		select @factura = '6' + substring(@buffer, 10, 7)
--	end
--else  
--	begin
--		select @factura = '0' + substring(@buffer, 10, 7)
--	end

select @factura = 
case @sucursal 
when 4 then '6' + substring(@buffer, 10, 7) 
when 1 then '1' + substring(@buffer, 10, 7) 
else '0' + substring(@buffer, 10, 7) 
end

select @tipo_documento = substring(@buffer, 17, 1)
if(isdate(substring(@buffer, 19, 8)) = 1)
	begin
		select @fecha_factura = convert(datetime, substring(@buffer, 19, 8), 112)
	end
else
	begin
		if(datepart(hh, current_timestamp) < 8)
			begin
				select @fecha_factura = convert(datetime, convert(varchar(8), current_timestamp, 112), 112)
			end
		else
			begin
				select @fecha_factura = convert(datetime, convert(varchar(8), dateadd(dd, 1, current_timestamp), 112), 112)
			end
	end
	
select @fecha_tandem = @fecha_factura --en tandem esta bien
select @codigo = substring(@buffer, 29, 7)
select @descripcion = substring(@buffer, 36, 40)
select @cod_barras = substring(@buffer, 76, 13)
select @clas_fis = replace(substring(@buffer, 89, 2), ' ', '')
select @piezas_surtidas_con_cargo = convert(int, substring(@buffer, 91, 7))
select @piezas_surtidas_sin_cargo = convert(int, substring(@buffer, 98, 7))




	if (isnumeric(substring(@buffer, 105, 10)) = 1)
		begin
			select @precio_farm_sin_imp = convert(money, substring(@buffer, 105, 10))
		end
	else
		begin
			select @precio_farm_sin_imp = prec_farm from maestro_productos where codigo = substring(@buffer, 29, 7)
		end
	


select @precio_pub_sin_imp = convert(money, substring(@buffer, 115, 10))
select @precio_pub_con_imp = convert(money, substring(@buffer, 125, 10))
select @importe_bruto = convert(money, substring(@buffer, 135, 13))
select @porcentaje_descto_oferta = convert(money, substring(@buffer, 148, 6))
select @descto_oferta = convert(money, substring(@buffer, 154, 13))
select @porcentaje_descto_comercial = convert(money, substring(@buffer, 167, 6))
select @descto_comercial = convert(money, substring(@buffer, 173, 13))
select @ieps = convert(money, substring(@buffer, 186, 13))
select @iva = convert(money, substring(@buffer, 199, 13))
select @bonificacion_iva = convert(money, substring(@buffer, 212, 13))
select @porcentaje_utilidad = convert(money, substring(@buffer, 225, 5))
select @importe_neto = convert(money, substring(@buffer, 230, 13))
select @orden = substring(@buffer, 243, 10)


select @porcentaje_iva = convert(money, substring(@buffer, 253, 5))
select @filler = substring(@buffer, 258, 5)
select @no_registro = convert(int, substring(@buffer, 263, 5))

select @desc_comerc_prod = convert(money, substring(@buffer, 268, 13))
select @porcentaje_iva2 = convert(money, substring(@buffer, 281,8))
select @iva2 = convert(money, substring(@buffer, 289, 9))
select @bonificacion_iva2 = convert(money, substring(@buffer, 298, 13))
select @porcentaje_ieps = convert(money, substring(@buffer, 301, 2))
select @desc_comerc_ieps = convert(money, substring(@buffer, 303, 13))
select @iva_del_iesps = convert(money, substring(@buffer, 316, 13))
select @bonificacion_iva_del_iesps = convert(money, substring(@buffer, 329, 13))
select @segto = substring(@buffer, 347, 2)
select @ctepadre = substring(@buffer, 349, 3)
select @rfc = ltrim(rtrim(substring(@buffer, 352, 13)))
if(len(@buffer) >= 372)
	begin 
		select @folio_fiscal = substring(@buffer, 365, 8)
	end
else
	begin 
		select @folio_fiscal = null
	end
if ((@factura is not null AND substring(@buffer, 18, 1) = 'R') or (@factura is not null AND substring(@buffer, 18, 1) = 'Q'))
begin

insert into historica.dbo.fes(
sucursal,
cliente,
digito_verificador,
serie,
factura,
fecha_factura,
codigo,
descripcion,
cod_barras,
clas_fis,
piezas_surtidas_con_cargo,
piezas_surtidas_sin_cargo,
precio_farm_sin_imp,
precio_pub_sin_imp,
precio_pub_con_imp,
importe_bruto,
porcentaje_descto_oferta,
descto_oferta,
porcentaje_descto_comercial,
descto_comercial,
ieps,
iva,
bonificacion_iva,
porcentaje_utilidad,
importe_neto,
orden,
porcentaje_iva,
filler,
no_registro,
desc_comerc_prod,
porcentaje_iva2,
iva2,
bonificacion_iva2,
porcentaje_ieps,
desc_comerc_ieps,
iva_del_iesps,
bonificacion_iva_del_iesps,
segto,
ctepadre,
rfc, 
tipo_documento,
folio_fiscal,
fecha_tandem
)
values(
@sucursal,
@cliente,
@digito_verificador,
@serie,
@factura,
@fecha_factura,
@codigo,
@descripcion,
@cod_barras,
@clas_fis,
@piezas_surtidas_con_cargo,
@piezas_surtidas_sin_cargo,
@precio_farm_sin_imp,
@precio_pub_sin_imp,
@precio_pub_con_imp,
@importe_bruto,
@porcentaje_descto_oferta,
@descto_oferta,
@porcentaje_descto_comercial,
@descto_comercial,
@ieps,
@iva,
@bonificacion_iva,
@porcentaje_utilidad,
@importe_neto,
@orden,
@porcentaje_iva,
@filler,
@no_registro,
@desc_comerc_prod,
@porcentaje_iva2,
@iva2,
@bonificacion_iva2,
@porcentaje_ieps,
@desc_comerc_ieps,
@iva_del_iesps,
@bonificacion_iva_del_iesps,
@segto,
@ctepadre,
@rfc,
@tipo_documento,
@folio_fiscal,
@FECHA_TANDEM
)


end
  exec sp_OAMethod @objFile, 'AtEndOfStream', @blnEndOfFile out
end
exec sp_OADestroy @objFile
exec sp_OADestroy @objFSys






GO
