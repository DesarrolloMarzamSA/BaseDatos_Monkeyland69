

--usp_genera_ofertas_medex 7, 'LIBRE', 'PLUS5'
--select * from maestro_productos_baan where descripcion like '%RANIFUR 150MG%'
CREATE    procedure [dbo].[usp_genera_ofertas_medex] @sucursal int, @primer_bolsa varchar(5), @segunda_bolsa varchar(5)
as

select
right('0000000000000000' + t1.cod_barras, 16) + 
left(t1.descripcion + '                                                  ', 50) + 
right('000000000' + convert(varchar(20), convert(bigint, 100 * case t1.grupo_est when 'PC01A' then t1.prec_farm + (t1.prec_farm * 0.5) else t1.prec_farm end)), 9) + 
case 
when t1.clas_fis = 'B'  then '0'
when t1.clas_fis = 'BA' then '1'
when t1.clas_fis = 'N'  then '0'
when t1.clas_fis = 'NA' then '1'
when t1.clas_fis = 'H'  then '0'
when t1.clas_fis = 'HA' then '1'
end +
right('00' + convert(varchar(2), convert(int, t1.iva * 100)), 2) + 
'0001' +
right('0000' + convert(varchar(6), convert(bigint, t2.porcentaje * 10000)), 4) +
'0000000000000000' +
convert(varchar(8), current_timestamp, 112)
from
maestro_productos_baan t1 inner join dboferta t2 on t1.codigo = t2.codigo 
inner join inventario_baan t3 on t1.codigo = t3.codigo and t3.sucursal = @sucursal
where
t2.sucursal = @sucursal and t2.bolsa = @primer_bolsa and
convert(int, t1.codigo ) < dbo.gobierno() and
substring(t1.status, 1, 1) <> 'B' 
union
select
right('0000000000000000' + t1.cod_barras, 16) + 
left(t1.descripcion + '                                                  ', 50) + 
right('000000000' + convert(varchar(20), convert(bigint, 100 * case t1.grupo_est when 'PC01A' then t1.prec_farm + (t1.prec_farm * 0.5) else t1.prec_farm end)), 9) + 
case 
when t1.clas_fis = 'B'  then '0'
when t1.clas_fis = 'BA' then '1'
when t1.clas_fis = 'N'  then '0'
when t1.clas_fis = 'NA' then '1'
when t1.clas_fis = 'H'  then '0'
when t1.clas_fis = 'HA' then '1'
end +
right('00' + convert(varchar(2), convert(int, t1.iva * 100)), 2) + 
'0001' +
right('0000' + convert(varchar(6), convert(bigint, t2.porcentaje * 10000)), 4) +
'0000000000000000' +
convert(varchar(8), current_timestamp, 112)
from
maestro_productos_baan t1 inner join dboferta t2 on t1.codigo = t2.codigo 
inner join inventario_baan t3 on t1.codigo = t3.codigo and t3.sucursal = @sucursal
where
convert(int, t1.codigo ) < dbo.gobierno() and
substring(t1.status, 1, 1) <> 'B' and
t2.sucursal = @sucursal and t2.bolsa = @segunda_bolsa and
t2.codigo not in (select distinct codigo from dboferta where sucursal = @sucursal and bolsa = @primer_bolsa)

GO

