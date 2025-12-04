
CREATE 
----exec [usp_fbenavides_fe_hrf] '20181212' 

----	CREATE --	drop
PROCEDURE [dbo].[usp_fbenavides_fe_hrf] @fecha VARCHAR(10)	--	@sucursal INT, 
AS
--DECLARE @sucursal INT
--DECLARE @cliente VARCHAR(5)						--	f.digito_verificador,
--DECLARE @factura VARCHAR(8)							--	f.cod_barras,
--DECLARE @sep VARCHAR(1)									--	f.clas_fis,
--DECLARE @factor INT											--	f.piezas_surtidas_sin_cargo,
--DECLARE @orden INT											--	f.porcentaje_utilidad,

--SET @sep = ''														--	f.bonificacion_iva2,
--SET @factor = 100												--	f.bonificacion_iva_del_iesps,
--/************************************************************************************************************/
----Declare @FacturasFaltantes as table(
----Factura varchar(20),
----OrdenMarzam varchar(20),
----Fecha varchar(10),
----IdCliente varchar(8)
----)

----insert into @FacturasFaltantes 
----select 
----RTRIM(IHINVN) as factura,
----	   RTRIM(IHORNO) as ordenMarzam,
----	   RTRIM(IHIDAT) as fecha,
----	   RTRIM(IHCUNO) as idCliente
----from openquery(as400,'
----SELECT * FROM MA4620EF04.SRBISH WHERE IHORNO IN (
----select OHORNO
----from MA4620EF04.SRBSOH
----INNER JOIN MA4620EF04.SRONAM ON OHCUNO=NANUM AND NANCA1 IN (''99319'',''99199'')
----where OHODAT =20200911 and OHOTME >=60000 and OHORDT like (''F%'') 
----UNION 
----select OHORNO
----from MA4620EF04.SRBSOH
----INNER JOIN MA4620EF04.SRONAM ON OHCUNO=NANUM AND NANCA1 IN (''99319'',''99199'')
----where OHODAT =20200912 and OHORDT like (''F%'') 
----union
----select OHORNO
----from MA4620EF04.SRBSOH
----INNER JOIN MA4620EF04.SRONAM ON OHCUNO=NANUM AND NANCA1 IN (''99319'',''99199'')
----where OHODAT =20200913 and OHORDT like (''F%'') 
----union
----select OHORNO
----from MA4620EF04.SRBSOH
----INNER JOIN MA4620EF04.SRONAM ON OHCUNO=NANUM AND NANCA1 IN (''99319'',''99199'')
----where OHODAT =20200914 and OHOTME < 60000 and OHORDT like (''F%'') 

----) AND IHTYPP=1 order by IHORNO
----')


----select * from @FacturasFaltantes order by Fecha,factura

--/************************************************************************************************************/

--CREATE TABLE #benavides_hf	(
--	no_prov				VARCHAR( 2)		    ,
--	sucursal			VARCHAR( 2)	NOT NULL,
--	folio_fiscal		VARCHAR(20)	NOT NULL,
--	no_registros		VARCHAR( 4)			,
--	fecha_factura		VARCHAR( 8)			,
--	orden				VARCHAR(10)			,
--	centro				VARCHAR( 4)			,
--	almacen				VARCHAR( 4)			,
--	importe_neto		VARCHAR(10)			,
--	iva					VARCHAR(10)			,
--	importe_bruto		VARCHAR(10)			,
--	descuento			VARCHAR(10)			,
--	iva_descto			VARCHAR(10)			,
--	/*importe_neto		money,
--	iva					money,
--	importe_bruto		money,
--	descuento			money,
--	iva_descto			money,*/
--	clave_factura		VARCHAR( 2)	
--	--IDINVN 				numeric(12,0)
--	--PRIMARY KEY (sucursal, folio_fiscal)
--	)

--SET DATEFIRST 7	--	FIJA EL PRIMER DIA ES DOMINGO

----Sunday		 1 
----Monday		 2
----Tuesday		 3
----Wednesday	 4
----Thursday	 5
----Friday		 6
----Saturday	 7

--DECLARE @dias INT
----	SI EL DIA ES LUNES LE RESTA 2 DIAS AL RANGO

--SET @dias = CASE WHEN DATEPART(DW,CONVERT(DATETIME,GETDATE(),121)) = 2 THEN 3 ELSE 1 END
----print('dias '+cast(@dias as varchar))
----select CASE WHEN DATEPART(DW,CONVERT(DATETIME,GETDATE(),121)) = 2 THEN 3 ELSE 1 END
----select  DATEPART(DW,CONVERT(DATETIME,GETDATE(),121))


--select DISTINCT SUCURSAL,SERIE,IDINVN,FACTURA,IDCUNO,FECHAPROG,IDLINE,IDPRDC,
--[NOPEDIDO] as ORDEN,NETO_CANTIDAD,IVA_MONEDA,PRECIO_CANTIDAD,DESCUENTOPROD,0 as IVADESCUENTO,IEPS_MONEDA
--INTO #facturas_benavides--select distinct IDINVN
--	from --[dbo].[detalle_benavides_historico] 
--	[dbo].[detalle_benavides] 
-- 	inner JOIN  [monkeyland].[dbo].[catalgoBenavides] cpb on IDPRDC = cpb.CODIGO
--	where IDINVN  in (
--'900382394'
--)

----	sucursal=23 and RTRIM(IDCUNO) in('X51289',
----'X51124',
----'X51120',
----'X51142',
----'X51292',
----'X51126',
----'X51133',
----'X51290',
----'X51918',
----'X51122',
----'X51119',
----'X51118',
----'X51121',
----'X51578',
----'X51123',
----'X51134',
----'X52070',
----'X51604',
----'X51600',
----'X52378',
----'X52225',
----'X51545',
----'X52075',
----'X52377',
----'X51132',
----'X51641',
----'X51602',
----'X51117',
----'X51921',
----'X51724',
----'X52279',
----'X51288',
----'X51136',
----'X51601',
----'X52448',
----'X51558',
----'X51143',
----'X51144',
----'X52340',
----'X51147',
----'X51603',
----'X51621',
----'X51137',
----'X51920',
----'X51291',
----'X51127',
----'X51286',
----'X51612',
----'X51619',
----'X52244',
----'X52296',
----'X51140',
----'X51625',
----'X51141',
----'X51131',
----'X52033',
----'X52300',
----'X52301',
----'X51557',
----'X51145',
----'X52088',
----'X51138',
----'X52094',
----'X51139',
----'X51956',
----'X51128',
----'X52276',
----'X51130',
----'X51125',
----'X52052',
----'X51287',
----'X52182',
----'X52418',
----'X52257',
----'X51116')
--	 --IDCUNO in('J02744') and convert(varchar,FECHAPROG,112)>='20160601'
--	--convert(varchar,FECHAPROG,112)=convert(varchar,getdate()-6,112) and ESTATUSH in(3)	
--	-- IDCUNO in('G09973') --and 
--	--convert(varchar,FECHAPROG,112)>='20170123'
--	 order by IDINVN
	
--	--update [dbo].[detalle_benavides] set [NOPEDIDO]='' where IDINVN  in(808001269959)
--	--select *
--	--from [dbo].[detalle_benavides] where IEPS>0 IDINVN=806001757496 
--update monkeyland..detalle_benavides set ESTATUSH=2,FECHAESTATUS=GETDATE() where convert(varchar,FECHAPROG,112)>=convert(varchar,getdate()-@dias,112) and ESTATUSH=1 

--ALTER TABLE #facturas_benavides ADD PRIMARY KEY (SUCURSAL, IDCUNO, IDINVN, IDPRDC,IDLINE)

----DROP TABLE #facturas_benavides

--UPDATE #facturas_benavides SET SUCURSAL = 7 WHERE SUCURSAL = 8
--UPDATE #facturas_benavides SET SUCURSAL = 3 WHERE SUCURSAL = 2
--UPDATE #facturas_benavides SET SUCURSAL = 24 WHERE SUCURSAL = 23
----UPDATE #facturas_benavides SET SUCURSAL = 18 WHERE SUCURSAL = 19

--SELECT DISTINCT f.SUCURSAL as sucursal, substring(f.IDCUNO,2,5) as cliente, f.FECHAPROG as fecha_factura, f.FACTURA as factura, 
--f.SERIE as serie, f.FACTURA as folio_fiscal, f.ORDEN as orden,IDPRDC--,f.IDINVN
--INTO #encabezado_benavides
--FROM #facturas_benavides f


--DECLARE @no_prov			VARCHAR(2)
--DECLARE @no_registros		INT
--DECLARE @neto_factura		real    --NUMERIC(10,2)
--DECLARE @iva				real	--NUMERIC(10,2)
--DECLARE @bruto_factura		real	--NUMERIC(10,2)
--DECLARE @descto_factura		real	--NUMERIC(10,2)
--DECLARE @iva_descto			real	--NUMERIC(10,2)

--SET @no_prov = '05'
--SET @no_registros = 0
--SET @neto_factura = 0
--SET @iva = 0
--SET @bruto_factura = 0
--SET @descto_factura = 0
--SET @iva_descto = 0

--BEGIN
--	DECLARE  cur_encabezados CURSOR FORWARD_ONLY FOR 
--		SELECT DISTINCT
--			fb.sucursal ,
--			substring(fb.IDCUNO,2,5) cliente	,
--			fb.factura
--		FROM #facturas_benavides fb 
--		order by fb.SUCURSAL
--	OPEN cur_encabezados
--	FETCH FROM cur_encabezados INTO @sucursal, @cliente, @factura --,@orden	--	@sucursal, 

--	WHILE @@FETCH_STATUS = 0
--		BEGIN		
--			SELECT @no_registros	= (SELECT COUNT(*) registros FROM #facturas_benavides WHERE sucursal = @sucursal AND substring(IDCUNO,2,5) = @cliente AND factura = @factura)
--			SELECT @neto_factura	= (SELECT ((SUM(NETO_CANTIDAD)+sum(IVA_MONEDA)+sum(IEPS_MONEDA))* @factor) Suma	FROM #facturas_benavides WHERE sucursal = @sucursal AND substring(IDCUNO,2,5) = @cliente AND factura = @factura)
--			SELECT @iva				= (SELECT (SUM(IVA_MONEDA)*@factor) Suma	FROM #facturas_benavides WHERE sucursal = @sucursal AND substring(IDCUNO,2,5) = @cliente AND factura = @factura)
--			SELECT @bruto_factura	= (SELECT (SUM(PRECIO_CANTIDAD)*@factor) Suma	FROM #facturas_benavides WHERE sucursal = @sucursal AND substring(IDCUNO,2,5) = @cliente AND factura = @factura)
--			SELECT @descto_factura	= (SELECT (SUM(DESCUENTOPROD)*@factor) Suma	FROM #facturas_benavides WHERE sucursal = @sucursal AND substring(IDCUNO,2,5) = @cliente AND factura = @factura)
--			SELECT @iva_descto		= (SELECT SUM(IVADESCUENTO ) Suma	FROM #facturas_benavides WHERE sucursal = @sucursal AND substring(IDCUNO,2,5) = @cliente AND factura = @factura)

--			INSERT INTO #benavides_hf
--				SELECT 
--					@no_prov	no_prov				,
--					RIGHT(REPLICATE('0', 2)+CONVERT(VARCHAR,e.sucursal),2)	sucursal			,					
--					LEFT(e.serie
--					--e.serie_cfd
--					 +  CONVERT(VARCHAR,CONVERT(INT, e.factura)) + REPLICATE(' ',20),20) folio_fiscal	,					
--					RIGHT(REPLICATE('0', 4)+CONVERT(VARCHAR,@no_registros),4)									no_registros	, 
--					CONVERT(VARCHAR,fecha_factura,112)															fecha_factura,	
--					RIGHT(REPLICATE('0',10)+CONVERT(VARCHAR,CONVERT(BIGINT, 
--					CASE WHEN ISNUMERIC(rtrim(ltrim(e.orden))) = 1 THEN e.orden ELSE '' END
--					--''
--					)),10) orden,						
--					LEFT(      ISNULL(csb.cia       , REPLICATE(' ', 4) ),4  )	centro				,	
--					LEFT(      ISNULL(csb.mostrador , REPLICATE(' ', 4) ),4  )	almacen				,	
--					RIGHT(REPLICATE('0',10)+CAST( CONVERT(INT,@neto_factura		) as VARCHAR) ,10)	     /*cast(@neto_factura as money)*/	importe_neto	, 	
--					RIGHT(REPLICATE('0',10)+CAST( CONVERT(INT,@iva						) as VARCHAR) ,10) /*cast(@iva as money)*/ iva		,	
--					RIGHT(REPLICATE('0',10)+CAST( CONVERT(INT,@bruto_factura	) as VARCHAR) ,10)		/*cast(@bruto_factura as money)*/	importe_bruto,	
--					RIGHT(REPLICATE('0',10)+CAST( CONVERT(INT,@descto_factura	) as VARCHAR) ,10)		/*cast(@descto_factura as money)*/	descuento			,	
--					RIGHT(REPLICATE('0',10)+CAST( CONVERT(INT,@iva_descto			) as VARCHAR) ,10)	/*cast(@iva_descto as money)*/	iva_descto		,	
--					'FT'	--,	e.IDINVN		
--				FROM #encabezado_benavides e
--				INNER JOIN cat_sucursales_benavides csb on e.cliente = csb.cuenta and e.sucursal = csb.sucursal  				
--				WHERE e.sucursal = @sucursal AND 
--				e.cliente = @cliente AND e.factura = @factura;

--			FETCH NEXT FROM cur_encabezados INTO @sucursal, @cliente, @factura	
--			END
--		CLOSE cur_encabezados
--		DEALLOCATE cur_encabezados
--	END
	
--SELECT distinct * FROM #benavides_hf

--DROP TABLE #facturas_benavides
--DROP TABLE #encabezado_benavides
--DROP TABLE #benavides_hf

DECLARE @sucursal INT
DECLARE @cliente VARCHAR(12)
DECLARE @factura VARCHAR(12)
DECLARE @sep VARCHAR(1)	
DECLARE @factor INT	
DECLARE @orden INT
DECLARE @no_prov			VARCHAR(2)
DECLARE @no_registros		INT
DECLARE @neto_factura		real    
DECLARE @iva				real	
DECLARE @bruto_factura		real	
DECLARE @descto_factura		real	
DECLARE @iva_descto			real	

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

select DISTINCT SUCURSAL,SERIE,IDINVN,FACTURA,IDCUNO,FECHAPROG,IDLINE,IDPRDC,
[NOPEDIDO] as ORDEN,NETO_CANTIDAD,IVA_MONEDA,PRECIO_CANTIDAD,DESCUENTOPROD,0 as IVADESCUENTO,IEPS_MONEDA
INTO #facturas_benavides_sap_aux
	from [dbo].[detalle_benavides] 
	where IDINVN in (
'824000717495',
'824000717498',
'824000717499'
	)
	 order by IDINVN

ALTER TABLE #facturas_benavides_sap_aux ADD PRIMARY KEY (SUCURSAL, IDCUNO, IDINVN, IDPRDC,IDLINE)

select SUCURSAL,SERIE,IDINVN,FACTURA,IDCUNO,FECHAPROG,IDPRDC,ORDEN,
sum(NETO_CANTIDAD)as NETO_CANTIDAD,sum(IVA_MONEDA) as IVA_MONEDA,sum(PRECIO_CANTIDAD)as PRECIO_CANTIDAD,sum(DESCUENTOPROD)as DESCUENTOPROD,sum(IVADESCUENTO)as IVADESCUENTO,sum(IEPS_MONEDA)as IEPS_MONEDA
into  #facturas_benavides_sap
from #facturas_benavides_sap_aux
group by SUCURSAL,SERIE,IDINVN,FACTURA,IDCUNO,FECHAPROG,IDPRDC,ORDEN

SELECT DISTINCT f.SUCURSAL as sucursal, f.IDCUNO as cliente, f.FECHAPROG as fecha_factura, f.FACTURA as factura, 
f.SERIE as serie, f.FACTURA as folio_fiscal, f.ORDEN as orden,IDPRDC
INTO #encabezado_benavides_sap
FROM #facturas_benavides_sap f


SET @factor = 100	
SET @no_prov = '05'
SET @no_registros = 0
SET @neto_factura = 0
SET @iva = 0
SET @bruto_factura = 0
SET @descto_factura = 0
SET @iva_descto = 0

BEGIN
	DECLARE  cur_encabezados_sap CURSOR FORWARD_ONLY FOR 
		SELECT DISTINCT
			fb.sucursal ,
			fb.IDCUNO cliente	,
			fb.factura
		FROM #facturas_benavides_sap fb 
		order by fb.SUCURSAL
	OPEN cur_encabezados_sap
	FETCH FROM cur_encabezados_sap INTO @sucursal, @cliente, @factura 

	WHILE @@FETCH_STATUS = 0
		BEGIN		
			SELECT @no_registros	= (SELECT COUNT(*) registros FROM #facturas_benavides_sap WHERE sucursal = @sucursal AND IDCUNO = @cliente AND factura = @factura)
			SELECT @neto_factura	= (SELECT ((SUM(NETO_CANTIDAD)+sum(IVA_MONEDA)+sum(IEPS_MONEDA))* @factor) Suma	FROM #facturas_benavides_sap WHERE sucursal = @sucursal AND IDCUNO = @cliente AND factura = @factura)
			SELECT @iva				= (SELECT (SUM(IVA_MONEDA)*@factor) Suma	FROM #facturas_benavides_sap WHERE sucursal = @sucursal AND IDCUNO = @cliente AND factura = @factura)
			SELECT @bruto_factura	= (SELECT (SUM(PRECIO_CANTIDAD)*@factor) Suma	FROM #facturas_benavides_sap WHERE sucursal = @sucursal AND IDCUNO = @cliente AND factura = @factura)
			SELECT @descto_factura	= (SELECT (SUM(DESCUENTOPROD)*@factor) Suma	FROM #facturas_benavides_sap WHERE sucursal = @sucursal AND IDCUNO = @cliente AND factura = @factura)
			SELECT @iva_descto		= (SELECT SUM(IVADESCUENTO ) Suma	FROM #facturas_benavides_sap WHERE sucursal = @sucursal AND  IDCUNO = @cliente AND factura = @factura)
			print @sucursal
			print @cliente
			INSERT INTO #benavides_hf
				SELECT 
					@no_prov	no_prov				,
					RIGHT(REPLICATE('0', 2)+CONVERT(VARCHAR,e.sucursal),2)	sucursal			,					
					LEFT(e.serie
					 +  CONVERT(VARCHAR,CONVERT(INT, e.factura)) + REPLICATE(' ',20),20) folio_fiscal	,					
					RIGHT(REPLICATE('0', 4)+CONVERT(VARCHAR,@no_registros),4)									no_registros	, 
					CONVERT(VARCHAR,fecha_factura,112)															fecha_factura,	
					RIGHT(REPLICATE('0',10)+CONVERT(VARCHAR,CONVERT(BIGINT, CASE WHEN ISNUMERIC(rtrim(ltrim(e.orden))) = 1 THEN e.orden ELSE '' END)),10) orden,						
					LEFT(      ISNULL(csb.cia       , REPLICATE(' ', 4) ),4  )	centro				,	
					LEFT(      ISNULL(csb.mostrador , REPLICATE(' ', 4) ),4  )	almacen				,	
					RIGHT(REPLICATE('0',10)+CAST( CONVERT(INT,@neto_factura		) as VARCHAR) ,10)	     	importe_neto	, 	
					RIGHT(REPLICATE('0',10)+CAST( CONVERT(INT,@iva						) as VARCHAR) ,10)  iva		,	
					RIGHT(REPLICATE('0',10)+CAST( CONVERT(INT,@bruto_factura	) as VARCHAR) ,10)			importe_bruto,	
					RIGHT(REPLICATE('0',10)+CAST( CONVERT(INT,@descto_factura	) as VARCHAR) ,10)			descuento			,	
					RIGHT(REPLICATE('0',10)+CAST( CONVERT(INT,@iva_descto			) as VARCHAR) ,10)		iva_descto		,	
					'FT'	
				FROM #encabezado_benavides_sap e
				INNER JOIN cat_sucursales_benavides_sap csb on e.cliente = csb.cuenta and e.sucursal = csb.sucursal  				
				WHERE e.sucursal = @sucursal AND e.cliente = @cliente AND e.factura = @factura
				union
				SELECT 
					@no_prov	no_prov				,
					RIGHT(REPLICATE('0', 2)+CONVERT(VARCHAR,e.sucursal),2)	sucursal			,					
					LEFT(e.serie
					 +  CONVERT(VARCHAR,CONVERT(INT, e.factura)) + REPLICATE(' ',20),20) folio_fiscal	,					
					RIGHT(REPLICATE('0', 4)+CONVERT(VARCHAR,@no_registros),4)									no_registros	, 
					CONVERT(VARCHAR,fecha_factura,112)															fecha_factura,	
					RIGHT(REPLICATE('0',10)+CONVERT(VARCHAR,CONVERT(BIGINT, CASE WHEN ISNUMERIC(rtrim(ltrim(e.orden))) = 1 THEN e.orden ELSE '' END)),10) orden,						
					LEFT(      ISNULL(csb.cia       , REPLICATE(' ', 4) ),4  )	centro				,	
					LEFT(      ISNULL(csb.mostrador , REPLICATE(' ', 4) ),4  )	almacen				,	
					RIGHT(REPLICATE('0',10)+CAST( CONVERT(INT,@neto_factura		) as VARCHAR) ,10)	     	importe_neto	, 	
					RIGHT(REPLICATE('0',10)+CAST( CONVERT(INT,@iva						) as VARCHAR) ,10)  iva		,	
					RIGHT(REPLICATE('0',10)+CAST( CONVERT(INT,@bruto_factura	) as VARCHAR) ,10)			importe_bruto,	
					RIGHT(REPLICATE('0',10)+CAST( CONVERT(INT,@descto_factura	) as VARCHAR) ,10)			descuento			,	
					RIGHT(REPLICATE('0',10)+CAST( CONVERT(INT,@iva_descto			) as VARCHAR) ,10)		iva_descto		,	
					'FT'	
				FROM #encabezado_benavides_sap e
				INNER JOIN cat_sucursales_benavides csb on e.cliente = csb.cliente_ibs and e.sucursal = csb.sucursal  				
				WHERE e.sucursal = @sucursal AND e.cliente = @cliente AND e.factura = @factura;
			FETCH NEXT FROM cur_encabezados_sap INTO @sucursal, @cliente, @factura	
			END
		CLOSE cur_encabezados_sap
		DEALLOCATE cur_encabezados_sap
	END
SELECT distinct * FROM #benavides_hf

--DROP TABLE #facturas_benavides
DROP TABLE #facturas_benavides_sap_aux
--DROP TABLE #encabezado_benavides
DROP TABLE #benavides_hf
DROP TABLE #facturas_benavides_sap
DROP TABLE #encabezado_benavides_sap

GO

