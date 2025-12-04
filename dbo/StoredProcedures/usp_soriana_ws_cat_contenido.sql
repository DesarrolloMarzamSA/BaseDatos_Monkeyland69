CREATE procedure [dbo].[usp_soriana_ws_cat_contenido]
as

/*
select	--top 100
			convert(BIGINT, t2.cod_barras) Codigo, --Codigo,
			t1.contenido1 Contenido, --Contenido
			t1.unidadcontenido1 UnidadContenido --UnidadContenido
from		maestro_productos_baan_extras t1 
inner join maestro_productos_baan t2 on
			t1.codigo = t2.codigo			
INNER JOIN vi_catalogo_soriana t3 on t3.codigo = t1.codigo
where	--convert(bigint, t2.codigo) < dbo.gobierno() and 
			len(rtrim(ltrim(t2.lab_rfc)))  > 0
			and  isnumeric(t2.cod_barras ) = 1
			and convert(bigint, t2.cod_barras) > 0
			and left(t2.status, 1) <> 'B'

--			and t2.codigo NOT IN (
--'1501501',
--'0144702',
--'0066904',
--'0066905',
--'0279778',
--'0232515',
--'0232510',
--'0232513',
--'0232520',
--'1836088',
--'1836096',
--'1248532',
--'2138217',
--'0808014',
--'1253318',
--'0092004',
--'8407037',
--'2639913',
--'2639915'
--)		
			
			
order by 
			t2.cod_barras --desc
*/

/*
select	--top 100
--	distinct 
			convert(bigint, cs.cod_barras) Codigo, --Codigo,
			pr.contenido1 Contenido, --Contenido
			pr.unidadcontenido1 UnidadContenido --UnidadContenido
from	catalogo_soriana cs 
inner join maestro_productos_baan_extras	  pr on
			cs.codigo = pr.codigo			
			
*/			
			
/*			
where	--convert(bigint, t1.codigo) < dbo.gobierno() and 
			len(rtrim(ltrim(t2.lab_rfc)))  > 0
			--and  isnumeric(t2.cod_barras ) = 1
			--and convert(bigint, t2.cod_barras) > 0
			
*/

/*
order by 
--			codigo desc, Contenido, UnidadContenido
			cod_barras 
*/






select	--top 100
			convert(BIGINT, t2.cod_barras) Codigo, --Codigo,
			t1.contenido1 Contenido, --Contenido
			t1.unidadcontenido1 UnidadContenido --UnidadContenido
from		vi_catalogo_soriana t3 
inner join maestro_productos_baan t2 on t2.codigo = t3.codigo			
INNER JOIN maestro_productos_baan_extras t1 on t3.codigo = t1.codigo
where	--convert(bigint, t2.codigo) < dbo.gobierno() and 
			len(rtrim(ltrim(t2.lab_rfc)))  > 0
			and  isnumeric(t2.cod_barras ) = 1
			and convert(bigint, t2.cod_barras) > 0
			--and left(t2.status, 1) <> 'B'

--			and t2.codigo NOT IN (
--'1501501',
--'0144702',
--'0066904',
--'0066905',
--'0279778',
--'0232515',
--'0232510',
--'0232513',
--'0232520',
--'1836088',
--'1836096',
--'1248532',
--'2138217',
--'0808014',
--'1253318',
--'0092004',
--'8407037',
--'2639913',
--'2639915'
--)		

/*
and 			t3.cod_barras IN (
'7501037915112',								---	BISOLVONES
'7501034691538',
'7501034691415',
'7501034691620'
)
*/
			
order by 
			t3.cod_barras --desc

GO

