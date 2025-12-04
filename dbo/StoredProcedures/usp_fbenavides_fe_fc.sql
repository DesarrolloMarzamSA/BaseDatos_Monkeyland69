/*
usp_fbenavides_fe_fc '2011-06-13'
*/

--  
--  FECHA CREACION: 28 NOV 2008 - 02 DIC 2008
--  MIGUEL SAMAYOA  
--  ARCHIVO DESTINO: FCXXX donde XXX es la IATA de la sucursal  


CREATE 
--	CREATE
PROCEDURE [dbo].[usp_fbenavides_fe_fc] (@fecha VARCHAR(10))
as

/*
DECLARE @fecha VARCHAR(10)
SET @fecha =  '2011-06-13'
*/

DECLARE @segto VARCHAR(2)
DECLARE @ctepadre VARCHAR(3)
DECLARE @factura VARCHAR(8)
DECLARE @sep VARCHAR(1)
DECLARE @factor int
SET @factor = 100
SET @sep = '|'


CREATE TABLE #fbenavides_fc	(
	proveedor							VARCHAR( 2),
	sucursal							VARCHAR( 2),
	cliente								VARCHAR( 7),
	centro								VARCHAR( 4),
	almacen								VARCHAR( 4),
	fecha									VARCHAR( 8),
	factura								VARCHAR(20),
	pedido								VARCHAR(10),
	laboratorio						VARCHAR( 6),
	cod_benavides					VARCHAR(18),
	piezas_con_cargo			VARCHAR( 7),
	piezas_sin_cargo			VARCHAR( 7),
	prec_farmacia					VARCHAR(10),
	ventra_bruta					VARCHAR(10),
	rebajas								VARCHAR(10),
	ieps_sobre_vta				VARCHAR(10),
	iva_vta								VARCHAR(10),
	vta_neta							VARCHAR(10),
	costo_base						VARCHAR(10),
	oferta								VARCHAR(10),
	comision							VARCHAR(10),
	ieps_comision					VARCHAR(10),
	iva_comision					VARCHAR(10),
	cost_neto							VARCHAR(10),
	importe_nota_ajuste		VARCHAR(10),
	iva_ajuste						VARCHAR(10),
	oferta_precio_fcia		VARCHAR(10),
	iva_descto						VARCHAR(10),
	descto_ieps						VARCHAR(10),
	iva_descto_ieps				VARCHAR(10),
	fecha_vencimiento			VARCHAR( 8),
	precio_oferta					VARCHAR(10)
)


SET @segto = 'C1'
SET @ctepadre = '319'
DECLARE @dias INT

SET DATEFIRST 7	--	FIJA EL PRIMER DIA ES DOMINGO

SET @dias = CASE WHEN DATEPART(DW,CONVERT(DATETIME,@fecha,121)) = 1 THEN -2 ELSE -1 END

SET @dias = CASE WHEN DATEPART(DW,CONVERT(DATETIME,@fecha,121)) = 1 THEN -2 ELSE -2 END

SELECT 
	'05'																										codprov, 
																													f.sucursal, 
																													f.cliente,
	ISNULL(b.cia      , REPLICATE('-',4)) 									cia, 
	ISNULL(b.mostrador, REPLICATE('-',4)) 									mostrador, 
																													fecha_factura, 
																													serie, 
																													factura, 
	ISNULL(orden,'')																				orden, 
	'000000'																								cod_may,		--	codigo
	CONVERT(INT,ISNULL(bcp.cod_ben,REPLICATE('0',18)))			cod_ben,
																													piezas_surtidas_con_cargo,
																													piezas_surtidas_sin_cargo, 
	CONVERT(INT,precio_farm_sin_imp * @factor)							precio_farm_sin_imp, 
	CONVERT(INT,(importe_bruto			* @factor))							vta_bruta,	--	(precio_farm_sin_imp * piezas_surtidas_con_cargo) - descto_oferta)
	CONVERT(INT,descto_comercial    * @factor)							rebajas, 
	CONVERT(INT,descto_comercial    * @factor)							descto_comercial, 
	CONVERT(INT,iva                 * @factor)							iva, 
	0																												ieps_vta,	--	ieps
	CONVERT(INT,importe_neto        * @factor)							vta_neta, 
	CONVERT(INT,importe_neto        * @factor)							costo_base, 
	CONVERT(INT,descto_oferta       * @factor)							oferta, 
	0																												comision, 
	0																												ieps_comision,
	0																												iva_comision, 
	CONVERT(INT,importe_neto        * @factor)							costo_neto,
	0																												nota_ajuste,
	0																												iva_ajuste,
	0																												prec_ofe_farma,
	CONVERT(INT,bonificacion_iva    * @factor)							iva_descto,
	0																												dcto_ieps,
	0																												iva_descto_ieps,
	REPLICATE(' ', 8)																				vencimiento,
	0																												prec_ofe,
																													f.codigo,
																													f.folio_fiscal
into #facturas_benavides 
from facturacion_electronica_estandar f
left join cat_sucursales_benavides b on f.cliente = b.cuenta --	and f.sucursal = b.sucursal
left join vw_cat_productos_benavides_fe bcp on bcp.cod_mar = f.codigo 
 
--left join catalogo_autoservicios bcp on bcp.codigo = f.codigo AND bcp.status = 'A' 
--		AND bcp.segto = 'C1' and bcp.ctepadre = '319' and bcp.sucursal = 7 
WHERE --f.fecha_factura --= CONVERT(datetime,@fecha,121) 
	fecha_tandem --= CONVERT(DATETIME,@fecha,121)
	BETWEEN DATEADD(DD,@dias, CONVERT(datetime,@fecha,121) ) AND CONVERT(DATETIME,@fecha,121) 
	AND (
--f.segto = @segto
 f.ctepadre = '319'	--	= @ctepadre 
	AND f.rfc = 'FBE9110215Z3'	--	AGREGADO POR PROBLEMA DE DUPLICIDAD DE FOLIOS FISCALES EN GDL CON EL ISSSTE
	AND NOT cliente = '05961'
	) --  se excluyen las facturas del CEDIS 
OR 
	(
	--f.segto = @segto
	f.ctepadre = '199'	--	= @ctepadre 
	)
ORDER BY f.sucursal,f.factura,f.codigo

UPDATE #facturas_benavides 
SET sucursal =  s.almacen
FROM #facturas_benavides f 
INNER JOIN sucursales s ON f.sucursal = s.sucursal


--SELECT * FROM #facturas_benavides 

SET @sep = ''

--	create table #resultados(tipo VARCHAR(2),col1 VARCHAR(500),orden int, codigo VARCHAR(7), cliente VARCHAR(5), folio_fiscal VARCHAR(10))

	/*DECLARE  cur_encabezados CURSOR forward_only FOR 
	SELECT 
		t1.sucursal,
		t1.factura 
	FROM #facturas_benavides t1 
	WHERE fecha_factura = CONVERT(datetime,@fecha,121) 
		AND sucursal = @sucursal 
		AND ctepadre = @ctepadre 
		AND segto = @segto
	group by t1.sucursal,t1.factura
	order by t1.sucursal,t1.factura

	open cur_encabezados
	fetch next from cur_encabezados into @sucursal, @factura*/

	begin
--	insert into #resultados (tipo,col1,orden,codigo, cliente, folio_fiscal)
	insert into #fbenavides_fc
		SELECT  
			codprov																																										proveedor						,
			RIGHT('00'+CONVERT(VARCHAR,f.sucursal),2)																									sucursal						,
			RIGHT(REPLICATE('0', 7)+cliente,7)																												cliente							,
			cia																																												centro							,
			mostrador																																									almacen							,
			CONVERT(VARCHAR,fecha_factura,112)																												fecha								,
			LEFT(s.serie_cfd + CONVERT(VARCHAR,CONVERT(INT,f.folio_fiscal) )+ REPLICATE('0',20)  ,20) factura							,
			RIGHT(REPLICATE('0',10) + LTRIM(RTRIM(orden)),10)																					pedido							,
			RIGHT(REPLICATE('0', 6) + cod_may, 6)																											laboratorio					,
			RIGHT(REPLICATE('0',18) + CONVERT(VARCHAR, cod_ben									   ),18)							cod_benavides				,
			RIGHT(REPLICATE('0', 7) + CONVERT(VARCHAR, piezas_surtidas_con_cargo   ), 7)							piezas_con_cargo		,
			RIGHT(REPLICATE('0', 7) + CONVERT(VARCHAR, piezas_surtidas_sin_cargo   ), 7)							piezas_sin_cargo		,
			RIGHT(REPLICATE('0',10) + CONVERT(VARCHAR, precio_farm_sin_imp         ),10)							prec_farmacia				,
			RIGHT(REPLICATE('0',10) + CONVERT(VARCHAR, vta_bruta                   ),10)							ventra_bruta				,
			RIGHT(REPLICATE('0',10) + CONVERT(VARCHAR, rebajas                     ),10)							rebajas							,
			RIGHT(REPLICATE('0',10) + CONVERT(VARCHAR, ieps_vta                    ),10)							ieps_sobre_vta			,
			RIGHT(REPLICATE('0',10) + CONVERT(VARCHAR, iva                         ),10)							iva_vta							,
			RIGHT(REPLICATE('0',10) + CONVERT(VARCHAR, vta_neta                    ),10)							vta_neta						,
			RIGHT(REPLICATE('0',10) + CONVERT(VARCHAR, costo_base                  ),10)							costo_base					,
			RIGHT(REPLICATE('0',10) + CONVERT(VARCHAR, oferta                      ),10)							oferta							,
			RIGHT(REPLICATE('0',10) + CONVERT(VARCHAR, comision                    ),10)							comision						,
			RIGHT(REPLICATE('0',10) + CONVERT(VARCHAR, ieps_comision               ),10)							ieps_comision				,
			RIGHT(REPLICATE('0',10) + CONVERT(VARCHAR, iva_comision                ),10)							iva_comision				,
			RIGHT(REPLICATE('0',10) + CONVERT(VARCHAR, costo_neto                  ),10)							cost_neto						,
			RIGHT(REPLICATE('0',10) + CONVERT(VARCHAR, nota_ajuste                 ),10)							importe_nota_ajuste	,
			RIGHT(REPLICATE('0',10) + CONVERT(VARCHAR, iva_ajuste                  ),10)							iva_ajuste					,
			RIGHT(REPLICATE('0',10) + CONVERT(VARCHAR, prec_ofe_farma              ),10)							oferta_precio_fcia	,
			RIGHT(REPLICATE('0',10) + CONVERT(VARCHAR, iva_descto                  ),10)							iva_descto					,
			RIGHT(REPLICATE('0',10) + CONVERT(VARCHAR, dcto_ieps                   ),10)							descto_ieps					,
			RIGHT(REPLICATE('0',10) + CONVERT(VARCHAR, iva_descto_ieps             ),10)							iva_descto_ieps			,
			RIGHT(REPLICATE(' ', 8) + CONVERT(VARCHAR, vencimiento                 ), 8)							fecha_vencimiento		,
			RIGHT(REPLICATE('0',10) + CONVERT(VARCHAR, prec_ofe                    ),10)							precio_oferta
																																															
--			COL1,0,codigo, cliente, folio_fiscal
		from #facturas_benavides f
		INNER JOIN sucursales s ON f.sucursal = s.sucursal

	/*  fetch next from cur_encabezados 
		into @sucursal, @factura*/
	end
--	SELECT * from #resultados

SELECT * FROM #fbenavides_fc
--	DROP TABLE #resultados
DROP TABLE #fbenavides_fc
DROP TABLE #facturas_benavides

GO

