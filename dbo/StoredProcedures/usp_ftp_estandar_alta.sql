
/*

EXECUTE usp_ftp_estandar_alta 8224, 4, 85, '85542', '', 'ZAYED', 'd85542', 1, 'operaciones@marzam.com.mx', '190.1.4.12', 'd85542', '3145145i', 'norte/cadenas/d85542', 1, 0, 50000, 0, 1, 1, 1, 1, 1, 'libre', 'ZZZZZ', '0800', '1805', '1805', '1805'
*/



CREATE	--	CREATE	--	DROP
PROCEDURE [dbo].[usp_ftp_estandar_alta]

@idcatclientesftp int					,		--	 1
@sucursal  int								,		--	 2
@ticket int										,		--	 3
@cliente varchar(6)						,		--	 4
@ctepadre varchar(6)					,		--	 5 
@descripcion varchar(50)			,		--	 6
@nombre varchar(30)						,		--	 7
@email varchar(300)						,		--	 8
@correos varchar(100)					,		--	 9
@solaris_ip VARCHAR(15)				,		--	 4
@usuario varchar(30)					,		--	11
@password varchar(30)					,		--	12
@ruta varchar(100)						,		--	13
@activo	int										,		--	14
@filtro	int										,		--	15
@filtro_max money							,		--	16
@filtro_min money							,		--	17
@fee int											,		--	18
@ped int											,		--	19
@mae int											,		--	20
@cam int											,		--	21
@ofe int											,		--	22
@bolsa1 VARCHAR(5)						,		--	23
@bolsa2 VARCHAR(5)						,		--	24
@horarioFactElect varchar(6)	,		--	25
@horarioCatalogo varchar(6)		,		--	26
@horarioCambios varchar(6)		,		--	27
@HorarioOfertas varchar(6)				--	28
													
AS

--@ruta varchar(30)											,		--	10

declare
@leyenda varchar(30)					,		--	 7
@query varchar(500)						, 
@tandem_ip VARCHAR(15)				,		--	 3
@solaris_usr VARCHAR(15)			,		--	 5
@solaris_pwd VARCHAR(15)			,		--	 6
@propietario varchar(5)				,		--	 8
@ftp INT													--	10

SET @tandem_ip = '190.1.4.169'
--SET @solaris_ip = '190.1.4.12'
SET @solaris_usr = 'apadmin'
SET @solaris_pwd = '4tuR1n'
set @propietario = 'MASR'



set @ftp = 1

IF LEN(@ctepadre)=0
	SET @ctepadre = NULL


set @leyenda = (SELECT TOP 1 IATA FROM sucursales WHERE sucursal = @sucursal )+ ' ' + upper(@nombre)

set @query = 'fecha_tandem >= CONVERT(DATETIME, CONVERT(VARCHAR(10), CURRENT_TIMESTAMP, 121), 121) AND sucursal = ' + CONVERT(VARCHAR,  @sucursal )
--' AND segto = ''A1'' AND ctepadre = ''280'' '
if @ctepadre IS NOT NULL
	SET @query = @query + ' AND ctepadre = '+CHAR(39)+@ctepadre+CHAR(39)+' '
else	
	SET @query = @query + ' AND cliente = '+CHAR(39)+@cliente+CHAR(39)


declare @miid1 varchar(20)
declare @miid2 varchar(20)
declare @miid3 varchar(20)
declare @miid4 varchar(20)

select @miid1 = right('000000' + convert(varchar(20), max(convert(bigint, id_tarea_programada)) + 10), 10) from tareas_programadas where isnumeric(id_tarea_programada)=1
select @miid2 = right('000000' + convert(varchar(20), max(convert(bigint, id_tarea_programada)) + 20), 10) from tareas_programadas where isnumeric(id_tarea_programada)=1
select @miid3 = right('000000' + convert(varchar(20), max(convert(bigint, id_tarea_programada)) + 30), 10) from tareas_programadas where isnumeric(id_tarea_programada)=1
select @miid4 = right('000000' + convert(varchar(20), max(convert(bigint, id_tarea_programada)) + 40),10) from tareas_programadas  where isnumeric(id_tarea_programada)=1

print @cliente
IF (SELECT COUNT(*) FROM cat_clientes_estandar_ftp WHERE sucursal = @sucursal AND nombre = @nombre) = 0
BEGIN
	insert into cat_clientes_estandar_ftp 
		(sucursal, descripcion, nombre, email, ip, usuario, password, ruta, hora_inicio, hora_fin, activo, filtro_monto , limite_filtro_min, limite_filtro_max, timestamp, mae, ofe, cam, ped, fee, cliente, ctepadre, id, ticket)
	values
		(@sucursal, @descripcion, lower(@nombre), @correos, @solaris_ip, lower(@usuario), @password, @ruta, '00:00:00.000', '23:59:59.999', @activo, @filtro, @filtro_min, @filtro_max, current_timestamp, @mae, @ofe, @cam, @ped, @fee, @cliente, @ctepadre, @idcatclientesftp, @ticket)
		
END

IF (SELECT COUNT(*) FROM parametros_fact_elec_estandar WHERE sucursal = @sucursal AND cliente = @nombre) = 0
BEGIN
	insert into parametros_fact_elec_estandar
		(sucursal, cliente, envia_mail, email_addr, query, ip_cliente, usuario_cliente, password_cliente, ruta_cliente, nombre_archivo, envia_ftp, unsoloarchivo, fecha_alta, selex) 
	values
		(@sucursal, @nombre, @email, @correos, @query, @solaris_ip,@solaris_usr,@solaris_pwd, '/' + @ruta + '/out/','F',@ftp,0, GETDATE(), 0)
END

IF (SELECT COUNT(*) FROM parametros_acarreador_ftp WHERE sucursal = @sucursal AND cliente = @nombre AND tipo_archivo = 'OfertasFTP') = 0
BEGIN
	insert into parametros_acarreador_ftp 
		(sucursal, cliente, tipo_archivo, descripcion, ip_origen, usuario_origen, password_origen, archivo_origen, ip_destino, usuario_destino, password_destino, archivo_destino, hora, bolsa1, bolsa2) 
	values
		(@sucursal, @nombre, 'OfertasFTP', 'Cat Ofertas Std FTP'	, @tandem_ip, '', '', '', @solaris_ip, @solaris_usr, @solaris_pwd, @ruta + '/out/OFERTAS.DAT', @HorarioOfertas, @bolsa1, @bolsa2)
END

IF (SELECT COUNT(*) FROM parametros_acarreador_ftp WHERE sucursal = @sucursal AND cliente = @nombre AND tipo_archivo = 'CatalogoFTP') = 0
BEGIN
	insert into parametros_acarreador_ftp 
		(sucursal, cliente, tipo_archivo, descripcion, ip_origen, usuario_origen, password_origen, archivo_origen, ip_destino, usuario_destino, password_destino, archivo_destino, hora, bolsa1, bolsa2) 
	values
		(@sucursal, @nombre, 'CatalogoFTP', 'Catalogo Std FTP'		, @tandem_ip, '', '', '', @solaris_ip, @solaris_usr, @solaris_pwd, @ruta + '/out/CATALOGO.DAT', @horarioCatalogo, @bolsa1, @bolsa2)
END

IF (SELECT COUNT(*) FROM parametros_acarreador_ftp WHERE sucursal = @sucursal AND cliente = @nombre AND tipo_archivo = 'CambiosFTP') = 0
BEGIN
	insert into parametros_acarreador_ftp 
		(sucursal, cliente, tipo_archivo, descripcion, ip_origen, usuario_origen, password_origen, archivo_origen, ip_destino, usuario_destino, password_destino, archivo_destino, hora, bolsa1, bolsa2) 
	values
		(@sucursal, @nombre, 'CambiosFTP', 'Cambios Std FTP'			, @tandem_ip, '', '', '', @solaris_ip, @solaris_usr, @solaris_pwd, @ruta + '/out/CAMBIOS.DAT', @horarioCambios, @bolsa1, @bolsa2)
END



--create table #formato	(
--	dato			VARCHAR(50)	,
--	valor			VARCHAR(50)	,
--	notas			VARCHAR(50)	,
--	orden			INT	IDENTITY
--)

--INSERT INTO #formato VALUES 
--('Favor de Crear el siguiente sitio FTP de '	,'CLIENTES STD FTP',''),
--('Sucursal:'	,@suc,''),
--('Cliente:'	,@letra + @cliente,''),
--('Usuario:'	,@usuario,''),
--('Password:'	,@password,''),
--('home directory:'	,@ruta,'755 (rwxrwxr-x)'),
--('Home/in/'	,@ruta+'/in/'	,'775 (rwxrwxr-x)'),
--('Home/out/'	,@ruta+'/out/','775 (rwxrwxr-x)'),
--('Home/xml/'	,@ruta+'/xml/','775 (rwxrwxr-x)')

--SELECT dato, valor, notas FROM #formato

select 
	'Ray / Omar / Adrian:  Favor de Crear el sitio ftp',		--	1
	'192.168.90.12',	--	2
	descripcion, --	3
	usuario, password, ruta --	delete
from cat_clientes_estandar_ftp
where nombre = @nombre
union 
select 
	'Favor de proporcionar estos datos al cliente: ',--1
	'200.38.152.241' ftp_ip, --	2
	descripcion,	--	3
	usuario, password, '' --	delete
from cat_clientes_estandar_ftp
where nombre = @nombre

--select *  --	delete
--from parametros_acarreador_ftp
--where cliente = @nombre

--select *  --	delete
--from parametros_fact_elec_estandar
--where cliente = @nombre

--SELECT top 12 * FROM tareas_programadas order by fecha_creacion desc

IF (SELECT COUNT(*) FROM tareas_programadas WHERE descripcion LIKE '%'+@leyenda+'%' AND clase = 'STD' AND tipo = 'CPE') = 0
BEGIN
	--SELECT COUNT(*) tareas FROM tareas_programadas WHERE descripcion LIKE '%'+@leyenda+'%' 
	INSERT INTO tareas_programadas   
		(id_tarea_programada, sucursal, path, ejecutable, descripcion, hora_ejecucion, parametros, dias, meses, ejecutado, demanda, habilitado, hora_ultima_ejecucion, selex, observaciones, propietario, clase, fecha_creacion, tipo   )
	VALUES 
		(@miid1, @sucursal, 'D:\Interfases\EstandarFtpCambios',       'CambiosEstandarFtp.exe',  @leyenda + ' Cambios estandar ftp',     @horarioCambios, CONVERT(VARCHAR,@sucursal) + ' ' + @nombre				, '1111111', '111111111111', 1, 1, 1, current_timestamp, 0, @cliente, @propietario, 'STD', GETDATE()	,'CPE')
END

IF (SELECT COUNT(*) FROM tareas_programadas WHERE descripcion LIKE '%'+@leyenda+'%' AND clase = 'STD' AND tipo = 'MAE') = 0
BEGIN
	--SELECT COUNT(*) tareas FROM tareas_programadas WHERE descripcion LIKE '%'+@leyenda+'%' 
	INSERT INTO tareas_programadas   
		(id_tarea_programada, sucursal, path, ejecutable, descripcion, hora_ejecucion, parametros, dias, meses, ejecutado, demanda, habilitado, hora_ultima_ejecucion, selex, observaciones, propietario, clase, fecha_creacion, tipo   )
	VALUES 
		(@miid2, @sucursal, 'D:\Interfases\EstandarFtpCatalogo',      'CatalogoEstandarFtp.exe', @leyenda + ' Catalogo estandar ftp',    @HorarioCatalogo, CONVERT(VARCHAR,@sucursal) + ' 1 ' + @nombre			, '1111111', '111111111111', 1, 1, 1, current_timestamp, 0, @cliente, @propietario, 'STD', GETDATE()	,'MAE')
END

IF (SELECT COUNT(*) FROM tareas_programadas WHERE descripcion LIKE '%'+@leyenda+'%' AND clase = 'STD' AND tipo = 'OFE') = 0
BEGIN
	--SELECT COUNT(*) tareas FROM tareas_programadas WHERE descripcion LIKE '%'+@leyenda+'%' 
	INSERT INTO tareas_programadas   
		(id_tarea_programada, sucursal, path, ejecutable, descripcion, hora_ejecucion, parametros, dias, meses, ejecutado, demanda, habilitado, hora_ultima_ejecucion, selex, observaciones, propietario, clase, fecha_creacion, tipo   )
	VALUES 
		(@miid3, @sucursal, 'D:\Interfases\EstandarFtpOfertas',       'OfertasEstandarFtp.exe',  @leyenda + ' Ofertas estandar ftp',     @HorarioOfertas, CONVERT(VARCHAR,@sucursal) + ' ' + @nombre + ' 1' , '1111111', '111111111111', 1, 1, 1, current_timestamp, 0, @cliente, @propietario, 'STD', GETDATE()	,'OFE')
END

IF (SELECT COUNT(*) FROM tareas_programadas WHERE descripcion LIKE '%'+@leyenda+'%' AND clase = 'STD' AND tipo = 'FEE') = 0
BEGIN
	--SELECT COUNT(*) tareas FROM tareas_programadas WHERE descripcion LIKE '%'+@leyenda+'%' 
	INSERT INTO tareas_programadas   
		(id_tarea_programada, sucursal, path, ejecutable, descripcion, hora_ejecucion, parametros, dias, meses, ejecutado, demanda, habilitado, hora_ultima_ejecucion, selex, observaciones, propietario, clase, fecha_creacion, tipo   )
	VALUES 
		(@miid4, @sucursal, 'E:\Marzam\PROCESOS_OUT\CFD_ESTANDAR', 'FacturacionEstandar.exe', @leyenda + ' Facturacion estandar ftp', @HorarioFactElect, @nombre													, '1111111', '111111111111', 1, 1, 1, current_timestamp, 0, @cliente, @propietario, 'STD', GETDATE()	,'FEE')
END

--  @ftp = 1
--  @cam = 0
--  @mae = 1
--  @ofe = 0
--  @fee = 1
--  @ped = 1


----------SELECT id_tarea_programada id, descripcion, hora_ejecucion hora
----------FROM tareas_programadas WITH (NOLOCK)
----------WHERE id_tarea_programada in (@miid1, @miid2, @miid3, @miid4)
----------OR descripcion LIKE '%'+@leyenda+'%'



/*
DELETE from parametros_acarreador_ftp where cliente like '%sfe06170%'
DELETE from tareas_programadas where parametrOS like '%sfe06170%'
DELETE FROM parametros_fact_elec_estandar  WHERE CLIENTE LIKE '%sfe06170%'
DELETE FROM  cat_clientes_estandar_ftp WHERE NOMBRE LIKE '%sfe06170%'
*/

/*
select * from parametros_acarreador_ftp where cliente like '%sfe06170%'
select * from tareas_programadas where parametrOS like '%sfe06170%'
select * FROM parametros_fact_elec_estandar WHERE CLIENTE LIKE '%sfe06170%'
select * FROM cat_clientes_estandar_ftp WHERE NOMBRE LIKE '%sfe06170%'
*/
--update tareas_programadas set demanda = 1 where parametrOS like '%calif%'


--declare @nombre varchar(30)
--select @nombre = 'dfmayte'

/*
select * --delete
from parametros_fact_elec_estandar
where cliente = @nombre

select * --	delete
from cat_clientes_estandar_ftp
where nombre = @nombre

select * --	delete
from parametros_acarreador_ftp
where cliente = @nombre
*/


--set @query = 'select * from vi_fact_elec_estandar where '+@query
--execute @query

--DROP TABLE #formato

GO

