

CREATE procedure [dbo].[usp_importa_todos_dbcopis]
as
declare @cadena as char(23), @sucursal as tinyint, @letra as varchar(1), @ip as varchar(20), @usuario as varchar(50), @password as varchar(50), @fact_elec as varchar(50)
declare @archivo as varchar(20), @archivo_local as varchar(50), @ruta_local as varchar(50), @comando_delete as varchar(50), @comando_mkdir as varchar(50)
declare @objFSys int 
declare @objFile int 
declare @blnEndOfFile int
declare @buffer varchar(1000)
declare @arch_ruta_completo varchar(100)
declare @factura char(8)
declare @fecha_fact datetime
declare @cliente char(5)

set @ruta_local = 'd:\interfases\dbcopis\' + convert(varchar(8), getdate(), 112) + '\'
set @comando_mkdir = 'md d:\interfases\dbcopis\' + convert(varchar(8), getdate(), 112)
set @cadena = right('0000' + cast(datepart(yy, getdate()) as varchar(4)),4) + '-' + right('00'   + cast(datepart(mm, getdate()) as varchar(4)),2) + '-' + right('00'   + cast(datepart(dd, getdate()) as varchar(4)),2) + ' ' +right('00'   + cast(datepart(hh, getdate()) as varchar(2)),2) + ':' + right('00'   + cast(datepart(mi, getdate()) as varchar(2)),2) + ':00.000'
exec master..xp_cmdshell @comando_mkdir
WAITFOR DELAY '00:00:02'		

declare cur_sucursales cursor forward_only for select sucursal, letra, ip, usuario, password, dbcopi from rutas_tandem
open cur_sucursales
fetch next from cur_sucursales into @sucursal, @letra, @ip, @usuario, @password, @fact_elec 
	while @@fetch_status = 0
	begin
		set @archivo = @letra + 'DBCOPI'
		set @archivo_local = @ruta_local + @archivo
		set @comando_delete = 'del ' + @ruta_local + 'ftpcmd.txt'
		exec USP_ftp_GetFile 	
		@FTPServer = @ip ,
		@FTPUser = @usuario ,
		@FTPPWD = @password ,
		@FTPPath = @fact_elec ,
		@FTPFileName = '.DBCOPI' ,
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

		select @factura = substring(@buffer, 1, 8)
		
		if(isdate('20' + substring(@buffer, 11,2) + '/' + substring(@buffer, 13, 2) + '/' + substring(@buffer, 9,2))=1)
			begin
				select @fecha_fact = convert(datetime, '20' + substring(@buffer, 9, 2) + '-' + substring(@buffer, 11, 2) + '-' + substring(@buffer, 13, 2), 121)
			end
		else
			begin
				select @fecha_fact = convert(datetime, '2000-01-01 00:00:00.000', 121)
			end

		select @cliente = substring(@buffer, 15, 5)
		
		insert into dbcopi (sucursal, factura, fecha_fact, cliente) values(@sucursal, @factura, @fecha_fact, @cliente)

		  exec sp_OAMethod @objFile, 'AtEndOfStream', @blnEndOfFile out
		end
		exec sp_OADestroy @objFile
		exec sp_OADestroy @objFSys
		
		fetch next from cur_sucursales into @sucursal, @letra, @ip, @usuario, @password, @fact_elec
	end
close cur_sucursales
deallocate cur_sucursales

GO

