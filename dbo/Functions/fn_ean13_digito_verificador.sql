CREATE
--CREATE 
FUNCTION fn_ean13_digito_verificador (@EAN  VARCHAR(12))
RETURNS VARCHAR(13)
AS

--	MIGUEL SAMAYOA
--	RECIBE 12 Y CALCULA DV 

--	SET @EAN = '750400362000'			--	GLN BASE de MARZAM

BEGIN
	DECLARE @Sum INT, @SumImpar INT, @Digit INT, @CheckSum INT, @cuenta INT

	SET @Sum = 0
	SET @SumImpar = 0
	SET @Digit = 0
	SET @CUENTA =  LEN(@EAN)

	WHILE @cuenta > 0		BEGIN
		SET @Digit = CONVERT(INT, SUBSTRING(@EAN, @cuenta, 1 ) )
			IF ( @cuenta % 2 != 0 )
				BEGIN	    
					SET @SumImpar = @SumImpar + @Digit	
				END
			ELSE
				BEGIN
					SET @Sum = @Sum + @Digit
				END
		SET @cuenta = @cuenta - 1
	END	 
	SET @Digit = @SumImpar + ( @Sum * 3 )	 
	SET @CheckSum = (10 - (@Digit % 10)) % 10

	RETURN @EAN + CONVERT(VARCHAR,@CheckSum )
/*
SELECT DBO.fn_ean13_digito_verificador ('750400362000')
*/
END

GO

