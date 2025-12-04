CREATE procedure [dbo].[usp_soriana_ws_cat_sustancias_activas02]
as
/*
select	2 orden, --orden
			convert(decimal(19,0), cod_barras) Codigo, --Codigo,
			desc_sus_act2 Nombre, --Nombre
			0000.00 Concentracion, --Concentracion
			'   ' UnidadConcentracion --UnidadConcentracion
from		maestro_productos_baan
where convert(bigint, codigo) < 2900000
--AND  cod_barras in ('0736085400892',
--'0000075003845',
--'7501070635596',
--'0736085400984'
--)
*/


select	2 orden, --orden
			convert(decimal(19,0), mp.cod_barras) Codigo, --Codigo,
			desc_sus_act2 Nombre, --Nombre
			0000.00 Concentracion, --Concentracion
			'   ' UnidadConcentracion --UnidadConcentracion



from		maestro_productos_baan mp 
inner join vi_catalogo_soriana cs on mp.codigo = cs.codigo

GO

