CREATE PROCEDURE usp_fahorro_normal_facturas_entregadas
	@fecha VARCHAR(10),
	@orden VARCHAR(100),
	@hash_md5 VARCHAR(50),
	@segto VARCHAR(2),
	@ctepadre VARCHAR(3),
	@archivo VARCHAR(50)
AS

--DECLARE @orden VARCHAR(100)
--DECLARE @hash_md5 VARCHAR(50)
--DECLARE @sucursal TINYINT
--DECLARE @factura VARCHAR(20)
--DECLARE @cliente VARCHAR(20)
--DECLARE @fecha VARCHAR(10)
--DECLARE @sql VARCHAR(5000)
--DECLARE @segto VARCHAR(2)
--DECLARE @ctepadre VARCHAR(3)
--DECLARE @archivo VARCHAR(50)
--SET @orden = '10093'
--SET @hash_md5 = '6323909a6c3fd4fb20d63460dbd7efa1'
--SET @fecha = '2012-08-07'
--SET @segto = 'C1'
--SET @ctepadre = '007'
--SET @archivo = ''

DECLARE @sucursal TINYINT
DECLARE @factura VARCHAR(20)
DECLARE @cliente VARCHAR(20)
DECLARE @sql VARCHAR(5000)

SELECT	@sucursal = t1.sucursal, 
		@factura = t1.factura, 
		@cliente = t2.ibs_letra + t1.cliente  
FROM	encabezado t1 WITH(NOLOCK) inner join sucursales t2 ON 
		t1.sucursal = t2.sucursal
WHERE	t1.fecha_tandem >= CONVERT(VARCHAR(10), DATEADD(DD, -2, CONVERT(DATETIME, @fecha, 121)), 121) and 
		t1.segto = @segto and 
		t1.ctepadre = @ctepadre and 
		t1.orden like '%' + @orden + ''

INSERT	INTO fahorro_normal_facturas_entregadas (sucursal, factura, cliente, orden, hash_md5, fecha, archivo) 
VALUES	(@sucursal, @factura, @cliente, @orden, @hash_md5, CURRENT_TIMESTAMP, @archivo)

SELECT @@ROWCOUNT

GO

