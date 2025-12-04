CREATE PROCEDURE [dbo].[usp_farmacon_archivos_xml_02] 
	@fecha datetime
AS
--select * from openquery(as400,'select trim(natreg) as natreg from ma4620ef04.sronam where nanca1=''99599'' group by natreg')
-- exec [dbo].[usp_farmacon_archivos_xml_02] '2021-06-17'
--DECLARE @fecha datetime
--SET @fecha = '2012-08-29'

SELECT	DISTINCT 'Factura' +
		CONVERT(VARCHAR(8), CONVERT(BIGINT, t1.folio_fiscal) )+
		CASE
			WHEN t1.sucursal = 6 THEN 'FJ'
			WHEN t1.sucursal = 16 THEN 'FP'   
			WHEN t1.sucursal = 17 THEN 'FQ'  
			WHEN t1.sucursal = 18 THEN 'FR'  
			WHEN t1.sucursal = 25 THEN 'FY'  
			WHEN t1.sucursal = 50 THEN 'FQ'
			WHEN t1.sucursal = 51 THEN 'FR'            
		END,
		CASE
			WHEN t1.sucursal = 6 THEN 'fae0120FJ' + CONVERT(VARCHAR(8), CONVERT(BIGINT, t1.folio_fiscal)) + '.xml'
			WHEN t1.sucursal = 16 THEN 'fae0120FP' + CONVERT(VARCHAR(8), CONVERT(BIGINT, t1.folio_fiscal)) + '.xml'
			WHEN t1.sucursal = 17 THEN 'fae0002FQ' + CONVERT(VARCHAR(8), CONVERT(BIGINT, t1.folio_fiscal)) + '.xml'
			WHEN t1.sucursal = 18 THEN 'fae0002FR' + CONVERT(VARCHAR(8), CONVERT(BIGINT, t1.folio_fiscal)) + '.xml'
			WHEN t1.sucursal = 25 THEN 'fae0002FY' + CONVERT(VARCHAR(8), CONVERT(BIGINT, t1.folio_fiscal)) + '.xml'
			WHEN t1.sucursal = 50 THEN 'fae0120FQ' + CONVERT(VARCHAR(8), CONVERT(BIGINT, t1.folio_fiscal)) + '.xml'
			WHEN t1.sucursal = 51 THEN 'fae0120FR' + CONVERT(VARCHAR(8), CONVERT(BIGINT, t1.folio_fiscal)) + '.xml'
		END,
		t1.sucursal,
		t1.ctepadre
FROM	encabezado t1 WITH(NOLOCK) INNER JOIN rutas_tandem t2 ON
		t1.sucursal =  t2.sucursal
WHERE	t1.fecha_tandem = CONVERT(VARCHAR, CONVERT(VARCHAR(10), @fecha, 121), 121) AND
		t1.sucursal IN (1,21,6, 16, 17, 18, 25, 50, 51) AND
		--t1.segto = 'C2' AND 
		t1.ctepadre IN ('599', '873','965') 
GROUP BY	
		t1.sucursal,
		t1.ctepadre, 
		t1.folio_fiscal, 
		t2.ip
ORDER BY	
		t1.sucursal,
		t1.ctepadre

--		select t1.*
--		FROM	encabezado t1 WITH(NOLOCK) INNER JOIN rutas_tandem t2 ON
--		t1.sucursal =  t2.sucursal
--WHERE	-- = CONVERT(VARCHAR, CONVERT(VARCHAR(10), @fecha, 121), 121) AND
--		t1.sucursal IN (1,21,6, 16, 17, 18, 25, 50, 51) AND
--		--t1.segto = 'C2' AND 
--		t1.ctepadre IN ('599', '873','965') order by t1.fecha_tandem desc

GO

