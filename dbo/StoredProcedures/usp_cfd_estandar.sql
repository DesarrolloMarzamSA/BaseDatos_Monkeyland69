
CREATE
--CREATE
PROCEDURE [dbo].[usp_cfd_estandar] 

/*
SELECT * FROM encabezado_cfd WHERE sucursal = 4 AND  segto = 'H1' and ctepadre = '085'
*/


/*
execute [usp_cfd_estandar]  '2018-02-13', 'M27870'
*/
--declare
@fecha VARCHAR(10), @IDCliente VARCHAR(10)
AS

DECLARE @query VARCHAR(5000), @header VARCHAR(5000)
--set @fecha = '2011-01-05'
--SET @suc = 7
--SET @IDCliente = 'PARIVERA'

DECLARE @Cuerpo VARCHAR(500)
SET @Cuerpo = '( ' + (SELECT ISNULL(mail_body ,'') mail_body FROM cfd_parametros_estandar c WHERE c.idcliente = @IDCliente) + ' + e.orden  )  cuerpo '

SET @header = 
--	'INSERT INTO tmp_cfd_encabezado '+ CHAR(13) +
	'SELECT '+ CHAR(13)+
	'e.sucursal			, ' + CHAR(13)	+
	'substring(convert(varchar,e.fechaprog,111),0,5)+''-''+cast(cast(substring(convert(varchar,e.fechaprog,111),6,2) as int)as varchar)+''-''+cast(cast(substring(convert(varchar,e.fechaprog,111),9,2) as int)as varchar) as fechaprog	, ' + CHAR(13)	+
	--' case when e.serie_cfd=''FF'' then ''FE'' else e.serie_cfd end	as serie_cfd,	' + CHAR(13)	+
	' e.serie_cfd,	' + CHAR(13)	+
--	'CASE WHEN e.fechaprog < s.fecha_ibs THEN s.serie_cfd_old ELSE	s.serie_cfd	END			serie_cfd				,														' + CHAR(13) +
	'cast(e.folio_fiscal as bigint)as folio_fiscal	,	' + CHAR(13)	+
	'e.IATA					,	' + CHAR(13)	+
	'e.cliente			,	' + CHAR(13)	+
	'e.farmacia			,	'	+ CHAR(13)	+
	'e.orden				,	'	+ CHAR(13)	+
	'e.fecha_tandem	,'	+ CHAR(13)	+
	'e.rfc					,'	+ CHAR(13)	+
	@Cuerpo							+ CHAR(13)	+
	--', ''' + @IDCliente + '''  idcliente '	+ CHAR(13)	+
	--', CONVERT(CHAR(4),YEAR(fechaprog)) + ''-''+ RIGHT( ''00'' + CONVERT(VARCHAR, MONTH(fechaprog)), 2) ANOMES '	+ CHAR(13)	+
	'FROM encabezado_cfd e WITH(NOLOCK) '+
--	'INNER JOIN sucursales s ON s.sucursal = e.sucursal  ' + CHAR(13)	+
--	'INNER JOIN clientes_baan cb ON cb.sucursal = e.sucursal AND cb.cliente = e.cliente  ' +
	'WHERE ' + CHAR(13) --+
	--'e.fecha_factura = CONVERT(DATETIME,'''+@fecha+''',121)  AND '
	--'e.fecha_factura >= DATEADD(DD, -1, (CONVERT(DATETIME,'''+@fecha+''',121) ) ) AND '

SET @query = ''--'DECLARE @fecha VARCHAR(10) '+ CHAR(13)+ 'set @fecha = '+CHAR(39)+@fecha+CHAR(39) +' ' +CHAR(13) 
--	SELECT @query
--	PRINT @query

SET @query = @query + @header + CHAR(13) +
	(SELECT '	' + c.query FROM cfd_parametros_estandar c WHERE c.idcliente = @IDCliente) + CHAR(13)	+
	' AND e.fechaprog between CONVERT(SMALLDATETIME,'''+@fecha+''',121)-1 and CONVERT(SMALLDATETIME,'''+@fecha+''',121)+1 '

--SELECT @query
PRINT @query
EXECUTE (@query)

GO

