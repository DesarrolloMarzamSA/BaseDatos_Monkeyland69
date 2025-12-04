CREATE VIEW [dbo].[cat_articulos_costco]
AS
SELECT	codigo,
		cod_barrcli
FROM	dbcataut
WHERE	segmento = 'E1' AND 
		cadena = '681' AND 
		STATUS = 'A'

GO

