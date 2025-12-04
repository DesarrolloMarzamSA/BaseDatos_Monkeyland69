


CREATE PROCEDURE [dbo].[usp_actualiza_bitacora_consulta]
AS
BEGIN
--	truncate table bitacora_consulta
--	insert into bitacora_consulta(interfase, mensaje, resultado, timestamp) 
--	select top 1500 interfase, mensaje, resultado, timestamp from bitacora where interfase <> 'InsertaAprobacion' and timestamp > dateadd(hh, -24, current_timestamp) order by timestamp desc

	TRUNCATE TABLE bitacora_consulta
		INSERT INTO bitacora_consulta(interfase, mensaje, resultado, timestamp) 
		SELECT TOP 1500 interfase, mensaje, resultado, timestamp 
		FROM bitacora
		WHERE timestamp > DATEADD(hh, -24, CURRENT_TIMESTAMP) 
		AND interfase <> 'InsertaAprobacion'
		ORDER BY timestamp DESC

delete from bitacora where interfase = 'InsertaAprobacion'
--	FAVOR DE NO BORRAR ESTE BLOQUE COMENTADO PARA FUTURAS CONSULTAS
-- 	INSERT INTO bitacora_consulta(interfase, mensaje, resultado, timestamp) 
--			SELECT interfase, mensaje, resultado, timestamp 
--			FROM historica.dbo.bitacora 
--			WHERE CONVERT(VARCHAR,timestamp,121) BETWEEN '2010-03-01 08:30:00' AND '2010-03-01 14:00:00'
--			AND mensaje LIKE '%MACRO%'
END

GO

