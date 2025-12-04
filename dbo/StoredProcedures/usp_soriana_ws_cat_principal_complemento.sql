CREATE procedure [dbo].[usp_soriana_ws_cat_principal_complemento]
as

/*
select		convert(decimal(19, 0), t2.cod_barras) Codigo, --Codigo
				t1.marca, 
				t1.presentacion
from			maestro_productos_baan_extras t1 
inner join maestro_productos_baan t2 on
				t1.codigo = t2.codigo
where convert(bigint, t1.codigo) < 2900000 
--AND  t2.cod_barras in ('0736085400892',
--'0000075003845',
--'7501070635596',
--'0736085400984'
--)
*/


--select		convert(decimal(19, 0), Ltrim(Rtrim(cs.cod_barras))) Codigo, --Codigo
--				t1.marca, 
--				t1.presentacion
--from			maestro_productos_baan_extras t1 
--inner join maestro_productos_baan t2 on
--				t1.codigo = t2.codigo
--inner join vi_catalogo_soriana cs on t1.codigo = t2.codigo


select		convert(decimal(19, 0), Ltrim(Rtrim(cs.cod_barras))) Codigo, --Codigo
				t1.marca, 
				t1.presentacion
from maestro_productos_baan_extras t1 
--inner join maestro_productos_baan t2 on t1.codigo = t2.codigo
inner join vi_catalogo_soriana cs on t1.codigo = cs.codigo

GO

