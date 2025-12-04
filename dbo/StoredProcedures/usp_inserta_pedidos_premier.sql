CREATE PROCEDURE [dbo].[usp_inserta_pedidos_premier]
@sucursal TINYINT, @cliente VARCHAR (5), @cod_barras VARCHAR (13), @cant_ped INT, @arch_cliente VARCHAR (50), @orden CHAR (10), @hash_md5 VARCHAR (50), @enviado_ftp CHAR (10), @piezas_sin_cargo TINYINT, @precio_farmacia_sin_iva MONEY, @importe_descuento_oferta_unitario MONEY, @importe_descuento_financiero_unitario MONEY
WITH ENCRYPTION
AS
BEGIN
--El cuerpo del script estaba cifrado y no se puede reproducir aquí.
    RETURN
END



GO

