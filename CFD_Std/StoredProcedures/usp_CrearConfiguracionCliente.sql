-- =============================================
-- Author: Francisco Roberto Martínez Hernández
-- Create date: 25/06/2019
-- Description:	Actualiza la configuración del cliente indicado
--  EXEC [CFD_Std].[usp_CrearConfiguracionCliente]	
-- =============================================
CREATE PROCEDURE [CFD_Std].[usp_CrearConfiguracionCliente]	
	@idcliente VARCHAR (10),
	@descripcion VARCHAR (50),
	@clave_proveedor VARCHAR (20),
	--Siguientes 3 columnas para crear registro tabla(tareas_programadas)
	--@id_tarea_programada VARCHAR (10),
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

  DECLARE @Msj VARCHAR(2000) 
  IF EXISTS(SELECT TOP 1 1 FROM cfd_parametros_estandar WITH(NOLOCK)  WHERE sucursal = @Sucursal AND idcliente = @idcliente)
  BEGIN
     
       SET @Msj= '¡Ya existe una tarea y sus parametros de configuración para este cliente : '+@idcliente+', sucursal : '+CAST(@Sucursal AS VARCHAR)+'!';
		RAISERROR(@Msj,16,1);
		RETURN;
  END

  BEGIN TRY
      DECLARE @id_tarea INT=0
      BEGIN TRAN Tran_Tareas
		  
		  SELECT TOP 1 @id_tarea = (MAX(id_tarea)+1) FROM cfd_parametros_estandar WHERE ISNUMERIC( id_tarea ) > 0

		  MERGE INTO cfd_parametros_estandar T
		  USING 
		  (
			 SELECT
					/*@id_tarea AS id_tarea,*/ @idcliente AS idcliente, @sucursal AS sucursal, @descripcion AS descripcion, @segto AS segto, @ctepadre AS ctepadre
					, @habilitado AS habilitado, @ftp AS ftp, @correo AS correo, @zip AS zip, @pdf AS pdf, @archivo AS archivo, @direcciones AS direcciones
					, @ftp_host AS ftp_host, @ftp_usuario AS ftp_usuario, @ftp_password AS ftp_password, @ftp_ruta_inbox AS ftp_ruta_inbox, @ftp_ruta_outbox AS ftp_ruta_outbox, @ftp_ruta_resp AS ftp_ruta_resp
					, @query AS query, @periodo AS periodo, @clave_proveedor AS clave_proveedor, @mail_body AS mail_body, @add_mailbody AS add_mailbody, @cuentas AS cuentas
					, @nc AS nc, @sc AS sc, @brfc AS brfc, @rfc AS rfc
		  ) S ON (T.sucursal = S.Sucursal AND T.idcliente = S.idcliente)
		  WHEN NOT MATCHED THEN
		  INSERT
		  ([id_tarea] ,[idcliente] ,[sucursal] ,[descripcion] ,[segto] ,[ctepadre] ,[habilitado] ,[ftp] ,[correo] ,[zip] ,[pdf] ,[archivo] ,[direcciones] ,[ftp_host] ,[ftp_usuario] ,[ftp_password] ,[ftp_ruta_inbox] ,[ftp_ruta_outbox] ,[ftp_ruta_resp] ,[query] ,[fecha_alta] ,[periodo] ,[clave_proveedor] ,[mail_body] ,[add_mailbody] ,[nc] ,[sc] ,[brfc] ,[rfc] ,[cuentas])
		   VALUES																																																																																						
		  (@id_tarea , [idcliente] ,[sucursal] ,[descripcion] ,[segto] ,[ctepadre] ,[habilitado] ,[ftp] ,[correo] ,[zip] ,[pdf] ,[archivo] ,[direcciones] ,[ftp_host] ,[ftp_usuario] ,[ftp_password] ,[ftp_ruta_inbox] ,[ftp_ruta_outbox] ,[ftp_ruta_resp] ,[query] , GETDATE() ,[periodo] ,[clave_proveedor] ,[mail_body] ,[add_mailbody] ,[nc] ,[sc] ,[brfc] ,[rfc]   ,[cuentas]); 
   			
		  IF EXISTS(SELECT TOP 1 1 FROM cfd_parametros_estandar WHERE id_tarea = @id_tarea)
		  BEGIN
		    -- DECLARE @CteLike VARCHAR(20) = REPLACE('%<Cliente>%','<Cliente>',@IdCliente)
		    --Se crea tarea programada
			DECLARE @id_tarea_programada VARCHAR (100), @descripcion_tarea_programada VARCHAR (150)
			SELECT TOP 1 @id_tarea_programada = (MAX(CAST(id_tarea_programada AS NUMERIC))+10) FROM tareas_programadas WHERE ISNUMERIC( id_tarea_programada ) > 0
	
			SELECT @descripcion_tarea_programada= ISNULL(IATA,'')+' - ' + @descripcion+ ' - CFD ESTANDAR MAIL' FROM sucursales WITH(NOLOCK)	WHERE sucursal = @sucursal

			INSERT INTO [dbo].[tareas_programadas]
				   ([id_tarea_programada],[sucursal],[path],[ejecutable],[descripcion],[hora_ejecucion],[parametros],[dias],[meses] ,[ejecutado]
				   ,[demanda],[habilitado],[hora_ultima_ejecucion],[selex],[observaciones],[propietario],[clase],[fecha_creacion],[tipo])
			 VALUES
				   (@id_tarea_programada,@sucursal,'E:\Marzam\PROCESOS_OUT\CFD_ESTANDAR','CFD_ESTANDAR.EXE', @descripcion_tarea_programada,@hora_ejecucion, (@idcliente + ' HOY'),'1111111','111111111111',0
					,0,1,GETDATE(),0,@observaciones, 'MASR','STD',GETDATE(),'CFD')
		  END	
       COMMIT TRAN Tran_Tareas

	   --Resultado exitoso:
	    SELECT 
		id_tarea, idcliente, sucursal, descripcion, habilitado, ftp, correo, as2, zip, pdf, archivo, direcciones, ftp_host, nc, 
		brfc, ftp_ruta_inbox, periodo, query  
		FROM cfd_parametros_estandar WHERE id_tarea = @id_tarea
  END TRY
  BEGIN CATCH
       ROLLBACK TRAN Tran_Tareas
	    SET @Msj = ERROR_MESSAGE()
	   	RAISERROR(@Msj,16,1);
		RETURN;
  END CATCH

END

GO

