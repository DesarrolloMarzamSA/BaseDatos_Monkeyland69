create procedure [dbo].[spr_repetidosCatalogoYzaFarmacon]
  @cliente varchar(7),
  @cuentaVerificado varchar(10)
  as
  if exists(SELECT  [cliente]
      ,[cuentaVerificado]
  FROM [monkeyland].[dbo].[catalogoYzaFarmacon] 
  where cliente = @cliente and cuentaVerificado = @cuentaVerificado)
  begin
  select 1 as repetido
  end
  else
  begin
  select 0 AS noRepetido
  end

GO

