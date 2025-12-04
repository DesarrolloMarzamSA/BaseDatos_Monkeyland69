CREATE PROCEDURE [dbo].[usp_fmorelost_pedidos_insert]
@fecha_pedido SMALLDATETIME, @orden_compra VARCHAR (9), @sucursal INT, @cliente VARCHAR (5), @cod_barras VARCHAR (13), @codigo VARCHAR (7), @cantidad_pedida INT, @piezas_con_cargo INT, @piezas_sin_cargo INT, @precio_farnacia_sin_iva MONEY, @importe_descto_oferta MONEY, @importe_descto_comercial MONEY, @linea INT, @arch_cliente VARCHAR (100), @hash_md5 VARCHAR (50)
WITH ENCRYPTION
AS
BEGIN
--El cuerpo del script estaba cifrado y no se puede reproducir aquí.
    RETURN
END



GO

