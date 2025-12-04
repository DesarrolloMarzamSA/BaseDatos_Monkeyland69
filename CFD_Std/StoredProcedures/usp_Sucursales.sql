-- =============================================
-- Author: Francisco Roberto Martínez Hernández
-- Create date: 25/06/2019
-- Description:	Obtiene las sucursales que con el formato que se utiliza en el CFD estandar
--  EXEC [CFD_Std].[usp_Sucursales]
-- =============================================
create PROCEDURE [CFD_Std].[usp_Sucursales]	
AS
BEGIN
	
        SELECT 
		sucursal, descripcion FROM sucursales WITH(NOLOCK)	
END

GO

