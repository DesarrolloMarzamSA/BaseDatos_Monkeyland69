
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE 
--	CREATE
PROCEDURE [dbo].[usp_lab_sanofi_respalda_pedidos_historia]
WITH ENCRYPTION
AS

/*
TRUNCATE TABLE	pedidos_lab_sanofi_header_historia				;
TRUNCATE TABLE  pedidos_lab_sanofi_address_historia				;
TRUNCATE TABLE  pedidos_lab_sanofi_order_line_historia		;
*/

IF(@@SERVERNAME='MXT-MACHINEGUN')
BEGIN
	DELETE FROM mike.dbo.facturacion_electronica_estandar 
		--WHERE CONVERT(VARCHAR(10),fecha_factura,121) = '2010-11-25'

	INSERT INTO mike.dbo.facturacion_electronica_estandar 
					(	sucursal, cliente, factura, orden, codigo, cod_barras, descripcion, fecha_factura, timestamp, precio_farm_sin_imp, piezas_surtidas_con_cargo)
	SELECT		sucursal, cliente, factura, RIGHT(b2b_order_number, 10) orden, codigo, cod_barras, descripcion, recepcion, delivery_date, sell_price, SUM(cantidad_surtida) piezas_surtidas_con_cargo
	FROM pedidos_lab_sanofi_order_line p
	WHERE p.factura IS NOT NULL
	GROUP BY	sucursal, cliente, factura, RIGHT(b2b_order_number, 10) , codigo, cod_barras, descripcion, recepcion, delivery_date, sell_price
	ORDER BY	sucursal, cliente, factura, RIGHT(b2b_order_number, 10) , codigo, cod_barras, descripcion, recepcion, delivery_date, sell_price

	INSERT INTO pedidos_lab_sanofi_header_historia			SELECT *	FROM	pedidos_lab_sanofi_header				;	
	INSERT INTO pedidos_lab_sanofi_address_historia			SELECT *	FROM	pedidos_lab_sanofi_address			;
	INSERT INTO pedidos_lab_sanofi_order_line_historia	SELECT *	FROM	pedidos_lab_sanofi_order_line		;

	UPDATE mike.dbo.facturacion_electronica_estandar SET 
		no_registro = p.orden, 
		folio_fiscal = RIGHT('00'+ CONVERT(VARCHAR, p.sucursal), 2) + RIGHT(p.factura,6)
	FROM mike.dbo.facturacion_electronica_estandar f
	INNER JOIN pedidos_lab_sanofi_order_line_historia p ON 
		p.cliente = F.cliente AND p.sucursal = f.sucursal AND p.factura = f.factura AND p.codigo = f.codigo
	;

	update facturacion_electronica_estandar set
		folio_fiscal = RIGHT(f.cliente,4) + RIGHT(f.factura,4)
	from facturacion_electronica_estandar f
	inner join pedidos_lab_sanofi_header p on 
		p.sucursal = f.sucursal and p.cliente = f.cliente and p.factura = f.factura and p.b2b_order_number = f.orden
	;
END
ELSE
BEGIN
	INSERT INTO pedidos_lab_sanofi_header_historia			SELECT *	FROM	pedidos_lab_sanofi_header				;	
	INSERT INTO pedidos_lab_sanofi_address_historia			SELECT *	FROM	pedidos_lab_sanofi_address			;
	INSERT INTO pedidos_lab_sanofi_order_line_historia	SELECT *	FROM	pedidos_lab_sanofi_order_line		;
END

UPDATE pedidos_lab_sanofi_header_historia SET
	folio_fiscal = f.folio_fiscal
FROM pedidos_lab_sanofi_header_historia p
INNER JOIN facturacion_electronica_estandar f ON f.sucursal = p.sucursal AND f.factura = p.factura
;



/*
SELECT * FROM pedidos_lab_sanofi_header			--INTO pedidos_lab_sanofi_header_bkp			
SELECT * FROM pedidos_lab_sanofi_address		--INTO pedidos_lab_sanofi_address_bkp			
SELECT * FROM pedidos_lab_sanofi_order_line	--INTO pedidos_lab_sanofi_order_line_bkp 

SELECT * FROM pedidos_lab_sanofi_header_historia			--INTO pedidos_lab_sanofi_header_bkp			
SELECT * FROM pedidos_lab_sanofi_address_historia			--INTO pedidos_lab_sanofi_address_bkp			
SELECT * FROM pedidos_lab_sanofi_order_line_historia	--INTO pedidos_lab_sanofi_order_line_bkp 
*/
/*
SELECT * FROM facturacion_electronica_estandar
*/
/*
DROP TABLE pedidos_lab_sanofi_header_bkp			
DROP TABLE pedidos_lab_sanofi_address_bkp		
DROP TABLE pedidos_lab_sanofi_order_line_bkp
*/

/*
TRUNCATE TABLE pedidos_lab_sanofi_header				
TRUNCATE TABLE  pedidos_lab_sanofi_address			
TRUNCATE TABLE  pedidos_lab_sanofi_order_line		
*/


/*
INSERT INTO pedidos_lab_sanofi_header				SELECT * 	FROM pedidos_lab_sanofi_header_bkp		
INSERT INTO pedidos_lab_sanofi_address			SELECT *	FROM pedidos_lab_sanofi_address_bkp		
INSERT INTO pedidos_lab_sanofi_order_line		SELECT *  FROM pedidos_lab_sanofi_order_line_bkp
*/
GO
