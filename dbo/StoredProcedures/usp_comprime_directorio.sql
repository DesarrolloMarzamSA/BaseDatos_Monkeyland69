
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_comprime_directorio] @directorio as varchar(500), @archivo_zip as varchar(500)

as

declare @cmd varchar(500)
declare @comando_shell varchar(500)
select @cmd = replace('"C:\Program Files\WinRAR\WinRAR.exe" a -afzip -r -s -o+ -m1 -ep -df ' + @archivo_zip + ' ' + @directorio + '\', '\\', '\')
exec master..xp_cmdshell @cmd

set @comando_shell = 'rd ' + @directorio
exec master..xp_cmdshell @comando_shell
GO
