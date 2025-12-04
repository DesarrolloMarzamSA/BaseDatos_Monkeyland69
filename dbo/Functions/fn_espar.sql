create function fn_espar(@entrada int)
returns int
as
begin
declare @resultado as int
	declare @equis as int
	select @equis = @entrada % 2
	if @equis = 1 
	begin
		select @resultado = 0
	end 
	else
	begin
		select @resultado = 1
	end


	/*  function odd(input_val) 
	  begin
		 x = input_val mod 2;
		 if x == 1 then
			return true;
		 else
			return false;
	   end
	*/
	return @resultado
end

GO

