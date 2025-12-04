-- =============================================
-- Author:		Omar Hernández López
-- Create date: Mayo 2' 2016
-- Description:	Generar Reporte Mensual de Sanofi
-- =============================================
create PROCEDURE [dbo].[REPORTE_MENSUAL_SANOFI]
	@fechaInicio int, @fechaFin int
AS
BEGIN
	SET NOCOUNT ON;

	declare @SQL varchar(MAX) = '
		select * from openquery(AS400,''
select 
case
when IDSROM=''''01C'''' then ''''Guadalajara''''
when IDSROM=''''01G'''' then ''''Monterrey''''
when IDSROM=''''01J'''' then ''''Tijuana''''
when IDSROM=''''01M'''' then ''''Mérida''''
when IDSROM=''''01R'''' then ''''Hermosillo''''
when IDSROM=''''01U'''' then ''''Metropolitano''''
when IDSROM=''''01X'''' then ''''Juarez''''
when IDSROM=''''01E'''' then ''''Villahermosa''''
                   end as plaza,
IDSROM,IDINVN,IDORNO,IDIDAT,IDCUNO,IDPRDC,IDDESC,IDSQTY,IDITET,IDITIT,OHSURF as numero_orden
from MA4620EF04.SROISDPL
inner join MA4620EF04.SRBSOH on OHORNO=IDORNO
inner join MA4620EF04.SRONAM on IDCUNO=NANUM
 where  OHODAT>=' + Convert(varchar(MAX),@fechaInicio) + ' and OHODAT<=' + Convert(varchar(MAX),@fechaFin) + ' and OHORDT=''''FS''''
 union
select 
case
when IDSROM=''''01C'''' then ''''Guadalajara''''
when IDSROM=''''01G'''' then ''''Monterrey''''
when IDSROM=''''01J'''' then ''''Tijuana''''
when IDSROM=''''01M'''' then ''''Mérida''''
when IDSROM=''''01R'''' then ''''Hermosillo''''
when IDSROM=''''01U'''' then ''''Metropolitano''''
when IDSROM=''''01X'''' then ''''Juarez''''
when IDSROM=''''01E'''' then ''''Villahermosa''''
                   end as plaza,
IDSROM,IDINVN,IDORNO,IDIDAT,IDCUNO,IDPRDC,IDDESC,IDSQTY,IDITET,IDITIT,OHSURF
from MA4620EF11.SROISDPL
inner join MA4620EF11.SRBSOH on OHORNO=IDORNO
inner join MA4620EF11.SRONAM on IDCUNO=NANUM
 where  OHODAT>=' + Convert(varchar(MAX),@fechaInicio) + ' and OHODAT<=' + Convert(varchar(MAX),@fechaFin) + ' and OHORDT=''''FS''''
 with ur
'')
	'

	EXEC (@SQL)
END

GO

