USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO




--usp_genera_catalogo_medex 5, '00642'
CREATE  procedure [dbo].[usp_genera_catalogo_medex] @sucursal int, @cliente varchar(5)
WITH ENCRYPTION
as
declare @descuento money
select @descuento = convert(money, descuento) from clientes_baan where sucursal = @sucursal and cliente = @cliente

select 
'A' +
right('0000000000000000' + t1.cod_barras, 16) + 
right('0000000000000000' + t1.codigo, 14) + 
left(t1.descripcion + '                                                  ', 50) +
left(t1.lab_corto + '                    ', 20) + 
case t1.clas_ssa 
when '1' then '1' 
when '2' then '1' 
when '3' then '1' 
when '4' then '1' 
when '5' then '1' 
when '6' then '1' 
when '7' then '0' 
when '8' then '0' 
when '9' then '0' 
else '0' end +
case t1.refrigerado when 'R' then '1' else '0' end  +
case t1.clas_ssa 
when '1' then '1' 
when '2' then '3' 
when '3' then '3' 
else '0' end +
'PZA       001' +
case t1.clas_ssa 
when '1' then '1' 
when '2' then '1' 
when '3' then '1' 
when '4' then '1' 
when '5' then '1' 
when '6' then '1' 
when '7' then '0' 
when '8' then '0' 
when '9' then '0' 
else '0' end + 
convert(varchar(1), t2.derecho_devolucion) + 
right('000000000' + convert(varchar(20), convert(bigint, 100 * case t1.grupo_est when 'PC01A' then t1.prec_farm + (t1.prec_farm * 0.5) else t1.prec_farm end)), 9) + 
right('000000000' + convert(varchar(20), convert(bigint, 100 * case t1.grupo_est when 'PC01A' then t1.prec_pub +  (t1.prec_pub * 0.5)  else t1.prec_pub  end)), 9) + 
case t1.iva when 0 then '0' else '1' end +
right('00' + convert(varchar(2), convert(int, t1.iva * 100)), 2) + 
case 
when t1.clas_fis = 'B'  then right('0000' + convert(varchar(16), convert(bigint, 100 * @descuento)), 4)
when t1.clas_fis = 'BA' then right('0000' + convert(varchar(16), convert(bigint, 100 * @descuento)), 4)
when t1.clas_fis = 'N'  then '0000' 
when t1.clas_fis = 'NA' then '0000' 
when t1.clas_fis = 'H'  then right('0000' + convert(varchar(16), convert(bigint, 100 * t1.descto_prod)), 4) 
when t1.clas_fis = 'HA' then right('0000' + convert(varchar(16), convert(bigint, 100 * t1.descto_prod)), 4)  end +
case t1.grupo_est when 'PC01A' then '5000' else '0000' end +
convert(varchar(8), current_timestamp, 112) + '0'
from
maestro_productos_baan t1 inner join inventario_baan t2 on t1.codigo = t2.codigo
where
t2.sucursal = @sucursal and
isnumeric(t1.cod_barras) = 1 and 
convert(int, t1.codigo) < dbo.gobierno() /*and
t2.piezas > 0*/






GO
