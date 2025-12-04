
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [IBS].[DetalleOfertas]
@factura varchar(15)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  declare @query as varchar(max)='
  select idline,
   secuencia,
   rtrim(IDPRDC) as producto,
   DTDIID,
   Oferta,
   DTDCAM,
   DTHDCA
  from openquery(as400,''
  select idline,
  COALESCE(DTSEQ,0) as secuencia,
  IDPRDC,
  DTDIID,
  COALESCE(DTDCPR,0) AS Oferta,
  DTDCAM,
  DTHDCA
  from MA4620EF04.srbISD
  inner JOIN MA4620EF04.SROGDT on DTGDSQ = IDGDSQ AND DTDITY = ''''1''''
  where IDINVN='+@factura+'  order by idline,COALESCE(DTSEQ,0)
  '')'

exec (@query)

END

GO

