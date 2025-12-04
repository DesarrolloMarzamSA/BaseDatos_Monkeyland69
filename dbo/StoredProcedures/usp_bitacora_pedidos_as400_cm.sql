SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE	--	CREATE
PROCEDURE [dbo].[usp_bitacora_pedidos_as400_cm]
@FECHA CHAR(8), @LINEAS INT
--,@ctepadre VARCHAR(6) 
AS

/*
usp_bitacora_pedidos_as400_cm '20120801', 10 , '009'
*/

--SET @FECHA = CONVERT(CHAR(8), GETDATE()  , 112) + ' ' +

DECLARE @ETL VARCHAR(500), @as400 VARCHAR(500)
,@ctepadre VARCHAR(6) 

SET @ctepadre = '009'

SET @as400 = 
'SELECT 	* '+
	--wksec AS secuencia	,
	--wktim	AS hora				,
	--wkdes	AS descripcion 
'FROM ' +
'MARZAMPRD.Z1BITA ' +
'WHERE '+
'WKCUNO = ' + CHAR(39)+CHAR(39)+ 
 @ctepadre +
CHAR(39)+CHAR(39)+ 'AND ' +
'WKFEC = ' + @FECHA + ' ' +
'ORDER BY wktim DESC '

--SELECT @as400


SET @ETL = '

SELECT TOP ' + CONVERT(VARCHAR,@LINEAS)+ '  *
	--secuencia		,
	--hora				,
	--descripcion 
FROM OPENQUERY(as400, ''' + @as400 + ''' ) '


execute (@etl)


--WHERE b.wkfec = '+ CONVERT(char(10),GETDATE(),112) 


--'AND WKSEC ' + CASE 
--WHEN (DATEPART(HH , GETDATE() ) BETWEEN 08 AND 10 )
--	/*AND (DATEPART(MM , GETDATE() ) BETWEEN 01 AND 30)*/ THEN '= 1'
--WHEN (DATEPART(HH , GETDATE() ) BETWEEN 10 AND 11 )
--	/*AND (DATEPART(MM , GETDATE() ) BETWEEN 01 AND 30)*/ THEN '= 2' 
--ELSE '>= 0' END + ' ' 
GO
