create view vi_devoluciones_hh_folios as
SELECT 
t2.sucursal, 
t1.agen_cod, 
t1.agen_nombre, 
t1.folio_inicial, 
t1.folio_final, 
t1.fecha_hora 
FROM 
dbo.devoluciones_hh_folios t1 inner join dbo.sucursales t2 on t1.sucursal = t2.sucursal

GO

