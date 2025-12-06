
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_genera_respuesta_pedidos_esquivar]
	@arch_cliente VARCHAR(50),
	@hash_md5 VARCHAR(50)
WITH ENCRYPTION
AS

--DECLARE @arch_cliente VARCHAR(50)
--DECLARE @hash_md5 VARCHAR(50)
--SET @arch_cliente = '00092.173'
--SET @hash_md5 = '13b6d2d708a5295676f3afe02779b7f9'

SELECT	RIGHT(REPLICATE('0', 13) + CONVERT(VARCHAR, t1.cod_barras),13) +
		RIGHT(REPLICATE('0', 5) + CONVERT(VARCHAR, t1.cliente), 5) +
		RIGHT(REPLICATE(' ', 7) + CONVERT(VARCHAR, CAST(ISNULL(t1.cant_ped, 0)-ISNULL(t1.cant_surt, 0) AS INT)),7) +
		LEFT(ISNULL(t2.descripcion, 'NO EXISTE PRODUCTO ....') + REPLICATE(' ', 30), 30) + 
		CASE
			WHEN t1.motivo_no_surtido = 2 THEN '2    '
			WHEN t1.motivo_no_surtido = 7 THEN '7    '
			WHEN t1.motivo_no_surtido = 9 THEN '9    '
			WHEN t1.motivo_no_surtido = 0 THEN '7    '
			WHEN t1.cant_surt IS NULL AND t1.motivo_no_surtido IS NULL AND t1.tamano_archivo_respuesta IS NULL AND t1.codigo IS NULL AND t1.arch_tandem IS NULL THEN '11   ' 
			WHEN t1.cant_surt IS NULL AND t1.motivo_no_surtido IS NULL AND CONVERT(BIGINT, t1.codigo) > 0 AND t1.tamano_archivo_respuesta >= 54  THEN '9    '
			WHEN t1.cant_ped > t1.cant_surt AND t1.cant_surt > 0 AND t1.cant_surt IS NOT NULL AND t1.motivo_no_surtido = 0 THEN '7    '
			WHEN t1.sucursal IS NULL THEN '10   '
			ELSE '7    '
		END
FROM 	pedidos_esquivar t1 LEFT OUTER JOIN maestro_productos_baan t2 ON
		t1.codigo = t2.codigo 
WHERE 	((ISNULL(t1.cant_ped, 0) <> ISNULL(t1.cant_surt, 0)) OR 
		(ISNULL(t1.cant_surt, 0) IS NULL)) AND 
		t1.arch_cliente = @arch_cliente AND
		t1.hash_md5 IN (@hash_md5)
--UNION
--SELECT	RIGHT(REPLICATE('0', 13) + CONVERT(VARCHAR, t1.cod_barras),13) +
--		RIGHT(REPLICATE('0', 5) + CONVERT(VARCHAR, t1.cliente), 5) +
--		RIGHT(REPLICATE(' ', 7) + CONVERT(VARCHAR, CAST(ISNULL(t1.cant_ped, 0)-ISNULL(t1.cant_surt, 0) AS INT)),7) +
--		LEFT(ISNULL(t2.descripcion, 'NO EXISTE PRODUCTO ....') + REPLICATE(' ', 30), 30) + 
--		'10   '
--FROM 	pedidos_esquivar t1 RIGHT OUTER JOIN maestro_productos_baan t2 ON
--		t1.codigo = t2.codigo 
--WHERE 	((ISNULL(t1.cant_ped, 0) <> ISNULL(t1.cant_surt, 0)) OR 
--		(ISNULL(t1.cant_surt, 0) IS NULL)) AND 
--		t1.arch_cliente = @arch_cliente AND
--		t1.hash_md5 IN (@hash_md5) AND
--		t1.sucursal IS NULL
GO
