USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
--NOMBRE SP: 	usp_genera_catalogo_farmacias_ABC.      
--CLIENTE: 	FARMACIAS ABC 
--DESCRIPCION: 	OBTIENE INFORMACION DE maestro_productos_baan 
--  PARA CREAR EL CATALOGO MAESTRO DE ARTICULOS PARA F-ABC GDL
--REPONSABLE: 	MIGUEL SAMAYOA.
--FECHA creacion: 	18/FEB/ 2009 12:16 P.M.
--FECHA ultima modificacion:  30/dic/2009 IVA Sucursales 2010

CREATE PROCEDURE [dbo].[usp_genera_catalogo_farmacias_abc] 
WITH ENCRYPTION
AS

DECLARE @sucursal INT
DECLARE @porcentaje_iva MONEY
SET @sucursal = 3
SET @porcentaje_iva = (SELECT porcentaje_iva FROM sucursales WHERE sucursal = @sucursal)

SELECT 
  mpb.codigo +  
  LEFT (descripcion+space(31),31) +       
  LEFT(RIGHT('0000000' + CONVERT(VARCHAR,
    CASE mpb.grupo_est  WHEN 'PC01A' THEN mpb.prec_farm + (mpb.prec_farm * 0.5)  
                        ELSE mpb.prec_farm END ),10), 7) +  
  LEFT(RIGHT('0000000' + CONVERT(VARCHAR,
    CASE mpb.grupo_est  WHEN 'PC01A' THEN mpb.prec_pub  + (mpb.prec_farm * 0.5)  
                        ELSE mpb.prec_pub  END ),10), 7) +  
  CASE  WHEN mpb.clas_fis IN ('B ','N ','H ') THEN '00'
        WHEN mpb.clas_fis IN ('BA','NA','HA') THEN CONVERT(CHAR(2),CONVERT(INT,@porcentaje_iva * 100))    -- '15'
        ELSE '  ' END +                         
  CASE  WHEN mpb.clas_ssa    IN(1,2,3)     THEN 'CO'  
        WHEN mpb.clas_ssa    = 4           THEN 'ET'  
        WHEN mpb.clas_ssa    IN(5,6)       THEN 'OT'  
        WHEN mpb.clas_ssa    = 7           THEN 'MC'  
        WHEN mpb.clas_ssa    = 8           THEN 'PF'  
        WHEN mpb.clas_ssa    = 9           THEN 'MI'  
        ELSE 'MI'  END +    
  LEFT (lab_largo+space(25),25) +     
  RIGHT('0000' +      
    CASE WHEN mpb.cod_lab IS NULL  THEN '1111' ELSE mpb.cod_lab END, 4) +      
  CONVERT(varchar(10),mpb.fecha_alta,112) +   
  LEFT(mpb.clas_fis + space(2),2) +     
  ' ' +       
  CASE WHEN mpb.clas_ssa        IN(5,6) THEN 'L' ELSE ' ' END +   
  CASE WHEN mpb.refrigerado     = 'R'   THEN 'R' ELSE ' ' END +   
--  RIGHT(cod_barras,13) +        
--  cod_barras_tandem +        
left(ltrim(isnull(t3.cod_barras_abc, mpb.cod_barras_tandem)) + '             ', 13) +
--  LEFT(CONVERT(VARCHAR,CONVERT(BIGINT,cod_barras) ) + REPLICATE(' ',13)  ,13) +        
  CASE WHEN mpb.clas_ssa        IN (1,2,3) THEN 'C' 
       WHEN mpb.clas_ssa        IN (5,6)   THEN 'L' 
       WHEN mpb.clas_ssa        = 7        THEN 'H' 
       WHEN mpb.clas_ssa        = 8        THEN 'P' 
       WHEN mpb.clas_ssa        = 9        THEN 'V' 
       ELSE ' ' END + 
  CASE WHEN mpb.grupo_producto  IN('00','03','40')  THEN 'E' 
       WHEN mpb.grupo_producto  IN('01','41'     )  THEN 'P' 
       WHEN mpb.grupo_producto  IN('02','42'     )  THEN 'M' 
       ELSE ' '  END + 
  LEFT(mpb.grupo_est, 5)  + 
  '  '   + 
  '    '  
   col1
FROM	maestro_productos_baan mpb
INNER JOIN inventario_baan invent ON	mpb.codigo = invent.codigo 
left outer join gdl_abc_catalogo t3 on mpb.codigo = t3.codigo
WHERE 	mpb.cod_barras IS NOT NULL 
  AND	mpb.clas_ssa <> '' 
  AND	invent.sucursal = @sucursal
  AND convert(int,mpb.codigo) < dbo.gobierno()
GO
