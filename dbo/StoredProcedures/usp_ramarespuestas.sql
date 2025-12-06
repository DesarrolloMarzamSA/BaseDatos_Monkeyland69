
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_ramarespuestas] 
	@archivo VARCHAR(10)
WITH ENCRYPTION
AS
SELECT 	'"' + RTRIM(codigo) + '","' + 
	RTRIM(codigopresentacion) + '","' + 
	RIGHT('00000' + CAST(cant_ped AS VARCHAR(5)), 5) + '","' + 
	digitocausa + '","' + precio + '","' + 
	RIGHT('00000' + CAST(cant_surt AS VARCHAR(5)), 5) + '","' + 
	piezassincargo + '"' 
FROM 	pedidos_rama 
WHERE 	rutaarchivo like '%' + @archivo + '%'
ORDER BY consecutivo

UPDATE	pedidos_rama
SET	procesado = '1'
WHERE	rutaarchivo like '%' + @archivo + '%'

GO
