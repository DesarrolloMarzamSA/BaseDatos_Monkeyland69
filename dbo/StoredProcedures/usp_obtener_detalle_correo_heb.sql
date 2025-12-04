-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_obtener_detalle_correo_heb] @ordenes varchar(max)
AS
BEGIN
	-- [usp_obtener_detalle_correo_heb] '50235282,50235283,50235291,50235292,50235294'
	SET NOCOUNT ON;
	declare @query varchar(max)   
	set @query ='
	select p.Document_type,p.Heb_rfc,p.Vendor_number,p.Detail_number_of_lines,
	cast(p.Purchase_order as numeric)as Purchase_order,p.Subsidiary_gln,p.Subsidiary,p.Subsidiary_desc,
	count(d.product_id) as totalProducto,sum(d.ordered_quantity) totalProductosPedidos
	from monkeyland..pedidoHEB_Encabezado p
		inner join monkeyland..pedidoHEB_Detalle d on p.Purchase_order=d.Purchase_order and p.Subsidiary_gln=d.Subsidiary_gln
		and p.Subsidiary=d.Subsidiary
	where p.Estatus=''PENDIENTE'' and p.EstatusEnvio=60 and p.Purchase_order in('+@ordenes+')
	group by p.Document_type,p.Heb_rfc,p.Vendor_number,p.Detail_number_of_lines,
	p.Purchase_order,p.Subsidiary_gln,p.Subsidiary,p.Subsidiary_desc' 
	print(@query);
	execute(@query);
	
  
END

GO

