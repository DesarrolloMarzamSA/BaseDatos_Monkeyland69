
CREATE FUNCTION [dbo].[fnLeeClave] 
(
    @clave VARBINARY(8000)
)
RETURNS VARCHAR(30)
AS
BEGIN
    
    
    DECLARE @pass AS VARCHAR(30)
    ------------------------------------
    ------------------------------------
    --Se descifra el campo aplicandole la misma llave con la que se cifro dbCurso09
    SET @pass = DECRYPTBYPASSPHRASE('kike',@clave)
    ------------------------------------
    ------------------------------------    
    RETURN @pass

END

GO

