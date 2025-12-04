




CREATE  procedure [dbo].[usp_importa_catalogos_autoservicios]
as

declare @objFSys int 
declare @objFile int 
declare @blnEndOfFile int
declare @buffer varchar(4000)
declare @arch_ruta_completo varchar(100)
declare @fecha_proceso datetime
declare @cadena as char(23)


declare @segto as varchar(2)
declare @ctepadre as varchar(3)
declare @codigo as varchar(7)
declare @status as varchar(1)
declare @cod_barrcli as varchar(13)
declare @cod_prodcli as varchar(20)
declare @fecalt as varchar(8)
declare @grupo as varchar(4)
declare @grupo_factura as varchar(1)
declare @desc_espec as money
declare @empaque as varchar(10)
declare @familia as varchar(4)
declare @subfamilia as varchar(4)
declare @precio_farmacia as money
declare @precio_publico as money
declare @fecha_inicio_precios as int
declare @fecha_fin_precios as int
declare @fechamod as int
declare @horamod as int
declare @usuario as varchar(6)
declare @tipomov as varchar(1)
declare @statud_old as varchar(1)
declare @fechamod_old as int
declare @horamod_old as int
declare @usuario_old as varchar(6)
declare @clasificacion_fiscal as varchar(2)
declare @cau_codigo_para_venta as varchar(9)
declare @filler as varchar(9)


declare @segto_checa as varchar
declare @ctepadre_checa as varchar
declare @codigo_checa as varchar
declare @status_checa as varchar
declare @cod_barrcli_checa as varchar
declare @cod_prodcli_checa as varchar
declare @fecalt_checa as varchar
declare @grupo_checa as varchar
declare @grupo_factura_checa as varchar
declare @desc_espec_checa as money
declare @empaque_checa as varchar
declare @familia_checa as varchar
declare @subfamilia_checa as varchar
declare @precio_farmacia_checa as money
declare @precio_publico_checa as money
declare @fecha_inicio_precios_checa as int
declare @fecha_fin_precios_checa as int
declare @fechamod_checa as int
declare @horamod_checa as int
declare @usuario_checa as varchar
declare @tipomov_checa as varchar
declare @statud_old_checa as varchar
declare @fechamod_old_checa as int
declare @horamod_old_checa as int
declare @usuario_old_checa as varchar
declare @clasificacion_fiscal_checa as varchar
declare @cau_codigo_para_venta_checa as varchar
declare @filler_checa as varchar



declare @archivo as varchar(20), @archivo_local as varchar(50), @ruta_local as varchar(50), @comando_delete as varchar(50), @comando_mkdir as varchar(50)
declare @sucursal as tinyint, @letra as varchar(1), @ip as varchar(20), @usuarioftp as varchar(50), @password as varchar(50), @fact_elec as varchar(50)

set @ruta_local = 'd:\interfases\CORPdbcataut\' + convert(varchar(8), getdate(), 112) + '\'
set @comando_mkdir = 'md d:\interfases\CORPdbcataut\' + convert(varchar(8), getdate(), 112)
set @cadena = right('0000' + cast(datepart(yy, getdate()) as varchar(4)),4) + '-' + right('00'   + cast(datepart(mm, getdate()) as varchar(4)),2) + '-' + right('00'   + cast(datepart(dd, getdate()) as varchar(4)),2) + ' ' +right('00'   + cast(datepart(hh, getdate()) as varchar(2)),2) + ':' + right('00'   + cast(datepart(mi, getdate()) as varchar(2)),2) + ':00.000'
exec master..xp_cmdshell @comando_mkdir

declare cur_sucursales cursor fast_forward for select sucursal, letra, ip, usuario, password, ofertas from rutas_tandem order by sucursal desc
open cur_sucursales
fetch next from cur_sucursales into @sucursal, @letra, @ip, @usuarioftp, @password, @fact_elec 
	while @@fetch_status = 0
	begin
		set @archivo = @letra + 'DBCATAUT'
		set @archivo_local = @ruta_local + @archivo
		set @comando_delete = 'del ' + @ruta_local + 'ftpcmd.txt'
		exec USP_ftp_GetFile 	
		@FTPServer = @ip ,
		@FTPUser = @usuarioftp ,
		@FTPPWD = @password ,
		@FTPPath = @fact_elec ,
		@FTPFileName = '.DBCATAUT' ,
		@SourcePath = @ruta_local ,
		@SourceFile = @archivo ,
		@workdir = @ruta_local
		exec master..xp_cmdshell @comando_delete
		WAITFOR DELAY '00:00:02'

exec sp_OACreate 'Scripting.FileSystemObject', @objFSys out 
set @arch_ruta_completo = @archivo_local

exec sp_OAMethod @objFSys, 'OpenTextFile', @objFile out, @arch_ruta_completo , 1
exec sp_OAMethod @objFile, 'AtEndOfStream', @blnEndOfFile out
while @blnEndOfFile=0 begin
	exec sp_OAMethod @objFile, 'ReadLine', @buffer out
	select @buffer = replace(@buffer, '''', ' ')

	
	select @segto  = substring(@buffer,1,2) 
	select @ctepadre  = substring(@buffer,3,3) 
	select @codigo  = substring(@buffer,8,7)
	select @status  = substring(@buffer,15,1) 
	select @cod_barrcli  = substring(@buffer,16,13) 
	select @cod_prodcli  = substring(@buffer,29,20) 
	select @fecalt  = substring(@buffer,49,8) 
	select @grupo  = substring(@buffer,57,4) 
	select @grupo_factura  = substring(@buffer,61,1) 
	select @desc_espec  = convert(money, substring(@buffer,62,5)) 
	select @empaque  = substring(@buffer,67,10) 
	select @familia  = substring(@buffer,77,4) 
	select @subfamilia  = substring(@buffer,81,4) 
	select @precio_farmacia  = convert(money, substring(@buffer,85,9)) 
	select @precio_publico  = convert(money, substring(@buffer,94,9)) 
	select @fecha_inicio_precios  = convert(int, substring(@buffer,103,8))
	select @fecha_fin_precios  = convert(int, substring(@buffer,111,8))
	select @fechamod  = convert(int, substring(@buffer,119,8)) 
	select @horamod  = convert(int, substring(@buffer,127,4)) 
	select @usuario  = substring(@buffer,131,6) 
	select @tipomov  = substring(@buffer,137,1) 
	select @statud_old  = substring(@buffer,138,1) 
	select @fechamod_old  = convert(int, substring(@buffer,139,8)) 
	select @horamod_old  = convert(int, substring(@buffer,147,4))
	select @usuario_old  = substring(@buffer,151,6) 
	select @clasificacion_fiscal  = substring(@buffer,157,2) 
	select @cau_codigo_para_venta  = substring(@buffer,159,9) 




			select		
			@segto_checa = segto,
			@ctepadre_checa = ctepadre,
			@codigo_checa = codigo,
			@status_checa = status,
			@cod_barrcli_checa = cod_barrcli,
			@cod_prodcli_checa = cod_prodcli,
			@fecalt_checa = fecalt,
			@grupo_checa = grupo,
			@grupo_factura_checa = grupo_factura,
			@desc_espec_checa = desc_espec,
			@empaque_checa = empaque,
			@familia_checa = familia,
			@subfamilia_checa = subfamilia,
			@precio_farmacia_checa = precio_farmacia,
			@precio_publico_checa = precio_publico,
			@fecha_inicio_precios_checa = fecha_inicio_precios,
			@fecha_fin_precios_checa = fecha_fin_precios,
			@fechamod_checa = fechamod,
			@horamod_checa = horamod,
			@usuario_checa = usuario,
			@tipomov_checa = tipomov,
			@statud_old_checa = statud_old,
			@fechamod_old_checa = fechamod_old,
			@horamod_old_checa = horamod_old,
			@usuario_old_checa = usuario_old,
			@clasificacion_fiscal_checa = clasificacion_fiscal,
			@cau_codigo_para_venta_checa = cau_codigo_para_venta,
			@filler_checa = filler
			from catalogo_autoservicios where 
			sucursal = @sucursal and
			segto = @segto and
			ctepadre = @ctepadre and
			codigo = @codigo
			
			if @@rowcount > 0
			begin
			if(
				(@status_checa <> @status) or 
				(@cod_barrcli_checa <> @cod_barrcli) or 
				(@cod_prodcli_checa <> @cod_prodcli) or 
				(@fecalt_checa <> @fecalt) or 
				(@grupo_checa <> @grupo) or 
				(@grupo_factura_checa <> @grupo_factura) or 
				(@desc_espec_checa <> @desc_espec) or 
				(@empaque_checa <> @empaque) or 
				(@familia_checa <> @familia) or 
				(@subfamilia_checa <> @subfamilia) or 
				(@precio_farmacia_checa <> @precio_farmacia) or 
				(@precio_publico_checa <> @precio_publico) or 
				(@fecha_inicio_precios_checa <> @fecha_inicio_precios) or 
				(@fecha_fin_precios_checa <> @fecha_fin_precios) or 
				(@fechamod_checa <> @fechamod) or 
				(@horamod_checa <> @horamod) or 
				(@usuario_checa <> @usuario) or 
				(@tipomov_checa <> @tipomov) or 
				(@statud_old_checa <> @statud_old) or 
				(@fechamod_old_checa <> @fechamod_old) or 
				(@horamod_old_checa <> @horamod_old) or 
				(@usuario_old_checa <> @usuario_old) or 
				(@clasificacion_fiscal_checa <> @clasificacion_fiscal) or 
				(@cau_codigo_para_venta_checa <> @cau_codigo_para_venta))
			begin
				update catalogo_autoservicios set
				cod_prodcli = @cod_prodcli,
				fecalt = @fecalt, 
				grupo = @grupo, 
				grupo_factura = @grupo_factura,
				desc_espec = @desc_espec,
				empaque = @empaque,
				familia = @familia,
				subfamilia = @subfamilia,
				precio_farmacia = @precio_farmacia,
				precio_publico = @precio_publico,
				fecha_inicio_precios = @fecha_inicio_precios,
				fecha_fin_precios = @fecha_fin_precios,
				fechamod = @fechamod,
				horamod = @horamod,
				usuario = @usuario,
				tipomov = @tipomov,
				statud_old = @statud_old,
				fechamod_old = @fechamod_old,
				horamod_old = @horamod_old,
				usuario_old = @usuario_old,
				clasificacion_fiscal = @clasificacion_fiscal,
				cau_codigo_para_venta = @cau_codigo_para_venta,
				filler = @filler,
				fecha_hora_cambio = current_timestamp
				where 
				sucursal = @sucursal and
				segto = @segto and
				ctepadre = @ctepadre and
				codigo = @codigo

			end
	
	
				
	
	
		end
	else --no existe el registro
		begin
				
		insert into catalogo_autoservicios(sucursal,
					SEGTO, 
					ctepadre, 
					CODIGO, 
					STATUS, 
					COD_BARRCLI, 
					COD_PRODCLI, 
					FECALT, 
					GRUPO, 
					GRUPO_FACTURA, 
					DESC_ESPEC, 
					EMPAQUE, 
					FAMILIA, 
					SUBFAMILIA, 
					PRECIO_FARMACIA, 
					PRECIO_PUBLICO, 
					FECHA_INICIO_PRECIOS, 
					FECHA_FIN_PRECIOS, 
					FECHAMOD, 
					HORAMOD, 
					USUARIO, 
					TIPOMOV, 
					STATUD_OLD, 
					FECHAMOD_OLD, 
					HORAMOD_OLD, 
					USUARIO_OLD, 
					CLASIFICACION_FISCAL, 
					CAU_CODIGO_PARA_VENTA, 
					FILLER) 
					values(
					@sucursal,
					substring(@buffer,1,2) ,
					substring(@buffer,3,3) ,
					substring(@buffer,8,7),
					substring(@buffer,15,1) ,
					substring(@buffer,16,13) ,
					substring(@buffer,29,20) ,
					substring(@buffer,49,8) ,
					substring(@buffer,57,4) ,
					substring(@buffer,61,1) ,
					convert(money, substring(@buffer,62,5)) ,
					substring(@buffer,67,10) ,
					substring(@buffer,77,4) ,
					substring(@buffer,81,4) ,
					convert(money, substring(@buffer,85,9)) ,
					convert(money, substring(@buffer,94,9)) ,
					convert(int, substring(@buffer,103,8)),
					convert(int, substring(@buffer,111,8)),
					convert(int, substring(@buffer,119,8)) ,
					convert(int, substring(@buffer,127,4)) ,
					substring(@buffer,131,6) ,
					substring(@buffer,137,1) ,
					substring(@buffer,138,1) ,
					convert(int, substring(@buffer,139,8)) ,
					convert(int, substring(@buffer,147,4)),
					substring(@buffer,151,6) ,
					substring(@buffer,157,2) ,
					substring(@buffer,159,9) ,
					substring(@buffer,167,9))
		end


 	 exec sp_OAMethod @objFile, 'AtEndOfStream', @blnEndOfFile out
end
exec sp_OADestroy @objFile
exec sp_OADestroy @objFSys


	fetch next from cur_sucursales into @sucursal, @letra, @ip, @usuarioftp, @password, @fact_elec
	end
close cur_sucursales
deallocate cur_sucursales

GO

