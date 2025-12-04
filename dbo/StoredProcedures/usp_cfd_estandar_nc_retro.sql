USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE
--CREATE	--	DROP
PROCEDURE [dbo].[usp_cfd_estandar_nc_retro] 

/*
execute usp_cfd_estandar_nc_retro  '2011-08-12', 'ROYRESORTS'
*/
--declare
@fecha VARCHAR(10), @IDCliente VARCHAR(10)
WITH ENCRYPTION
AS

DECLARE @query VARCHAR(5000), @header VARCHAR(5000)
--set @fecha = '2011-01-05'
--SET @suc = 7
--SET @IDCliente = 'PARIVERA'


DECLARE @consulta VARCHAR(500)

DECLARE @Cuerpo VARCHAR(500)

--SET @Cuerpo = ', ( ' + (SELECT ISNULL(mail_body ,'') mail_body FROM cfd_parametros_estandar c WHERE c.idcliente = @IDCliente) + '   )  cuerpo '

--SET @consulta = (SELECT ISNULL(mail_body ,'') mail_body FROM cfd_parametros_estandar c WHERE c.idcliente = @IDCliente)

--CREATE TABLE #cuerpo (col1 VARCHAR(500) )

--INSERT INTO #cuerpo EXECUTE @consulta

--SET @Cuerpo = (SELECT TOP 1 col1 FROM #cuerpo )

SET @Cuerpo =  '''_'''


SET @header = 
--	'INSERT INTO tmp_cfd_encabezado '+ CHAR(13) +
	'SELECT '+ CHAR(13)+
	'e.sucursal			, ' + CHAR(13)	+
	'substring(convert(varchar,e.fechaprog,111),0,5)+''-''+cast(cast(substring(convert(varchar,e.fechaprog,111),6,2) as int)as varchar)+''-''+cast(cast(substring(convert(varchar,e.fechaprog,111),9,2) as int)as varchar) as fechaprog, ' + CHAR(13)	+
	'e.serie serie_cfd, ' + CHAR(13)	+
--	'CASE WHEN e.fecha < s.fecha_ibs THEN s.serie_cfd_old ELSE	s.serie_cfd	END			serie_cfd				,														' + CHAR(13) +
	'e.folio folio_fiscal	,	' + CHAR(13)	+
	's.IATA					,	' + CHAR(13)	+
	'e.cliente			,	' + CHAR(13)	+
	'e.farmacia			,	'	+ CHAR(13)	+
	'e.rfc			,	'	+ CHAR(13)	+
	'NULL orden			,	'	+ CHAR(13)	+
	'e.fecha fecha_tandem,	'	+ CHAR(13)	+
	@Cuerpo	+	' cuerpo'					+ CHAR(13)	+
	--', ''' + @IDCliente + '''  idcliente '	+ CHAR(13)	+
	--', CONVERT(CHAR(4),YEAR(fechaprog)) + ''-''+ RIGHT( ''00'' + CONVERT(VARCHAR, MONTH(fechaprog)), 2) ANOMES '	+ CHAR(13)	+
	'FROM notas_credito e WITH(NOLOCK) '+
	'INNER JOIN sucursales s ON s.sucursal = e.sucursal  ' + CHAR(13)	+
	--'INNER JOIN clientes_baan cb ON cb.sucursal = e.sucursal AND cb.cliente = e.cliente  ' +
	'WHERE ' + CHAR(13) --+
	--'e.fecha_factura = CONVERT(DATETIME,'''+@fecha+''',121)  AND '
	--'e.fecha_factura >= DATEADD(DD, -1, (CONVERT(DATETIME,'''+@fecha+''',121) ) ) AND '

SET @query = ''--'DECLARE @fecha VARCHAR(10) '+ CHAR(13)+ 'set @fecha = '+CHAR(39)+@fecha+CHAR(39) +' ' +CHAR(13) 
--	SELECT @query
--	PRINT @query

SET @query = @query + @header + CHAR(13) +
	(SELECT '	' + c.query FROM cfd_parametros_estandar c WHERE c.idcliente = @IDCliente) + CHAR(13)	+
--	' AND e.fecha = CONVERT(SMALLDATETIME,'''+@fecha+''',121) '
	' AND e.fecha BETWEEN CONVERT(SMALLDATETIME,''2011-01-01'',121) ' + 
	' AND CONVERT(SMALLDATETIME,'''+@fecha+''',121) ' + 
	' ORDER BY fecha, serie_cfd, folio_fiscal '

--SELECT @Cuerpo
--SELECT @query
--PRINT @query
EXECUTE (@query)
GO
