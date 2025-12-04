CREATE procedure [dbo].[SP_idproveedor]-- '2520'
@idpr nvarchar(30)
as
begin
select id_proveeftp from  proveedoresftp  where id_proveeftp like  '%'+ @idpr + '%'  
end

GO

