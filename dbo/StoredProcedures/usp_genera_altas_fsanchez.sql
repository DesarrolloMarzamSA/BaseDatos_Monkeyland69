USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[usp_genera_altas_fsanchez] ( @dias int)
WITH ENCRYPTION
as

--	usp_genera_altas_fsanchez 10
--	MODIFICADO:	2010-03-25	FUNCION GOBIERNO
begin

SELECT   
	prod.codigo,
	LEFT(descripcion+SPACE(31),31) descripcion,
  LEFT(RIGHT('0000000' + CONVERT(VARCHAR(15),CASE prod.grupo_est  WHEN 'PC01A' THEN prod.prec_farm + (prod.prec_farm * 0.5)  ELSE prod.prec_farm END ),10), 7) prec_farm,
  LEFT(RIGHT('0000000' + CONVERT(VARCHAR(15),CASE prod.grupo_est  WHEN 'PC01A' THEN prod.prec_pub  + (prod.prec_farm * 0.5)  ELSE prod.prec_pub  END ),10), 7) prec_pub,
	case when clas_fis in('BA','NA') then '10' else '00' end iva,
	left(lab_largo+space(30),30) proveedor,
  cod_lab,
  (CASE   WHEN prod.clas_ssa    IN(1,2,3)     THEN 'CO'
          WHEN prod.clas_ssa    = 4           THEN 'ET'
          WHEN prod.clas_ssa    IN(5,6)       THEN 'OT'
          WHEN prod.clas_ssa    = 7           THEN 'MC' 
          WHEN prod.clas_ssa    = 8           THEN 'PF'
          WHEN prod.clas_ssa    = 9           THEN 'MI'  ELSE 'MI'  END) tipo_prod,
--  ' ' Terap,     -- clasif terapeutica
  (CASE   WHEN prod.clas_ssa    IN(5,6)      THEN 'L'    ELSE ' '  END)  OTC,    --  clasif OTC
  left(refrigerado+'  ',1) refri,
  case when clas_ssa in (1,2,3) then 'P' else ' ' end psicotropicos, -- psicotropicos
  substring(left(cod_barras+space(10),13),3,13) ean,
  clas_abc importantes,
  Left(clas_fis+'  ',2) clas_fis,
  left(cod_barras+space(10),3) AMECOPAIS  ,
  /*' ' letrapich,
  '   ' as numeropich,
  '    ' as clrf_a,convert(char(10),fecha_alta,12)*/ fecha_alta ,cod_barras
into #altas_fsanchez
FROM maestro_productos_baan prod
--  FULL OUTER JOIN dbcataut autos         ON	prod.codigo = autos.codigo AND autos.SEGMENTO = 'C2' AND. autos.CADENA = '232'
--  INNER JOIN inventario_baan invent ON	prod.codigo = invent.codigo 
WHERE 
	convert(int, prod.codigo) < dbo.gobierno() and
  substring(prod.status, 1, 1) <> 'B' and

datediff(d,fecha_alta,CONVERT(datetime,current_timestamp,12)) <= @dias --and status = '   '  
order by fecha_alta desc

select codigo + descripcion + prec_farm + prec_pub + iva + proveedor + cod_lab + tipo_prod + --Terap + 
  OTC + refri + psicotropicos + ean + importantes + clas_fis + AMECOPAIS cadena_layout, /*+ 
  letrapich +
  numeropich + clrf_a,*/
fecha_alta,cod_barras
from #altas_fsanchez 

drop table #altas_fsanchez  
end
GO
