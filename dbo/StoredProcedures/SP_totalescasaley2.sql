
create procedure [dbo].[SP_totalescasaley2]
@totalbd int,
@totalarchivo int,
@totalftps int,
@totalftpr int
as
begin
insert into  totalescasaley2 (totalbd,totalarchivo,totalftps,totalftpr,fecha) values (@totalbd,@totalarchivo,@totalftps,@totalftpr,getdate())
end

GO

