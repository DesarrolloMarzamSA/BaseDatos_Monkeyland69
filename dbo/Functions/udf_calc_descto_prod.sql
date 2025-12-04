

CREATE	--	CREATE --	DROP
FUNCTION [dbo].[udf_calc_descto_prod]

( @clas_fis VARCHAR(2), @descto MONEY, @descto_prod  MONEY)


RETURNS MONEY

AS

BEGIN

IF @clas_fis IN ('B','BA') RETURN @descto
IF @clas_fis IN ('N','NA','F','FA') RETURN 0
IF @clas_fis IN ('H','HA') RETURN @descto_prod

RETURN 0

END

GO

