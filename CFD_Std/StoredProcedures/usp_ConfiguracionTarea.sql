-- =============================================
-- Author: Francisco Roberto Martínez Hernández
-- Create date: 25/06/2019
-- Description:	Obtiene la configuracion de la tarea asignada al cliente
--  EXEC [CFD_Std].[usp_ConfiguracionTarea] 3, 'c02950'
-- =============================================
CREATE PROCEDURE [CFD_Std].[usp_ConfiguracionTarea]
    @Sucursal INT,
	@IdCliente VARCHAR(15)
AS
BEGIN
	

	    DECLARE @CteLike VARCHAR(20) = REPLACE('%<Cliente>%','<Cliente>',@IdCliente)
        SELECT TOP 1
		id_tarea_programada,sucursal,path,ejecutable,descripcion,hora_ejecucion,parametros
		,dias,meses,ejecutado,demanda,habilitado,hora_ultima_ejecucion,selex,observaciones
		,propietario,clase,fecha_creacion,tipo
		FROM tareas_programadas WITH(NOLOCK) 
		 WHERE sucursal = @Sucursal and parametros like @CteLike  --and id_tarea_programada = '200200200'	    
		ORDER BY fecha_creacion DESC
END

GO

