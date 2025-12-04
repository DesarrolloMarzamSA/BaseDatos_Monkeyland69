
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Ahorro].[actualizaFacturacion]
@nombreArchivo varchar(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	MERGE [Ahorro].[encabezadoFacturasAhorro] AS destino
	USING (SELECT @nombreArchivo as nombreArchivo) AS origen
		ON (destino.nombreArchivo=origen.nombreArchivo)
	WHEN MATCHED THEN 
		UPDATE SET fechacarga = getdate(), estatus = 20;
END

GO

