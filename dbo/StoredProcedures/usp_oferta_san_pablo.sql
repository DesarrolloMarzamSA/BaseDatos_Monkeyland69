-- =============================================
-- Author:		mandrade
-- Create date: 25/06/2015
-- Description:	obtiene peticion de oferta San Pablo
-- =============================================
CREATE PROCEDURE [dbo].[usp_oferta_san_pablo]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	select	d.[numero_pet_oferta],d.[item],d.[articulo],d.[ean],d.[cantidad],d.[fecha_peticion_oferta],
			d.[unidad_medida],isnull(c.P_FARMACIA,0)as p_farmacia,isnull(c.[OFERTA],0)as oferta
	from monkeyland..[detalle_oferta_san_pablo] d
	left join monkeyland..catalogo_oferta_san_pablo c 
	on cast(d.ean as numeric(18,0))=cast(c.[PJEANP] as numeric(18,0))
	order by d.linea
END

GO

