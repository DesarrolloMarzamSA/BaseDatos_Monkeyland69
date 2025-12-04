CREATE procedure [dbo].[SPftps]
as 
begin
select id_ftp ,servidor +'  '+NombreServidor as servidor   from ftpprovedores
end

GO

