
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


CREATE	--	CREATE
PROCEDURE [dbo].[usp_soriana_cfd_busca_tienda]
@sucursal INT, @cliente VARCHAR(5)

WITH ENCRYPTION
AS
/*
EXECUTE usp_soriana_cfd_busca_tienda 5, '05321'
*/

SELECT 
	CONVERT(INT, numTienda) numTienda, 
	nombre,
	sucursal, 
	cliente, 
	gln 
FROM CatTiendasSoriana
WHERE sucursal = @sucursal AND cliente = @cliente
GO
