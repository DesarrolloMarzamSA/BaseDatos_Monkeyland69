

CREATE

--[usp_fbenavides_fe_df_prueba]  '20141006'
PROCEDURE [dbo].[usp_fbenavides_fe_df_prueba]
	@fecha VARCHAR(10)			--	@sucursal INT, 
AS

DECLARE @sucursal INT
DECLARE @cliente VARCHAR(5)						--	f.digito_verificador,
DECLARE @factura VARCHAR(8)							--	f.cod_barras,
DECLARE @sep VARCHAR(1)									--	f.clas_fis,
DECLARE @factor INT											--	f.piezas_surtidas_sin_cargo,
DECLARE @orden INT											--	f.porcentaje_utilidad,
																				--	f.filler,
SET @sep = ''														--	f.bonificacion_iva2,
SET @factor = 100												--	f.bonificacion_iva_del_iesps,

CREATE TABLE #benavides_hf	(
	no_prov					VARCHAR( 2)													,
	sucursal				VARCHAR( 2)						NOT NULL			,
	centro					VARCHAR( 4)													,
	almacen					VARCHAR( 4)													,
	folio_fiscal		VARCHAR(20)						NOT NULL			,
	importe_neto		VARCHAR(10)	,
	importe_bruto		VARCHAR(10) ,
	descto_producto	    VARCHAR(10)	,
	iva_producto		VARCHAR(10)	,
	iva_descto			VARCHAR(10)	,
	/*importe_neto		money,
	importe_bruto		money,
	descto_producto	    money,
	iva_producto		money,
	iva_descto			money,*/
	-----------------------------------------
	cod_benavides		VARCHAR(18)	NOT NULL,	
	cant_surtida		VARCHAR( 6)	,
	no_pedido			VARCHAR(10)	,
	no_registro			INT			NOT NULL,
	codigo VARCHAR(10)	
	--idlinea int
	PRIMARY KEY (sucursal, folio_fiscal, cod_benavides, importe_neto,no_registro)	
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

SET @dias =  CASE WHEN DATEPART(DW,CONVERT(DATETIME,GETDATE(),121)) = 2 THEN 3 ELSE 1 END

select DISTINCT SUCURSAL,SERIE,IDINVN,FACTURA,IDCUNO,FECHAPROG,IDLINE,IDPRDC,
[NOPEDIDO] as ORDEN,NETO_CANTIDAD,IVA_MONEDA,PRECIO_CANTIDAD,DESCUENTOPROD,0 as IVADESCUENTO,IDQTY,IEPS_MONEDA
	INTO #facturas_benavides
	from [dbo].[detalle_benavides] 
	--INNER JOIN  [monkeyland].[dbo].[catalgoBenavides] cpb on IDPRDC = cpb.CODIGO
	where --IDINVN=803004508779 and
	convert(varchar,FECHAPROG,112)>=convert(varchar,getdate()-@dias,112) and ESTATUSD in(1,2)
	 order by IDINVN
	 --	 select convert(varchar,FECHAPROG,112) from  [dbo].[detalle_benavides]
 
ALTER TABLE #facturas_benavides ADD PRIMARY KEY  (SUCURSAL, IDCUNO, IDINVN, IDPRDC,IDLINE)


UPDATE #facturas_benavides SET SUCURSAL = 7 WHERE SUCURSAL = 8

SELECT DISTINCT f.SUCURSAL as sucursal, f.IDCUNO, f.FECHAPROG as fecha_factura, f.FACTURA as factura,
 f.SERIE as serie, f.SERIE as folio_fiscal, f.ORDEN as orden
INTO #encabezado_benavides
FROM #facturas_benavides f

DECLARE @no_prov				VARCHAR(2)
DECLARE @no_registros			INT
DECLARE @neto_factura			real--NUMERIC(10,2)
DECLARE @iva					real--NUMERIC(10,2)
DECLARE @bruto_factura			real--NUMERIC(10,2)
DECLARE @descto_factura			real--NUMERIC(10,2)
DECLARE @iva_descto				real--NUMERIC(10,2)

SET @no_prov = '05'
SET @no_registros = 0
SET @neto_factura = 0
SET @iva = 0
SET @bruto_factura = 0
SET @descto_factura = 0
SET @iva_descto = 0

--BEGIN
	--DECLARE  cur_encabezados CURSOR forward_only FOR 
	--	SELECT DISTINCT
	--		fb.sucursal ,
	--		substring(fb.IDCUNO,2,5) cliente,
	--		fb.factura
	--	FROM #facturas_benavides fb 

	--OPEN cur_encabezados
	--FETCH FROM cur_encabezados INTO @sucursal, @cliente, @factura 

	----WHILE @@FETCH_STATUS = 0
	--	BEGIN	
			INSERT INTO #benavides_hf
				SELECT 
					@no_prov																																																									no_prov					,								
					RIGHT(REPLICATE('0', 2)+CONVERT(VARCHAR,f.SUCURSAL),2)																																		sucursal				,	
					LEFT(ISNULL(csb.cia       , REPLICATE(' ', 4) ),4	)																																				centro					,	
					LEFT(ISNULL(csb.mostrador , REPLICATE('0', 4) ),4	)																																				almacen					,	
					LEFT( f.SERIE
					 + CONVERT(VARCHAR,CONVERT(INT,f.factura ))+  REPLICATE(' ',20),20)										folio_fiscal		,
					RIGHT(REPLICATE('0',10)	+	CAST( CONVERT(INT,(NETO_CANTIDAD+IVA_MONEDA+IEPS_MONEDA)   * @factor) as VARCHAR),10) /*(NETO_CANTIDAD+IVA_MONEDA)*/ as importe_neto		,	
					RIGHT(REPLICATE('0',10)	+	CAST( CONVERT(INT,PRECIO_CANTIDAD * @factor) as VARCHAR),10) /*PRECIO_CANTIDAD*/ as importe_bruto		,	
					RIGHT(REPLICATE('0',10)	+	CAST( CONVERT(INT,DESCUENTOPROD   * @factor) as VARCHAR),10) /*DESCUENTOPROD*/ as descto_producto	,	
					RIGHT(REPLICATE('0',10)	+	CAST( CONVERT(INT,IVA_MONEDA      * @factor) as VARCHAR),10) /*IVA_MONEDA*/ as iva_producto		,	
					RIGHT(REPLICATE('0',10)	+	CAST( CONVERT(INT,IVADESCUENTO    * @factor) as VARCHAR),10) /*IVADESCUENTO*/ as iva_descto			,
					RIGHT(REPLICATE('0',18)	+	RIGHT(ISNULL(cast(cast(cpb.COD_PRODCLI as numeric)as varchar),REPLICATE('0',18)) ,18),18)																								cod_benavides		,	
					RIGHT(REPLICATE('0', 6)	+	CAST( CONVERT(INT,f.IDQTY) as VARCHAR), 6)									cant_surtida		,	
					RIGHT(REPLICATE('0',10)	+	CONVERT(VARCHAR,CONVERT(BIGINT,  (CASE WHEN ISNUMERIC(orden) = 1 THEN orden ELSE '' END))),10)  no_pedido				,
					IDLINE,f.IDPRDC
				FROM #facturas_benavides f
				INNER JOIN cat_sucursales_benavides csb on substring(f.IDCUNO,2,5) = csb.cuenta AND f.sucursal = csb.sucursal
				left JOIN  [monkeyland].[dbo].[catalgoBenavides] cpb on f.IDPRDC = cpb.CODIGO
				--WHERE f.sucursal = @sucursal AND substring(f.IDCUNO,2,5) = @cliente AND f.factura = @factura

				--select * from [monkeyland].[dbo].[catalgoBenavides]

	--		FETCH NEXT FROM cur_encabezados INTO @sucursal, @cliente, @factura--	@sucursal
	--		--DROP TABLE #remision

	--		END
	--	CLOSE cur_encabezados
	--	DEALLOCATE cur_encabezados
	--END
	
SELECT 
	no_prov					,
	sucursal				,
	centro					,
	almacen					,
	folio_fiscal		,
	importe_neto		,
	importe_bruto		,
	descto_producto	,
	iva_producto		,
	iva_descto			,
	cod_benavides		,
	cant_surtida		,
	no_pedido--,codigo
FROM #benavides_hf
ORDER BY sucursal, folio_fiscal, no_registro

DROP TABLE #facturas_benavides
DROP TABLE #encabezado_benavides
DROP TABLE #benavides_hf

GO

