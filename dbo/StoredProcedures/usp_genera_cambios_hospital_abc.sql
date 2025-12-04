USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_genera_cambios_hospital_abc]
WITH ENCRYPTION
as
select '353' + '	' + t1.cod_barras + '	' + ' ' + '	' + 
case t1.clas_fis 
when 'N'  then convert(varchar(20), round(t1.prec_farm * 100, 0, 2)/100) 
when 'NA' then convert(varchar(20), round(t1.prec_farm * 100, 0, 2)/100) 
when 'B'  then convert(varchar(20), convert(decimal(6, 2), round((t1.prec_farm - (t1.prec_farm * 0.18)) * 100, 0, 2)/100)) 
when 'BA' then convert(varchar(20), convert(decimal(6, 2), round((t1.prec_farm - (t1.prec_farm * 0.18)) * 100, 0, 2)/100)) 
when 'H'  then convert(varchar(20), convert(decimal(6, 2), round((t1.prec_farm - (t1.prec_farm * (t1.descto_prod/100)))*100, 0, 2)/100)) 
when 'HA' then convert(varchar(20), convert(decimal(6, 2), round((t1.prec_farm - (t1.prec_farm * (t1.descto_prod/100)))*100, 0, 2)/100)) 
end + '	' +  
convert(varchar(20), t1.prec_pub) + '	' + 
case t1.clas_fis when 'N' then '00.00' when 'NA' then '00.00' when 'B' then '18.00' when 'BA' then '18.00' when 'H' then right('00' + convert(varchar(6), t1.descto_prod), 5)  when 'HA' then right('00' + convert(varchar(6), t1.descto_prod), 5) end + '	' + 
replace(replace(replace(convert(varchar(19), current_timestamp, 121), '-', ''), ' ', ''), ':', '')  
from maestro_productos_baan t1 inner join inventario_baan t2 on t1.codigo = t2.codigo and t2.sucursal =  1   
where 
convert(int, t1.codigo) < dbo.gobierno()

GO
