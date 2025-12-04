USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE	--	CREATE	--	DROP
PROCEDURE [dbo].[usp_fmorelost_pedidos_codigos]
WITH ENCRYPTION
AS

--	DATE					ACTION			PROGRAMMER
--	2011-09-13		CREACION		MIGUEL SAMAYOA

DELETE FROM pedidos_fmorelost_historia
WHERE fecha_pedido < DATEADD(DD, -15, GETDATE() )

INSERT INTO pedidos_fmorelost_historia
SELECT * FROM pedidos_fmorelost p

UPDATE pedidos_fmorelost SET 
	codigo = mp.codigo
FROM pedidos_fmorelost pt
INNER JOIN maestro_productos_baan mp ON 
	mp.codigo < dbo.gobierno() AND
	RIGHT( REPLICATE('0', 13) + pt.cod_barras, 13) = mp.cod_barras
WHERE mp.codigo IS NULL OR mp.codigo = REPLICATE('0', 7)

DELETE FROM pedidos_fmorelost 
WHERE codigo = REPLICATE('0',7)

DELETE FROM pedidos_fmorelost
WHERE cliente NOT IN 
(SELECT cliente FROM cat_cuentas_fmorelost)


--IF(SELECT COUNT(*) FROM pedidos_fmorelost_historia p WHERE) > 0

--SELECT * FROM pedidos_fmorelost_historia p
GO
