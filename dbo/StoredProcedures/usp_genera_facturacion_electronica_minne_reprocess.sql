------------------------------------------------------------
--  usp_genera_facturacion_electronica_minne  '2012-04-30'
--  FACTURACION ELECTRONICA MINNE POR MOSTRADOR
--  SUCURSAL 24 JUAREZ
--  fecha:  23 / mar / 2009
--  hecha por miguel samayoa


--  NUMERO DE CLIENTE		7
--  NUMERO DE FACTURA		7
--  CODIGO DE MEDIPAC		6
--  CANTIDAD SURTIDA		7
--  PRECIO FARMACIA			10.2
--  TOTAL DE OFTAS			10.2
--  TOTAL DE DESC				10.2
--  TOTAL DEL IVA				10.2
--  TOTAL IMPORTE				10.2
--  DESC X PORC					4.2
--  DESC X P.P.					4.2
--  CODIGO DE BARRA			14
--  PRECIO PUBLICO			10.2
--  NUMERO DE ORDEN			10
--  FECHA DE FACTURA		8

--  05122440173930000000000000100000269500000004490000000404300000000000000018417166618007501299301234 0000035000000000000020090324
--[usp_genera_facturacion_electronica_minne]  '2015-01-02'

CREATE PROCEDURE [dbo].[usp_genera_facturacion_electronica_minne_reprocess] ( @fecha varchar(10) )
AS
begin
--  DECLARE @fecha varchar(10)
--  SET @fecha = '2009-03-24'
DECLARE @sep varchar(1)
set @sep = '|'
set @sep = ''
DECLARE @FACTOR INT
SET @FACTOR = 100
--declare @fechaAux varchar(10)
--set @fechaAux =  convert(varchar,getdate()-1,111)
--CREATE TABLE 


SELECT 
	f.cliente,
	f.digito_verificador,
  f.factura,
  REPLICATE('0',6)  codigo, --  f.codigo,
  convert(varchar,            f.piezas_surtidas_con_cargo              ) piezas_surtidas_con_cargo,
  convert(varchar,CONVERT(INT,f.precio_farm_sin_imp         * @FACTOR )) precio_farm_sin_imp,
  convert(varchar,CONVERT(INT,f.descto_oferta               * @FACTOR )) descto_oferta,
  convert(varchar,CONVERT(INT,f.descto_comercial            * @FACTOR )) descto_comercial,
  convert(varchar,CONVERT(INT,f.iva                         * @FACTOR )) iva,
  convert(varchar,CONVERT(INT,f.importe_neto						    * @FACTOR )) importe_neto,
  convert(varchar,CONVERT(INT,f.porcentaje_descto_oferta    * @FACTOR )) porcentaje_descto_oferta,
  convert(varchar,CONVERT(INT,f.porcentaje_descto_comercial * @FACTOR )) porcentaje_descto_comercial,
  f.cod_barras,
  convert(varchar,CONVERT(INT,f.precio_pub_sin_imp          * @FACTOR )) precio_pub_sin_imp,
	f.orden,
	convert(varchar(10),f.fecha_factura,112) fecha_factura,   --  20090319
  f.descripcion   
INTO #facturacion_minne 
FROM facturacion_electronica_estandar f
WHERE ctepadre = '717' AND segto in('C2' ,'A2')
	--AND fecha_factura >=CONVERT(datetime,@fecha,121)
	AND f.folio_fiscal in('00096625','00105599')

ORDER BY f.sucursal,f.factura,f.no_registro

ALTER TABLE #facturacion_minne ADD renglon int

--UPDATE #facturacion_minne SET renglon = 

declare @@renglon int
set @@renglon = 1
DECLARE MY_CURSOR CURSOR FOR
  SELECT 
    '0'+cliente + @sep +
    digito_verificador + @sep +
    RIGHT(factura,7) + @sep +
    codigo + @sep +
    RIGHT(replicate('0', 7) + piezas_surtidas_con_cargo  , 7) + @sep +
    RIGHT(replicate('0',10) + precio_farm_sin_imp        ,10) + @sep +
    RIGHT(replicate('0',10) + descto_oferta              ,10) + @sep +
    RIGHT(replicate('0',10) + descto_comercial           ,10) + @sep +
    RIGHT(replicate('0',10) + iva                        ,10) + @sep +
    RIGHT(replicate('0',10) + importe_neto               ,10) + @sep +
    RIGHT(replicate('0', 4) + porcentaje_descto_oferta   , 4) + @sep +
    RIGHT(replicate('0', 4) + porcentaje_descto_comercial, 4) + @sep +
    RIGHT(REPLICATE('0',13) + cod_barras + ' '           ,14) + @sep +
    RIGHT(replicate('0',10) + precio_pub_sin_imp         ,10) + @sep +
    LEFT(orden + REPLICATE(' ',10),10) + @sep +
    fecha_factura --	+ @sep + descripcion
--    RIGHT(replicate('0',13) + importe_neto              , 7) + @sep +
--    RIGHT(replicate('0', 5) + porcentaje_utilidad        , 7) + @sep +
--    LEFT(clas_fis + REPLICATE(' ', 2), 2) + @sep +
--    RIGHT(replicate('0',13) + iva2                       , 7) + @sep +
--    RIGHT(replicate('0',13) + ieps                       , 7) + @sep +
--    RIGHT(replicate('0',10) + precio_pub_con_imp         , 7) + @sep +
--    RIGHT(replicate('0', 7) + piezas_surtidas_sin_cargo  , 7) + @sep +
--    LEFT(descripcion + REPLICATE(' ',31),31) + @sep +
--    producto_blancos + @sep +
--    RIGHT(replicate('0',16) + no_pedido                  , 7) + @sep +
--    RIGHT(replicate('0', 2)+sucursal,2) + @sep +
--    serie + @sep +
  from #facturacion_minne 


declare @@cadena VARCHAR(1000)
declare @@no_factura1 varchar(8)
declare @@no_factura2 varchar(8)
CREATE TABLE #resultado (cadena varchar(1000),renglon INT)
OPEN my_cursor 
FETCH NEXT FROM my_cursor INTO @@cadena
WHILE @@fetch_status = 0
  BEGIN
    set @@no_factura2 = '0'+SUBSTRING(@@cadena,8,7)
    INSERT INTO #resultado SELECT @@cadena,@@renglon
    SET @@renglon = @@renglon +1 
    FETCH NEXT FROM my_cursor INTO @@cadena
    set @@no_factura1 = '0'+SUBSTRING(@@cadena,8,7)
    IF @@no_factura1 <> @@no_factura2
      set @@renglon = 1
  END
CLOSE my_cursor
DEALLOCATE my_cursor
SELECT cadena AS cadena,
  '0'+SUBSTRING(cadena,8,7) FACTURA,
--  SUBSTRING(cadena,2,5) cliente,
  renglon as 'No' from #resultado

DROP TABLE #resultado
DROP TABLE #facturacion_minne 

end

GO

