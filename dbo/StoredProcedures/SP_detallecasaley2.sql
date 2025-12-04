create procedure [dbo].[SP_detallecasaley2]
@fecha nvarchar(30)
as
begin
select * from  casaleyarchivos where Fecha = @fecha
end

GO

