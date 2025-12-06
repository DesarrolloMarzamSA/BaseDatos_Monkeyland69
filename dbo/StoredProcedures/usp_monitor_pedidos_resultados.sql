
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE	--	CREATE	--	DROP
PROCEDURE [dbo].[usp_monitor_pedidos_resultados]
@filtro VARCHAR(50)
WITH ENCRYPTION
AS

/*
EXECUTE usp_monitor_pedidos_resultados '388'
EXECUTE usp_monitor_pedidos_resultados ''

*/

DECLARE @command VARCHAR(5000), @comillas1 VARCHAR(3), @comillas2 VARCHAR(3)

SET @comillas1 = REPLICATE(CHAR(39), 1)+'%'
SET @comillas2 = '%'+REPLICATE(CHAR(39), 1)

SET @command = '

SELECT 
		mp.fecha_hora							,
		mp.nombre									,
		mp.ctepadre								,
		mp.cliente_ibs							,
		RIGHT(REPLICATE('' '', 10) + CONVERT(VARCHAR,mp.lineas								,1) , 10)	as lineas							,
		RIGHT(REPLICATE('' '', 10) + CONVERT(VARCHAR,mp.pzas_solicitado				,1) , 10)	as pzas_solicitadas		,
		RIGHT(REPLICATE('' '', 10) + CONVERT(VARCHAR,mp.importe_solicitado		,1) , 10)	as importe_solicitado	,
		RIGHT(REPLICATE('' '', 10) + CONVERT(VARCHAR,mp.pzas_surtidas					,1) , 10)	as pzas_surtidas			,
		RIGHT(REPLICATE('' '', 10) + CONVERT(VARCHAR,mp.importe_surtidas			,1) , 10)	as importe_facturado	,
		pt.ibs_orno, 
		ISNULL(dd.descripcion, pt.motivo_no_surtido)  AS  motivo_no_surtido
		--motivo_no_surtido
FROM monitor_pedidos mp
INNER JOIN sucursales s ON s.ibs_letra = LEFT(mp.cliente_ibs, 1)
INNER JOIN Capa_ibs.dbo.pedidos_traductor pt ON 
	pt.sucursal = s.sucursal AND pt.cliente = SUBSTRING(mp.cliente_ibs, 2,5)
INNER JOIN dest_det_descripciones dd ON dd.dest_det = pt.motivo_no_surtido
'

	
IF LEN(@filtro)> 0
	SET @command = @command +

'WHERE '+
'mp.nombre like  ' + @comillas1 + LTRIM(RTRIM(@filtro)) + @comillas2 + ' '+
'OR mp.cliente_ibs LIKE ' + @comillas1 + LTRIM(RTRIM(@filtro)) + @comillas2 + ' ' +
'OR mp.ctepadre LIKE ' + @comillas1 + LTRIM(RTRIM(@filtro)) + @comillas2 + ' ' +

''

SET @command = @command +

'	
ORDER BY 
		fecha_hora							DESC,
		nombre									,
		ctepadre								,
		cliente_ibs							
'

EXECUTE (@command)


PRINT @COMMAND
GO
