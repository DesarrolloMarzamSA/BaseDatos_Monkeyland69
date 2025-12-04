CREATE PROCEDURE [dbo].[usp_genera_cambios_precio_freal] @sucursal int, @cliente VARCHAR(5)
AS
BEGIN

--exec usp_genera_cambios_precio_freal 17, '11560'
--SELECT * FROM cambios_precio_baan WHERE t_item = '0525233'
--SELECT top 100 * FROM encabezado WHERE sucursal = 7 AND farmacia like '%real%'

DECLARE @descuento MONEY
SELECT @descuento = CONVERT(MONEY, descuento) 
  FROM clientes_baan WHERE sucursal = @sucursal AND cliente = @cliente

DECLARE @codigo VARCHAR(7)
DECLARE @precio_farmacia_nuevo MONEY
DECLARE @precio_publico_nuevo MONEY
DECLARE @precio_farmacia_anterior MONEY
DECLARE @precio_publico_anterior MONEY
DECLARE @fecha_hora_nuevo datetime
DECLARE @fecha_hora_anterior datetime

CREATE TABLE #cambios_real(tipo VARCHAR(1), 
  cod_barras VARCHAR(16), 
  codigo VARCHAR(14), 
  nombre VARCHAR(50), 
  precio_farmacia_nuevo MONEY, 
  precio_farmacia_anterior MONEY, 
  precio_publico_nuevo MONEY, 
  precio_publico_anterior MONEY, 
  laboratorio VARCHAR(35),
  iva MONEY, 
  descuento MONEY, 
  fecha datetime)

DECLARE cur_cambios CURSOR fast_forward FOR 
  SELECT t_item, t_prfn, t_prpn, max(fecha_hora) fecha_hora 
    FROM cambios_precio_baan 
   WHERE fecha_hora > dateadd(dd, -5, current_timestamp) 
     AND CONVERT(int, t_item) < dbo.gobierno() 
  GROUP BY t_item, t_prfn, t_prpn

OPEN cur_cambios
FETCH NEXT FROM cur_cambios INTO 
  @codigo, @precio_farmacia_nuevo, @precio_publico_nuevo, @fecha_hora_nuevo

WHILE @@fetch_status = 0
BEGIN
	SELECT @precio_farmacia_anterior = t_prfn, @precio_publico_anterior = t_prpn, @fecha_hora_anterior = max(fecha_hora) 
    FROM cambios_precio_baan 
   WHERE t_item = @codigo 
     AND fecha_hora < @fecha_hora_nuevo 
  GROUP BY t_prfn, t_prpn
	INSERT INTO #cambios_real(tipo, codigo, precio_farmacia_anterior, precio_farmacia_nuevo, precio_publico_anterior, precio_publico_nuevo, fecha) 
	VALUES('A', '00' + @codigo, @precio_farmacia_anterior, @precio_farmacia_nuevo, @precio_publico_anterior, @precio_publico_nuevo, @fecha_hora_nuevo)
	FETCH NEXT FROM cur_cambios INTO @codigo, @precio_farmacia_nuevo, @precio_publico_nuevo, @fecha_hora_nuevo
END

CLOSE cur_cambios
DEALLOCATE cur_cambios

UPDATE #cambios_real SET 
  laboratorio = REPLACE(t2.lab_largo,',',' '),
  cod_barras = t2.cod_barras, nombre = t2.descripcion, iva = t2.iva, descuento =  
    case 
    WHEN t2.clas_fis in ('B','BA')  THEN @descuento
    WHEN t2.clas_fis IN ('N','NA')  THEN 0
    WHEN t2.clas_fis IN ('H','HA')  THEN t2.descto_prod END
FROM #cambios_real t1 
INNER JOIN maestro_productos_baan t2 ON t1.codigo = '00' + t2.codigo

UPDATE #cambios_real SET 
  precio_publico_anterior = 0 WHERE precio_publico_anterior IS NULL

UPDATE #cambios_real SET 
  precio_farmacia_anterior = 0 WHERE precio_farmacia_anterior IS NULL

--  SELECT * FROM #cambios_real -- where precio_publico_anterior IS NULL


SELECT 
  LEFT(t1.nombre + REPLICATE(' ',30), 30) descripcion,
  RIGHT(REPLICATE('0',13) + t1.cod_barras, 13) cod_barras,
  REPLICATE(' ', 2) filler1,
  RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR, CONVERT(MONEY, 
    CASE t2.grupo_est WHEN 'PC01A' THEN t1.precio_farmacia_nuevo + (t1.precio_farmacia_nuevo * 0.5) 
    ELSE t1.precio_farmacia_nuevo END)), 9) precio_farmacia_nuevo,
  REPLICATE(' ', 2) filler2,
  RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR, CONVERT(MONEY, 
    CASE t2.grupo_est WHEN 'PC01A' THEN t1.precio_publico_nuevo + (t1.precio_publico_nuevo * 0.5) 
    ELSE t1.precio_publico_nuevo END)), 9) precio_publico_nuevo 
    
FROM #cambios_real t1 
INNER JOIN maestro_productos_baan t2 ON t1.codigo = '00' + t2.codigo

END

GO

