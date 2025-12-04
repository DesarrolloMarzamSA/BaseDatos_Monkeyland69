  

  CREATE procedure [dbo].[spr_SetArchivosCompras]
  @programa varchar(50),
  @firma varchar(50),
  @nombre varchar(100),
  @burocredito nvarchar(100),
  @lineas int  
  as
  begin
  insert into hashes_md5Levicom (programa,firma,fecha,nombre_archivo,BuroCredito,lineas) values (@programa,@firma,getdate(),@nombre,@burocredito,@lineas)
  end

GO

