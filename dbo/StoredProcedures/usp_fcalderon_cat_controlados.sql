USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


CREATE	--	CREATE
PROCEDURE [dbo].[usp_fcalderon_cat_controlados]	WITH ENCRYPTION
AS

--	HECHO	POR:		MIGUEL SAMAYOA
--	2011-03-30		CREACION

SELECT	--*
	mp.codigo							,
	mp.cod_barras					,
	mp.descripcion				
FROM maestro_productos_baan mp
WHERE	mp.codigo < dbo.gobierno()
AND mp.clas_ssa IN ( 1, 2, 3)
ORDER BY mp.codigo
GO
