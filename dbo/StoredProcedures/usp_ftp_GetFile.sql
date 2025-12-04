USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO







CREATE     procedure [dbo].[usp_ftp_GetFile]
@FTPServer	varchar(128) ,
@FTPUser	varchar(128) ,
@FTPPWD		varchar(128) ,
@FTPPath	varchar(128) ,
@FTPFileName	varchar(128) ,

@SourcePath	varchar(128) ,
@SourceFile	varchar(128) ,

@workdir	varchar(128)
WITH ENCRYPTION
as
/*
exec s_ftp_GetFile 	
		@FTPServer = 'www.myftpsite.com' ,
		@FTPUser = 'myuser' ,
		@FTPPWD = 'mypwd' ,
		@FTPPath = '' ,
		@FTPFileName = 'myfile.html' ,
		@SourcePath = 'c:\vss\mywebsite\' ,
		@SourceFile = 'myfile.html' ,
		@workdir = 'c:\temp\'
*/

declare	@cmd varchar(1000)
declare @workfilename varchar(128)
	
	select @workfilename = 'ftpcmd.txt'
	
	-- deal with special characters for echo commands
	select @FTPServer = replace(replace(replace(@FTPServer, '|', '^|'),'<','^<'),'>','^>')
	select @FTPUser = replace(replace(replace(@FTPUser, '|', '^|'),'<','^<'),'>','^>')
	select @FTPPWD = replace(replace(replace(@FTPPWD, '|', '^|'),'<','^<'),'>','^>')
	select @FTPPath = replace(replace(replace(@FTPPath, '|', '^|'),'<','^<'),'>','^>')
	
	select @cmd = 'echo ' + 'lcd ' + @SourcePath
			+ ' >> ' + @workdir + @workfilename
	exec master..xp_cmdshell @cmd
	select	@cmd = 'echo '					+ 'open ' + @FTPServer
			+ ' > ' + @workdir + @workfilename
	exec master..xp_cmdshell @cmd
	select	@cmd = 'echo '					+ @FTPUser
			+ '>> ' + @workdir + @workfilename
	exec master..xp_cmdshell @cmd
	select	@cmd = 'echo '					+ @FTPPWD
			+ '>> ' + @workdir + @workfilename
	exec master..xp_cmdshell @cmd
	select @cmd = 'echo ' + 'lcd ' + @SourcePath
			+ ' >> ' + @workdir + @workfilename
	exec master..xp_cmdshell @cmd
	select	@cmd = 'echo '					+ 'get ' + @FTPPath + @FTPFileName + ' ' + @SourcePath + @SourceFile
			+ ' >> ' + @workdir + @workfilename
	exec master..xp_cmdshell @cmd
	select	@cmd = 'echo '					+ 'quit'
			+ ' >> ' + @workdir + @workfilename
	exec master..xp_cmdshell @cmd
	
	select @cmd = 'ftp -s:' + @workdir + @workfilename

	create table #a (id int identity(1,1), s varchar(1000))
	insert into #a(s) values('')
	exec master..xp_cmdshell @cmd
	
	select id, ouputtmp = s from #a










GO
