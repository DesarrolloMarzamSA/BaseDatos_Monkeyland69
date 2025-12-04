-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[EantoMarzam] 
(
	-- Add the parameters for the function here
	@EAN varchar(32)
	--<@Param1, sysname, @p1> <Data_Type_For_Param1, , int>
)
RETURNS varchar(32)
AS
BEGIN
	-- Declare the return variable here
	--DECLARE <@ResultVar, sysname, @Result> <Function_Data_Type, ,int>
	Declare @retrono varchar(32)

	-- Add the T-SQL statements to compute the return value here
	--SELECT TOP 1 @retrono=[codigo]
	--FROM [monkeyland].[dbo].[maestro_productos_baan]
	--where cast(cod_barras as bigint)=cast(@EAN as bigint)
	----and isnull(fecha_baja, DATEADD(day,1, getdate()))> GETDATE()
	--order by codigo asc

	SELECT TOP 1 @retrono=[codigo]
	FROM [capa_ibs].[dbo].[maestro_productos]
	where  ISNUMERIC(cod_barras)=1 and  cod_barras=@EAN
	order by codigo asc

	-- Return the result of the function
	RETURN @retrono

END

GO

