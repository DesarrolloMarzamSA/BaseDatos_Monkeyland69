
CREATE procedure [dbo].[SP_historialcasaley]
@serie nvarchar(20),
@total int,
@carpeta nvarchar(50),
@fecha nvarchar(60)
as
begin
insert into casaleyarchivos (Serie,Total,Fecha,Carpeta) values (@serie,@total,@fecha,@carpeta)
end

GO

