-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Ahorro].[reporteProduccion]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	 SELECT RP.[year]
      ,RP.[mes]
      ,RP.[dia]
	  ,case RP.diaSemana 
 when 1 then 'Domingo'
 when 2 then 'Lunes'
 when 3 then 'Martes'
 when 4 then 'Miercoles'
 when 5 then 'Jueves'
 when 6 then 'Viernes'
 when 7 then 'Sabado'
 end as [Dia Semana]
      ,[totalLineas]
      ,[lineasEnviadas]
      ,[lineasFaltantes]
      ,[pedidosTotales]
      ,[pedidosTraductor]
      ,[pedidosFaltantes]
	  ,DD.TotalArchivos
  FROM [Ahorro].[resumenPedidos] RP
  LEFT JOIN Ahorro.ArchivosDescargadosDia DD
  ON RP.[year] = DD.[year] AND RP.mes = DD.mes AND RP.dia = DD.dia
  order by [year] desc,[mes] desc,[dia] desc

END

GO

