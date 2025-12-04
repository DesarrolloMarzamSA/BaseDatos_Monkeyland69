

CREATE function [dbo].[ufn_numero_a_hora](@numero int)
returns varchar(12)
as
begin
declare @hora int, @minuto int, @segundo int
	select @hora = @numero / 3600
	select @minuto = (@numero % 3600) / 60
	select @segundo = ((@numero % 3600) % 60) 
	return right('00' + convert(varchar(2), @hora), 2) + ':' + right('00' + convert(varchar(2), @minuto), 2) + ':' + right('00' + convert(varchar(2), @segundo), 2) + '.000'
end

GO

