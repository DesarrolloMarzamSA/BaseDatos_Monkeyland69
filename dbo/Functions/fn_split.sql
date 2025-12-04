create function [dbo].fn_split(@cadena varchar(4000), @delimitador char(1)) 
returns @resultado Table (items varchar(4000))
as
begin

declare @index int
declare @item varchar(4000)

select @index = 1
if @cadena is null return
while @index != 0
begin
	select @index = CharIndex(@delimitador, @cadena)
	if (@index != 0)
		begin
			Select @item = left(@cadena, @index - 1)
		end
	else
		begin
			Select @item = @cadena
		end
	insert into @resultado(items) Values (@item)
	select @cadena = right(@cadena, Len(@cadena) - @index)
	if len(@cadena) = 0 break
end

return
end

GO

