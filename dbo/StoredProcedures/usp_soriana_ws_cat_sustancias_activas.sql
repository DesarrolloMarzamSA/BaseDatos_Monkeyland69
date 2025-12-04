CREATE procedure [dbo].[usp_soriana_ws_cat_sustancias_activas]
as

/*
select	distinct
			2 cantidad,  --Cantidad
			--case
			--	when len(desc_sus_act1) > 0 and len(desc_sus_act2) > 0 then 2
			--	when len(desc_sus_act1) > 0 and len(desc_sus_act2) = 0 then 1
			--	when len(desc_sus_act1) = 0 and len(desc_sus_act2) > 0 then 1
			--	when len(desc_sus_act1) = 0 and len(desc_sus_act2) = 0 then 0
			--end cantidad,  --Cantidad
			convert(decimal(19,0), cod_barras) Codigo --Codigo,
from		maestro_productos_baan
where	
			convert(bigint, codigo) < 2900000 
--			AND
--			 cod_barras in ('0736085400892',
--'0000075003845',
--'7501070635596',
--'0736085400984'
--)
*/


select	distinct
			2 cantidad,  --Cantidad
			convert(decimal(19,0), mp.cod_barras) Codigo --Codigo,
from		maestro_productos_baan mp 
inner join vi_catalogo_soriana cs on mp.codigo = cs.codigo

GO

