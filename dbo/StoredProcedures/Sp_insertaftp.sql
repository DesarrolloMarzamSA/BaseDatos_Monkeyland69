CREATE procedure [dbo].[Sp_insertaftp]
@servidor nvarchar(30),
@usuario nvarchar(30),
@password nvarchar(100),
@carpeta nvarchar(100),
@puerto nvarchar(100),
@tiposervidor nvarchar(10),
@nombreservidor nvarchar(50),
@usuarioreg nvarchar(50)
as 
begin 
insert into ftpprovedores (servidor,usuario,passwordd,carpeta,puerto,tiposervidor,NombreServidor,Usuarioreg)
 values(@servidor,@usuario,dbo.fnColocaClave(@password),@carpeta,@puerto,@tiposervidor,@nombreservidor,@usuarioreg)
end

GO

