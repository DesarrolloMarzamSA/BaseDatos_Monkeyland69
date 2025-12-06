
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_genera_respuesta_pedidos_leyva]
	@arch_cliente VARCHAR(50),
	@hash_md5 VARCHAR(50)
WITH ENCRYPTION
AS

--DECLARE @arch_cliente VARCHAR(50)
--DECLARE	@hash_md5 VARCHAR(50)
--SET @arch_cliente = 'PEDIDOS.TXT'
--SET @hash_md5 = '6f16cb6f7d6237e8a532bfc418977c25'

SELECT	LEFT(CONVERT(VARCHAR(15), cod_barras) + REPLICATE(' ', 15), 15) +
		RIGHT(REPLICATE(' ', 7) + CONVERT(VARCHAR(7), cant_ped), 7) +
		RIGHT(REPLICATE(' ', 7) + CONVERT(VARCHAR(7), ISNULL(cant_surt, 0)), 7) +
		LEFT(CONVERT(VARCHAR(10), orden) + REPLICATE(' ', 10), 10) +
		LEFT(CONVERT(VARCHAR(13), sucursal) + REPLICATE(' ', 13), 13) +
		LEFT(CONVERT(VARCHAR(12), cliente) + REPLICATE(' ', 12), 12)
FROM	pedidos_leyva
WHERE	hash_md5 = @hash_md5 AND
		arch_cliente = @arch_cliente
GO
