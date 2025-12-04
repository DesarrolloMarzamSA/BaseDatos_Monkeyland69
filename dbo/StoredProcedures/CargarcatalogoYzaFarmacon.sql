create procedure [dbo].[CargarcatalogoYzaFarmacon]
@cliente varchar(7),
@cuentaVerificado varchar(10),
@sucursal int,
@ctepadre varchar(5)
as begin
insert into catalogoYzaFarmacon
values (@cliente, @cuentaVerificado, @sucursal, @ctepadre)
end

GO

