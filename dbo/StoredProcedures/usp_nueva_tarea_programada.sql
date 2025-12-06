USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_nueva_tarea_programada]
	@sucursal varchar(20),
	@rutainterfase varchar(100),
	@interfase varchar(100),
	@descripcion varchar(100),
	@hora varchar(20),
	@cliente varchar(20)
WITH ENCRYPTION
AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO tareas_programadas (id_tarea_programada,sucursal,path,ejecutable,descripcion,hora_ejecucion,parametros,dias,meses,ejecutado,demanda,habilitado,hora_ultima_ejecucion,selex,observaciones,propietario,clase,fecha_creacion,tipo) 
	VALUES ((select max(id_tarea_programada)+1 as max from tareas_programadas),@sucursal,@rutainterfase,@interfase,@descripcion,@hora,@cliente+'HOY','1111111','111111111111',0,0,1,GETDATE(),0,NULL,'MASR','STD',GETDATE(),'CFD')
END
GO
