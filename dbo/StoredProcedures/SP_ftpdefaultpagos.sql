
CREATE procedure [dbo].[SP_ftpdefaultpagos]
@servidor nvarchar(50),
@tipo nvarchar(30)
as
begin
select servidor,usuario,dbo.fnLeeClave(passwordd)as "passwordd",carpeta,puerto from ftpprovedorespagos
where servidor = @servidor and tipo = @tipo
end

GO

