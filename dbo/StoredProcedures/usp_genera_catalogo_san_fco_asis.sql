
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

--NOMBRE SP: 	usp_genera_catalogo_san_fco_asis 3      
--CLIENTE: 	FARMACIAS SAN FCO DE ASIS 
--DESCRIPCION: 	OBTIENE INFORMACION DE maestro_productos_baan 
--  PARA CREAR EL CATALOGO MAESTRO DE ARTICULOS PARA FSFA.

--2009-07-27	CREACION													MIGUEL SAMAYOA
--2009-10-12	REVISION DE LAYOUTS								MIGUEL SAMAYOA
--2009-12-30  IVA Sucursales 2010								MIGUEL SAMAYOA
--2010-03-26	FUNCION GOBIERNO									MIGUEL SAMAYOA

CREATE  PROCEDURE [dbo].[usp_genera_catalogo_san_fco_asis] (@sucursal int)

AS

DECLARE @sep varchar(1)
set @SEP = ''
--  DECLARE @sucursal INT
DECLARE @porcentaje_iva MONEY
--  SET @sucursal = 3
SET @porcentaje_iva = (SELECT porcentaje_iva FROM sucursales WHERE sucursal = @sucursal)


SELECT 
  mpb.codigo + @sep +                             
  LEFT (descripcion+space(31),31) + @sep +         
  LEFT(RIGHT(REPLICATE('0', 7) + CONVERT(VARCHAR,   
    CASE mpb.grupo_est  WHEN 'PC01A' THEN mpb.prec_farm + (mpb.prec_farm * 0.5)  
                        ELSE mpb.prec_farm END ),10), 7) +  @sep +
  LEFT(RIGHT(REPLICATE('0', 7) + CONVERT(VARCHAR,   
    CASE mpb.grupo_est  WHEN 'PC01A' THEN mpb.prec_pub  + (mpb.prec_farm * 0.5)  
                        ELSE mpb.prec_pub  END ),10), 7) +  @sep +
  CASE  WHEN mpb.clas_fis IN ('B' ,'N' ,'H' ) THEN '00'   
        WHEN mpb.clas_fis IN ('BA','NA','HA') THEN CONVERT(CHAR(2),CONVERT(INT,@porcentaje_iva * 100)) --  '15'
        ELSE '  ' END +  @sep +
  CASE  WHEN mpb.clas_ssa    IN(1,2,3)     THEN 'CO'    
        WHEN mpb.clas_ssa    = 4           THEN 'ET'  
        WHEN mpb.clas_ssa    IN(5,6)       THEN 'OT'  
        WHEN mpb.clas_ssa    = 7           THEN 'MC'  
        WHEN mpb.clas_ssa    = 8           THEN 'PF'  
        WHEN mpb.clas_ssa    = 9           THEN 'MI'  
        ELSE 'MI'  END +  @sep +
  LEFT (lab_largo+space(25),25) + @sep +                         
  RIGHT(REPLICATE('0', 4) +                                          
    CASE WHEN mpb.cod_lab IS NULL  THEN '0000' ELSE mpb.cod_lab END, 4) +  @sep +
  CONVERT(varchar(10),mpb.fecha_alta,112) +  @sep +            
  LEFT(mpb.clas_fis + space(2),2) +  @sep + 
  ' ' +   @sep +  
  CASE WHEN mpb.clas_ssa        IN(5,6) THEN 'L' ELSE ' ' END + @sep +  
  CASE WHEN mpb.refrigerado     = 'R'   THEN 'R' ELSE ' ' END + @sep +  
  CASE WHEN mpb.clas_ssa        IN (1,2,3) THEN 'P'   
       ELSE ' ' END +  @sep +
  RIGHT(cod_barras,13) +  @sep +
  CASE WHEN mpb.clas_ssa        IN (1,2,3) THEN 'C'   
       WHEN mpb.clas_ssa        IN (5,6)   THEN 'L' 
       WHEN mpb.clas_ssa        = 7        THEN 'H' 
       WHEN mpb.clas_ssa        = 8        THEN 'P' 
       WHEN mpb.clas_ssa        = 9        THEN 'V' 
       WHEN mpb.grupo_producto  IN('00','03','40')  THEN 'E'  
       WHEN mpb.grupo_producto  IN('01','41'     )  THEN 'P' 
       WHEN mpb.grupo_producto  IN('02','42'     )  THEN 'M' 
       ELSE ' '  END +  @sep +
  LEFT(mpb.grupo_est, 5)  +  @sep +
  ' '   col1
FROM	maestro_productos_baan mpb
INNER JOIN inventario_baan invent ON	mpb.codigo = invent.codigo 
WHERE 	mpb.cod_barras IS NOT NULL 
  AND	mpb.clas_ssa <> '' 
  AND	invent.sucursal = @sucursal
  AND convert(int,mpb.codigo) < dbo.gobierno()
GO
