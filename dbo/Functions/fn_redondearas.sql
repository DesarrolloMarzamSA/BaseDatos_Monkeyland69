CREATE function [dbo].[fn_redondearas](@num decimal(20, 4), @decimales int)
returns decimal(20, 4)
as
begin
declare @n decimal(20, 4)
select @n = @num * power(10, @decimales)
select @n = sign(@n) * abs(floor(@n + .49))
return @n / power(10, @decimales)
end

/*
select dbo.fn_redondearas(dbo.fn_redondearas(460 * (1 - 0.1666), 2) * 0.18, 2), 69 union
select dbo.fn_redondearas(dbo.fn_redondearas(58.88 * (1 - 0.0909), 2) * 0.18, 2), 9.64 union
select dbo.fn_redondearas(dbo.fn_redondearas(135.82 * (1 - 0.0909), 2) * 0.18, 2), 22.22 union
select dbo.fn_redondearas(dbo.fn_redondearas(332.84 * (1 - 0.0909), 2) * 0.18, 2), 54.46 union
select dbo.fn_redondearas(dbo.fn_redondearas(135.82 * (1 - 0.0909), 2) * 0.18, 2), 22.22 union
select dbo.fn_redondearas(dbo.fn_redondearas(92 * (1 - 0.0909), 2) * 0.18, 2), 15.06 union
select dbo.fn_redondearas(dbo.fn_redondearas(246.48 * (1 - 0.1666), 2) * 0.18, 2), 36.98 union
select dbo.fn_redondearas(dbo.fn_redondearas(50.7 * (1 - 0.1666), 2) * 0.18, 2), 7.6 union
select dbo.fn_redondearas(dbo.fn_redondearas(288.35 * (1 - 0.0909), 2) * 0.18, 2), 47.19 union
select dbo.fn_redondearas(dbo.fn_redondearas(135.82 * (1 - 0.0909), 2) * 0.18, 2), 22.22 



713.58
1277.5086
select sign(576.5400)
select floor(576.5400 + .46)
*/

GO

