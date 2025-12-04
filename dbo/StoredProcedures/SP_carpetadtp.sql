CREATE procedure [dbo].[SP_carpetadtp]
@id nvarchar(50)

as
begin
declare @resultado nvarchar(40)
 select @resultado =  carpeta from proveedoresftp where id_proveeftp =@id
 select @resultado as carpeta
 if(@resultado ='')
 begin
  set @resultado = 'OTROS' 
  select @resultado
 end
 else  
 begin
  select @resultado = carpeta from proveedoresftp where id_proveeftp =@id
 end

 end

GO

