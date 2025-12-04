CREATE procedure [dbo].[usp_soriana_ws_cat_contenido2]
as


select	--top 100
			convert(BIGINT, t2.cod_barras) Codigo, --Codigo,
			t1.contenido2 Contenido, --Contenido
			t1.unidadcontenido2 UnidadContenido --UnidadContenido
from		maestro_productos_baan_extras t1 
inner join maestro_productos_baan t2 on
			t1.codigo = t2.codigo			
INNER JOIN vi_catalogo_soriana t3 on t3.codigo = t1.codigo
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
			
			
order by 
			t2.cod_barras --desc

			
/*			
select
			convert(bigint, cs.cod_barras) AS Codigo, --Codigo,
			pr.contenido2                  AS Contenido, --Contenido
			pr.unidadcontenido2            AS UnidadContenido --UnidadContenido
from	catalogo_soriana cs
inner join maestro_productos_baan_extras pr on
			pr.codigo = cs.codigo			
order by 
			cod_barras
*/

GO

