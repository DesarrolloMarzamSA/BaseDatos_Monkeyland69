
CREATE procedure [dbo].[Sp_insertaftppagos]
@servidor nvarchar(30),
@usuario nvarchar(30),
@password nvarchar(100),
@carpeta nvarchar(100),
@puerto nvarchar(100),
@tipo nvarchar (100),
@nombre nvarchar(50)
as 
begin 
insert into ftpprovedorespagos (servidor,usuario,passwordd,carpeta,puerto,tipo,nombre)
 values(@servidor,@usuario,dbo.fnColocaClave(@password),@carpeta,@puerto,@tipo,@nombre)
end

GO

