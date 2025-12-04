CREATE PROCEDURE [dbo].[usp_farmacon_archivos_xml] 
	@sucursal TINYINT,
	@fecha datetime
AS

--DECLARE @sucursal TINYINT
--DECLARE @fecha datetime
--SET @sucursal = 17
--SET @fecha = '2012-08-14'

SELECT	DISTINCT 'Factura' +
		--RIGHT(REPLICATE('0', 8) + CONVERT(VARCHAR(8), CONVERT(BIGINT, t1.folio_fiscal)), 8) +
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
			WHEN t1.sucursal = 6 THEN '190.1.32.3'
			WHEN t1.sucursal = 16 THEN '190.1.4.169'   
			WHEN t1.sucursal = 17 THEN '190.1.32.3'  
			WHEN t1.sucursal = 18 THEN '190.1.32.3'  
			WHEN t1.sucursal = 25 THEN '190.1.4.169'  
			WHEN t1.sucursal = 50 THEN '190.1.32.3'
			WHEN t1.sucursal = 51 THEN '190.1.32.3'            
		END AS ip,
		CASE
			WHEN t1.sucursal = 6 THEN 'fae0120FJ' + CONVERT(VARCHAR(8), CONVERT(BIGINT, t1.folio_fiscal)) + '.xml'
			WHEN t1.sucursal = 16 THEN 'fae0120FP' + CONVERT(VARCHAR(8), CONVERT(BIGINT, t1.folio_fiscal)) + '.xml'
			WHEN t1.sucursal = 17 THEN 'fae0002FQ' + CONVERT(VARCHAR(8), CONVERT(BIGINT, t1.folio_fiscal)) + '.xml'
			WHEN t1.sucursal = 18 THEN 'fae0002FR' + CONVERT(VARCHAR(8), CONVERT(BIGINT, t1.folio_fiscal)) + '.xml'
			WHEN t1.sucursal = 25 THEN 'fae0002FY' + CONVERT(VARCHAR(8), CONVERT(BIGINT, t1.folio_fiscal)) + '.xml'
			WHEN t1.sucursal = 50 THEN 'fae0120FQ' + CONVERT(VARCHAR(8), CONVERT(BIGINT, t1.folio_fiscal)) + '.xml'
			WHEN t1.sucursal = 51 THEN 'fae0120FR' + CONVERT(VARCHAR(8), CONVERT(BIGINT, t1.folio_fiscal)) + '.xml'
		END
FROM	encabezado t1 INNER JOIN rutas_tandem t2 ON
		t1.sucursal =  t2.sucursal
WHERE	t1.fecha_tandem = convert(varchar, convert(varchar(10), @fecha, 121), 121) AND
		t1.sucursal = @sucursal AND
		--t1.segto = 'C2' AND 
		t1.ctepadre IN ('599', '873','965') 
GROUP BY	
		t1.sucursal, 
		t1.folio_fiscal, 
		t2.ip

GO

