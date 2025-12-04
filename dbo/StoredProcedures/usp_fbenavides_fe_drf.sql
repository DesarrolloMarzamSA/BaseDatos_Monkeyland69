--[usp_fbenavides_fe_drf] '20181212'
CREATE 
PROCEDURE [dbo].[usp_fbenavides_fe_drf] @fecha VARCHAR(10)			--	@sucursal INT, 
AS

--DECLARE @sucursal INT
--DECLARE @cliente VARCHAR(5)						--	f.digito_verificador,
--DECLARE @factura VARCHAR(8)							--	f.cod_barras,
--DECLARE @sep VARCHAR(1)									--	f.clas_fis,
--DECLARE @factor INT											--	f.piezas_surtidas_sin_cargo,
--DECLARE @orden INT											--	f.porcentaje_utilidad,
																				--	f.filler,
--SET @sep = ''														--	f.bonificacion_iva2,
--SET @factor = 100												--	f.bonificacion_iva_del_iesps,

--CREATE TABLE #benavides_hf	(
--	no_prov					VARCHAR( 2)													,
--	sucursal				VARCHAR( 2)						NOT NULL			,
--	centro					VARCHAR( 4)													,
--	almacen					VARCHAR( 4)													,
--	folio_fiscal		VARCHAR(20)						NOT NULL			,
--	importe_neto		VARCHAR(10)	,
--	importe_bruto		VARCHAR(10) ,
--	descto_producto	    VARCHAR(10)	,
--	iva_producto		VARCHAR(10)	,
--	iva_descto			VARCHAR(10)	,
--	/*importe_neto		money,
--	importe_bruto		money,
--	descto_producto	    money,
--	iva_producto		money,
--	iva_descto			money,*/
--	-----------------------------------------
--	cod_benavides		VARCHAR(18)	NOT NULL,	
--	cant_surtida		VARCHAR( 6)	,
--	no_pedido			VARCHAR(10)	,
--	no_registro			INT			NOT NULL,
--	codigo VARCHAR(10)	
--	--idlinea int
--	PRIMARY KEY (sucursal, folio_fiscal, cod_benavides, importe_neto,no_registro)	
--	)

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

--SET @dias =  CASE WHEN DATEPART(DW,CONVERT(DATETIME,GETDATE(),121)) = 2 THEN 3 ELSE 1 END
----900389197
--/*SAP*/
--select DISTINCT SUCURSAL,SERIE,IDINVN,FACTURA,IDCUNO,FECHAPROG,IDLINE,IDPRDC,
--[NOPEDIDO] as ORDEN,NETO_CANTIDAD,IVA_MONEDA,PRECIO_CANTIDAD,DESCUENTOPROD,0 as IVADESCUENTO,IDQTY,IEPS_MONEDA
--	INTO #facturas_benavides
--	from [dbo].[detalle_benavides] 
--	where IDINVN in (
--'900389197',
--'900388286',
--'900388297',
--'900388283',
--'900388298',
--'900388295',
--'900388285',
--'900388284',
--'900389275',
--'900389392',
--'900389345',
--'900389247',
--'900389390',
--'900391060',
--'900390013',
--'900390713',
--'900391417',
--'900390029',
--'900391043',
--'900384399',
--'900389179',
--'900389196',
--'900389198',
--'900389271',
--'900389279',
--'900389381',
--'900389240',
--'900389359',
--'900389385',
--'900389242',
--'900389308',
--'900389284',
--'900389285',
--'900389244',
--'900389340',
--'900389249',
--'900389238',
--'900389388',
--'900389348',
--'900389288',
--'900389287',
--'900389354',
--'900389358',
--'900389395',
--'900389351',
--'900389346',
--'900389318',
--'900389350',
--'900389281',
--'900389312',
--'900389391',
--'900389276',
--'900389273',
--'900389356',
--'900389314',
--'900389383',
--'900389251',
--'900389389',
--'900389309',
--'900389316',
--'900390788',
--'900390859',
--'900390866',
--'900390871',
--'900389900',
--'900391028',
--'900390867',
--'900390874',
--'900389897',
--'900391029',
--'900391027',
--'900389899',
--'900391045',
--'900390863',
--'900390869',
--'900390998',
--'900390861',
--'900389976',
--'900389793',
--'900389964',
--'900389774',
--'900389791',
--'900389988',
--'900389729',
--'900389980',
--'900389969',
--'900389730',
--'900389777',
--'900389780',
--'900389972',
--'900389737',
--'900389806',
--'900389823',
--'900389778',
--'900389734',
--'900389767',
--'900389967',
--'900389970',
--'900389733',
--'900389826',
--'900389977',
--'900389704',
--'900389770',
--'900389775',
--'900388296',
--'900388287',
--'900388293',
--'900388291',
--'900388290',
--'900388288',
--'900388289',
--'900388294',
--'900388292',
--'900383203',
--'900383191',
--'900383204',
--'900383205',
--'900383192',
--'900383193',
--'900382909',
--'900382910',
--'900382948',
--'900382362',
--'900382398',
--'900382531',
--'900382545',
--'900382601',
--'900382395',
--'900382576',
--'900382598',
--'900382575',
--'900382408',
--'900382400',
--'900382434',
--'900382436',
--'900382433',
--'900382399',
--'900382510',
--'900382397',
--'900382346',
--'900382345',
--'900382600',
--'900382554',
--'900382530',
--'900382602',
--'900382527',
--'900382403',
--'900382359',
--'900382342',
--'900382556',
--'900382432',
--'900382435',
--'900382344',
--'900382409',
--'900382511',
--'900382340',
--'900382528',
--'900382358',
--'900382339',
--'900382431',
--'900382343',
--'900382555',
--'900382401',
--'900382361',
--'900382405',
--'900382430',
--'900382407',
--'900382404',
--'900382360',
--'900382532',
--'900382597',
--'900382357',
--'900382402',
--'900382396',
--'900382406',
--'900382428',
--'900382429',
--'900382341',
--'900382599',
--'900382529',
--'900382526',
--'900382394'
--	)
--	 order by IDINVN

--/***************************************************/

--/*IBS*/
--/*
--select  SUCURSAL,SERIE,IDINVN,FACTURA,case when len(IDCUNO)<9 then IDCUNO ,FECHAPROG,IDLINE,IDPRDC,
--[NOPEDIDO] as ORDEN,NETO_CANTIDAD,IVA_MONEDA,PRECIO_CANTIDAD,DESCUENTOPROD,0 as IVADESCUENTO,IDQTY,IEPS_MONEDA
--	INTO #facturas_benavides--select *
--	from
--	 --[dbo].[detalle_benavides_historico] 
--	 [dbo].[detalle_benavides] 
--	INNER JOIN  [monkeyland].[dbo].[catalgoBenavides] cpb on IDPRDC = cpb.CODIGO	
--	--where  --convert(varchar,FECHAPROG,112)=convert(varchar,getdate()-6,112) and ESTATUSH in(3)--
----	 IDCUNO in('G09973') --and 
--	-- convert(varchar,FECHAPROG,112)>='20170123'-- between '20150430' and '20150504'	
--where IDINVN  in (

--)
--order by IDINVN,IDLINE
--*/
	 
--	 --	 select convert(varchar,FECHAPROG,112) from  [dbo].[detalle_benavides]
 
-- update monkeyland..detalle_benavides set ESTATUSD=2,FECHAESTATUS=GETDATE() where convert(varchar,FECHAPROG,112)>=convert(varchar,getdate()-@dias,112) and ESTATUSD=1 

--ALTER TABLE #facturas_benavides ADD PRIMARY KEY  (SUCURSAL, IDCUNO, IDINVN, IDPRDC,IDLINE)


--UPDATE #facturas_benavides SET SUCURSAL = 7 WHERE SUCURSAL = 8
--UPDATE #facturas_benavides SET SUCURSAL = 3 WHERE SUCURSAL = 2
--UPDATE #facturas_benavides SET SUCURSAL = 24 WHERE SUCURSAL = 23
----UPDATE #facturas_benavides SET SUCURSAL = 18 WHERE SUCURSAL = 19

--SELECT DISTINCT f.SUCURSAL as sucursal, f.IDCUNO, f.FECHAPROG as fecha_factura, f.FACTURA as factura,
-- f.SERIE as serie, f.SERIE as folio_fiscal, f.ORDEN as orden,f.NETO_CANTIDAD
--INTO #encabezado_benavides
--FROM #facturas_benavides f

--DECLARE @no_prov				VARCHAR(2)
--DECLARE @no_registros			INT
--DECLARE @neto_factura			real--NUMERIC(10,2)
--DECLARE @iva					real--NUMERIC(10,2)
--DECLARE @bruto_factura			real--NUMERIC(10,2)
--DECLARE @descto_factura			real--NUMERIC(10,2)
--DECLARE @iva_descto				real--NUMERIC(10,2)

--SET @no_prov = '05'
--SET @no_registros = 0
--SET @neto_factura = 0
--SET @iva = 0
--SET @bruto_factura = 0
--SET @descto_factura = 0
--SET @iva_descto = 0

----BEGIN
----	DECLARE  cur_encabezados CURSOR forward_only FOR 
----		SELECT DISTINCT
----			fb.sucursal ,
----			substring(fb.IDCUNO,2,5) cliente,
----			fb.factura
----		FROM #facturas_benavides fb 

--	--OPEN cur_encabezados
--	--FETCH FROM cur_encabezados INTO @sucursal, @cliente, @factura 

--	--WHILE @@FETCH_STATUS = 0
--	--	BEGIN	
--			INSERT INTO #benavides_hf
--				SELECT 
--					@no_prov	no_prov		,								
--					RIGHT(REPLICATE('0', 2)+CONVERT(VARCHAR,f.SUCURSAL),2)	sucursal,	
--					LEFT(ISNULL(csb.cia       , REPLICATE(' ', 4) ),4	)	centro					,	
--					LEFT(ISNULL(csb.mostrador , REPLICATE('0', 4) ),4	)	almacen					,	
--					LEFT( f.SERIE
--					 + CONVERT(VARCHAR,CONVERT(INT,f.factura ))+  REPLICATE(' ',20),20)										folio_fiscal		,
--					RIGHT(REPLICATE('0',10)	+	CAST( CONVERT(INT,(NETO_CANTIDAD+IVA_MONEDA+IEPS_MONEDA)   * @factor) as VARCHAR),10) /*(NETO_CANTIDAD+IVA_MONEDA)*/ as importe_neto		,	
--					RIGHT(REPLICATE('0',10)	+	CAST( CONVERT(INT,PRECIO_CANTIDAD * @factor) as VARCHAR),10) /*PRECIO_CANTIDAD*/ as importe_bruto		,	
--					RIGHT(REPLICATE('0',10)	+	CAST( CONVERT(INT,DESCUENTOPROD   * @factor) as VARCHAR),10) /*DESCUENTOPROD*/ as descto_producto	,	
--					RIGHT(REPLICATE('0',10)	+	CAST( CONVERT(INT,IVA_MONEDA      * @factor) as VARCHAR),10) /*IVA_MONEDA*/ as iva_producto		,	
--					RIGHT(REPLICATE('0',10)	+	CAST( CONVERT(INT,IVADESCUENTO    * @factor) as VARCHAR),10) /*IVADESCUENTO*/ as iva_descto			,
--					RIGHT(REPLICATE('0',18)	+	RIGHT(ISNULL(cast(cast(cpb.COD_PRODCLI as numeric)as varchar),REPLICATE('0',18)) ,18),18)																								cod_benavides		,	
--					RIGHT(REPLICATE('0', 6)	+	CAST( CONVERT(INT,f.IDQTY) as VARCHAR), 6)									cant_surtida		,	
--					RIGHT(REPLICATE('0',10)	+	CONVERT(VARCHAR,CONVERT(BIGINT,  (
--					CASE WHEN ISNUMERIC(orden) = 1 THEN orden ELSE '' END
--					--''
--					))),10)  no_pedido				,
--					IDLINE,f.IDPRDC
--				FROM #facturas_benavides f
--				INNER JOIN cat_sucursales_benavides csb on substring(f.IDCUNO,2,5) = csb.cuenta AND f.sucursal = csb.sucursal
--				left JOIN  [monkeyland].[dbo].[catalgoBenavides] cpb on f.IDPRDC = cpb.CODIGO
--		--		WHERE f.sucursal = @sucursal AND substring(f.IDCUNO,2,5) = @cliente AND f.factura = @factura

--		--		--select * from [monkeyland].[dbo].[catalgoBenavides]

--		--	FETCH NEXT FROM cur_encabezados INTO @sucursal, @cliente, @factura--	@sucursal
--		--	--DROP TABLE #remision

--		--	END
--		--CLOSE cur_encabezados
--		--DEALLOCATE cur_encabezados
--	--END
	
--SELECT 
--		no_prov					,
--	sucursal				,
--	centro					,
--	almacen					,
--	folio_fiscal		,
--	importe_neto		,
--	importe_bruto		,
--	descto_producto	,
--	iva_producto		,
--	iva_descto			,
--	cod_benavides		,
--	cant_surtida		,
--	no_pedido--,codigo
--FROM #benavides_hf
--ORDER BY sucursal, folio_fiscal, no_registro

--DROP TABLE #facturas_benavides
--DROP TABLE #encabezado_benavides
--DROP TABLE #benavides_hf

DECLARE @sucursal INT
DECLARE @cliente VARCHAR(5)						
DECLARE @factura VARCHAR(8)							
DECLARE @sep VARCHAR(1)									
DECLARE @factor INT											
DECLARE @orden INT
DECLARE @no_prov				VARCHAR(2)='05'
DECLARE @no_registros			INT
DECLARE @neto_factura			real
DECLARE @iva					real
DECLARE @bruto_factura			real
DECLARE @descto_factura			real
DECLARE @iva_descto				real		

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
																
SET @sep = ''														
SET @factor = 100	
								
SET @factor = 100			


select DISTINCT SUCURSAL,SERIE,IDINVN,FACTURA,IDCUNO,FECHAPROG,IDLINE,IDPRDC,
[NOPEDIDO] as ORDEN,NETO_CANTIDAD,IVA_MONEDA,PRECIO_CANTIDAD,DESCUENTOPROD,0 as IVADESCUENTO,IDQTY,IEPS_MONEDA
	INTO #facturas_benavides_sap_aux
	from [dbo].[detalle_benavides] 	 
	where IDINVN in (
'824000717495',
'824000717498',
'824000717499'
	)
order by IDINVN

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
				union
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
				INNER JOIN cat_sucursales_benavides csb on f.IDCUNO = csb.cliente_ibs AND f.sucursal = csb.sucursal
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

--DROP TABLE #facturas_benavides
DROP TABLE #facturas_benavides_sap_aux
--DROP TABLE #encabezado_benavides
DROP TABLE #facturas_benavides_sap
DROP TABLE #encabezado_benavides_sap
DROP TABLE #benavides_hf

GO

