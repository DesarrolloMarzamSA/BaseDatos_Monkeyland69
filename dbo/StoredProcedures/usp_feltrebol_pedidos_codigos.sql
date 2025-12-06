
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


CREATE	--	CREATE
PROCEDURE [dbo].[usp_feltrebol_pedidos_codigos]
WITH ENCRYPTION
AS


UPDATE pedidos_ftrebol SET 
	codigo = mp.codigo
FROM pedidos_ftrebol pt
INNER JOIN maestro_productos_baan mp ON mp.cod_barras = pt.cod_barras

DELETE FROM pedidos_ftrebol 
WHERE codigo > dbo.gobierno()



GO
