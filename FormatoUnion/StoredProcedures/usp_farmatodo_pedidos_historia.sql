

CREATE
PROCEDURE [FormatoUnion].[usp_farmatodo_pedidos_historia]	
	@fecha VARCHAR(10)
AS



DELETE FROM [FormatoUnion].[pedidos_farmatodo_historia]
WHERE fecha < = DATEADD(dd, -30, GETDATE() )

INSERT INTO [FormatoUnion].[pedidos_farmatodo_historia] (
	fecha,sucursal,	cuenta,	cod_barras,	codigo,	pedido,	cantidad_surtida,	cantidad_pedida,
	arch_cliente,hora_resp_tandem,	arch_tandem,orden,	mostrador,	descripcion,tftp
)

SELECT 
	CONVERT(SMALLDATETIME,@fecha,121)fecha,	
	sucursal,cuenta,cod_barras,codigo,pedido,cantidad_surtida,cantidad_pedida,arch_cliente,
	hora_resp_tandem,arch_tandem,orden,mostrador,descripcion,tftp
FROM [FormatoUnion].[pedidos_Farmatodo]

GO

