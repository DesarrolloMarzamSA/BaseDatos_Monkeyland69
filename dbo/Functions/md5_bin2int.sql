--USE master
--GO

--////////////////////////////////////////
--//Create some useful Utility functions
--////////////////////////////////////////

-- Converts binary(4) into integer.
CREATE FUNCTION dbo.md5_bin2int
(@x BINARY(4))
RETURNS INT
BEGIN
   RETURN CONVERT(INT, SUBSTRING(@x, 4, 1) + SUBSTRING(@x, 3, 1) + SUBSTRING(@x, 2, 1) + SUBSTRING(@x, 1, 1))
END

GO

