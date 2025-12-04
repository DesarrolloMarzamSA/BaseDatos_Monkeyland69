USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


CREATE 
--CREATE 
PROCEDURE [dbo].[usp_lab_sanofi_prepara_respuestas]
WITH ENCRYPTION
AS

/*
DECLARE @procesados INT
DECLARE @rechazados INT

SET @procesados 
SET @rechazados 
*/

--				S U R T I D O
--			3 = Producto Ofertado en Precio
--			4	=	Producto Ofertado en Piezas
--			8	=	Producto Surtido

--				NO SURTIDOS
--			1	=	DESCONOCIDO
--			2	=	Venta de Psicotropico NO Autorizada
--			5	=	DESCONOCIDO
--			6	=	DESCONOCIDO
--			7	=	Producto Agotado	
--			9	=	Producto Descontinuado
--			0	=	Producto negado por margen


--	PRUEBA DE CLIENTES BLOQUEADOS POR CREDITO
/*
IF @@SERVERNAME = 'MXT-MACHINEGUN'
BEGIN
	UPDATE pedidos_lab_sanofi_order_line_historia SET	
		cantidad_surtida = 0, resultado = 0
	WHERE cliente = '00100'
END
*/


UPDATE pedidos_lab_sanofi_header_historia SET 
	factura = p.factura, 
	--delivery_date = GETDATE(), 
	order_status = CASE 	
		WHEN (SELECT COUNT(*) FROM pedidos_lab_sanofi_order_line_historia 
			WHERE b2b_order_number = h.b2b_order_number AND cantidad_surtida>0 ) > 0 THEN 'In Process' 	
		WHEN (SELECT COUNT(*) FROM pedidos_lab_sanofi_order_line_historia 
			WHERE b2b_order_number = h.b2b_order_number AND cantidad_surtida=0 ) > 0 THEN 'Rejected' 	
		ELSE ''  END,
	payment_type = CASE 	
		WHEN UPPER(h.payment_type) = 'CUENTA'		THEN 'Account' 	
		WHEN UPPER(h.payment_type) = 'EFECTIVO'	THEN 'Cash'		 	
		ELSE h.payment_type	END ,
	procesado = CASE 
		WHEN resultado IS NOT NULL THEN 1
		WHEN resultado IN ( 1, 2, 5, 6, 7, 9, 0) THEN 0
		ELSE procesado END
FROM pedidos_lab_sanofi_header_historia h 
INNER JOIN pedidos_lab_sanofi_order_line_historia p ON 
	p.b2b_order_number = h.b2b_order_number  ;

UPDATE pedidos_lab_sanofi_address_historia SET 
	country = 'Mexico'
WHERE UPPER(country) = 'MX'	;

--	LE PONE 1 SI SE SURTE, 0 SI SE CANCELA A LA TABLA ADDRESS
UPDATE pedidos_lab_sanofi_address_historia SET 
	procesado = CASE 
		WHEN p.resultado IS NOT NULL THEN 1
		WHEN p.resultado IN ( 1, 2, 5, 6, 7, 9, 0) THEN 0
		ELSE procesado END
FROM pedidos_lab_sanofi_address_historia a 
INNER JOIN pedidos_lab_sanofi_order_line_historia p ON 
	p.b2b_order_number = a.b2b_order_number  ;

--	ESTABLE CEROS CUANDO SE NIEGA EL PRODUCTO
--UPDATE pedidos_lab_sanofi_order_line SET
--	list_price = 0,
--	sell_price = 0,	--	NULL
--	l_total_amount = 0	--	NULL
--WHERE cantidad_surtida = 0 AND resultado IN ( 1, 2, 5, 6, 7, 9, 0)	;

--	ASIGNA LA SERIE CFD AL HEADER
UPDATE pedidos_lab_sanofi_header_historia SET 
	serie_cfd = s.serie_cfd
FROM pedidos_lab_sanofi_header_historia h 
INNER JOIN sucursales s ON s.sucursal = h.sucursal  ;

/*
--	ASIGNA EL FOLIO CFD AL HEADER
UPDATE pedidos_lab_sanofi_header SET 
	--	folio_fiscal = f.folio_fiscal
	folio_fiscal = f.folio_fiscal
FROM pedidos_lab_sanofi_header h 
INNER JOIN encabezado f ON f.sucursal = h.sucursal AND f.factura = h.factura  ;
*/

UPDATE pedidos_lab_sanofi_order_line_historia SET
	list_price = mpb.prec_farm,
	sell_price = mpb.prec_farm,	
	l_total_amount = cantidad_surtida * mpb.prec_farm	
FROM pedidos_lab_sanofi_order_line_historia psa
INNER JOIN maestro_productos_baan mpb ON psa.codigo = mpb.codigo
GO
