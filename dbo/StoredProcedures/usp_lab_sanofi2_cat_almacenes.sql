
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


CREATE --	CREATE	--	DROP
PROCEDURE [dbo].[usp_lab_sanofi2_cat_almacenes]
@fecha VARCHAR(10)

AS

/*
EXECUTE usp_lab_sanofi2_cat_almacenes '2012-04-13'
*/


SELECT 
	@fecha																			fecha		,
	RIGHT('00'+CONVERT(VARCHAR,sucursal),  2)		sucusal	,
	ibs_letra																		letra		,
	descripcion																	nombre	,
	IATA																				abrev		
FROM sucursales WITH (NOLOCK) 
WHERE fisica = 1
GO
