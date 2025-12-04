CREATE
--CREATE	--	DROP
PROCEDURE [dbo].[usp_cfd_estandar_nc] 
/*
execute usp_cfd_estandar_nc  '2015-01-12', 'A02670'
*/
@fecha VARCHAR(10), @IDCliente VARCHAR(10)
AS
DECLARE @query VARCHAR(5000), @header VARCHAR(5000)
--set @fecha = '2011-01-05'
--SET @suc = 7
--SET @IDCliente = 'PARIVERA'
declare @fechaAux datetime
declare @fechaAux2 varchar(10)
set @fechaAux= convert(datetime,@fecha,121)-1
set @fechaAux2=convert(varchar,@fechaAux,121)
DECLARE @consulta VARCHAR(500)
DECLARE @Cuerpo VARCHAR(500)
SET @Cuerpo =  '''_'''


SET @header = 
	'SELECT '+ CHAR(13)+
	'e.sucursal			, ' + CHAR(13)	+
	'substring(convert(varchar,e.fecha,111),0,5)+''-''+cast(cast(substring(convert(varchar,e.fecha,111),6,2) as int)as varchar)+''-''+cast(cast(substring(convert(varchar,e.fecha,111),9,2) as int)as varchar) as fechaprog , ' + CHAR(13)	+
	'e.serie serie_cfd,  ' + CHAR(13)	+
	'e.[FOLIO_DOCUFACT] folio_fiscal	,	' + CHAR(13)	+
	's.IATA					,	' + CHAR(13)	+
	'e.cliente as cliente			,	' + CHAR(13)	+
	'''''as farmacia				,	'	+ CHAR(13)	+
	'NULL orden			,	'	+ CHAR(13)	+
	'e.fecha fecha_tandem	,'	+ CHAR(13)	+
	'e.rfc						,'	+ CHAR(13)	+
	@Cuerpo	+	' cuerpo'					+ CHAR(13)	+
	'FROM Historica.dbo.notasCredito e WITH(NOLOCK) '+
	'INNER JOIN sucursales s ON s.sucursal = e.sucursal  ' + CHAR(13)	+	
	'WHERE ' + CHAR(13) 

SET @query = ''
--	SELECT @query
	PRINT @query

SET @query = replace(replace(@query + @header + CHAR(13) +
	(SELECT '	' + c.query FROM cfd_parametros_estandar c WHERE c.idcliente = @IDCliente) + CHAR(13)	+
	' AND e.fecha >= CONVERT(SMALLDATETIME,'''+@fechaAux2+''',121) ','e.ctepadre','substring(e.ctepadre,3,5)'),'e.cliente','substring(e.cliente,2,6)')
	

PRINT @query
EXECUTE (@query)

GO

