-- =============================================
-- Author:      Cesar Alejandro Hernandez Carachure
-- Create date: 12/08/2020
-- Description: Actualiza o Inserta los archivos descargados de cada día
-- ============================================
CREATE PROCEDURE Ahorro.[Sp_ActualizaArchivosDescargadosPorDia] 
@fecha VARCHAR(15),
@NoArchivos BIGINT
 AS
   BEGIN

   DECLARE @NoArchivosActuales BIGINT
   DECLARE @diaSemana INT

   SET @diaSemana = (SELECT (CASE DATENAME(dw,@fecha)
     when 'Monday' then 2
     when 'Tuesday' then 3
     when 'Wednesday' then 4
     when 'Thursday' then 5
     when 'Friday' then 6
     when 'Saturday' then 7
     when 'Sunday' then 1
     END))
 
IF NOT EXISTS(SELECT [year], mes, dia FROM Ahorro.ArchivosDescargadosDia 
WHERE [year]=SUBSTRING(@fecha,1,4) AND mes = SUBSTRING(@fecha,6,2) AND dia = SUBSTRING(@fecha,9,2))
BEGIN

INSERT INTO Ahorro.ArchivosDescargadosDia ([year], mes, dia, TotalArchivos, diaSemana) VALUES 
(SUBSTRING(@fecha,1,4), SUBSTRING(@fecha,6,2), SUBSTRING(@fecha,9,2), @NoArchivos, @diaSemana)

END
ELSE
BEGIN

SET @NoArchivosActuales = (SELECT TotalArchivos FROM Ahorro.ArchivosDescargadosDia 
WHERE [year]=SUBSTRING(@fecha,1,4) AND mes = SUBSTRING(@fecha,6,2) AND dia = SUBSTRING(@fecha,9,2))

UPDATE Ahorro.ArchivosDescargadosDia SET TotalArchivos = @NoArchivosActuales + @NoArchivos
WHERE [year]=SUBSTRING(@fecha,1,4) AND mes = SUBSTRING(@fecha,6,2) AND dia = SUBSTRING(@fecha,9,2)

END

   END

GO

