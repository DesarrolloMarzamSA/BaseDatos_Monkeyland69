
CREATE FUNCTION [dbo].[fnColocaClave] 
(
    @clave VARCHAR(25)
)
RETURNS VarBinary(8000)
AS
BEGIN
    
    
    DECLARE @pass AS VarBinary(8000)
    ------------------------------------
    ------------------------------------
    SET @pass = ENCRYPTBYPASSPHRASE('kike',@clave)--dbCurso09 es la llave para cifrar el campo.
    ------------------------------------
    ------------------------------------    
    RETURN @pass

END

GO

