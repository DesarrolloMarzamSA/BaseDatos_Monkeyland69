
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[usp_genera_facturacion_electronica_fgonzalez] (@FECHA VARCHAR(10)) 

AS

--	MIGUEL SAMAYOA
--	FECHA CREACION:	2010-01-11

/*
	usp_genera_facturacion_electronica_fgonzalez '2011-01-12'
*/

CREATE TABLE #salida  (  col1 VARCHAR(200)	)

CREATE TABLE #facturacion_supermercado_gonzalez_hoy	(
	sucursal									INT					NOT NULL,
	cliente										VARCHAR( 5)	NOT NULL,
	factura										VARCHAR( 8)					,
	folio_fiscal							VARCHAR( 8)					,
	codigo										VARCHAR( 7)					,
	cod_barras								VARCHAR(13)					,
	precio_farm_sin_imp				MONEY								,
	precio_pub_sin_imp				MONEY								,
	descto_oferta							MONEY								,
	piezas_surtidas_con_cargo	INT									,
	piezas_surtidas_sin_cargo	INT									,
	importe_bruto							MONEY								,
	importe_neto							MONEY								,
	serie_cfd									VARCHAR( 2)
)

INSERT INTO #facturacion_supermercado_gonzalez_hoy
SELECT
  f.sucursal,
  f.cliente,
  f.factura,
  f.folio_fiscal,
  f.codigo,
  f.cod_barras,
  f.precio_farm_sin_imp,
  f.precio_pub_sin_imp,
  f.descto_oferta,
  f.piezas_surtidas_con_cargo,
  f.piezas_surtidas_sin_cargo,
	f.importe_bruto,
	f.importe_neto,
  s.serie_cfd
FROM facturacion_electronica_estandar f
INNER JOIN sucursales s ON s.sucursal = f.sucursal
WHERE 
	f.segto = 'E2' AND f.ctepadre = '725' -- supermecado gonzalez
--	segto = 'E1' AND ctepadre = '044'	-- solo probando con soriana 
and f.sucursal = 24
AND f.folio_fiscal IS NOT NULL
AND f.fecha_factura =   --  between CONVERT(DATETIME,'2009-01-01',121) and 
CONVERT(DATETIME,@fecha,121)
ORDER BY f.sucursal, f.factura

CREATE TABLE #clientes_hoy  (
  renglon   INT IDENTITY,
  sucursal  INT,
  cliente   VARCHAR(5)  )

INSERT INTO #clientes_hoy (sucursal, cliente) 
  SELECT 
    sucursal, cliente 
  FROM #facturacion_supermercado_gonzalez_hoy
  GROUP BY sucursal, cliente 
  ORDER BY sucursal, cliente 

DECLARE @contador INT
SET @contador = 1
DECLARE @cliente VARCHAR(5)

WHILE @contador < (SELECT COUNT(*) FROM #clientes_hoy)
BEGIN
	SET	@cliente = (SELECT cliente FROM #clientes_hoy WHERE renglon = @contador)
  
	INSERT INTO #salida (col1) 
		SELECT 'C' 

	INSERT INTO #salida (col1) 
    SELECT 'C:('+@cliente+')' 

	INSERT INTO #salida (col1) 
   SELECT 'F'+ 
      LEFT(folio_fiscal + REPLICATE(' ',10), 10) + 
			REPLICATE('0', 6) +
			@FECHA +
			RIGHT(REPLICATE(' ',12) + CONVERT(VARCHAR,SUM(f.importe_bruto * 100)) , 12) +
			RIGHT(REPLICATE(' ',12) + CONVERT(VARCHAR,SUM(f.descto_oferta * 100)) , 12) +
			RIGHT(REPLICATE(' ',12) + CONVERT(VARCHAR,SUM(f.importe_neto	* 100)) , 12)
		FROM #facturacion_supermercado_gonzalez_hoy f
		WHERE cliente = @cliente
		GROUP BY folio_fiscal

	INSERT INTO #salida (col1) 
		SELECT 
			'A' + REPLICATE('0',50) col1
		
	INSERT INTO #salida (col1) 
		SELECT 
			'P' + REPLICATE('0',50) +
			RIGHT(REPLICATE(' ', 8) + codigo, 8) +
			RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR,piezas_surtidas_con_cargo		), 6) + 
			RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR,piezas_surtidas_sin_cargo		), 6) +
			RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR,(descto_oferta				* 100 )), 6) +
			RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR,(precio_farm_sin_imp	* 100 )), 6) +
			RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR,(precio_pub_sin_imp		* 100 )), 6) +
			REPLICATE('0',48) +
			cod_barras col1
			FROM #facturacion_supermercado_gonzalez_hoy f
			WHERE cliente = @cliente

  SET @contador = @contador + 1
END

SELECT col1 FROM #salida

DROP TABLE #facturacion_supermercado_gonzalez_hoy
DROP TABLE #clientes_hoy
DROP TABLE #salida
GO
