-- =============================================
-- Author: Francisco Roberto Martínez Hernández
-- Create date: 25/06/2019
-- Description:	Actualiza la configuración del cliente indicado
--  EXEC [CFD_Std].[usp_ActualizaConfiguracionCliente] 
-- =============================================
CREATE PROCEDURE [CFD_Std].[usp_ActualizaConfiguracionCliente]

	@id_tarea INT,
	@idcliente VARCHAR (10),
	@descripcion VARCHAR (50),
	@clave_proveedor VARCHAR (20),
	--Siguientes 3 columnas para actualizar tabla(tareas_programadas)
	@id_tarea_programada VARCHAR (10),
	@hora_ejecucion VARCHAR (150),
	@observaciones VARCHAR (400),

    @periodo VARCHAR (1),
    @habilitado BIT,
	@nc BIT,	
    @correo BIT,
    @zip BIT,
    @renombrar BIT,
	@pdf BIT,
	@archivo VARCHAR (50),
	@sucursal INT,	
	@sc BIT,
	@segto VARCHAR (2),
	@ctepadre VARCHAR (20),
	@brfc BIT,
	@rfc VARCHAR (13),
    @direcciones VARCHAR (6000),
	@query VARCHAR (500),		    
	@ftp BIT,
	@ftp_host VARCHAR (50),
	@ftp_usuario VARCHAR (50),
	@ftp_password VARCHAR (50),
	@ftp_ruta_inbox VARCHAR (255),
	@ftp_ruta_outbox VARCHAR (255),
	@ftp_ruta_resp VARCHAR (255),
    --@as2 BIT,
	--@as2_host VARCHAR (50),
	--@as2_usuario VARCHAR (50),
	--@as2_password VARCHAR (50),
	--@as2_ruta_inbox VARCHAR (255),
	--@as2_ruta_outbox VARCHAR (255),
	--@as2_ruta_resp VARCHAR (255),	
	@add_mailbody BIT,
	@mail_body VARCHAR (255),	
	--@tarea INT,
	--@ticket INT,
	--@hora VARCHAR (4),	
	--@nc_c8 BIT,
	@cuentas VARCHAR (1500)
AS
BEGIN
	
  MERGE INTO cfd_parametros_estandar T
  USING 
  (
     SELECT
	        @id_tarea AS id_tarea, @idcliente AS idcliente, @sucursal AS sucursal, @descripcion AS descripcion, @segto AS segto, @ctepadre AS ctepadre
			, @habilitado AS habilitado, @ftp AS ftp, @correo AS correo, @zip AS zip, @pdf AS pdf, @archivo AS archivo, @direcciones AS direcciones
			, @ftp_host AS ftp_host, @ftp_usuario AS ftp_usuario, @ftp_password AS ftp_password, @ftp_ruta_inbox AS ftp_ruta_inbox, @ftp_ruta_outbox AS ftp_ruta_outbox, @ftp_ruta_resp AS ftp_ruta_resp
			, @query AS query, @periodo AS periodo, @clave_proveedor AS clave_proveedor, @mail_body AS mail_body, @add_mailbody AS add_mailbody
			, @nc AS nc, @sc AS sc, @brfc AS brfc, @rfc AS rfc,@cuentas AS cuentas
  ) S ON (T.id_tarea=S.id_tarea)
  WHEN MATCHED THEN
    UPDATE SET 	
           T.id_tarea = S.id_tarea,
           T.idcliente = S.idcliente,
           T.sucursal = S.sucursal,
           T.descripcion = S.descripcion,
           T.segto = S.segto,
           T.ctepadre = S.ctepadre,
           T.habilitado = S.habilitado,
           T.ftp = S.ftp,
           T.correo = S.correo,
           --T.as2 = S.as2,
           T.zip = S.zip,
           T.pdf = S.pdf,
           T.archivo = S.archivo,
           T.direcciones = S.direcciones,
           T.ftp_host = S.ftp_host,
           T.ftp_usuario = S.ftp_usuario,
           T.ftp_password = S.ftp_password,
           T.ftp_ruta_inbox = S.ftp_ruta_inbox,
           T.ftp_ruta_outbox = S.ftp_ruta_outbox,
           T.ftp_ruta_resp = S.ftp_ruta_resp,
           --T.as2_host = S.as2_host,
           --T.as2_usuario = S.as2_usuario,
           --T.as2_password = S.as2_password,
           --T.as2_ruta_inbox = S.as2_ruta_inbox,
           --T.as2_ruta_outbox = S.as2_ruta_outbox,
           --T.as2_ruta_resp = S.as2_ruta_resp,
           T.query = S.query,
           --T.fecha_alta = S.fecha_alta,
           T.periodo = S.periodo,
           T.clave_proveedor = S.clave_proveedor,
           T.mail_body = S.mail_body,
           T.add_mailbody = S.add_mailbody,
           T.nc = S.nc,
           T.sc = S.sc,
           T.brfc = S.brfc,
           T.rfc = S.rfc,
		   T.cuentas=S.cuentas; 

	
  --Se actualiza tabla de tareas programadas
  IF (LEN(LTRIM(RTRIM(@id_tarea_programada)))>0 )
  BEGIN
    IF EXISTS(SELECT TOP 1 1 FROM tareas_programadas WITH(NOLOCK) WHERE id_tarea_programada=@id_tarea_programada)
    BEGIN
	 DECLARE  @descripcion_tarea_programada VARCHAR (150)
	 SELECT @descripcion_tarea_programada= ISNULL(IATA,'')+' - ' + @descripcion+ ' - CFD ESTANDAR MAIL' FROM sucursales WITH(NOLOCK)	WHERE sucursal = @sucursal
	 UPDATE tareas_programadas SET hora_ejecucion = @hora_ejecucion, observaciones = @observaciones, sucursal = @sucursal, descripcion = @descripcion_tarea_programada, parametros= (@idcliente + ' HOY') WHERE id_tarea_programada=@id_tarea_programada
    END
  END

END

GO

