CREATE  procedure [dbo].[Sp_Obtendatosftp]
@servidor nvarchar(50)
as
begin
select servidor,usuario,dbo.fnLeeClave(passwordd)as passwordd,carpeta,puerto 
from ftpprovedores where servidor = @servidor
end

GO

