


CREATE PROCEDURE [sap].[usp_genera_facturacion_electronica_fcias_farmapronto_encabezado_demanda]
	@sucursalR VARCHAR(20),--INT
	@fechaR VARCHAR(20),--DATETIME
	@segto VARCHAR(12),
	@ctepadre VARCHAR(13),
	@cliente VARCHAR(15),
	@folio_fiscal VARCHAR(18)

AS

DECLARE @sucursal INT
DECLARE @fecha DATETIME

SET @sucursal= CONVERT(INT,@sucursalR)
SET @fecha=CONVERT(DATE,@fechaR)



DECLARE @BrutoIEPS VARCHAR(12)
--declare @fecha2 varchar(8)=CONVERT(VARCHAR(8), dateadd(day,-1,@fecha), 112)
declare @fechaDiaUno varchar(8)=CONVERT(VARCHAR(8), dateadd(day,-1,@fecha), 112)
declare @fechaDiaDos varchar(8)=CONVERT(VARCHAR(8), @fecha, 112)

print 1
SELECT	@BrutoIEPS = RIGHT(
						REPLICATE(' ', 12) + 
						CONVERT(VARCHAR(12), 
								SUM((
										CONVERT(BIGINT, ISNULL(t1.importe_bruto, 0) * 100) - 
										CONVERT(BIGINT, ISNULL(t1.descto_oferta, 0) * 100)) / 2)
								), 12
					)
FROM 	facturacion_electronica_estandar t1 INNER JOIN maestro_productos t2 ON
		CONVERT(BIGINT, t1.cod_barras) = CONVERT(BIGINT, t2.cod_barras)
WHERE 	convert(datetime,t1.fecha_tandem, 105)  >= convert(datetime, @fecha, 105) and
		t1.segto = @segto AND 
		t1.ctepadre =  @ctepadre AND
		t1.sucursal = @sucursal AND
		t1.cliente = @cliente AND
		ISNUMERIC(t1.cod_barras) = 1 AND
		ISNUMERIC(t2.cod_barras) = 1 AND
		t1.folio_fiscal = @folio_fiscal AND
		t2.cod_barras IS NOT NULL AND		
		t2.grupo_est IN ('PC01G', 'PC01A')
print 2


-- se agrega tabla temporal que consume sp de extracion de embarque

declare @ExtraccionEmbarque table(
			VWERK varchar(8), 
			PARTNE varchar(20),
			XBLNR varchar(32), 
			VBELN varchar(20),
			FKDAT datetime, 
			POSNR datetime,
			MATNR bigint, 
			ARKTX varchar(80),
			CHARG varchar(20), 
			EAN11 varchar(36), 
			KONDM varchar(4),
			CANTIDAD decimal(13,3),
			PRECIOFARMACIA decimal(15,2),
			PRECIO_PUBLICO decimal(13,2),
			PRECIO_PUBLICO_IMP decimal(13,2), 
			IMPORTE_BRUTO decimal(13,2),
			PORCENTAJE_OFERTAS decimal(13,2),
			OFERTAS decimal(13,2), 
			PORCENTAJE_DESCUENTOS decimal(13,2), 
			DESCUENTOS decimal(13,2),
			IEPS decimal(13,2), 
			IVA decimal(13,2),
			IMPORTE_NETO decimal(13,2),
			BSTKD varchar(70),
			PORC_TMX1 decimal(10,2), 
			PORC_TMX2 decimal(10,2),
			IND_SECTOR varchar(20), 
			KNRZE varchar(20),
			TAXNUM varchar(40), 
			IDNUMBER varchar(120),
			ALTKN varchar(20)
		)

declare @SalidaTmp table( cadena varchar(max))
print 3

insert into @ExtraccionEmbarque 
--exec  [192.168.90.209].[MiddleWare].[IEmbarque].[ExtraccionEmbarque] @fechaDiaUno,'0011002195'
select distinct
			c.VWERK						,
			c.[PARTNER]					,
			'FC21' AS XBLNR				,
			f.VBELN						,
			f.FKDAT						,
			cast(f.[POSNR]as bigint)as [POSNR],
			RIGHT(REPLICATE('0',7)+CAST( CONVERT(BIGINT,CASE WHEN ISNUMERIC(rtrim(ltrim(f.MATNR))) = 1 THEN f.MATNR ELSE '0' END) as VARCHAR) ,7) as MATNR,--as codigo,
			f.ARKTX						,
			f.CHARG						,
			f.EAN11						,
			m.KONDM						,
			f.CANTIDAD					,
			f.PRECIOFARMACIA			,
			f.PRECIO_PUBLICO			,
			(f.PRECIO_PUBLICO+f.IVA)	as PRECIO_PUBLICO_IMP,
			f.IMPORTE_BRUTO				,
			f.PORCENTAJE_OFERTAS		,
			f.OFERTAS					,
			f.PORCENTAJE_DESCUENTOS		,
			f.DESCUENTOS				,
			f.IEPS						,
			f.IVA						,
			f.IMPORTE_NETO				,
			f.[BSTKD]					,
			cast(f.PORC_TMX1 as decimal(10,2))	as PORC_TMX1,
			cast(f.PORC_TMX2 as decimal(10,2))	as PORC_TMX2,
			c.IND_SECTOR				,
			c.KNRZE						,
			c.TAXNUM					,
			c.IDNUMBER					,
			c.ALTKN						
  from  [192.168.90.209].[MiddleWare].[sapdo].[FacturasDevolver] f
  inner join [192.168.90.209].[MiddleWare].[VwDM].[MClientes] c on f.KUNAG=c.[PARTNER]
  left join [192.168.90.209].[MiddleWare].[VwDM].[MMateriales] m on f.MATNR=m.MATNR
  where m.VKORG='2001' and c.BUKRS='2001' and VBELN IN (
'0901615778',
'0901618342',
'0901618340'
  )

--insert into @ExtraccionEmbarque exec  [192.168.90.209].[MiddleWare].[IEmbarque].[ExtraccionEmbarque] @fechaDiaUno,'0011000142'-- '20210601','0011000142'--@fecha2,'0011000142'
--insert into @ExtraccionEmbarque exec  [192.168.90.209].[MiddleWare].[IEmbarque].[ExtraccionEmbarque] @fechaDiaDos,'0011000142'-- '20210601','0011000142'

--insert into @extraccionEmbarque exec  [192.168.90.209].[MiddleWare].[IEmbarque].[ExtraccionEmbarque] @fechaDiaUno,'','0011000142'
--insert into @extraccionEmbarque exec  [192.168.90.209].[MiddleWare].[IEmbarque].[ExtraccionEmbarque] @fechaDiaUno,'','0016001800'

print 4
		
insert into @SalidaTmp
SELECT 	'F' +
		--RIGHT(REPLICATE(' ', 10) + CONVERT(VARCHAR(18),CONVERT(BIGINT,VBELN)), 8) +--sap:VBELN
		'  '+RIGHT(CONVERT(VARCHAR(18),CONVERT(BIGINT,VBELN)),8)+
		REPLICATE('0', 3) +
		REPLICATE('0', 3) +
		CONVERT(VARCHAR(8), FKDAT, 112) +--FKDAT
		RIGHT(REPLICATE('0', 12) + CONVERT(VARCHAR(18), CONVERT(BIGINT,sum(IMPORTE_NETO))), 12) + 
		RIGHT(REPLICATE('0', 12) + CONVERT(VARCHAR(18), CONVERT(BIGINT,sum(DESCUENTOS))), 12) +
		RIGHT(REPLICATE('0', 12) + CONVERT(VARCHAR(18), CONVERT(BIGINT,sum((IMPORTE_NETO+IVA)))), 12) + 
		RIGHT(REPLICATE('0', 12) + CONVERT(VARCHAR(18), CONVERT(BIGINT,sum(PORC_TMX1))), 12) + 
		RIGHT(REPLICATE('0', 12) + CONVERT(VARCHAR(18), CONVERT(BIGINT,sum(IMPORTE_NETO))), 12) +
		RIGHT(REPLICATE('0', 6) +  CONVERT(VARCHAR(18), CONVERT(BIGINT,sum(CANTIDAD))), 6) +  
		--RIGHT(REPLICATE(' ', 18) + (XBLNR+VBELN), 18)
		RIGHT(REPLICATE(' ', 18) + (XBLNR+RIGHT(VBELN,8)), 18)

FROM --extraccionEmbarqueFarmapronto
@ExtraccionEmbarque 
where 
	case when VWERK='1108' then '18' 
	when VWERK='1105' then '13' 
	when VWERK='1109' then '05' 
	when VWERK='1102' then '03' else VWERK end = @sucursal 
	and right(ALTKN,5)=@cliente and right(VBELN,8)=@folio_fiscal
GROUP BY XBLNR, FKDAT, VBELN
print 5

--insert into @SalidaTmp
--SELECT 	'F' +
--		RIGHT(REPLICATE(' ', 10) + t1.serie + CONVERT(VARCHAR(10), CONVERT(BIGINT, t1.folio_fiscal)), 10) +
--		REPLICATE('0', 3) +
--		REPLICATE('0', 3) +
--		CONVERT(VARCHAR(8), t1.fecha_factura, 112) +
--		RIGHT(REPLICATE('0', 12) + CONVERT(VARCHAR(12), CONVERT(BIGINT, SUM(importe_neto) * 100)), 12) + 
--		RIGHT(REPLICATE('0', 12) + CONVERT(VARCHAR(12), CONVERT(BIGINT, SUM(t1.descto_comercial) * 100)), 12) +
--		RIGHT(REPLICATE('0', 12) + CONVERT(VARCHAR(12),
--		ISNULL(SUM(CASE WHEN t1.clas_fis = 'N' THEN ISNULL(CONVERT(BIGINT, t1.importe_bruto * 100),0) - ISNULL(CONVERT(BIGINT, t1.descto_oferta*100),0) END),0) +  
--		ISNULL(SUM(CASE WHEN t1.clas_fis = 'B' THEN ISNULL(CONVERT(BIGINT, t1.importe_bruto * 100),0) - ISNULL(CONVERT(BIGINT, t1.descto_oferta*100),0) END), 0) +  
--		ISNULL(SUM(CASE WHEN t1.clas_fis = 'H' THEN ISNULL(CONVERT(BIGINT, t1.importe_bruto * 100),0) - ISNULL(CONVERT(BIGINT, t1.descto_oferta*100),0) END), 0) +
--		ISNULL(SUM(CASE WHEN t1.clas_fis = 'NA' THEN CONVERT(BIGINT, (t1.importe_bruto-descto_oferta) * 100) END), 0) +
--		ISNULL(SUM(CASE WHEN t1.clas_fis = 'BA' THEN CONVERT(BIGINT, (t1.importe_bruto-descto_oferta) * 100) END), 0) +
--		ISNULL(SUM(CASE WHEN t1.clas_fis = 'HA' THEN CONVERT(BIGINT, (t1.importe_bruto-descto_oferta) * 100) END), 0) + 
--		CONVERT(BIGINT, SUM(t1.iva) * 100)), 12) + 
--		RIGHT(REPLICATE('0', 12) + CONVERT(VARCHAR, CONVERT(BIGINT, SUM(t1.iva)*100)), 12) + 
--		CASE
--			WHEN @BrutoIEPS IS NOT NULL THEN @BrutoIEPS
--			WHEN @BrutoIEPS IS NULL THEN REPLICATE('0', 12)
--		END +
--		RIGHT(REPLICATE('0', 6) + CONVERT(VARCHAR(6), SUM(t1.piezas_surtidas_con_cargo)), 6) +  
--		RIGHT(REPLICATE(' ', 18) + t1.serie + CONVERT(VARCHAR(18), CONVERT(BIGINT, t1.folio_fiscal)), 18)
--FROM 	facturacion_electronica_estandar t1 
--meter en temporal resultado
--WHERE 	
--		--t1.ctepadre = @ctepadre AND
--		t1.sucursal = @sucursal AND
--		t1.cliente = @cliente AND
--		t1.folio_fiscal = @folio_fiscal

--GROUP BY t1.serie,fecha_factura, t1.folio_fiscal
print 6
select * from @SalidaTmp

GO

