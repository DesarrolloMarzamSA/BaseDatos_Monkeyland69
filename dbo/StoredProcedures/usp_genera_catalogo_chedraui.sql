USE monkeyland
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO






CREATE     procedure [dbo].[usp_genera_catalogo_chedraui]
WITH ENCRYPTION
as


--truncate table chedraui_precios

--insert into chedraui_precios select codigo, prec_farm, prec_pub from maestro_productos_baan where convert(int, codigo) < 6900000



--select 
--right('0000000000000' + convert(varchar(13), convert(bigint, t1.cod_barras)), 13) +
--left(t1.descripcion + '                                        ', 31) +
--left(right('       ' + convert(varchar(15), case t1.grupo_est when 'PC01A' then t2.pfar + (t2.pfar * 0.5) else t2.pfar end), 11), 8) +
--case 
--when t1.clas_fis = 'B' then '100.00'
--when t1.clas_fis = 'BA' then '100.00'
--when t1.clas_fis = 'N' then '  0.00' 
--when t1.clas_fis = 'NA' then '  0.00' 
--when t1.clas_fis = 'H' then right('   ' + convert(varchar(6), t1.descto_prod), 6) 
--when t1.clas_fis = 'HA' then right('   ' + convert(varchar(6), t1.descto_prod), 6) end
--from
--maestro_productos_baan t1 inner join chedraui_precios t2 on t1.codigo = t2.codigo
--where
--t1.codigo in (select codigo from inventario_baan) and 
--isnumeric(t1.cod_barras) = 1 and 
--convert(int, t1.codigo) < dbo.gobierno()
--order by
--t1.descripcion




--GO





select 
left(ltrim(t1.cod_barras_tandem) + '             ', 13) +
left(convert(varchar(50), t1.descripcion) + '                              ', 30) + 
left(right('       ' + convert(varchar(15), case t1.grupo_est when 'PC01A' then t1.prec_pub + (t1.prec_farm * 0.5) else t1.prec_pub end), 13), 10) + 
left(right('       ' + convert(varchar(15), case t1.grupo_est when 'PC01A' then t1.prec_farm + (t1.prec_farm * 0.5) else t1.prec_farm end), 13), 10) + 
case 
when t1.clas_fis = 'B' then '100.00'
when t1.clas_fis = 'BA' then '100.00'
when t1.clas_fis = 'N' then '  0.00' 
when t1.clas_fis = 'NA' then '  0.00' 
when t1.clas_fis = 'H' then right('      ' + convert(varchar(6), t1.descto_prod), 6) 
when t1.clas_fis = 'HA' then right('      ' + convert(varchar(6), t1.descto_prod), 6) else '  0.00' end
from
maestro_productos_baan t1 inner join inventario_baan t2 on t1.codigo = t2.codigo
where
t2.sucursal = 1 and
isnumeric(t1.cod_barras) = 1 and 
convert(int, t1.codigo) < dbo.gobierno()
order by
t1.descripcion

--select * from sysobjects where name like '%chedraui%'



GO
