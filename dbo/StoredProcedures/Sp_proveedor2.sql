CREATE procedure [dbo].[Sp_proveedor2]
as
begin
select  id_proveeftp+' '+nombre as nombrecom, id_proveeftp from proveedoresftp
end

GO

