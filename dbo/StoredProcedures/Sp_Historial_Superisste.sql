
CREATE procedure [dbo].[Sp_Historial_Superisste]
@usuario nvarchar(50)
as
begin
insert into  [monkeyland].[dbo].[historialSuperiiste]
select *,getdate(),@usuario from superisste3
delete [monkeyland].[dbo].[superisste3] 
select * from superisste3
end

GO

