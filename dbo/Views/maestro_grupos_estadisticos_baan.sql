create view [dbo].[maestro_grupos_estadisticos_baan]
as
select distinct grupo_est, desc_grupo_est descripcion from monkeyland.dbo.maestro_productos_baan

GO

