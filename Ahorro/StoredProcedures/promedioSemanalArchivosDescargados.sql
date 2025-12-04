-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Ahorro].[promedioSemanalArchivosDescargados]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  select SUM(Lunes) as Lunes,
		 SUM(Martes) as Martes,
		 SUM(Miercoles) as Miercoles,
		 SUM(Jueves) as Jueves,
		 SUM(Viernes) as Viernes,
		 SUM(Sabado) as Sabado,
		 SUM(Domingo) as Domingo
  from(
  select isnull(AVG(TotalArchivos),0) as Lunes,
		 0 as Martes,
		 0 as Miercoles,
		 0 as Jueves,
		 0 as Viernes,
		 0 as Sabado,
		 0 as Domingo
  From [Ahorro].ArchivosDescargadosDia
  where diaSemana=2
  union
  select 0 as Lunes,
		 AVG(isnull(TotalArchivos,0)) as Martes,
		 0 as Miercoles,
		 0 as Jueves,
		 0 as Viernes,
		 0 as Sabado,
		 0 as Domingo
  From [Ahorro].ArchivosDescargadosDia
  where diaSemana=3
  union
  select 0 as Lunes,
		 0 as Martes,
		 AVG(isnull(TotalArchivos,0)) as Miercoles,
		 0 as Jueves,
		 0 as Viernes,
		 0 as Sabado,
		 0 as Domingo
  From [Ahorro].ArchivosDescargadosDia
  where diaSemana=4
  union
  select 0 as Lunes,
		 0 as Martes,
		 0 as Miercoles,
		 AVG(isnull(TotalArchivos,0)) as Jueves,
		 0 as Viernes,
		 0 as Sabado,
		 0 as Domingo
  From [Ahorro].ArchivosDescargadosDia
  where diaSemana=5
  union
  select 0 as Lunes,
		 0 as Martes,
		 0 as Miercoles,
		 0 as Jueves,
		 AVG(isnull(TotalArchivos,0)) as Viernes,
		 0 as Sabado,
		 0 as Domingo
  From [Ahorro].ArchivosDescargadosDia
  where diaSemana=6
  union
  select 0 as Lunes,
		 0 as Martes,
		 0 as Miercoles,
		 0 as Jueves,
		 0 as Viernes,
		 AVG(isnull(TotalArchivos,0)) as Sabado,
		 0 as Domingo
  From [Ahorro].ArchivosDescargadosDia
  where diaSemana=7
  union
  select 0 as Lunes,
		 0 as Martes,
		 0 as Miercoles,
		 0 as Jueves,
		 0 as Viernes,
		 0 as Sabado,
		 AVG(isnull(TotalArchivos,0)) as Domingo
  From [Ahorro].ArchivosDescargadosDia
  where diaSemana=1
    ) as x

END

GO

