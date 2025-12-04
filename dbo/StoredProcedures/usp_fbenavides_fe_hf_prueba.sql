
CREATE 

--[usp_fbenavides_fe_hf_prueba] '20140903'
PROCEDURE [dbo].[usp_fbenavides_fe_hf_prueba]
	@fecha VARCHAR(10)	
AS


DECLARE @sucursal INT
DECLARE @cliente VARCHAR(5)						
DECLARE @factura VARCHAR(8)							
DECLARE @sep VARCHAR(1)									
DECLARE @factor INT										
DECLARE @orden INT										

SET @sep = ''												
SET @factor = 100										

CREATE TABLE #benavides_hf	(
	no_prov				VARCHAR( 2)		    ,
	sucursal			VARCHAR( 2)	NOT NULL,
	folio_fiscal		VARCHAR(20)	NOT NULL,
	no_registros		VARCHAR( 4)			,
	fecha_factura		VARCHAR( 8)			,
	orden				VARCHAR(10)			,
	centro				VARCHAR( 4)			,
	almacen				VARCHAR( 4)			,
	importe_neto		VARCHAR(10)			,
	iva					VARCHAR(10)			,
	importe_bruto		VARCHAR(10)			,
	descuento			VARCHAR(10)			,
	iva_descto			VARCHAR(10)			,
	clave_factura		VARCHAR( 2)	
	)

SET DATEFIRST 7	--	FIJA EL PRIMER DIA ES DOMINGO

--Sunday		 1 
--Monday		 2
--Tuesday		 3
--Wednesday	 4
--Thursday	 5
--Friday		 6
--Saturday	 7

DECLARE @dias INT
--	SI EL DIA ES LUNES LE RESTA 2 DIAS AL RANGO

SET @dias = CASE WHEN DATEPART(DW,CONVERT(DATETIME,GETDATE(),121)) = 2 THEN 3 ELSE 1 END
--print('dias '+cast(@dias as varchar))
--select CASE WHEN DATEPART(DW,CONVERT(DATETIME,GETDATE(),121)) = 2 THEN 3 ELSE 1 END
--select  DATEPART(DW,CONVERT(DATETIME,GETDATE(),121))


select DISTINCT SUCURSAL,SERIE,IDINVN,FACTURA,IDCUNO,FECHAPROG,IDLINE,IDPRDC,
[NOPEDIDO] as ORDEN,NETO_CANTIDAD,IVA_MONEDA,PRECIO_CANTIDAD,DESCUENTOPROD,0 as IVADESCUENTO,IEPS_MONEDA
INTO #facturas_benavides--select *
	from [dbo].[detalle_benavides] 
	where convert(varchar,FECHAPROG,112)>=convert(varchar,getdate()-@dias,112) 
	 order by IDINVN
	 
ALTER TABLE #facturas_benavides ADD PRIMARY KEY (SUCURSAL, IDCUNO, IDINVN, IDPRDC,IDLINE)

UPDATE #facturas_benavides SET SUCURSAL = 7 WHERE SUCURSAL = 8

SELECT DISTINCT f.SUCURSAL as sucursal, substring(f.IDCUNO,2,5) as cliente, f.FECHAPROG as fecha_factura, f.FACTURA as factura, 
f.SERIE as serie, f.FACTURA as folio_fiscal, f.ORDEN as orden,IDPRDC--,f.IDINVN
INTO #encabezado_benavides
FROM #facturas_benavides f

DECLARE @no_prov			VARCHAR(2)
DECLARE @no_registros		INT
DECLARE @neto_factura		real    --NUMERIC(10,2)
DECLARE @iva				real	--NUMERIC(10,2)
DECLARE @bruto_factura		real	--NUMERIC(10,2)
DECLARE @descto_factura		real	--NUMERIC(10,2)
DECLARE @iva_descto			real	--NUMERIC(10,2)

SET @no_prov = '05'
SET @no_registros = 0
SET @neto_factura = 0
SET @iva = 0
SET @bruto_factura = 0
SET @descto_factura = 0
SET @iva_descto = 0

BEGIN
	DECLARE  cur_encabezados CURSOR FORWARD_ONLY FOR 
		SELECT DISTINCT
			fb.sucursal ,
			substring(fb.IDCUNO,2,5) cliente	,
			fb.factura
		FROM #facturas_benavides fb 
		order by fb.SUCURSAL
	OPEN cur_encabezados
	FETCH FROM cur_encabezados INTO @sucursal, @cliente, @factura --,@orden	--	@sucursal, 

	WHILE @@FETCH_STATUS = 0
		BEGIN		
			SELECT @no_registros	= (SELECT COUNT(*) registros FROM #facturas_benavides WHERE sucursal = @sucursal AND substring(IDCUNO,2,5) = @cliente AND factura = @factura)
			SELECT @neto_factura	= (SELECT ((SUM(NETO_CANTIDAD)+sum(IVA_MONEDA)+sum(IEPS_MONEDA))* @factor) Suma	FROM #facturas_benavides WHERE sucursal = @sucursal AND substring(IDCUNO,2,5) = @cliente AND factura = @factura)
			SELECT @iva				= (SELECT (SUM(IVA_MONEDA)*@factor) Suma	FROM #facturas_benavides WHERE sucursal = @sucursal AND substring(IDCUNO,2,5) = @cliente AND factura = @factura)
			SELECT @bruto_factura	= (SELECT (SUM(PRECIO_CANTIDAD)*@factor) Suma	FROM #facturas_benavides WHERE sucursal = @sucursal AND substring(IDCUNO,2,5) = @cliente AND factura = @factura)
			SELECT @descto_factura	= (SELECT (SUM(DESCUENTOPROD)*@factor) Suma	FROM #facturas_benavides WHERE sucursal = @sucursal AND substring(IDCUNO,2,5) = @cliente AND factura = @factura)
			SELECT @iva_descto		= (SELECT SUM(IVADESCUENTO ) Suma	FROM #facturas_benavides WHERE sucursal = @sucursal AND substring(IDCUNO,2,5) = @cliente AND factura = @factura)

			INSERT INTO #benavides_hf
				SELECT 
					@no_prov	no_prov				,
					RIGHT(REPLICATE('0', 2)+CONVERT(VARCHAR,e.sucursal),2)	sucursal			,					
					LEFT(e.serie +  CONVERT(VARCHAR,CONVERT(INT, e.factura)) + REPLICATE(' ',20),20) folio_fiscal	,					
					RIGHT(REPLICATE('0', 4)+CONVERT(VARCHAR,@no_registros),4)									no_registros	, 
					CONVERT(VARCHAR,fecha_factura,112)															fecha_factura,	
					RIGHT(REPLICATE('0',10)+CONVERT(VARCHAR,CONVERT(BIGINT, CASE WHEN ISNUMERIC(rtrim(ltrim(e.orden))) = 1 THEN e.orden ELSE '' END)),10) orden,						
					LEFT(      ISNULL(csb.cia       , REPLICATE(' ', 4) ),4  )	centro				,	
					LEFT(      ISNULL(csb.mostrador , REPLICATE(' ', 4) ),4  )	almacen				,	
					RIGHT(REPLICATE('0',10)+CAST( CONVERT(INT,@neto_factura		) as VARCHAR) ,10)	     /*cast(@neto_factura as money)*/	importe_neto	, 	
					RIGHT(REPLICATE('0',10)+CAST( CONVERT(INT,@iva						) as VARCHAR) ,10) /*cast(@iva as money)*/			iva		,	
					RIGHT(REPLICATE('0',10)+CAST( CONVERT(INT,@bruto_factura	) as VARCHAR) ,10)		/*cast(@bruto_factura as money)*/	importe_bruto,	
					RIGHT(REPLICATE('0',10)+CAST( CONVERT(INT,@descto_factura	) as VARCHAR) ,10)		/*cast(@descto_factura as money)*/	descuento			,	
					RIGHT(REPLICATE('0',10)+CAST( CONVERT(INT,@iva_descto			) as VARCHAR) ,10)	/*cast(@iva_descto as money)*/		iva_descto		,	
					'FT'	--,	e.IDINVN		
				FROM #encabezado_benavides e
				INNER JOIN cat_sucursales_benavides csb on e.cliente = csb.cuenta and e.sucursal = csb.sucursal  				
				WHERE e.sucursal = @sucursal AND e.cliente = @cliente AND e.factura = @factura;
			FETCH NEXT FROM cur_encabezados INTO @sucursal, @cliente, @factura	
			END
		CLOSE cur_encabezados
		DEALLOCATE cur_encabezados
	END
	
SELECT distinct * FROM #benavides_hf

DROP TABLE #facturas_benavides
DROP TABLE #encabezado_benavides
DROP TABLE #benavides_hf

GO

