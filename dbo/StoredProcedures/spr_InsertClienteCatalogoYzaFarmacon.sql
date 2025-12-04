create procedure [dbo].[spr_InsertClienteCatalogoYzaFarmacon]
  (
  @cliente  varchar(7),
  @cuentaVerificado varchar(10),
  @sucursal int,
  @ctepadre int
  )
  as begin
  insert into catalogoYzaFarmacon(cliente, cuentaVerificado, sucursal, ctepadre)
  values (@cliente, @cuentaVerificado, @sucursal, @ctepadre)
  end

GO

