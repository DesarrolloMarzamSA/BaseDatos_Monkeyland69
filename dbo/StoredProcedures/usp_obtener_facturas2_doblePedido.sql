-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- [usp_obtener_facturas2_doblePedido] '28977172,28991667,28979872,28977919,28975773,28992246'
-- =============================================
CREATE PROCEDURE [dbo].[usp_obtener_facturas2_doblePedido] @ornos varchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	declare @query varchar(max)
	set @query='
	SELECT h.IHCUNO as Cliente,s.NANSNA as NomCliente,h.IHORNO as OrdenPedido,h.IHINVN as Factura,h.IHIDAT as Fecha,r.RSROUT as ruta
	FROM  MA4620EF04.SROISH h
	INNER JOIN MA4620EF04.SRONAM s ON h.IHCUNO=s.NANUM	
	INNER JOIN MA4620EF04.SRONAD s1 on s.NANUM=s1.ADNUM and s1.ADADNO=2
    INNER JOIN MA4620EF04.SRBRTS r on s1.ADDEST=r.RSDEST	
	where h.IHORNO in('+@ornos+') and IHCUNO not in(''''J00100'''')'
	
	--print('select * from openquery(AS400,'''+@query+''')')
	execute('select CLIENTE,replace(NOMCLIENTE,'','','''')as NOMCLIENTE,ORDENPEDIDO,FACTURA,FECHA,RUTA from openquery(AS400,'''+@query+''')')
END

GO

