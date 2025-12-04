

CREATE  PROCEDURE [sap].[usp_genera_facturacion_electronica_fcias_farmapronto_detalle_demanda_IBS]
	@sucursal INT,
	@fecha DATETIME,
	@segto VARCHAR(2),
	@ctepadre VARCHAR(13),
	@cliente VARCHAR(5),
	@folio_fiscal VARCHAR(18)
AS



declare @fechaDiaUno varchar(8)=CONVERT(VARCHAR(8), dateadd(day,-1,@fecha), 112)
declare @fechaDiaDos varchar(8)=CONVERT(VARCHAR(8), @fecha, 112)
print @fechaDiaUno
print @ctepadre
print @cliente
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

--las facturas estan entre el dia que fuerno enviadas y el dia siguiente debido a la metodologia de surtir antes de facturar
--insert into @ExtraccionEmbarque exec [192.168.90.209].[MiddleWare].[IEmbarque].[ExtraccionEmbarque] @fechaDiaUno,'0011000142'-- @fecha2,'0011000142'
--insert into @ExtraccionEmbarque exec [192.168.90.209].[MiddleWare].[IEmbarque].[ExtraccionEmbarque] @fechaDiaDos,'0011000142'-- @fecha2,'0011000142'

--insert into @extraccionEmbarque exec  [192.168.90.209].[MiddleWare].[IEmbarque].[ExtraccionEmbarque] @fechaDiaUno,'','0011000142'
--insert into @extraccionEmbarque exec  [192.168.90.209].[MiddleWare].[IEmbarque].[ExtraccionEmbarque] @fechaDiaUno,'','0016001800'
/*
insert into @extraccionEmbarque
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
			--f.PORCENTAJE_OFERTAS		,
			CONVERT(money, round(([OFERTAS]*100) / [IMPORTE_BRUTO],2,2)) as PORCENTAJE_OFERTAS,
			f.OFERTAS					,
			--f.PORCENTAJE_DESCUENTOS		,
			CAST(CASE WHEN f.IMPORTE_BRUTO-f.OFERTAS != 0 THEN ABS(ROUND((f.DESCUENTOS/(f.IMPORTE_BRUTO-f.OFERTAS)),4)*100) ELSE 0 END as money) as PORCENTAJE_DESCUENTOS,
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
  where m.VKORG='2001' and c.BUKRS='2001' and convert(varchar,f.FKDAT,112)>=@fechaDiaUno AND
   c.KDGRP='PA'
   */
   /*
insert into @SalidaTmp
SELECT	'P' +
		RIGHT(REPLICATE('0', 8) + CONVERT(VARCHAR(8), MATNR), 8) +
		RIGHT(REPLICATE('0', 6) + CONVERT(VARCHAR(6), CONVERT(BIGINT,(CANTIDAD))), 6) +
		RIGHT(REPLICATE('0', 6) + CONVERT(VARCHAR(6), 0), 6) +
		RIGHT(REPLICATE('0', 5) + CONVERT(VARCHAR(13), CONVERT(BIGINT,(PORCENTAJE_OFERTAS * 100))), 5) +
		RIGHT(REPLICATE('0', 8) + CONVERT(VARCHAR(13), CONVERT(BIGINT, PRECIOFARMACIA * 100)), 8) +
		RIGHT(REPLICATE('0', 8) + CONVERT(VARCHAR(13), CONVERT(BIGINT, PRECIO_PUBLICO * 100)), 8 ) +
		RIGHT(REPLICATE('0', 8) + CONVERT(VARCHAR(13), CONVERT(BIGINT, IMPORTE_BRUTO * 100)), 8) +
		RIGHT(REPLICATE('0', 8) + CONVERT(VARCHAR(13), CONVERT(BIGINT, (PRECIO_PUBLICO*CANTIDAD) * 100)), 8) +
		RIGHT(REPLICATE('0', 8) + CONVERT(VARCHAR(13), CONVERT(BIGINT, PORC_TMX1 * 100)), 8) +
		RIGHT(REPLICATE('0', 8) + CONVERT(VARCHAR(13), CONVERT(BIGINT, PORC_TMX2 * 100)), 8) +
		CASE
			WHEN KONDM = 'N'  THEN REPLICATE('0', 5)
			WHEN KONDM = 'NA' THEN REPLICATE('0', 5)
			WHEN KONDM = 'F'  THEN REPLICATE('0', 5)
			WHEN KONDM = 'FA' THEN REPLICATE('0', 5)
			WHEN KONDM = 'O'  THEN REPLICATE('0', 5)
			WHEN KONDM = 'OA' THEN REPLICATE('0', 5)						
			WHEN KONDM = 'B'  THEN RIGHT(REPLICATE('0', 5) + CONVERT(VARCHAR(13), CONVERT(BIGINT, PORCENTAJE_DESCUENTOS * 100)), 5)
			WHEN KONDM = 'BA' THEN RIGHT(REPLICATE('0', 5) + CONVERT(VARCHAR(13), CONVERT(BIGINT, PORCENTAJE_DESCUENTOS * 100)), 5)
			WHEN KONDM = 'H'  THEN RIGHT(REPLICATE('0', 5) + CONVERT(VARCHAR(13), CONVERT(BIGINT, PORCENTAJE_DESCUENTOS * 100)), 5)
			WHEN KONDM = 'HA' THEN RIGHT(REPLICATE('0', 5) + CONVERT(VARCHAR(13), CONVERT(BIGINT, PORCENTAJE_DESCUENTOS * 100)), 5)
			ELSE REPLICATE('0', 5)
		END +
		REPLICATE(' ', 1) +
		RIGHT(REPLICATE(' ', 8) + CONVERT(VARCHAR(13), CONVERT(BIGINT, IMPORTE_NETO * 100)), 8) +
		'1' +
		RIGHT(REPLICATE('0', 14) + CONVERT(VARCHAR(14), EAN11), 14) +
		RIGHT(REPLICATE('0', 4) + CONVERT(VARCHAR(4), 0), 4) +--sap: 0
		CASE
			WHEN KONDM = 'N' THEN '4'
			WHEN KONDM = 'NA' THEN '2'
			WHEN KONDM = 'F' THEN '4'
			WHEN KONDM = 'FA' THEN '2'
			WHEN KONDM = 'O' THEN '4'
			WHEN KONDM = 'OA' THEN '2'
			WHEN KONDM = 'B' THEN '4'
			WHEN KONDM = 'BA' THEN '2'
			WHEN KONDM = 'H' THEN '4'
			WHEN KONDM = 'HA' THEN '2'
		END +
		'0' +
		'0'
FROM 	@ExtraccionEmbarque
WHERE 	
	case when VWERK='1108' then '18' 
	when VWERK='1105' then '13' 
	when VWERK='1109' then '05' end = @sucursal AND
right(ALTKN,5)=@cliente AND
right(VBELN,8)=@folio_fiscal		
ORDER BY EAN11*/



insert into @SalidaTmp
SELECT	'P' +
		RIGHT(REPLICATE('0', 8) + CONVERT(VARCHAR(8), t1.codigo), 8) +
		RIGHT(REPLICATE('0', 6) + CONVERT(VARCHAR(6), t1.piezas_surtidas_con_cargo), 6) +
		RIGHT(REPLICATE('0', 6) + CONVERT(VARCHAR(6), t1.piezas_surtidas_sin_cargo), 6) +
		RIGHT(REPLICATE('0', 5) + CONVERT(VARCHAR(5), CONVERT(BIGINT, t1.porcentaje_descto_oferta * 100)), 5) +
		RIGHT(REPLICATE('0', 8) + CONVERT(VARCHAR(8), CONVERT(BIGINT, t1.precio_farm_sin_imp * 100)), 8) +
		RIGHT(REPLICATE('0', 8) + CONVERT(VARCHAR(8), CONVERT(BIGINT, t1.precio_pub_sin_imp * 100)), 8 ) +
		RIGHT(REPLICATE('0', 8) + CONVERT(VARCHAR, CONVERT(BIGINT, t1.importe_bruto * 100)), 8) +
		RIGHT(REPLICATE('0', 8) + CONVERT(VARCHAR, CONVERT(BIGINT, t1.precio_pub_sin_imp * t1.piezas_surtidas_con_cargo * 100)), 8) +
		RIGHT(REPLICATE('0', 8) + CONVERT(VARCHAR(8), CONVERT(BIGINT, t1.iva * 100)), 8) +
		RIGHT(REPLICATE('0', 8) + CONVERT(VARCHAR(8), CONVERT(BIGINT, t1.ieps * 100)), 8) +
		CASE
			WHEN t1.clas_fis = 'N'  THEN REPLICATE('0', 5)
			WHEN t1.clas_fis = 'NA' THEN REPLICATE('0', 5)
			WHEN t1.clas_fis = 'F'  THEN REPLICATE('0', 5)
			WHEN t1.clas_fis = 'FA' THEN REPLICATE('0', 5)
			WHEN t1.clas_fis = 'O'  THEN REPLICATE('0', 5)
			WHEN t1.clas_fis = 'OA' THEN REPLICATE('0', 5)						
			WHEN t1.clas_fis = 'B'  THEN RIGHT(REPLICATE('0', 5) + CONVERT(VARCHAR(5), CONVERT(BIGINT, t1.porcentaje_descto_comercial * 100)), 5)
			WHEN t1.clas_fis = 'BA' THEN RIGHT(REPLICATE('0', 5) + CONVERT(VARCHAR(5), CONVERT(BIGINT, t1.porcentaje_descto_comercial * 100)), 5)
			WHEN t1.clas_fis = 'H'  THEN RIGHT(REPLICATE('0', 5) + CONVERT(VARCHAR(5), CONVERT(BIGINT, t1.porcentaje_descto_comercial * 100)), 5)
			WHEN t1.clas_fis = 'HA' THEN RIGHT(REPLICATE('0', 5) + CONVERT(VARCHAR(5), CONVERT(BIGINT, t1.porcentaje_descto_comercial * 100)), 5)
			ELSE REPLICATE('0', 5)
		END +
		REPLICATE(' ', 1) +
		RIGHT(REPLICATE(' ', 8) + CONVERT(VARCHAR(8), CONVERT(BIGINT, t1.importe_neto * 100)), 8) +
		'1' +
		RIGHT(REPLICATE('0', 14) + CONVERT(VARCHAR(14), CONVERT(BIGINT, t1.cod_barras)), 14) +
		RIGHT(REPLICATE('0', 4) + CONVERT(VARCHAR(4), CONVERT(BIGINT, case when t1.porcentaje_utilidad>0 then t1.porcentaje_utilidad else 0 end * 100)), 4) +
		CASE
			WHEN t1.clas_fis = 'N' THEN '4'
			WHEN t1.clas_fis = 'NA' THEN '2'
			WHEN t1.clas_fis = 'F' THEN '4'
			WHEN t1.clas_fis = 'FA' THEN '2'
			WHEN t1.clas_fis = 'O' THEN '4'
			WHEN t1.clas_fis = 'OA' THEN '2'
			WHEN t1.clas_fis = 'B' THEN '4'
			WHEN t1.clas_fis = 'BA' THEN '2'
			WHEN t1.clas_fis = 'H' THEN '4'
			WHEN t1.clas_fis = 'HA' THEN '2'
		END +
		'0' +
		'0'
FROM 	facturacion_electronica_estandar t1
WHERE 	--t1.ctepadre = @ctepadre AND
		t1.sucursal = @sucursal AND
		t1.cliente = @cliente AND
		t1.folio_fiscal = @folio_fiscal		
ORDER BY t1.cod_barras

select * from @SalidaTmp

GO

