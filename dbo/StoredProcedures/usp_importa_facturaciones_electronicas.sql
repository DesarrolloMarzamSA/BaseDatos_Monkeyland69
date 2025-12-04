
CREATE PROCEDURE [dbo].[usp_importa_facturaciones_electronicas]
as
declare @sucursal as tinyint, @letra as varchar(1), @ip as varchar(20), @usuario as varchar(50), @password as varchar(50), @fact_elec as varchar(50)
declare @archivo as varchar(20), @archivo_local as varchar(50), @ruta_local as varchar(50), @comando_delete as varchar(50), @comando_mkdir as varchar(50)
set @ruta_local = 'D:\Interfases\FactsElect\' + convert(varchar(8), getdate(), 112) + '\'
set @comando_mkdir = 'md D:\Interfases\FactsElect\' + convert(varchar(8), getdate(), 112)
exec master..xp_cmdshell @comando_mkdir
WAITFOR DELAY '00:00:02'		

declare cur_sucursales cursor fast_forward for select sucursal, letra, ip, usuario, password, fact_elec from rutas_tandem where sucursal in (select sucursal from sucursales where sistema = 'baan') order by sucursal desc
open cur_sucursales
fetch next from cur_sucursales into @sucursal, @letra, @ip, @usuario, @password, @fact_elec 
	while @@fetch_status = 0
	begin
		set @archivo = @letra + 'DSTANDAR'
		set @archivo_local = @ruta_local + @archivo
		set @comando_delete = 'del ' + @ruta_local + 'ftpcmd.txt'
		exec USP_ftp_GetFile 	
		@FTPServer = @ip ,
		@FTPUser = @usuario ,
		@FTPPWD = @password ,
		@FTPPath = @fact_elec ,
		@FTPFileName = '.DSTANDAR' ,
		@SourcePath = @ruta_local ,
		@SourceFile = @archivo ,
		@workdir = @ruta_local
		exec master..xp_cmdshell @comando_delete
		WAITFOR DELAY '00:00:02'
		exec usp_importa_fact_elec @archivo_local, @sucursal
	fetch next from cur_sucursales into @sucursal, @letra, @ip, @usuario, @password, @fact_elec
	end
		--update historica.dbo.fes set orden = replace(orden, ' ', '') where segto = 'E1' and ctepadre in ('044', '032') and  fecha_factura > dateadd(dd, -1, current_timestamp)
close cur_sucursales
deallocate cur_sucursales
--exec usp_checa_ofaestan

GO

