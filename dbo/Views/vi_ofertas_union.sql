




CREATE
--CREATE 
VIEW [dbo].[vi_ofertas_union]
AS

SELECT 
	--DISTINCT 
		sucursal						,
		metodo							,
		codigo							,
		--status							,
		--tipo_oferta					,
		cant_base						,
		cant_oferta					,
		porcentaje					,
		vigencia_inicial		,
		vigencia_final			,
		disponible					,
		timestamp						

FROM Capa_ibs.dbo.tbl_metodos_ofertas
WHERE 
--sucursal = 5 and 
metodo in (
--'EF571','ZFHYB','EFLIB'
(
SELECT bolsa FROM bolsas_ofertas WHERE cadena = 'FUNION' /*ORDER by orden*/  ) 
)
/*
AND
(
vigencia_inicial >= '2012-07-10' and 
vigencia_final   >= CONVERT(DATE, GETDATE() )
)
*/

GO

