
CREATE PROCEDURE [dbo].[usp_farmacon_archivos_xml_02_cfdi_reproceso] @fecha datetime
AS
--EXECUTE [usp_farmacon_archivos_xml_02_cfdi_reproceso] '2017-05-12'
--DECLARE @fecha datetime
--SET @fecha = '2012-08-29'
SELECT	DISTINCT 
t1.serie,substring(convert(varchar,t1.fechaprog,111),0,5)+'/'+cast(cast(substring(convert(varchar,t1.fechaprog,111),6,2) as int)as varchar)+'/'+cast(cast(substring(convert(varchar,t1.fechaprog,111),9,2) as int)as varchar),
'Factura' +
		CONVERT(VARCHAR(8), CONVERT(BIGINT, t1.folio_fiscal) )+
		t1.serie,
		CASE
			WHEN t1.sucursal = 6 THEN 'fae0120'+t1.serie + CONVERT(VARCHAR(8), CONVERT(BIGINT, t1.folio_fiscal)) + '.xml'
			WHEN t1.sucursal = 16 THEN 'fae0120'+t1.serie + CONVERT(VARCHAR(8), CONVERT(BIGINT, t1.folio_fiscal)) + '.xml'
			WHEN t1.sucursal = 17 THEN 'fae0002'+t1.serie + CONVERT(VARCHAR(8), CONVERT(BIGINT, t1.folio_fiscal)) + '.xml'
			WHEN t1.sucursal = 18 THEN 'fae0002'+t1.serie + CONVERT(VARCHAR(8), CONVERT(BIGINT, t1.folio_fiscal)) + '.xml'
			WHEN t1.sucursal = 25 THEN 'fae0002'+t1.serie + CONVERT(VARCHAR(8), CONVERT(BIGINT, t1.folio_fiscal)) + '.xml'
			WHEN t1.sucursal = 50 THEN 'fae0120'+t1.serie + CONVERT(VARCHAR(8), CONVERT(BIGINT, t1.folio_fiscal)) + '.xml'
			WHEN t1.sucursal = 51 THEN 'fae0120'+t1.serie + CONVERT(VARCHAR(8), CONVERT(BIGINT, t1.folio_fiscal)) + '.xml'
			WHEN t1.sucursal in(1,21) THEN 'fae0120'+t1.serie + CONVERT(VARCHAR(8), CONVERT(BIGINT, t1.folio_fiscal)) + '.xml'
		END,
		t1.sucursal,
		t1.ctepadre,t1.filler
FROM	Historica.dbo.encabezado t1 WITH(NOLOCK) INNER JOIN rutas_tandem t2 ON
		t1.sucursal =  t2.sucursal
WHERE	t1.fechaprog = CONVERT(VARCHAR, CONVERT(VARCHAR(10), @fecha, 121), 121) AND
		t1.sucursal IN (1,21,6, 16, 17, 18, 25, 50, 51) AND
		t1.segto = 'C2' AND 
		t1.ctepadre IN ('599', '873') 
GROUP BY	
		t1.sucursal,convert(varchar,t1.fechaprog,111),
		t1.serie,
		t1.ctepadre, 
		t1.folio_fiscal, 
		t2.ip,t1.filler
ORDER BY	
		t1.sucursal,
		t1.ctepadre

GO

