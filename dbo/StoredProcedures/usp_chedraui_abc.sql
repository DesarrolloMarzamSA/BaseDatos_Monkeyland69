
CREATE procedure [dbo].[usp_chedraui_abc]
as
select t3.columnota + replace(convert(varchar(8), current_timestamp, 4), '.', '') + t3.cod_barras columnota, t3.prec_pub, t3.prec_farm 
into #cat
from 
(select 
'C' + 
'0' + t1.codigo + 
case t1.grupo_producto when '00' then '1' when '03' then '1' when '40' then '1' else '2' end +  
'00 0' + 
case t1.refrigerado when 'R' then '1' else '0' end + 
case when t1.clas_ssa in ('7', '8', '9', ' ') then case when t1.grupo_producto in ('00', '03', '40') then '7' else ' ' end else t1.clas_ssa end + 
case when t1.clas_fis in ('BA', 'NA', 'HA') then '2' else '4' end + 
left(t1.descripcion + '                                   ', 35) + 
left(t1.lab_corto + '          ', 10) +  
right('00000000000' + convert(varchar(9), convert(int, case t1.grupo_est when 'PC01A' then t1.prec_pub +  (t1.prec_pub * 0.5) else  t1.prec_pub end * 100)), 9) +  
right('00000000000' + convert(varchar(9), convert(int, case t1.grupo_est when 'PC01A' then t1.prec_farm + (t1.prec_farm * 0.5) else t1.prec_farm end * 100)), 9) +  
'0' columnota,  
right('0000000000000' + convert(varchar(13), convert(bigint, t1.cod_barras)), 13) cod_barras, 
t1.codigo, 
convert(int, right('00000000000' + convert(varchar(9), convert(int, case t1.grupo_est when 'PC01A' then t1.prec_pub +  (t1.prec_pub * 0.5) else  t1.prec_pub end * 100)), 9)) prec_pub, 
convert(int, right('00000000000' + convert(varchar(9), convert(int, case t1.grupo_est when 'PC01A' then t1.prec_farm + (t1.prec_farm * 0.5) else t1.prec_farm end * 100)), 9)) prec_farm 
from 
maestro_productos_baan t1 inner join inventario_baan t2 on t1.codigo = t2.codigo and t2.sucursal = 1 
where t1.lab_corto <> 'ASTRAZ' and isnumeric(t1.cod_barras) = 1 and convert(int, t1.codigo) < dbo.gobierno()
) t3 
inner join cambios_precio_baan t2 on t3.codigo = t2.t_item  
inner join dbcataut t4 on t3.codigo = t4.codigo and t4.segmento = 'E1' and t4.cadena = '015' 
group by 
t3.columnota, 
t3.cod_barras, 
t3.prec_pub, 
t3.prec_farm

GO

