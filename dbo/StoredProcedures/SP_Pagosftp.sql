
create procedure [dbo].[SP_Pagosftp]
@id nvarchar(39)
as
begin
select f.servidor,f.usuario,dbo.fnLeeClave(f.passwordd) as pass,f.carpeta,f.puerto 
from ftpprovedorespagos f
inner join proveedoresftppagos p on f.id_ftp = p.id_ftp_fk where p.id_proveeftp = @id
 end

GO

