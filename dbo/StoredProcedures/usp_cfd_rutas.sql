
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE
PROCEDURE [dbo].[usp_cfd_rutas]

AS

SELECT descripcion, ruta, recursivo  
FROM cfd_rutas WITH(NOLOCK) 
WHERE habilitado = 1 
ORDER BY orden
GO
