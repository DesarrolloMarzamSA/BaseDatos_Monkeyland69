CREATE procedure [dbo].[Sp_datos]
as
begin
select  ft.id_proveeftp as "Id proveedor",
  ft.nombre as "Nombre",
  pr.servidor as "Servidor",
  pr.carpeta as "Carpeta",
  pr.NombreServidor as "Nombres",
  case
   when pr.tiposervidor = 1 
    then 'FTP'
	 else 'SFTP' end as "Tipo servidor"
from ftpprovedores pr
inner join proveedoresftp ft     on pr.id_ftp = ft.id_ftp_fk
end

GO

