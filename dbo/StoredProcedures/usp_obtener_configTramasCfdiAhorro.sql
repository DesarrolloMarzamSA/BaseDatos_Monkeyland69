-- =============================================
-- Author:		MARCO ANTONIO ANDRADE
-- Create date: 23/01/2018
-- Description:	Obtiene configuracion parea generar layout de tramas: 01,02,03 (CFDI) 
-- =============================================
CREATE PROCEDURE [dbo].[usp_obtener_configTramasCfdiAhorro]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT [Id]
          ,[IdTrama]
          ,[Posicion]
          ,[CampoMarzam]
          ,[Alineado]
          ,[Longitud] 
		  ,[ValorPredefinido]       
    FROM [dbo].[TramasCfdiAhorro] WITH(NOLOCK) --WHERE IDTRAMA='01'
	ORDER BY IdTrama,Posicion
END

GO

