-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE usp_descuentos_confidenciales_union
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT distinct codigo_marzam,codigo_barras,producto,isnull(descuento_volumen,0) as descuento_volumen,
	isnull(descuento_netos,0) as descuento_netos 
	FROM catalogo_descuentos_farmacias_union
END

GO

