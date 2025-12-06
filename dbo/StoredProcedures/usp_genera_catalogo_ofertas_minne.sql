
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_genera_catalogo_ofertas_minne]

AS



/*
DECLARE @porcentaje decimal(5,2)

SET @porcentaje = 
	(SELECT descuento FROM clientes_baan 
		WHERE sucursal = 24 AND cliente = '50323')
*/

--	2009-03-05	SE ELIMINO LA BOLSA LIBRE QUEDANDO EL SEGMENTO C2717

--	UPDATE bolsas_ofertas SET bolsa = 'PLUS7' where cadena  = 'FMINNE'


/*
EXECUTE usp_genera_catalogo_ofertas_minne;
*/

CREATE TABLE #ofertas_minne (
	sucursal						INT					,
  bolsa               VARCHAR( 5)	,
	codigo              VARCHAR( 7)	,
	--descripcion         VARCHAR(31)	,
 -- lab_corto           VARCHAR(20)	,
	cant_base           INT					,
	cant_oferta         INT					,
	porcentaje          MONEY,	--	DECIMAL(14,2)
	vigencia_inicial    DATETIME	,
	vigencia_final      DATETIME	,
	disponible					INT					,
	timestamp						DATETIME
	--cod_barras          VARCHAR(14)	,
 -- clas_fis            VARCHAR( 2)	,
 -- descto              MONEY				,
 -- status              VARCHAR( 1)
)

INSERT INTO #ofertas_minne
	--cod_barras          ,
 -- clas_fis            ,
 -- descto              ,
 -- status              

EXECUTE usp_constructor_ofertas 'FMINNE' ,23

DECLARE @sep varchar(1)
set @sep = ''

--SELECT * FROM #ofertas_minne


SELECT
 	REPLICATE('0', 6) + @sep + 
	LEFT(mp.descripcion + REPLICATE(' ',30)											,30)		+ @sep + 
  LEFT(mp.lab_corto + REPLICATE(' ', 4)												, 4)		+ @sep + 
	RIGHT(REPLICATE('0', 3) + CONVERT(VARCHAR,cant_base)  			, 3)		+ @sep + 
	RIGHT(REPLICATE('0', 3) + CONVERT(VARCHAR,cant_oferta)			, 3)		+ @sep + 
  RIGHT(REPLICATE('0', 7) + CONVERT(VARCHAR,porcentaje * 100)	, 7)		+ @sep + 
	CONVERT(VARCHAR(10),vigencia_inicial,112) 													+ @sep + 
	CONVERT(VARCHAR(10),vigencia_final	,112) 													+ @sep + 
	RIGHT(REPLICATE('0',13) + cod_barras											  ,13) + @sep + 
  LEFT(clas_fis + REPLICATE(' ', 2), 2) oferta
FROM #ofertas_minne ofe
INNER JOIN monkeyland.dbo.maestro_productos mp ON 
	mp.codigo = ofe.codigo
;

DROP TABLE #OFERTAS_MINNE

GO
