
create procedure Sp_obtenerftpPagos
@idpro nvarchar(40)
as
begin

select pr.servidor,pr.usuario,dbo.fnLeeClave(pr.passwordd) as contra,pr.carpeta,pr.puerto,pr.tipo
from ftpprovedorespagos pr
inner join proveedoresftppagos ft on pr.id_ftp = ft.id_ftp_fk
 where  ft.id_proveeftp = @idpro

end

GO

