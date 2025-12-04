USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_comprime_archivo] @archivo as varchar(500), @archivo_zip as varchar(500)
WITH ENCRYPTION
as

declare @cmd varchar(500)
declare @comando_shell varchar(500)
select @cmd = '"C:\Program Files\WinRAR\WinRAR.exe" a -afzip -r -s -o+ -m1 -ep -df ' + @archivo_zip + ' ' + @archivo
exec master..xp_cmdshell @cmd

set @comando_shell = 'del ' + @archivo
exec master..xp_cmdshell @comando_shell
GO
