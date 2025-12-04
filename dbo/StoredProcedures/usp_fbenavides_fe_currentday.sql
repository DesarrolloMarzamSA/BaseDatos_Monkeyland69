CREATE	--	CREATE --	DROP
PROCEDURE usp_fbenavides_fe_currentday
@fecha VARCHAR(10)
AS

/*
EXECUTE usp_fbenavides_fe_currentday '2012-06-01'
*/

DECLARE @dias INT

SET @dias = CASE WHEN DATEPART(DW,CONVERT(DATETIME,@fecha,121)) = 1 THEN -2 ELSE -1 END

--	SET @dias = CASE WHEN DATEPART(DW,CONVERT(DATETIME,@fecha,121)) = 1 THEN -2 ELSE -2 END




/*
CREATE --	DROP
TABLE 
	encabezado_benavides_abc(
	[sucursal] [tinyint] NOT NULL,
	[factura] [char](8) NOT NULL,
--	[serie] [char](2) NOT NULL,
	[cliente] [char](5) NOT NULL,
	[ruta] [char](3) NOT NULL,
	[facturado] [char](1) NULL,
	[farmacia] [char](39) NULL,
	[etiquetas] [char](1) NULL,
	[domicilio] [char](40) NULL,
	[colonia] [char](23) NULL,
	[itinerario] [char](2) NULL,
	[letradig] [char](1) NULL,
	[restodig] [char](2) NULL,
	[numdig] [char](2) NULL,
	[poblacion] [char](15) NULL,
	[jefeagente] [char](1) NULL,
	[numagente] [char](2) NULL,
	[control] [char](1) NULL,
	[diapago] [char](1) NULL,
	[cvecredito] [char](1) NULL,
	[filler2] [char](2) NULL,
	[password] [char](4) NULL,
	[horacap] [smalldatetime] NULL,
	[hojordsur] [char](3) NULL,
	[hojfactura] [char](3) NULL,
	[tipfac] [char](1) NULL,
	[bulto] [char](1) NULL,
	[producee0] [char](4) NULL,
	[renglonee0] [char](4) NULL,
	[importe] [char](1) NULL,
	[controlado] [char](1) NULL,
	[desctoesp] [char](5) NULL,
	[dueno] [char](30) NULL,
	[meno999] [char](5) NULL,
	[mayp000] [char](5) NULL,
	[encima] [char](1) NULL,
	[jaula] [char](3) NULL,
	[rutaf] [char](3) NULL,
	[facturadof] [char](1) NULL,
	[itineraf] [char](3) NULL,
	[producto3a] [char](6) NULL,
	[prducto2a] [char](6) NULL,
	[producto1a] [char](6) NULL,
	[productob] [char](6) NULL,
	[productoc] [char](6) NULL,
	[fechaprog] [smalldatetime] NULL,
	[repleon] [char](4) NULL,
	[limexcedid] [char](1) NULL,
	[impmenor] [char](1) NULL,
	[rutaencima] [char](3) NULL,
	[complerel] [char](1) NULL,
	[espnetos] [char](1) NULL,
	[mafnarch] [char](8) NULL,
	[prodimp] [char](1) NULL,
	[indcod] [char](1) NULL,
	[enestacion] [char](3) NULL,
	[numjob] [char](3) NULL,
	[puerta] [char](2) NULL,
	[filler3] [char](1) NULL,
	[tipoorden] [char](1) NULL,
	[tipofactur] [char](1) NULL,
	[cadenaid] [char](1) NULL,
	[modosepara] [char](1) NULL,
	[licitacion] [char](16) NULL,
	[contrato] [char](16) NULL,
	[orden] [char](16) NULL,
	[fianza] [char](16) NULL,
	[fechaalta] [smalldatetime] NULL,
	[noalta] [char](10) NULL,
	[segto] [char](2) NULL,
	[ctepadre] [char](3) NULL,
	[filler] [char](13) NULL,
	[timestamp] [datetime] NULL,
	[folio_fiscal] [varchar](8) NULL,
	[fecha_tandem] [smalldatetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[sucursal] ASC,
	[factura] ASC--,
	--[serie] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
*/

TRUNCATE TABLE encabezado_benavides_abc	;

INSERT INTO encabezado_benavides_abc
SELECT e.* 
FROM encabezado e
INNER JOIN clientes_baan b ON b.sucursal = e.sucursal AND b.cliente = e.cliente
WHERE 
	e.fecha_tandem = CONVERT(DATETIME,@fecha,121)
--	CONVERT(DATETIME,'2012-06-01',121)
AND (
		(	e.ctepadre = '199' ) 
	OR 
		(	e.ctepadre = '319' AND 
			e.cliente <> '05961'	AND	--  se excluyen las facturas del CEDIS 
				b.rfc = 'FBE9110215Z3'	--	se fuerza a traves de RFC
		)
	)

--	SELECT * FROM encabezado_benavides_abc


----------------------------


TRUNCATE TABLE fes_benavides_abc

INSERT INTO fes_benavides_abc

SELECT 
	f.sucursal									,
	f.cliente										,
	f.digito_verificador				,
	f.serie											,
	f.factura										,
	f.fecha_factura							,
	f.codigo										,
	f.descripcion								,
	f.cod_barras								,
	f.clas_fis									,
	f.piezas_surtidas_con_cargo	,
	f.piezas_surtidas_sin_cargo	,
	f.precio_farm_sin_imp				,
	f.precio_pub_sin_imp				,
	f.precio_pub_con_imp				,
	f.importe_bruto							,
	f.porcentaje_descto_oferta	,
	f.descto_oferta							,
	f.porcentaje_descto_oferta	,
	f.descto_comercial					,
	f.ieps											,
	f.iva												,
	f.bonificacion_iva					,
	f.porcentaje_utilidad				,
	f.importe_neto							,
	f.orden											,
	f.porcentaje_iva						,
	f.filler										,
	f.no_registro								,
	f.desc_comerc_prod					,
	f.porcentaje_iva2						,
	f.iva2											,
	f.bonificacion_iva2					,
	f.porcentaje_ieps						,
	f.desc_comerc_ieps					,
	f.iva_del_iesps							,
	f.bonificacion_iva_del_iesps,
	f.timestamp									,
	f.segto											,
	f.ctepadre									,
	f.rfc												,
	f.tipo_documento						,
	f.folio_fiscal							,
	f.fecha_tandem

FROM facturacion_electronica_estandar f
INNER JOIN encabezado_benavides_abc e ON 
	e.sucursal = f.sucursal AND e.factura = f.factura
--WHERE 
/*
fecha_tandem = CONVERT(DATETIME,@fecha,121)
--CONVERT(DATETIME,'2012-05-24',121) 
--	BETWEEN DATEADD(DD,@dias, CONVERT(datetime,@fecha,121) ) AND CONVERT(DATETIME,@fecha,121) 
AND 
( 
	(
		f.cliente <> '05961' AND	--  se excluyen las facturas del CEDIS 
	--f.segto = 'C1' AND 
		f.ctepadre = '319'
		AND f.rfc = 'FBE9110215Z3'	--	se fuerza a traves de RFC
	) 
OR (
   --f.segto = 'C2' AND
   f.ctepadre = '199' 
   )
)
*/

--	SELECT * FROM fes_benavides_abc

GO

