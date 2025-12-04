


CREATE PROCEDURE [dbo].[usp_fbenavides_fe_df]
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

	-----------------------------------------
	cod_benavides		VARCHAR(18)	NOT NULL,	
	cant_surtida		VARCHAR( 6)	,
	no_pedido			VARCHAR(10)	,
	no_registro			INT			NOT NULL,
	codigo VARCHAR(10)	
	PRIMARY KEY (sucursal, folio_fiscal, cod_benavides, importe_neto,no_registro)	
	)



SET DATEFIRST 7	


DECLARE @dias INT
--	SI EL DIA ES LUNES LE RESTA 2 DIAS AL RANGO

SET @dias =  CASE WHEN DATEPART(DW,CONVERT(DATETIME,GETDATE(),121)) = 2 THEN 3 ELSE 1 END

select DISTINCT SUCURSAL,SERIE,IDINVN,FACTURA,IDCUNO,FECHAPROG,IDLINE,IDPRDC,
[NOPEDIDO] as ORDEN,NETO_CANTIDAD,IVA_MONEDA,PRECIO_CANTIDAD,DESCUENTOPROD,0 as IVADESCUENTO,IDQTY,IEPS_MONEDA
	INTO #facturas_benavides
	from [dbo].[detalle_benavides] 
	where convert(varchar,FECHAPROG,112)>=convert(varchar,getdate()-@dias,112)-- and ESTATUSD in(1,2)
	 order by IDINVN

 
 update monkeyland..detalle_benavides set ESTATUSD=2,FECHAESTATUS=GETDATE() where convert(varchar,FECHAPROG,112)>=convert(varchar,getdate()-@dias,112) and ESTATUSD=1 

ALTER TABLE #facturas_benavides ADD PRIMARY KEY  (SUCURSAL, IDCUNO, IDINVN, IDPRDC,IDLINE)


UPDATE #facturas_benavides SET SUCURSAL = 7 WHERE SUCURSAL = 8

UPDATE #facturas_benavides SET SUCURSAL = 3 WHERE SUCURSAL = 2
UPDATE #facturas_benavides SET SUCURSAL = 24 WHERE SUCURSAL = 23


SELECT DISTINCT f.SUCURSAL as sucursal, f.IDCUNO, f.FECHAPROG as fecha_factura, f.FACTURA as factura,
 f.SERIE as serie, f.SERIE as folio_fiscal, f.ORDEN as orden
INTO #encabezado_benavides
FROM #facturas_benavides f

DECLARE @no_prov				VARCHAR(2)
DECLARE @no_registros			INT
DECLARE @neto_factura			real
DECLARE @iva					real
DECLARE @bruto_factura			real
DECLARE @descto_factura			real
DECLARE @iva_descto				real

SET @no_prov = '05'
SET @no_registros = 0
SET @neto_factura = 0
SET @iva = 0
SET @bruto_factura = 0
SET @descto_factura = 0
SET @iva_descto = 0


			INSERT INTO #benavides_hf
				SELECT 
					@no_prov																																																									no_prov					,								
					RIGHT(REPLICATE('0', 2)+CONVERT(VARCHAR,f.SUCURSAL),2)																																		sucursal				,	
					LEFT(ISNULL(csb.cia       , REPLICATE(' ', 4) ),4	)																																				centro					,	
					LEFT(ISNULL(csb.mostrador , REPLICATE('0', 4) ),4	)																																				almacen					,	
					LEFT( f.SERIE
					 + CONVERT(VARCHAR,CONVERT(INT,f.factura ))+  REPLICATE(' ',20),20)										folio_fiscal		,
					RIGHT(REPLICATE('0',10)	+	CAST( CONVERT(INT,(NETO_CANTIDAD+IVA_MONEDA+IEPS_MONEDA)   * @factor) as VARCHAR),10)  as importe_neto		,	
					RIGHT(REPLICATE('0',10)	+	CAST( CONVERT(INT,PRECIO_CANTIDAD * @factor) as VARCHAR),10)  as importe_bruto		,	
					RIGHT(REPLICATE('0',10)	+	CAST( CONVERT(INT,DESCUENTOPROD   * @factor) as VARCHAR),10)  as descto_producto	,	
					RIGHT(REPLICATE('0',10)	+	CAST( CONVERT(INT,IVA_MONEDA      * @factor) as VARCHAR),10)  as iva_producto		,	
					RIGHT(REPLICATE('0',10)	+	CAST( CONVERT(INT,IVADESCUENTO    * @factor) as VARCHAR),10)  as iva_descto			,
					RIGHT(REPLICATE('0',18)	+	RIGHT(ISNULL(cast(cast(cpb.COD_PRODCLI as numeric)as varchar),REPLICATE('0',18)) ,18),18)																								cod_benavides		,	
					RIGHT(REPLICATE('0', 6)	+	CAST( CONVERT(INT,f.IDQTY) as VARCHAR), 6)									cant_surtida		,	
					RIGHT(REPLICATE('0',10)	+	CONVERT(VARCHAR,CONVERT(BIGINT,  (CASE WHEN ISNUMERIC(orden) = 1 THEN orden ELSE '' END))),10)  no_pedido				,
					IDLINE,f.IDPRDC
				FROM #facturas_benavides f
				INNER JOIN cat_sucursales_benavides csb on substring(f.IDCUNO,2,5) = csb.cuenta AND f.sucursal = csb.sucursal
				left JOIN  [monkeyland].[dbo].[catalgoBenavides] cpb on f.IDPRDC = cpb.CODIGO

--**************************************************************************SAP*******************************************

								
SET @factor = 100			


select DISTINCT SUCURSAL,SERIE,IDINVN,FACTURA,IDCUNO,FECHAPROG,IDLINE,IDPRDC,
[NOPEDIDO] as ORDEN,NETO_CANTIDAD,IVA_MONEDA,PRECIO_CANTIDAD,DESCUENTOPROD,0 as IVADESCUENTO,IDQTY,IEPS_MONEDA
	INTO #facturas_benavides_sap_aux
	from [dbo].[detalle_benavides] 
	where len(IDCUNO)>6 and 
	convert(varchar,FECHAPROG,112)>=convert(varchar,getdate()-@dias,112) --and ESTATUSD in(1,2)
	 order by IDINVN
--	where IDINVN in (
--'900317312',
--'900318144'
--	)

ALTER TABLE #facturas_benavides_sap_aux ADD PRIMARY KEY  (SUCURSAL, IDCUNO, IDINVN, IDPRDC,IDLINE)

select SUCURSAL,SERIE,IDINVN,FACTURA,IDCUNO,FECHAPROG,IDPRDC,ORDEN,
sum(NETO_CANTIDAD)AS NETO_CANTIDAD,SUM(IVA_MONEDA)AS IVA_MONEDA,SUM(PRECIO_CANTIDAD) AS PRECIO_CANTIDAD,SUM(DESCUENTOPROD)AS DESCUENTOPROD,
SUM(IVADESCUENTO)AS IVADESCUENTO,SUM(IDQTY)AS IDQTY,SUM(IEPS_MONEDA) AS IEPS_MONEDA
into  #facturas_benavides_sap
from #facturas_benavides_sap_aux
group by SUCURSAL,SERIE,IDINVN,FACTURA,IDCUNO,FECHAPROG,IDPRDC,ORDEN

SELECT DISTINCT f.SUCURSAL as sucursal, f.IDCUNO, f.FECHAPROG as fecha_factura, f.FACTURA as factura,
 f.SERIE as serie, f.SERIE as folio_fiscal, f.ORDEN as orden
INTO #encabezado_benavides_sap
FROM #facturas_benavides_sap f




SET @no_prov = '05'

			INSERT INTO #benavides_hf
				SELECT 
					@no_prov																																																									no_prov					,								
					RIGHT(REPLICATE('0', 2)+CONVERT(VARCHAR,f.SUCURSAL),2)																																		sucursal				,	
					LEFT(ISNULL(csb.cia       , REPLICATE(' ', 4) ),4	)																																				centro					,	
					LEFT(ISNULL(csb.mostrador , REPLICATE('0', 4) ),4	)																																				almacen					,	
					LEFT( f.SERIE
					 + CONVERT(VARCHAR,CONVERT(INT,f.factura ))+  REPLICATE(' ',20),20)										folio_fiscal		,
					RIGHT(REPLICATE('0',10)	+	CAST( CONVERT(INT,(NETO_CANTIDAD+IVA_MONEDA+IEPS_MONEDA)   * @factor) as VARCHAR),10)  as importe_neto		,	
					RIGHT(REPLICATE('0',10)	+	CAST( CONVERT(INT,PRECIO_CANTIDAD * @factor) as VARCHAR),10)  as importe_bruto		,	
					RIGHT(REPLICATE('0',10)	+	CAST( CONVERT(INT,DESCUENTOPROD   * @factor) as VARCHAR),10)  as descto_producto	,	
					RIGHT(REPLICATE('0',10)	+	CAST( CONVERT(INT,IVA_MONEDA      * @factor) as VARCHAR),10)  as iva_producto		,	
					RIGHT(REPLICATE('0',10)	+	CAST( CONVERT(INT,IVADESCUENTO    * @factor) as VARCHAR),10)  as iva_descto			,
					RIGHT(REPLICATE('0',18)	+	RIGHT(ISNULL(cast(cast(cpb.COD_PRODCLI as numeric)as varchar),REPLICATE('0',18)) ,18),18)																								cod_benavides		,	
					RIGHT(REPLICATE('0', 6)	+	CAST( CONVERT(INT,f.IDQTY) as VARCHAR), 6)									cant_surtida		,	
					RIGHT(REPLICATE('0',10)	+	CONVERT(VARCHAR,CONVERT(BIGINT,  (CASE WHEN ISNUMERIC(orden) = 1 THEN orden ELSE '' END))),10)  no_pedido				,
					0
					--IDLINE
					,f.IDPRDC
				FROM #facturas_benavides_sap f
				INNER JOIN cat_sucursales_benavides_sap csb on f.IDCUNO = csb.cuenta AND f.sucursal = csb.sucursal
				left JOIN  [monkeyland].[dbo].[catalgoBenavides] cpb on f.IDPRDC = cpb.CODIGO


--***************************************************************************SAP*************************************	
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
	no_pedido
FROM #benavides_hf
ORDER BY sucursal, folio_fiscal, no_registro

DROP TABLE #facturas_benavides
DROP TABLE #facturas_benavides_sap_aux
DROP TABLE #encabezado_benavides
DROP TABLE #facturas_benavides_sap
DROP TABLE #encabezado_benavides_sap
DROP TABLE #benavides_hf

GO

