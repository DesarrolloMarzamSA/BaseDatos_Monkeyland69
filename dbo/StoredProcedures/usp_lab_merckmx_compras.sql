
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE	--	CREATE	--	DROP
PROCEDURE [dbo].[usp_lab_merckmx_compras]
WITH ENCRYPTION
AS

/*
EXECUTE usp_lab_merckmx_compras
*/

SELECT	--  TOP 10	--* 
	c.ClaveDist								,
	c.ClaveSucDist						,
	c.FechaMovimiento					,
	c.HoraMovimiento					,
	c.CodigoMat								,
	c.CodigoEAN								,
	c.ClaseMovimiento					,
	c.MotivoMovimiento				,
	c.OrigenMovimiento				,
	c.StatusInventario				,
	c.Cantidad								,
	c.UnidadMedida						,
	c.UnidadMedida						,
	c.NumeroLote							,
	c.Texto1									,
	c.Texto2									,
	c.Texto3
FROM lab_merckmx_compras_ingresadas c WITH (NOLOCK)
GO
