USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE	--	CREATE	--	DROP
PROCEDURE [dbo].[usp_feltrebol_catalogo]
WITH ENCRYPTION
AS

--	FECHA				DESCRIPCION					AUTOR
--	2011-08-11	CREACION						MIGUEL SAMAYOA

/*
EXECUTE usp_feltrebol_catalogo
*/


SELECT
	LEFT (mp.cod_barras + REPLICATE(' ',13) 																					,13)	codigo_ean			,
	LEFT (mp.descripcion + REPLICATE(' ',31)																					,31)	descripcion			,
	RIGHT(REPLICATE(' ',10) + CONVERT(VARCHAR, CONVERT(MONEY,
		CASE mp.grupo_est WHEN 'PC01A' THEN mp.prec_farm	* 1.5 ELSE mp.prec_farm	END))	,10)	prec_farm				,
	RIGHT(REPLICATE(' ',10) + CONVERT(VARCHAR, CONVERT(MONEY,
		CASE mp.grupo_est WHEN 'PC01A' THEN mp.prec_pub		* 1.5 ELSE mp.prec_pub	END))	,10)	prec_farm				,
	RIGHT(REPLICATE(' ',10) + CONVERT(VARCHAR, 
	CASE  WHEN mp.clas_fis IN ('B','BA') THEN 18
				WHEN mp.clas_fis IN ('N','NA') THEN 0
				WHEN mp.clas_fis IN ('H','HA') THEN mp.descto_prod END)											,10)	porc_desc_fin
FROM maestro_productos_baan mp			WITH (NOLOCK)
INNER JOIN inventario_baan  ib			WITH (NOLOCK) ON 
	ib.sucursal = 1 AND ib.codigo = mp.codigo AND ib.piezas > 0
WHERE
	CONVERT(INT,mp.codigo) < dbo.gobierno() AND 
	ISNUMERIC(cod_barras) = 1
GO
