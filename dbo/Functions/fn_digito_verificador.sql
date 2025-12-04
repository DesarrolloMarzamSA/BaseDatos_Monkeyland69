
/*		static string digito_verificador(string cuenta)
		{
			string buffer = String.Empty;
			int i = 0;
			int[] factores = {6,5,4,3,2};
			int[] tabla = {1,2,3,4,5,6,7,8,9,10,11};
			int[] digitos = {0,0,9,8,7,6,5,4,3,2,1};
			int resultado = 0;
			for(i=0;i<5;i++)
			{
				resultado = resultado + int.Parse(cuenta.Substring(i, 1)) * factores[i];
			}
			resultado = (resultado % 11) + 1;
			for(i=0;i<11;i++)
			{
				if(resultado==tabla[i])
				{
					buffer = digitos[i].ToString();
				}
			}
			return buffer;
		}

*/


CREATE function fn_digito_verificador(@cliente varchar(5))
returns char(1)
as
begin
declare @i as int
declare @j as int
declare @perro as varchar(100)
declare @resultado as int
declare @factores char(5)
declare @buffer int
declare @tabla char(22)
declare @digitos char(11)
select @factores = '65432'
select @tabla = '0102030405060708091011'
select @digitos = '00987654321'
select @i = 0
select @resultado = 0
select @perro = ''
while(@i<6)
begin
	select @resultado = @resultado + (convert(int, substring(@cliente, @i, 1)) *  convert(int, substring(@factores, @i, 1)))
	select @i = @i + 1
end
select @resultado = (@resultado % 11) + 1
select @i = 1
select @j = 1
while(@i<24)
begin
	if(@resultado=convert(int, substring(@tabla, @i , 2)))
	begin
		select @buffer = convert(int, substring(@digitos, @j, 1))
	end
	select @i = @i + 2
	select @j = @j + 1
end
return  convert(char(1), @buffer)
end

GO

