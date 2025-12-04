CREATE procedure [dbo].[SP_insertaprovedorftp]
@id nvarchar(200),
@nombre nvarchar(200),
@idftp int,
@carpeta nvarchar(200),
@usuarioreg nvarchar(30)
as
begin
insert into  proveedoresftp (id_proveeftp,nombre,id_ftp_fk,carpeta,usuarioreg) values (@id,@nombre,@idftp,@carpeta,@usuarioreg)
end

GO

