------------------------------------------------------------
--		[sap].[usp_genera_facturacion_electronica_minne]  '2021-07-05'

CREATE PROCEDURE [sap].[usp_genera_facturacion_electronica_minne] ( @fecha varchar(10) )
AS
begin
  --DECLARE @fecha varchar(10) --= '20201021'
  set @fecha=convert(varchar(10),getdate()-1,112)

declare @tmpEEPlantilla table(
	VWERK varchar(4),PARTNER varchar(10),XBLNR varchar(16),VBELN varchar(10),
	FKDAT datetime,POSNR varchar(6),MATNR varchar(40),ARKTX varchar(40),
	CHARG varchar(10),EAN11 varchar(18),KONDM varchar(60),CANTIDAD DECIMAL(13,3),
	PRECIOFARMACIA DECIMAL(15,2),PRECIO_PUBLICO DECIMAL(15,2),PRECIO_PUBLICO_IMP decimal(15,2),IMPORTE_BRUTO decimal(15,2),
	PORCENTAJE_OFERTAS decimal(15,2),OFERTAS decimal(15,2),PORCENTAJE_DESCUENTOS decimal(13,2),
	DESCUENTOS decimal(15,2),IEPS decimal(13,2),IVA decimal(13,2),IMPORTE_NETO decimal(13,2),BSTKD varchar(35),
	PORC_TMX1 decimal(12,2),PORC_TMX2 decimal(12,2),IND_SECTOR varchar(10),KNRZE varchar(10),TAXNUM varchar(20),
	IDNUMBER varchar(60),ALTKN varchar(10),NAME_ORG1 varchar(60)
)  
INSERT INTO @tmpEEPlantilla
EXEC [192.168.90.209].[MiddleWare].[IEmbarque].[ExtraccionEmbarquePlantilla] @fecha,'0011001471'

SELECT '0'
	+ substring(ALTKN,2,6)
	+ '1'
	+ RIGHT(VBELN,7)
	+ REPLICATE('0',6)
	+ REPLICATE('0', 7-len(CONVERT(VARCHAR,Convert(int,isnull(cantidad ,0)))))+CONVERT(VARCHAR,Convert(int,isnull(cantidad ,0)))  
    + RIGHT(replicate('0',10-len(convert(varchar,CONVERT(INT,(PRECIOFARMACIA  * 100))))) + convert(varchar,CONVERT(INT,(PRECIOFARMACIA  * 100))) ,10) -- PRECIOFARMACIA convert(varchar,CONVERT(INT,PRECIOFARMACIA  * 100 )) 
    + RIGHT(replicate('0',10-len(convert(varchar,CONVERT(INT,(OFERTAS         * 100))))) + convert(varchar,CONVERT(INT,(OFERTAS         * 100))) ,10)									--	OFERTAS
    + RIGHT(replicate('0',10-len(convert(varchar,CONVERT(INT,(DESCUENTOS      * 100))))) + convert(varchar,CONVERT(INT,(DESCUENTOS      * 100))) ,10)										--	DESCUENTOS
    + RIGHT(replicate('0',10-len(convert(varchar,CONVERT(INT,(IVA             * 100))))) + convert(varchar,CONVERT(INT,(IVA             * 100))) ,10)									--	IVA
    + RIGHT(replicate('0',10-len(convert(varchar,CONVERT(INT,(IMPORTE_NETO    * 100))))) + convert(varchar,CONVERT(INT,(IMPORTE_NETO    * 100))) ,10)									--	IMPORTE_NETO
    + RIGHT(replicate('0', 4) + convert(varchar,CONVERT(INT,(PORCENTAJE_OFERTAS  * 100))), 4)										--	PORCENTAJE_OFERTAS
    + RIGHT(replicate('0', 4) + convert(varchar,CONVERT(INT,(PORCENTAJE_DESCUENTOS* 100))), 4)										--	PORCENTAJE_DESCUENTOS
    + RIGHT(REPLICATE('0',13) + EAN11 + ' '           ,14)										--	EAN11
    + RIGHT(replicate('0',10) + convert(varchar,CONVERT(INT,(PRECIO_PUBLICO*100)))         ,10)										--	PRECIO_PUBLICO
    + LEFT(BSTKD + REPLICATE(' ',10),10)														--	BSTKD
    + CONVERT(varchar,FKDAT,112) as Detalle									--	FKDAT --CONVERT(datetime,fecha_factura,121)
	
	, RIGHT(VBELN,7) Factura
	, 'R' + RIGHT(VBELN,7) + '.TXT' AS Archivo
FROM @tmpEEPlantilla
ORDER BY XBLNR

  --SELECT 
  --  '0'+ cliente + @sep +												--substring(ALTKN,1,len(ALTKN))
  --  digito_verificador + @sep +											--'1'
  --  RIGHT(factura,7) + @sep +											--XBLNR
  --  codigo + @sep +														--MATNR
  --  RIGHT(replicate('0', 7) + piezas_surtidas_con_cargo  , 7) + @sep +	--CANTIDAD convert(varchar,CONVERT(INT,CANTIDAD  * 100 )) 
  --  RIGHT(replicate('0',10) + precio_farm_sin_imp        ,10) + @sep +	--PRECIOFARMACIA convert(varchar,CONVERT(INT,PRECIOFARMACIA  * 100 )) 
  --  RIGHT(replicate('0',10) + descto_oferta              ,10) + @sep +	--OFERTAS
  --  RIGHT(replicate('0',10) + descto_comercial           ,10) + @sep +	--DESCUENTOS
  --  RIGHT(replicate('0',10) + iva                        ,10) + @sep +	--IVA
  --  RIGHT(replicate('0',10) + importe_neto               ,10) + @sep +	--IMPORTE_NETO
  --  RIGHT(replicate('0', 4) + porcentaje_descto_oferta   , 4) + @sep +	--PORCENTAJE_OFERTAS
  --  RIGHT(replicate('0', 4) + porcentaje_descto_comercial, 4) + @sep +	--PORCENTAJE_DESCUENTOS
  --  RIGHT(REPLICATE('0',13) + cod_barras + ' '           ,14) + @sep +	--EAN11
  --  RIGHT(replicate('0',10) + precio_pub_sin_imp         ,10) + @sep +	--PRECIO_PUBLICO
  --  LEFT(orden + REPLICATE(' ',10),10) + @sep +							--BSTKD
  --  fecha_factura --	+ @sep + descripcion							--FKDAT --CONVERT(datetime,fecha_factura,121)

  --from #facturacion_minne 

  END

GO

