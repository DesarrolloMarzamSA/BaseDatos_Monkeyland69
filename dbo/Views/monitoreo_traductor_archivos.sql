create view monitoreo_traductor_archivos 
as
select sucursal, archivo, convert(varchar(16), fecha, 121) fecha from monitoreo_traductor

GO

