
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

--SELECT PROD_ID, PROD_DESC FROM ttiitm001080



--exec usp_mptij_roma_catalogo 6
CREATE procedure [dbo].[usp_mptij_roma_catalogo] 
WITH ENCRYPTION
as
declare @sucursal tinyint 
select @sucursal = 6
declare @descuento money
select @descuento = convert(money, descuento) from clientes_baan where sucursal = 6 and cliente = '01928'


select 
right(t1.codigo, 6) +
case when t1.iva > 0 then '1' else '0' end +
left(t1.descripcion + '                              ', 30) + '|' +
right('0000000000' + convert(varchar(10), case grupo_est when 'PC01A' then convert(int, 100 * t1.prec_pub * 1.5) else convert(int, t1.prec_pub * 100) end), 9) +  '|' +
right('0000000000' + convert(varchar(10), case grupo_est when 'PC01A' then convert(int, 100 * t1.prec_farm * 1.5) else convert(int, t1.prec_farm * 100) end), 9) + '|' +
left(t1.lab_corto, 3) +  '|' +
case 
when t1.clas_fis = 'B'  then right('0000' + convert(varchar(16), convert(bigint, 100 * @descuento)), 4)
when t1.clas_fis = 'BA' then right('0000' + convert(varchar(16), convert(bigint, 100 * @descuento)), 4)
when t1.clas_fis = 'N'  then '0000' 
when t1.clas_fis = 'NA' then '0000' 
when t1.clas_fis = 'H'  then right('0000' + convert(varchar(16), convert(bigint, 100 * t1.descto_prod)), 4) 
when t1.clas_fis = 'HA' then right('0000' + convert(varchar(16), convert(bigint, 100 * t1.descto_prod)), 4)  end + '|' +
'  ' +  '|' +
' ' + '|' +
' ' + t1.cod_barras +  '|' +
case grupo_est when 'PC01A' then '05000' else '00000' end + '|' +
t1.cod_barras +  '|' +
'00' + '|' +
'00001' + '|' +
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
case t1.refrigerado when 'R' then '1' else '0' end  + '|' +
case t1.clas_ssa 
when '1' then 'P' 
when '2' then 'P' 
when '3' then 'P' 
else ' ' end  '|' 
from
maestro_productos_baan t1 inner join inventario_baan t2 on t1.codigo = t2.codigo
where
t2.sucursal = @sucursal and
isnumeric(t1.cod_barras) = 1 and 
convert(int, t1.codigo) < dbo.gobierno() and
t2.piezas > 0



GO
