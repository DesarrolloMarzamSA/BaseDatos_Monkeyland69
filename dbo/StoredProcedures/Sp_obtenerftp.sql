CREATE procedure [dbo].[Sp_obtenerftp] --'2431'
@idpro nvarchar(40)
as
begin
select pr.servidor,pr.usuario,dbo.fnLeeClave(pr.passwordd) as contra,pr.carpeta,pr.puerto,pr.tiposervidor
from ftpprovedores pr
inner join proveedoresftp ft on pr.id_ftp = ft.id_ftp_fk
 where  ft.id_proveeftp = @idpro
end

GO

