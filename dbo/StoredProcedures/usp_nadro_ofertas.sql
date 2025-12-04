create procedure usp_nadro_ofertas
as
select 
'       ' + 
t1.cod_barras +
left(t1.descripcion + replicate(' ', 35), 35) + 
left(convert(varchar(6), t2.porcentaje) + '0000', 6) +
replace(convert(varchar(10), t2.vigencia_inicial, 121), '-', '') +
replace(convert(varchar(10), t2.vigencia_final, 121), '-', '')
from
maestro_productos_baan t1 inner join dboferta t2 on t1.codigo = t2.codigo
where
t2.sucursal = 1 and
convert(int, t1.codigo) < dbo.gobierno() and
left(t1.status, 1) <> 'B' and
t2.bolsa = 'C1868'
order by t1.descripcion

GO

