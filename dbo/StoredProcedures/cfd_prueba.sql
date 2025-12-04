-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE cfd_prueba
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   SELECT e.sucursal			, substring(convert(varchar,e.fechaprog,111),0,5)+'-'+cast(cast(substring(convert(varchar,e.fechaprog,111),6,2) as int)as varchar)+'-'+cast(cast(substring(convert(varchar,e.fechaprog,111),9,2) as int)as varchar) as fechaprog	,  e.serie_cfd,	e.folio_fiscal	,	e.IATA					,	e.cliente			,	e.farmacia			,	e.orden				,	e.fecha_tandem	,e.rfc					,(  + e.orden  )  cuerpo ,e.ctepadreFROM encabezado_cfd e WITH(NOLOCK) WHERE  e.fechaprog between CONVERT(SMALLDATETIME,'2017-04-05',121)-1 and CONVERT(SMALLDATETIME,'2017-04-05',121)+1 
 and e.ctepadre not in('007','044','139','319')
END

GO

