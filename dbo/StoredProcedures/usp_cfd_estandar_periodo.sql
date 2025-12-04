USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE	--	CREATE
PROCEDURE [dbo].[usp_cfd_estandar_periodo]
  @fecha0 VARCHAR(10), @fecha1 VARCHAR(10), @idCliente VARCHAR(10)
WITH ENCRYPTION
AS

DECLARE @fecha VARCHAR(10)

/*
SET @fecha0 = '2011-04-01'
SET @fecha1 = '2011-04-30'
SET @idCliente = 'DMQUIROZ'
*/

CREATE TABLE #cfd_mensual	(
	sucursal			INT,
	fechaprog			SMALLDATETIME,
	serie_cfd			VARCHAR(2)				NOT NULL,
	folio_fiscal	VARCHAR(10)				NOT NULL,
	iata					VARCHAR(3),
	cliente				VARCHAR(5),
	farmacia			VARCHAR(100)
	PRIMARY KEY (serie_cfd, folio_fiscal))

IF DATEDIFF(DD,  CONVERT(SMALLDATETIME,@fecha1,121) , CONVERT(SMALLDATETIME,@fecha0,121) ) <= 180
	SET @fecha = @fecha0
	WHILE @fecha <= @fecha1
	BEGIN
		INSERT INTO #cfd_mensual EXECUTE usp_cfd_estandar @fecha, @idCliente		;
		SET @fecha = CONVERT(VARCHAR(10), DATEADD(dd,1, CONVERT(SMALLDATETIME,@fecha,121)) ,121)
--		SELECT @fecha
	END

SELECT * FROM #cfd_mensual

DROP TABLE #cfd_mensual
GO
