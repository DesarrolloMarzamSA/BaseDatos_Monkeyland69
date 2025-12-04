USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE
--	CREATE
PROCEDURE [dbo].[usp_lab_sanofi_bodegas] 
@almacen INT, @fecha VARCHAR(10)
WITH ENCRYPTION
AS
/*
usp_lab_sanofi_bodegas 18,'2011-02-11'
*/
/*
DECLARE @fecha VARCHAR(10)
SET @fecha = '2010-04-06'
DECLARE @almacen INT
SET @almacen = 1
*/
/*
DECLARE @SEP VARCHAR(10)
SET @SEP = '|'
DECLARE @contador INT
*/

SELECT DISTINCT
	RIGHT(REPLICATE('0', 2) + CONVERT(VARCHAR,sucursal), 2)  sucursal,
	descripcion
from sucursales			WITH (NOLOCK)
WHERE sucursal = @almacen AND virtual = 0 
--	ORDER BY IATA	
GO
