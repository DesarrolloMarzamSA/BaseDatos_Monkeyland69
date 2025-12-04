
CREATE	--	CREATE	--	DROP
PROCEDURE [dbo].[usp_fardemex_catalogo_maestro]
	--@fecha VARCHAR(10)

AS

/*
EXECUTE usp_fardemex_catalogo_maestro
*/

/**************************************** viejo catalogo fardemex*/

DECLARE @sucursal INT
SET @sucursal = 4
IF (SELECT COUNT(*) FROM sys.sysobjects WHERE name = 'ofertas_fardemex') =0
	CREATE --	drop	--	truncate
	TABLE ofertas_fardemex (
	sucursal					int					,
	bolsa							varchar( 5)	,
	codigo						varchar( 7)	,
	cant_base					money				,
	cant_oferta				money				,
	porcentaje				money				,
	vigencia_inicial	DATE			,
	vigencia_final		DATE			,
	disponible				INT								,
	timestamp					DATETIME
	primary key (sucursal, bolsa, codigo) )

	TRUNCATE TABLE	ofertas_fardemex
	
	INSERT INTO ofertas_fardemex
	EXECUTE usp_constructor_ofertas 'FARDEMEX', @sucursal


DECLARE @descto_cte MONEY

SET @descto_cte = 
	(SELECT descuento FROM clientes_baan 
	WHERE sucursal = 4 AND cliente = '87872')


SELECT
	mpb.codigo																																				,
	LEFT( cod_barras  + REPLICATE(' ', 13)    , 13)												cod_barras	,
	LEFT( descripcion + REPLICATE(' ', 35)    , 35)												descripcion	,
	lab_largo																																					,
	RIGHT(REPLICATE(' ', 09) + CONVERT(VARCHAR,cast(precios.prec_farm as decimal(9,2))		) , 09)				prec_farm		,
	RIGHT(REPLICATE(' ', 09) + CONVERT(VARCHAR,prec_pub			) , 09)				prec_pub		,
	RIGHT(REPLICATE(' ', 06) + CONVERT(VARCHAR,iva					) , 06)				iva					,
	RIGHT(REPLICATE(' ', 06) + CONVERT(VARCHAR,
		case when mpb.codigo in('2514002','2514003') then CAST(1 as money)
	else
	dbo.udf_calc_descto_prod( mpb.clas_fis, @descto_cte	, mpb.descto_prod	 )   
		end
		) , 06)	descto,
	CASE 
	WHEN ib.piezas = 0 THEN 'FA'
	WHEN ib.piezas > 0 THEN 'NO'
	END estatus,
	LEFT( clas_fis + REPLICATE(' ',  2),  2)															clas_fis						,
	RIGHT(REPLICATE(' ', 06) + CONVERT(VARCHAR,/*CASE 
		WHEN mpb.clas_fis IN	('B', 'BA' ) THEN  06.10		--	B Y BA
		WHEN mpb.clas_fis IN	('N', 'NA' ) THEN  00.00		--	NETOS
		WHEN mpb.clas_fis = 'H' THEN  CASE		--	LIMITADOS
			WHEN mpb.cod_lab = 0170 THEN 
			WHEN mpb.lab_corto = 'BAYER' THEN 8
			WHEN mpb.lab_corto = 'BAYER' THEN 8
			ELSE 0
			END
		else 0 
		END					*/
	ISNULL(cfb.descto_bonif,0)			
		), 06)	AS descto_especial			,
	RIGHT(REPLICATE(' ', 06) + CONVERT(VARCHAR,0						), 06) 				descto_bonificacion	,
	RIGHT(REPLICATE(' ', 06) + CONVERT(VARCHAR,ISNULL(ofe.porcentaje * 100, 0)), 06) oferta

	--,codigo, status, clas_fis, clas_ssa
	/*+
	RIGHT(REPLICATE(' ', 09) + CONVERT(VARCHAR,descto_prod ) , 09) */
	
FROM maestro_productos_baan mpb
inner join openquery(AS400,'select trim(psprdc) as psprdc,COALESCE(PSSALP,0) as prec_farm,PSPRIL from  MA4620EF04.SR4PRS where PSPRIL=''02'' WITH UR') as precios
	on mpb.codigo=precios.psprdc
INNER JOIN inventario_baan ib ON 
	ib.sucursal = 21 AND ib.codigo = mpb.codigo
LEFT OUTER JOIN dboferta ofe ON 
	ofe.codigo = mpb.codigo and bolsa='LIBRE' and ofe.sucursal=21
LEFT OUTER JOIN cat_prod_fardemex_bonif_161213 cfb ON 
	cfb.codigo = mpb.codigo
WHERE 
	mpb.codigo < dbo.gobierno() AND
	LEFT(mpb.status ,1 ) <> 'B'
ORDER BY mpb.codigo

GO

