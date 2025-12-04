
-- =============================================
-- Author:		Antonio Acosta Rodríguez
-- Create date: 25-07-16
-- Description:	Genera el descuento escalonado para Grufarnay
-- =============================================
CREATE FUNCTION [dbo].[fn_getDiscount](@pFarmacia float, @dis1 float, @dis2 float, @dis3 float, @dis4 float, @dis5 float, @dis6 float)
RETURNS float
AS
BEGIN
    declare @pFinal float = @pFarmacia;
	declare @entero int;
	if not @dis1 is null
	begin
		set @pFinal = @pFinal - (@pFinal * (@dis1 / 100));
		set @pFinal = @pFinal - (@pFinal * (@dis2 / 100));
		set @pFinal = @pFinal - (@pFinal * (@dis3 / 100));
		set @pFinal = @pFinal - (@pFinal * (@dis4 / 100));
		set @pFinal = @pFinal - (@pFinal * (@dis5 / 100));
		set @pFinal = @pFinal - (@pFinal * (@dis6 / 100));
		set @entero = @pFinal;
		set @entero = len(@pFinal - @entero);
		if @entero > 4
		begin
			set @pFinal = round(@pFinal, 2, 1);
		end
	end
    return @pFinal
END;

GO

