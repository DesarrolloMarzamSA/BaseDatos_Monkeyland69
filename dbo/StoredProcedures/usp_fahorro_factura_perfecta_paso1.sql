
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_fahorro_factura_perfecta_paso1]
	@fecha_inicial VARCHAR(10),
	@fecha_final VARCHAR(10),
	@sql_complemento VARCHAR(8000)
WITH ENCRYPTION
AS
DECLARE @sql VARCHAR(8000)
SET @sql = ''
--DECLARE @fecha_inicial VARCHAR(10)
--DECLARE @fecha_final VARCHAR(10)
--DECLARE @sql VARCHAR(8000)
--DECLARE @sql_complemento VARCHAR(8000)
--SET @fecha_inicial = '2012-04-24'
--SET @fecha_final = '2012-05-02'
--SET @sql = ''
--SET @sql_complemento =	'(t2.factura = ''30198517'' and t2.codigos = ''002145201'') or
--						(t2.factura = ''30198517'' and t2.codigos = ''002082905''))'

SELECT	@sql =	'	SELECT	t2.factura + right(t2.codigos, 7) llave, 
							t1.sucursal, 
							t1.cliente, 
							t2.factura + right(t2.codigos, 7) llave, 
							t1.factura,
							t2.codigos,
							t3.cod_barras,
							t2.cant_ped,
							t4.devfa_pzas_aceptadas
					FROM	encabezado t1 INNER JOIN detalle t2 ON
							t1.sucursal = t2.sucursal AND
							t1.factura = t2.factura INNER JOIN maestro_productos_baan t3 ON 
							t2.codigos = ''00'' + t3.codigo LEFT OUTER JOIN devoluciones_spt_fahorro t4 ON 
							t1.sucursal = t4.devfa_sucursal AND 
							t1.factura = t4.devfa_folio_remision AND 
							t3.codigo = t4.devfa_codigo
					WHERE	t1.segto = ''C1'' AND
							t1.ctepadre = ''007'' AND
							t1.fechaprog BETWEEN CONVERT(DATETIME, '
SELECT @sql =	@sql + '''' + @fecha_inicial + '''' + ', 121) AND CONVERT(DATETIME, ' + '''' + @fecha_final + '''' + ', 121) AND ('
SELECT @sql =	@sql + @sql_complemento
EXECUTE (@sql)
GO
