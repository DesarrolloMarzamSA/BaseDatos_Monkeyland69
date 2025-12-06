
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
/*
usp_fact_elect_cifras_control_fenix '2012-05-17'
*/

--	HECHO POR MIGUEL SAMAYOA
--	ESTE usp SIRVE PARA INFORMAR AL FENIX LA FACTURACION DIARIA
--	A PETICION DE VICKY

--	MODIFICADO	2010-03-25	DOCUMENTACION
--	MODIFICADO	2011-03-18	SERIES CFD / IBS


CREATE --	CREATE
PROCEDURE [dbo].[usp_fact_elect_cifras_control_fenix] (@fecha VARCHAR(10)) WITH ENCRYPTION
AS

--	DECLARE @fecha VARCHAR(10) SET @fecha = '2011-03-17'


CREATE TABLE #fe_fenix	(	
	sucursal						INT											,
	fecha_factura				DATETIME								,
	cliente							VARCHAR( 5)			NOT NULL,
	serie_cfd						VARCHAR( 2)			NOT NULL,
	folio_fiscal				VARCHAR(10)			NOT NULL,
	importe_neto				MONEY										,
	iva									MONEY										,
	ieps								MONEY										,
	importe_bruto				MONEY
	)

INSERT INTO #fe_fenix
SELECT 
	fe.sucursal				,
	fe.fecha_factura	,
	fe.cliente				,
  CASE WHEN fe.fecha_factura < su.fecha_ibs THEN su.serie_cfd_old ELSE su.serie_cfd END						serie_cfd,	
	CASE WHEN fe.fecha_factura < su.fecha_ibs THEN CONVERT(VARCHAR,CONVERT(BIGINT,fe.folio_fiscal))	
		ELSE	fe.folio_fiscal  END																																	folio_fiscal,	
	fe.importe_neto														,
	fe.iva																		,
	fe.ieps																		,
	fe.importe_bruto	

FROM facturacion_electronica_estandar fe		WITH (NOLOCK)
INNER JOIN sucursales				su	ON	su.sucursal = fe.sucursal
WHERE fe.segto = 'C1' AND fe.ctepadre = '010'
AND fecha_factura = CONVERT(DATETIME,@fecha,121)
ORDER BY fe.sucursal



SELECT 
	su.IATA																			suc	,
--	fe.sucursal	,
  CONVERT(VARCHAR(10),fe.fecha_factura,121)		fecha_factura	,
	su.ibs_letra+ fe.cliente										cliente,
  CONVERT(INT,cf.numTienda)										Tda_Fenix			,
  fe.serie_cfd + fe.folio_fiscal							folio_fiscal	,
  SUM(fe.importe_neto	) 											Imp_Neto			,
  SUM(fe.iva					) 											I_V_A					, 
  SUM(fe.ieps					) 											I_E_P_S				,
  SUM(fe.importe_bruto) 											Imp_Bto 
FROM #fe_fenix fe														WITH (NOLOCK)
INNER JOIN sucursales				su	ON	su.sucursal = fe.sucursal
INNER JOIN CatTiendasFenix	cf	ON	cf.sucursal = fe.sucursal and cf.cliente = fe.cliente
GROUP BY 
	su.IATA	,
	--fe.sucursal	,
	fe.fecha_factura	, 
	su.ibs_letra+ fe.cliente				,
	cf.numTienda			, 
	fe.serie_cfd			,
	fe.folio_fiscal
ORDER BY 
	su.IATA	,
	--fe.sucursal	,
	fe.fecha_factura	, 
	su.ibs_letra+ fe.cliente				,
	cf.numTienda			, 
	fe.serie_cfd			,
	fe.folio_fiscal


DROP TABLE #fe_fenix;
GO
