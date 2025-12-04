CREATE PROCEDURE [dbo].[usp_genera_fact_elect_det_farmacon_previa] 
	@sucursal INT,
	@fecha datetime,
	@segto VARCHAR(2),
	@ctepadre VARCHAR(3)
AS
--exec [dbo].[usp_genera_fact_elect_det_farmacon_previa] 18,'2021-04-09','C2','999'
--DECLARE @sucursal TINYINT
--DECLARE @fecha DATETIME
--DECLARE @segto VARCHAR(2)
--DECLARE @ctepadre VARCHAR(3)
--SET @sucursal = 17
--SET @fecha = '2015-12-14'
--SET @segto = 'C2'
--SET @ctepadre = '599'

CREATE TABLE #facturacion_farmacon(
	[serie_factura] [varchar](16) NULL,
	[fecha_factura] [varchar](8) NULL,
	[cliente] [varchar](7) NULL,
	[ean] [varchar](13) NULL,
	[piezas_surtidas] [varchar](6) NULL,
	[porcentaje_Oferta] [varchar](5) NULL,
	[porcentaje_descto] [varchar](4) NULL,
	[porcentajeIVA] [varchar](4) NULL,
	[precio_publico] [varchar](8) NULL,
	[precio_farmacia] [varchar](8) NULL,
	[orden] [varchar](10) NULL,
	[valor] [varchar](1) NOT NULL,
	[ieps] [varchar](8000) NULL
) ON [PRIMARY]

insert into #facturacion_farmacon
SELECT 	CASE
            WHEN @sucursal = 5 THEN 'FE' + LEFT(CONVERT(VARCHAR(14), CONVERT(BIGINT, t1.folio_fiscal)) + REPLICATE(' ', 14), 14)
			WHEN @sucursal = 6 THEN 'FJ' + LEFT(CONVERT(VARCHAR(14), CONVERT(BIGINT, t1.folio_fiscal)) + REPLICATE(' ', 14), 14)
			WHEN @sucursal = 16 THEN 'FP' + LEFT(CONVERT(VARCHAR(14), CONVERT(BIGINT, t1.folio_fiscal)) + REPLICATE(' ', 14), 14)
			WHEN @sucursal = 17 THEN 'FQ' + LEFT(CONVERT(VARCHAR(14), CONVERT(BIGINT, t1.folio_fiscal)) + REPLICATE(' ', 14), 14)
  			WHEN @sucursal = 18 THEN 'FR' + LEFT(CONVERT(VARCHAR(14), CONVERT(BIGINT, t1.folio_fiscal)) + REPLICATE(' ', 14), 14)
  			WHEN @sucursal = 25 THEN 'FY' + LEFT(CONVERT(VARCHAR(14), CONVERT(BIGINT, t1.folio_fiscal)) + REPLICATE(' ', 14), 14)
  			WHEN @sucursal = 50 THEN 'FQ' + LEFT(CONVERT(VARCHAR(14), CONVERT(BIGINT, t1.folio_fiscal)) + REPLICATE(' ', 14), 14)
  			WHEN @sucursal = 51 THEN 'FR' + LEFT(CONVERT(VARCHAR(14), CONVERT(BIGINT, t1.folio_fiscal)) + REPLICATE(' ', 14), 14)
			WHEN @sucursal = 21 THEN 'FU' + LEFT(CONVERT(VARCHAR(14), CONVERT(BIGINT, t1.folio_fiscal)) + REPLICATE(' ', 14), 14)
			WHEN @sucursal = 1 THEN 'FU' + LEFT(CONVERT(VARCHAR(14), CONVERT(BIGINT, t1.folio_fiscal)) + REPLICATE(' ', 14), 14)
			WHEN @sucursal = 13 THEN 'FM' + LEFT(CONVERT(VARCHAR(14), CONVERT(BIGINT, t1.folio_fiscal)) + REPLICATE(' ', 14), 14)
			WHEN @sucursal = 11 THEN 'FM' + LEFT(CONVERT(VARCHAR(14), CONVERT(BIGINT, t1.folio_fiscal)) + REPLICATE(' ', 14), 14)
		END as serie_factura,
		CONVERT(VARCHAR(8), t1.fecha_factura, 112)as fecha_factura, 
		RIGHT(REPLICATE('0', 7)	+ isnull(ctf.cuentaVerificado,t1.cliente), 7) as cliente ,
		LEFT(CONVERT(VARCHAR(13), CONVERT(BIGINT, t1.cod_barras)) + REPLICATE(' ', 13), 13)as ean,
		RIGHT(REPLICATE('0', 6) + CONVERT(VARCHAR, t1.piezas_surtidas_con_cargo), 6)as piezas_surtidas,
		RIGHT(REPLICATE('0', 5) + CONVERT(VARCHAR, CONVERT(INT, t1.porcentaje_descto_oferta * 100)), 5) as porcentaje_Oferta ,
		CASE
			WHEN t1.clas_fis = 'N' THEN '0000'
			WHEN t1.clas_fis = 'NA' THEN '0000'
			WHEN t1.clas_fis = 'B' THEN '9999'
			WHEN t1.clas_fis = 'BA' THEN '9999'
			WHEN t1.clas_fis = 'H' THEN RIGHT(REPLICATE('0', 4) + CONVERT(VARCHAR(4), CONVERT(INT, t1.porcentaje_descto_comercial * 100)), 4)
			WHEN t1.clas_fis = 'HA' THEN RIGHT(REPLICATE('0', 4) + CONVERT(VARCHAR(4), CONVERT(INT, t1.porcentaje_descto_comercial * 100)), 4)
		END porcentaje_descto,
		LEFT(CONVERT(VARCHAR, CONVERT(INT, t1.porcentaje_iva * 100)) + REPLICATE('0', 4), 4) as porcentajeIVA,
		RIGHT(REPLICATE('0', 8) + CONVERT(VARCHAR, CONVERT(INT, t1.precio_pub_sin_imp * 100)), 8)as precio_publico ,
		RIGHT(REPLICATE('0', 8) + CONVERT(VARCHAR, CONVERT(INT, t1.precio_farm_sin_imp * 100)), 8)as precio_farmacia ,
		CASE
			WHEN t1.orden = '' THEN REPLICATE('0', 10)
			WHEN t1.orden <> '' THEN RIGHT(REPLICATE('0', 10) + RTRIM(LTRIM(t1.orden)), 10)
		END as orden ,
		'F'as valor,
		REPLICATE('0',5-len(cast(REPLACE(cast(isnull(i.[IEPS],0) as varchar),'.','') as varchar))) +REPLACE(cast(isnull(i.[IEPS],0) as varchar),'.','')as ieps
FROM 	facturacion_electronica_estandar t1  
left join Historica.[dbo].[producto_impuesto] i on t1.codigo=i.[Producto]
left join catalogoYzaFarmacon ctf on substring(ctf.cliente,2,5)=t1.cliente and t1.sucursal=ctf.sucursal and t1.ctepadre=ctf.[ctepadre]
WHERE	t1.fecha_factura >= dateadd(d, -3, CONVERT(DATETIME, CONVERT(VARCHAR(10), @fecha, 121), 121)) AND 
		t1.sucursal = @sucursal AND
		t1.ctepadre in('599','873','965','465')--,'645')
		order by t1.serie,t1.factura

	
	--******************************************************* SAP *********************************************************************
		CREATE TABLE #factura_sap(
			[VWERK] [nvarchar](4) NOT NULL,
			[PARTNER] [nvarchar](10) NOT NULL,
			[XBLNR] [nvarchar](16) NULL,
			[VBELN] [nvarchar](10) NOT NULL,
			[FKDAT] [datetime] NULL,
			[POSNR] [bigint] NULL,
			[MATNR] [varchar](7) NULL,
			[ARKTX] [nvarchar](40) NULL,
			[CHARG] [nvarchar](10) NULL,
			[EAN11] [nvarchar](18) NULL,
			[KONDM] [nvarchar](2) NULL,
			[CANTIDAD] [decimal](13, 3) NULL,
			[PRECIOFARMACIA] [decimal](15, 2) NULL,
			[PRECIO_PUBLICO] [decimal](13, 2) NULL,
			[PRECIO_PUBLICO_IMP] [decimal](14, 2) NULL,
			[IMPORTE_BRUTO] [decimal](13, 2) NULL,
			[PORCENTAJE_OFERTAS] [decimal](13, 2) NULL,
			[OFERTAS] [decimal](13, 2) NULL,
			[PORCENTAJE_DESCUENTOS] [decimal](13, 2) NULL,
			[DESCUENTOS] [decimal](13, 2) NULL,
			[IEPS] [decimal](13, 2) NULL,
			[IVA] [decimal](13, 2) NULL,
			[IMPORTE_NETO] [decimal](13, 2) NULL,
			[orden] [varchar](50) NOT NULL,
			[PORC_TMX1] [decimal](24, 9) NULL,
			[PORC_TMX2] [decimal](24, 9) NULL,
			[IND_SECTOR] [nvarchar](10) NULL,
			[KNRZE] [nvarchar](10) NULL,
			[TAXNUM] [nvarchar](20) NULL,
			[IDNUMBER] [nvarchar](60) NULL
		) ON [PRIMARY]

		declare @fecha_Aux varchar(8)
		declare @sucursal_aux varchar(5)
		set @fecha_Aux= convert(varchar,getdate()-1,112)
		 
		 if @sucursal = 18
		 begin
		 set @sucursal_aux='1108'
		 end
		 else if @sucursal = 17
		 begin
		 set @sucursal_aux='1104'
		 end
		  else if @sucursal = 5
		 begin
		 set @sucursal_aux='1109'
		 end
		 else if @sucursal = 13
		 begin
		 set @sucursal_aux='1105'
		 end
		 else if @sucursal = 21
		 begin
		 set @sucursal_aux='1100'
		 end
		 else if @sucursal = 16
		 begin
		 set @sucursal_aux='1107'
		 end
	insert into #factura_sap
	exec [192.168.90.209].MiddleWare.[IEmbarque].[ExtraccionFacturacionEstandar] @fecha_Aux,'0011000006'

	insert into #facturacion_farmacon
	select  distinct 
		LEFT(CONVERT(VARCHAR(16),  isnull('FC21'+cast(cast(VBELN as bigint) as varchar(10)),'')) + REPLICATE(' ', 16), 16)  as serie_factura,
		CONVERT(VARCHAR(8), [FKDAT], 112)as fecha_factura, 
		RIGHT(REPLICATE('0', 7)	+ isnull(cast([IDNUMBER] as varchar),''), 7) as cliente ,
		LEFT(CONVERT(VARCHAR(13), CONVERT(BIGINT, [EAN11])) + REPLICATE(' ', 13), 13)as ean,
		RIGHT(REPLICATE('0', 6) + CONVERT(VARCHAR, cast(cantidad as numeric(9,0))), 6)as piezas_surtidas,
		RIGHT(REPLICATE('0', 5) + CONVERT(VARCHAR, CONVERT(INT, [PORCENTAJE_OFERTAS] * 100)), 5) as porcentaje_Oferta ,
		RIGHT(REPLICATE('0', 4) + CONVERT(VARCHAR(4), CONVERT(INT, [PORCENTAJE_DESCUENTOS] * 100)), 4) as porcentaje_descto,
		LEFT(CONVERT(VARCHAR, CONVERT(INT, [PORC_TMX1] * 100)) + REPLICATE('0', 4), 4) as porcentajeIVA,
		RIGHT(REPLICATE('0', 8) + CONVERT(VARCHAR, CONVERT(INT, [PRECIO_PUBLICO] * 100)), 8)as precio_publico ,
		RIGHT(REPLICATE('0', 8) + CONVERT(VARCHAR, CONVERT(INT, [PRECIOFARMACIA] * 100)), 8)as precio_farmacia ,
		RIGHT(REPLICATE('0', 10) + RTRIM(LTRIM([orden])), 10) as orden ,
		'F'as valor,
		REPLICATE('0',5-len(cast(REPLACE(cast(isnull([IEPS],0) as varchar),'.','') as varchar))) +REPLACE(cast(isnull([IEPS],0) as varchar),'.','')as ieps
	from #factura_sap WHERE [VWERK]=@sucursal_aux
	
	
	--*********************************************************** SAP *******************************************
select serie_factura+fecha_factura+cliente+ean+piezas_surtidas+porcentaje_Oferta+porcentaje_descto+porcentajeIVA+precio_publico+precio_farmacia+orden+valor+ieps 
	from #facturacion_farmacon
	drop table #facturacion_farmacon
	drop table #factura_sap

GO

