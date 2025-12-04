USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE	--	CREATE	--	DROP
PROCEDURE [dbo].[usp_fmorelost_pedidos_faltantes]

WITH ENCRYPTION
AS


--	DATE				ACTION				AUTHOR
--	2011-09-14	CREATION			MIGUEL SAMAYOA

/*
EXECUTE usp_fmorelost_pedidos_faltantes;
*/

SELECT
	LEFT ( LTRIM(RTRIM(cod_barras))	+	REPLICATE(' ',13)																					,13)		cod_barras	,
	RIGHT( REPLICATE(' ', 7) + CONVERT(VARCHAR, cantidad_pedida	)																, 7)		pzas_ped		,
	RIGHT( REPLICATE(' ', 7) + CONVERT(VARCHAR, cantidad_pedida - ISNULL(cantidad_surtida, 0)	) , 7)		pzas_fal		,
	LEFT ( LTRIM(RTRIM(pedido))	+	REPLICATE(' ',10)																							,10)		num_pedido	,
	LEFT ( cliente	+	REPLICATE(' ',12)																													,12)		cliente			,
	LEFT ( CONVERT(VARCHAR, sucursal)	 +		 REPLICATE(' ', 2)																	, 2)		zona
FROM pedidos_fmorelost
GO
