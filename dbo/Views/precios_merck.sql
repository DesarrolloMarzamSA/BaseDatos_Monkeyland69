create view precios_merck
as
select codigo, precio from capa_ibs.dbo.listas_precios where lista = '04'

GO

