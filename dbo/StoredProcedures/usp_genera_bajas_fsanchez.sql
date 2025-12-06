
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_genera_bajas_fsanchez] ( @dias int)

--	usp_genera_bajas_fsanchez 5

WITH ENCRYPTION
as
begin 
  SELECT   
    prod.codigo, descripcion, fecha_baja, status
    FROM maestro_productos_baan prod
  --  FULL OUTER JOIN dbcataut autos    ON	prod.codigo = autos.codigo AND autos.SEGMENTO = 'C2' AND. autos.CADENA = '232'
  --  INNER JOIN inventario_baan invent ON	prod.codigo = invent.codigo 
  WHERE 
  	convert(int, prod.codigo) < dbo.gobierno() and
    substring(prod.status, 1, 1) = 'B' and
  
  datediff(d,fecha_baja,CONVERT(datetime,current_timestamp,12)) <= @dias --and status = '   '  
  order by fecha_alta desc
end
GO
