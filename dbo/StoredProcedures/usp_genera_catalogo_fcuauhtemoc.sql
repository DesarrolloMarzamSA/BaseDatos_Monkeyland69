USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_genera_catalogo_fcuauhtemoc] 
--	@sucursal INT
--NOMBRE SP: 	usp_genera_catalogo_fcuauhtemoc.      
--CLIENTE: 	FARMACIAS fcuauhtemoc 
--DESCRIPCION: 	OBTIENE INFORMACION DE maestro_productos_baan 
--        PARA CREAR EL CATALOGO MAESTRO DE ARTICULOS PARA Fcuauhtemoc.
--HECHO POR: 			MIGUEL SAMAYOA.
--Creacion: 			07/09/2009
--Modificacion:		25/03/2010
WITH ENCRYPTION
AS

declare @factor int
declare @sep varchar(1)
set @sep = ''
set @factor = 100

SELECT 
	mpb.codigo,																											--	 1
  mpb.cod_barras,																									--	 2
  mpb.descripcion,																								--	 3
  LEFT(mpb.lab_corto,4) lab_corto,																--	 4
  CASE mpb.grupo_est																				
    WHEN 'PC01A' THEN mpb.prec_pub  + (mpb.prec_farm * 0.5)	
    ELSE mpb.prec_pub * 1 END AS prec_pub  ,											--	 5
  CASE mpb.grupo_est																				
    WHEN 'PC01A' THEN mpb.prec_farm + (mpb.prec_farm * 0.5)	
    ELSE mpb.prec_farm * 1 END AS prec_farm,											--	 6
  CASE 
    WHEN mpb.clas_ssa IN ('1','2','3')  THEN 'C'   
    WHEN mpb.clas_ssa IN ('4'        )  THEN 'E'   
    WHEN mpb.clas_ssa IN ('5','6'    )  THEN 'O'   
    WHEN mpb.clas_ssa IN ('7'        )  THEN 'U'   
    WHEN mpb.clas_ssa IN ('8'        )  THEN 'P'   
    WHEN mpb.clas_ssa IN ('9',' '    )  THEN 'V'   
    WHEN mpb.grupo_est = 'PCO1A'        THEN 'H'  
    ELSE                                     'V' END AS tip_prod,	--	 7
  CASE	
    WHEN mpb.clas_fis IN ('B' ,'N' ,'H' )  THEN '02'
    WHEN mpb.clas_fis IN ('BA','NA'     )  THEN '03'
    ELSE                                     '00' END AS tip_iva,	--	 8
  mpb.clas_fis,	--	 9
  CASE 
    WHEN mpb.clas_fis IN ('B' ,'BA'     )  THEN 001.01
    WHEN mpb.clas_fis IN ('N' ,'NA'     )  THEN 000.00
    WHEN mpb.clas_fis IN ('H' ,'HA'     )  THEN convert(decimal(6,2),descto_prod)
    ELSE                                        000.00 END AS descto		--	10
INTO #catalogo_minne  
FROM maestro_productos_baan mpb
--INNER JOIN inventario_baan invent ON	mpb.codigo = invent.codigo	-----------------------
--  AND invent.sucursal = 24  AND invent.piezas > 0	---------------------- A PETICION DEL CLIENTE QUIERE TODO !!!!
WHERE convert(bigint,mpb.codigo) < dbo.gobierno() 
AND isnumeric(mpb.codigo) = 1
AND mpb.cod_barras IS NOT NULL
and LEFT(mpb.status,1) <> 'B'


CREATE TABLE #tempo_mae_minne (col1 varchar(500) )
INSERT INTO #tempo_mae_minne (col1)
  SELECT 
    codigo + @sep +																						--	1
    LEFT(cod_barras  + REPLICATE(' ',15) ,15) + @sep +				--	2
    LEFT(descripcion + REPLICATE(' ',55) ,55) + @sep +				--	3
    LEFT(lab_corto   + REPLICATE(' ', 4) , 4) + @sep +				--	4
    RIGHT(REPLICATE('0',10) + CONVERT(varchar,cast(prec_farm as decimal(7,2)) ) ,10) + @sep +	--	5
    RIGHT(REPLICATE('0',10) + CONVERT(varchar,cast(prec_farm as decimal(7,2)) ) ,10) + @sep +	--	6
--    RIGHT(REPLICATE('0',10) + CONVERT(varchar,cast(prec_pub  as decimal(7,2)) ) ,10) + @sep +	--	6	--	A PETICION DEL CLIENTE POR QUE SE ESPANTO POR LO ALTO DEL PRECIO
    tip_prod + @sep +																					--	7
    tip_iva + @sep +																					--	8
    LEFT(clas_fis+REPLICATE(' ',2),2) + @sep +								--	9
    RIGHT(REPLICATE('0',8) + convert(varchar,descto),8)				--	10
  FROM #catalogo_minne

SELECT * FROM #tempo_mae_minne

DROP TABLE #catalogo_minne
DROP TABLE #tempo_mae_minne
GO
