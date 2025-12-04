
--exec usp_mptij_roma_ofertas 6, 'LIBRE', 'ZZZZZ'

CREATE procedure [dbo].[usp_mptij_roma_ofertas] 
as

declare @sucursal tinyint
declare @primer_bolsa varchar(5)
declare @segunda_bolsa varchar(5)

select @sucursal = 6
select @primer_bolsa = 'LIBRE'
select @segunda_bolsa = 'ZZZZZ'

select
'0000000' + 
right(t1.codigo, 6) +
'       ' +
'MZM' +
'D' +
'00000001' + 
right('0000000000' + convert(varchar(10), case grupo_est when 'PC01A' then convert(int, 100 * prec_farm * 1.5) else convert(int, prec_farm * 100) end), 10) +
'0000000000' + 
'0000000000' +
right('00000' + convert(varchar(10), convert(int, t1.porcentaje * 10000)), 5) +
'0000000' +
'0000000' +
'      ' +
'V' +
t2.cod_barras
from
dboferta t1 inner join maestro_productos_baan t2 on t1.codigo = t2.codigo
where
t1.sucursal = @sucursal and
t1.bolsa = @primer_bolsa and
isnumeric(t2.cod_barras) = 1 and
substring(t2.status, 1,1) <> 'B' and
convert(int, t2.codigo) < dbo.gobierno() 

union

select
'0000000' + 
right(t1.codigo, 6) +
'       ' +
'MZM' +
'D' +
'00000001' + 
right('0000000000' + convert(varchar(10), case grupo_est when 'PC01G' then convert(int, 100 * prec_farm * 1.5) else convert(int, prec_farm * 100) end), 10) +
'0000000000' + 
'0000000000' +
right('00000' + convert(varchar(10), convert(int, t1.porcentaje * 10000)), 5) +
'0000000' +
'0000000' +
'      ' +
'V' +
t2.cod_barras
from
dboferta t1 inner join maestro_productos_baan t2 on t1.codigo = t2.codigo
where
t1.sucursal = @sucursal and
t1.bolsa = @segunda_bolsa and
isnumeric(t2.cod_barras) = 1 and
substring(t2.status, 1,1) <> 'B' and
convert(int, t2.codigo) < dbo.gobierno() and
t2.codigo not in (select codigo from dboferta where sucursal = @sucursal and bolsa = @primer_bolsa)

GO

