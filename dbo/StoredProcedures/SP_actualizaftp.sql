CREATE procedure [dbo].[SP_actualizaftp]
@id nvarchar(30),
@ftp int 
as
begin
update proveedoresftp set id_ftp_fk = @ftp where id_proveeftp = @id
end

GO

