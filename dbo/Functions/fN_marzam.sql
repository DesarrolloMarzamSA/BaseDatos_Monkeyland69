CREATE	--	DROP
FUNCTION dbo.fN_marzam()
RETURNS VARCHAR(100)
AS

--	SELECT dbo.fn_marzam()

BEGIN
	DECLARE @RazonSocial VARCHAR(100)
	SET @RazonSocial = 'CASA MARZAM S.A. DE C.V.' 
	RETURN @RazonSocial
END

GO

