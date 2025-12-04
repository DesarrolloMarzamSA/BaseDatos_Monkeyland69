CREATE PROCEDURE [dbo].[usp_graba_fahorro_normal_fecha_ibs]
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
--DECLARE @x_Dummy INT
--SET @orden = '10093'
--SET @hash_md5 = '6323909a6c3fd4fb20d63460dbd7efa1'
--SET @fecha = '2012-08-07'
--SET @segto = 'C1'
--SET @ctepadre = '007'
--SET @archivo = ''
--SET @x_Dummy = 0

DECLARE @sucursal TINYINT
DECLARE @factura VARCHAR(20)
DECLARE @cliente VARCHAR(20)
DECLARE @sql VARCHAR(5000)
DECLARE @x_Dummy INT
SET @x_Dummy = 0

SELECT	@sucursal = t1.sucursal, 
		@factura = t1.factura, 
		@cliente = t2.ibs_letra + t1.cliente  
FROM	encabezado t1 inner join sucursales t2 ON 
		t1.sucursal = t2.sucursal
WHERE	t1.fecha_tandem >= CONVERT(VARCHAR(10), DATEADD(DD, -2, CONVERT(DATETIME, @fecha, 121)), 121) and 
		t1.segto = @segto and 
		t1.ctepadre = @ctepadre and 
		--t1.orden like '%' + @orden + ''
		t1.orden = RIGHT('000000000' + CONVERT(VARCHAR, CONVERT(BIGINT, @orden)), 9)
--IF NOT EXISTS (SELECT factura FROM graba_fahorro_normal_fecha_ibs WHERE sucursal = @sucursal AND factura = @factura AND cliente = @cliente AND orden = @orden AND hash_md5 = @hash_md5 AND archivo = @archivo)
--	BEGIN
SELECT	@sql = 'UPDATE MA4620EF04.SRBISH SET IHDUD1 = ' + CONVERT(VARCHAR(8), CURRENT_TIMESTAMP, 112) + ', ' + 'IHDUD2 = ' + REPLACE(CONVERT(VARCHAR(8), CURRENT_TIMESTAMP, 108), ':', '') + ' WHERE IHINVN LIKE ''%'
SELECT	@sql = @sql + CONVERT(VARCHAR, CONVERT(BIGINT, @factura)) + '%'' AND IHCUNO = ''' + @cliente + ''' AND IHIDAT >= ' + convert(varchar(8), dateadd(dd, -2, convert(datetime, @fecha, 121)), 112) + ''
EXECUTE (@sql) AT [AS400]
SET @x_Dummy = @@ROWCOUNT
IF @x_Dummy > 0
	BEGIN
		INSERT	INTO fahorro_normal_facturas_entregadas (sucursal, factura, cliente, orden, hash_md5, fecha, archivo) 
		VALUES	(@sucursal, @factura, @cliente, @orden, @hash_md5, CURRENT_TIMESTAMP, @archivo)
		SELECT @@ROWCOUNT 
	END
ELSE
	BEGIN
		SELECT @@ROWCOUNT
	END
	--END

GO

