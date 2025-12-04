  CREATE procedure [dbo].[spr_GetArchivosCompras]
  @programa varchar(50),
  @firma varchar(50),
  @nombre varchar(100)
  as
  begin
  select top 1 firma from hashes_md5Levicom where programa = @programa and firma = @firma and nombre_archivo = @nombre
  end

GO

