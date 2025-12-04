-- =============================================
-- Author:		mandrade
-- Create date: 2015-06-10
-- Description:	obtiene los hornos con doble folio
-- [usp_obtener_facturas_doblePedido_dia] '20161027'
-- =============================================
CREATE PROCEDURE [dbo].[usp_obtener_facturas_doblePedido_dia] @fecha varchar(8)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @query varchar(max)	
	set @query='
	select IHORNO,COUNT(IHINVN) AS TOTAL	
	from MA4620EF04.SROISH
	WHERE IHTYPP=1 AND IHIDAT ='+@fecha+' AND IHCUNO NOT IN(''''J00100'''')
	GROUP BY IHORNO
	HAVING COUNT(IHINVN)>=2'
--	print('select * from openquery(AS400,'''+@query+''')')
	execute ('select IHORNO from openquery(AS400,'''+@query+''')')    
END

GO

