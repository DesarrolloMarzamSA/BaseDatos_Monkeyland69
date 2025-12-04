USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
  
--NOMBRE SP:  usp_fsfa_catalogo 3        
--CLIENTE:  FARMACIAS SAN FCO DE ASIS   
--DESCRIPCION:  OBTIENE INFORMACION DE maestro_productos_baan   
--  PARA CREAR EL CATALOGO MAESTRO DE ARTICULOS PARA FSFA.  
  
--2009-07-27 CREACION             MIGUEL SAMAYOA  
--2009-10-12 REVISION DE LAYOUTS        MIGUEL SAMAYOA  
--2009-12-30  IVA Sucursales 2010        MIGUEL SAMAYOA  
--2010-03-26 FUNCION GOBIERNO         MIGUEL SAMAYOA  

/*
EXECUTE usp_fsfa_catalogo 3
*/

  
CREATE	--	CREATE  
PROCEDURE [dbo].[usp_fsfa_catalogo] (@sucursal int)  
WITH ENCRYPTION
AS  
  
DECLARE @sep varchar(1)  
set @SEP = ''  
--  DECLARE @sucursal INT  
DECLARE @porcentaje_iva MONEY  
--  SET @sucursal = 3  
SET @porcentaje_iva = (SELECT porcentaje_iva FROM sucursales WHERE sucursal = @sucursal)  
  
  
SELECT   
  mpb.codigo																																																			codigo				,                               
  LEFT (descripcion+REPLICATE(' ', 31),31)																																				descripcion		,
  LEFT(RIGHT(REPLICATE('0', 7) + CONVERT(VARCHAR,     
    CASE mpb.grupo_est  WHEN 'PC01A' THEN (mpb.prec_farm * 1.5)  ELSE mpb.prec_farm END ),10), 7)									prec_farm			,
  LEFT(RIGHT(REPLICATE('0', 7) + CONVERT(VARCHAR,     
    CASE mpb.grupo_est  WHEN 'PC01A' THEN (mpb.prec_pub * 1.5)   ELSE mpb.prec_pub  END ),10), 7)									prec_pub			,
  CASE  WHEN mpb.clas_fis IN ('B' ,'N' ,'H' ) THEN '00'     
        WHEN mpb.clas_fis IN ('BA','NA','HA') THEN CONVERT(CHAR(2),CONVERT(INT,@porcentaje_iva * 100)) ELSE '  ' END porc_iva		,
  CASE  WHEN mpb.clas_ssa    IN(1,2,3)     THEN 'CO'      
        WHEN mpb.clas_ssa    = 4           THEN 'ET'    
        WHEN mpb.clas_ssa    IN(5,6)       THEN 'OT'    
        WHEN mpb.clas_ssa    = 7           THEN 'MC'    
        WHEN mpb.clas_ssa    = 8           THEN 'PF'    
        WHEN mpb.clas_ssa    = 9           THEN 'MI'    
        ELSE 'MI'  END																																														tipo					,
  LEFT (lab_largo+REPLICATE(' ', 25),25)  																																				lab_largo			,
  RIGHT(REPLICATE('0', 4) +                                            
    CASE WHEN mpb.cod_lab IS NULL  THEN '0000' ELSE mpb.cod_lab END, 4)																						cod_lab				,
  CONVERT(VARCHAR(10),mpb.fecha_alta,112)																																					fecha_alta		,
  LEFT(mpb.clas_fis + space(2),2)																																									clas_fis			,
  ' '																																																							filler1				,
  CASE WHEN mpb.clas_ssa        IN(5,6) THEN 'L' 			ELSE ' ' END  lim,    
  CASE WHEN mpb.refrigerado     = 'R'   THEN 'R' 			ELSE ' ' END  ref,    
  CASE WHEN mpb.clas_ssa        IN (1,2,3) THEN 'P'		ELSE ' ' END	p,
  RIGHT(cod_barras,13) cod_barras	,
  CASE WHEN mpb.clas_ssa        IN (1,2,3) THEN 'C'     
       WHEN mpb.clas_ssa        IN (5,6)   THEN 'L'   
       WHEN mpb.clas_ssa        = 7        THEN 'H'   
       WHEN mpb.clas_ssa        = 8        THEN 'P'   
       WHEN mpb.clas_ssa        = 9        THEN 'V'   
       WHEN mpb.grupo_producto  IN('00','03','40')  THEN 'E'    
       WHEN mpb.grupo_producto  IN('01','41'     )  THEN 'P'   
       WHEN mpb.grupo_producto  IN('02','42'     )  THEN 'M'   
       ELSE ' '  END																																															clase	,
  LEFT(mpb.grupo_est, 5)  grupo_est
  --' '   col1  
FROM maestro_productos_baan mpb  
INNER JOIN inventario_baan invent ON mpb.codigo = invent.codigo   
WHERE  mpb.cod_barras IS NOT NULL   
  AND mpb.clas_ssa <> ''   
  AND invent.sucursal = @sucursal  
  AND convert(int,mpb.codigo) < dbo.gobierno()  
GO
