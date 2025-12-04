USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[usp_importa_parametros_ofertas]
WITH ENCRYPTION
as
set nocount on

--declare @objFSys int 
--declare @objFile int 
--declare @blnEndOfFile int
--declare @buffer varchar(1000)

--declare @sucursal tinyint
--declare @cliente varchar(5)
--declare @bandera_libre varchar(1)
--declare @bandera_plus varchar(2)

--declare @sucursal_checa tinyint
--declare @cliente_checa varchar(5)
--declare @bandera_libre_checa varchar(1)
--declare @bandera_plus_checa varchar(2)

--CREATE TABLE #clientes_ofertas(
--sucursal tinyint NOT NULL,
--cliente varchar(5) NOT NULL,
--bandera_libre varchar(1) NULL,
--bandera_plus varchar(2) NULL,
--primary key(sucursal, cliente))
		
--declare @cadena as char(23), @sucursal_tandem as tinyint, @letra as varchar(1), @ip as varchar(20), @usuario as varchar(50), @password as varchar(50), @fact_elec as varchar(50)
--declare @archivo as varchar(20), @archivo_local as varchar(50), @ruta_local as varchar(50), @comando_delete as varchar(50), @comando_mkdir as varchar(50)
--declare @archivo_tandem as varchar(20)
--declare @comando_rmdir varchar(100)
--set @ruta_local = 'd:\interfases\ofertasFAEP04\' + convert(varchar(8), getdate(), 112) + '\'
--set @comando_mkdir = 'md d:\interfases\ofertasFAEP04\' + convert(varchar(8), getdate(), 112)
--set @cadena = right('0000' + cast(datepart(yy, getdate()) as varchar(4)),4) + '-' + right('00'   + cast(datepart(mm, getdate()) as varchar(4)),2) + '-' + right('00'   + cast(datepart(dd, getdate()) as varchar(4)),2) + ' ' +right('00'   + cast(datepart(hh, getdate()) as varchar(2)),2) + ':' + right('00'   + cast(datepart(mi, getdate()) as varchar(2)),2) + ':00.000'
--set @comando_rmdir = 'rmdir /s /q d:\interfases\ofertasFAEP04\' + convert(varchar(8), getdate(), 112)
--exec master..xp_cmdshell @comando_rmdir
--exec master..xp_cmdshell @comando_mkdir
--WAITFOR DELAY '00:00:02'		

--declare cur_sucursales cursor fast_forward for select sucursal, letra, ip, usuario, password, facturacion from rutas_tandem where sucursal not in (2,50,51,52) order by sucursal desc

--open cur_sucursales
--fetch next from cur_sucursales into @sucursal_tandem, @letra, @ip, @usuario, @password, @fact_elec 
--	while @@fetch_status = 0
--	begin
--		set @archivo = @letra + 'FAEP04'
--		set @archivo_tandem = '.' + substring(@fact_elec, charindex('.', @fact_elec) + 1, 1 ) + 'FAEP04'
--		set @archivo_local = @ruta_local + @archivo
--		set @comando_delete = 'del ' + @ruta_local + 'ftpcmd.txt'
--		exec USP_ftp_GetFile 	
--		@FTPServer = @ip ,
--		@FTPUser = @usuario ,
--		@FTPPWD = @password ,
--		@FTPPath = @fact_elec ,
--		@FTPFileName = @archivo_tandem ,
--		@SourcePath = @ruta_local ,
--		@SourceFile = @archivo ,
--		@workdir = @ruta_local
--		exec master..xp_cmdshell @comando_delete
--		WAITFOR DELAY '00:00:02'

--		exec sp_OACreate 'Scripting.FileSystemObject', @objFSys out 
--		exec sp_OAMethod @objFSys, 'OpenTextFile', @objFile out, @archivo_local , 1
--		exec sp_OAMethod @objFile, 'AtEndOfStream', @blnEndOfFile out
--		while @blnEndOfFile=0 
--		begin
--			exec sp_OAMethod @objFile, 'ReadLine', @buffer out
--			insert into #clientes_ofertas(sucursal, cliente, bandera_libre, bandera_plus) values(@sucursal_tandem, substring(@buffer, 1, 5),  substring(@buffer, 12, 1), substring(@buffer, 45, 2))
--			exec sp_OAMethod @objFile, 'AtEndOfStream', @blnEndOfFile out
--		end
--		exec sp_OADestroy @objFile
--		exec sp_OADestroy @objFSys
--	fetch next from cur_sucursales into @sucursal_tandem, @letra, @ip, @usuario, @password, @fact_elec
--	end
--close cur_sucursales
--deallocate cur_sucursales


--declare cursor_restantes cursor fast_forward for
--select t1.sucursal, t1.cliente, 'L', ' ' from clientes_baan t1 left outer join #clientes_ofertas t2 on t1.sucursal = t2.sucursal and t1.cliente = t2.cliente where t2.cliente is null

--open cursor_restantes

--fetch next from cursor_restantes into @sucursal, @cliente, @bandera_libre, @bandera_plus
--while @@fetch_status = 0
--begin
--	insert into #clientes_ofertas values(@sucursal, @cliente, @bandera_libre, @bandera_plus)
--	fetch next from cursor_restantes into @sucursal, @cliente, @bandera_libre, @bandera_plus
--end
--close cursor_restantes
--deallocate cursor_restantes


--declare cursor_clientes_ofertas cursor fast_forward for select sucursal, cliente, bandera_libre, bandera_plus from #clientes_ofertas
--open cursor_clientes_ofertas

--fetch next from cursor_clientes_ofertas into @sucursal, @cliente, @bandera_libre, @bandera_plus
--while @@fetch_status = 0
--begin
--	select 
--	@sucursal_checa = sucursal,
--	@cliente_checa = cliente,
--	@bandera_libre_checa = bandera_libre,
--	@bandera_plus_checa = bandera_plus
--	from
--	clientes_ofertas
--	where
--	sucursal = @sucursal and
--	cliente = @cliente
--	if @@rowcount > 0
--		begin
--			if ((@bandera_libre_checa <> @bandera_libre) or (@bandera_plus_checa <> @bandera_plus))
--			begin
--				update clientes_ofertas set 
--				bandera_libre = @bandera_libre,
--				bandera_plus = @bandera_plus
--				where
--				sucursal = @sucursal and
--				cliente = @cliente
--			end
--		end
--	else
--		begin
--			insert into clientes_ofertas(sucursal, cliente, bandera_libre, bandera_plus, bandera_mega) values(@sucursal, @cliente, @bandera_libre, @bandera_plus, ' ')
--		end
	
--	fetch next from cursor_clientes_ofertas into @sucursal, @cliente, @bandera_libre, @bandera_plus
--end
--close cursor_clientes_ofertas
--deallocate cursor_clientes_ofertas

--declare @checa_lineas int
--select @checa_lineas = count(*) from #clientes_ofertas
--if @checa_lineas > 50000
--begin
--	declare cursor_limpia_clientes_ofertas cursor fast_forward for select t1.sucursal, t1.cliente from clientes_ofertas t1 left outer join #clientes_ofertas t2 on t1.sucursal = t2.sucursal and t1.cliente = t2.cliente where t2.cliente is null
--	open cursor_limpia_clientes_ofertas 
--	fetch next from cursor_limpia_clientes_ofertas into @sucursal, @cliente
--	while @@fetch_status = 0
--	begin
--		delete from clientes_ofertas where sucursal = @sucursal and cliente = @cliente
--		fetch next from cursor_limpia_clientes_ofertas into @sucursal, @cliente
--	end
--	close cursor_limpia_clientes_ofertas
--	deallocate cursor_limpia_clientes_ofertas
--end

--declare cursor_clientes_mega cursor fast_forward for select sucursal, cliente from monkeyland.dbo.clientes_baan where 
--(sucursal in (1, 13, 11) and right(cliente, 1) = '2') or --sur y mérida
--(sucursal = 25 and convert(int, cliente) < 20000) or --medipac tijuana
--(sucursal not in (1, 13, 11, 25) and convert(int, cliente) between 20001 and 29999) --las demás
--open cursor_clientes_mega

--fetch next from cursor_clientes_mega into @sucursal, @cliente

--while @@fetch_status = 0
--begin
--	select @sucursal_checa = sucursal, @cliente_checa = cliente from clientes_ofertas where sucursal = @sucursal and cliente = @cliente and bandera_mega <> 'MG'
--	if @@rowcount > 0
--	begin
--		update clientes_ofertas set bandera_mega = 'MG', bandera_libre = ' ', bandera_plus = ' ' where sucursal = @sucursal and cliente = @cliente 
--	end
--	else
--	begin
--		insert into clientes_ofertas(sucursal, cliente, bandera_libre, bandera_plus, bandera_mega) values(@sucursal, @cliente, ' ', ' ', 'MG')
--	end
--	fetch next from cursor_clientes_mega into @sucursal, @cliente
--end

--close cursor_clientes_mega
--deallocate cursor_clientes_mega

set nocount off


--select top 100 * from clientes_ofertas
GO
