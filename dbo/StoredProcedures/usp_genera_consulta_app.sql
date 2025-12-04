CREATE 
--	CREATE 
PROCEDURE usp_genera_consulta_app
AS
BEGIN


declare @fecha_marzam datetime

if(datepart(hh, current_timestamp) < 13)
	begin
		select @fecha_marzam = convert(datetime, convert(varchar(10), current_timestamp, 121), 121)
	end
else
	begin
		select @fecha_marzam = dateadd(dd, 1, convert(datetime, convert(varchar(10), current_timestamp, 121), 121))
	end


DECLARE @fecha1 VARCHAR(23), @fecha2 VARCHAR(23), @fecha VARCHAR(10)

--	SET @fecha = CONVERT(VARCHAR(10),DATEADD(DD,1,CURRENT_TIMESTAMP) ,121)	--	+' 00:00:00.000'
SET @fecha = CONVERT(VARCHAR(10),@fecha_marzam ,121)	--	+' 00:00:00.000'
SET @fecha1 = CONVERT(VARCHAR(10),CURRENT_TIMESTAMP,121)	--	+' 00:00:00.000'
SET @fecha2 = CONVERT(VARCHAR(10),CURRENT_TIMESTAMP,121)	--	+' 23:59:59.999'
--	SELECT @fecha, @fecha1, @fecha2

SELECT 
	e.sucursal,
	e.segto, 
	e.ctepadre, 
	s.descripcion , 
	COUNT(*) facturas, 
	MAX(e.timestamp) ultima_hora	--	CONVERT(VARCHAR(10), e.timestamp, 108)
INTO #gatubela
FROM encabezado e
INNER JOIN aplicaciones_monitorear s ON e.sucursal = s.sucursal AND e.segto = s.segto AND e.ctepadre = s.ctepadre
WHERE e.fechaprog = CONVERT(DATETIME,@fecha ,121)
--	AND e.timestamp BETWEEN CONVERT(DATETIME,@fecha1 ,121) AND CONVERT(DATETIME,@fecha2 ,121)
	AND e.timestamp BETWEEN CONVERT(DATETIME,@fecha1 + ' ' + horario0 ,121) AND CONVERT(DATETIME,@fecha2 + ' ' +horario1 ,121)
--	AND e.sucursal > 1 
GROUP BY e.sucursal, e.segto, e.ctepadre, s.descripcion
ORDER BY e.sucursal, e.segto, e.ctepadre, s.descripcion

UPDATE aplicaciones_monitorear SET
	facturas = 0,
	fecha_hora = NULL,
	color = 0

UPDATE aplicaciones_monitorear SET
	facturas = g.facturas,
	fecha_hora = ultima_hora
FROM aplicaciones_monitorear a
INNER JOIN #gatubela g ON a.sucursal = g.sucursal AND  a.segto = g.segto AND a.ctepadre = g.ctepadre


UPDATE aplicaciones_monitorear SET
	esperadas = CASE WHEN esperadas IS NULL THEN 0 ELSE esperadas END

UPDATE aplicaciones_monitorear SET
	esperadas = CASE WHEN esperadas < facturas THEN facturas ELSE esperadas END

UPDATE aplicaciones_monitorear SET
	porc = 0

UPDATE aplicaciones_monitorear SET
	porc = 
	CASE WHEN esperadas > 0 THEN 
		( (CONVERT(DECIMAL(10,2),facturas) / CONVERT(DECIMAL(10,2),esperadas) ) * 100 )
	ELSE CONVERT(DECIMAL(10,2), 1) END	

UPDATE aplicaciones_monitorear SET 
	color = CASE
		WHEN porc BETWEEN	 0	AND		20	THEN	1
		WHEN porc BETWEEN	21	AND		40	THEN	2
		WHEN porc BETWEEN	41	AND		60	THEN	3
		WHEN porc BETWEEN	61	AND		80	THEN	4
		WHEN porc BETWEEN	81	AND	 100	THEN	5 END



/*

UPDATE aplicaciones_monitorear SET 
	no_error = NULL
	
SELECT a.id, 
	(SELECT TOP 1 b.mensaje from bitacora_consulta b 
	WHERE B.mensaje like '%'+LTRIM(RTRIM(a.descripcion))+'%' AND b.resultado = 0) mensaje
INTO #errores_bitacora
FROM aplicaciones_monitorear a 
WHERE 
	(SELECT TOP 1 
b.mensaje from bitacora_consulta b 
		WHERE B.mensaje like '%'+LTRIM(RTRIM(a.descripcion))+'%' AND b.resultado = 0) IS NOT NULL
--and facturas > 0 

UPDATE aplicaciones_monitorear SET 
	no_error = mensaje
FROM aplicaciones_monitorear a
INNER JOIN #errores_bitacora eb ON a.id = eb.id

DROP TABLE #errores_bitacora
*/



SELECT 
--	segto+ctepadre sc, 
--	sucursal,
	s.iata suc,
	a.descripcion, 
	a.facturas, 
	CASE 
		WHEN a.esperadas = 999999	THEN 0 
		ELSE a.esperadas END esperadas, 
	--	fecha_hora,
	a.porc,
	CASE 
		WHEN a.fecha_hora IS NULL THEN 'N/A' 
		ELSE CONVERT(VARCHAR,a.fecha_hora,108) END hora,
--,	no_error
CASE 
	WHEN a.no_error IS NULL THEN 'OK' 
	 ELSE a.no_error END no_error
, a.color
--	, horario0, horario1
FROM aplicaciones_monitorear a
INNER JOIN sucursales s ON s.sucursal = a.sucursal
WHERE CONSOLA = 1
--AND (FACTURAS > 0 OR no_error IS not NULL)
ORDER BY 
--	facturas 
orden,	color
--DESC


--	usp_genera_consulta_app
DROP TABLE #gatubela
END

GO

