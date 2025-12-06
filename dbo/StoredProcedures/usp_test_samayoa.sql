USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE	--	create
procedure [dbo].[usp_test_samayoa]
WITH ENCRYPTION
as


declare @valor int

set @valor = 0

while @valor < 10
begin
	waitfor delay '00:00:05.000'
	print  convert(varchar,getdate(),121) + ' ' + convert(varchar, @valor)
	set @valor = @valor + 1
end
GO
