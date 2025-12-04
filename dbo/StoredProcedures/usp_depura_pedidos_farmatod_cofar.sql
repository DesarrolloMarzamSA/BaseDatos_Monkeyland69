-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE usp_depura_pedidos_farmatod_cofar
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	insert into [monkeyland].[dbo].[pedidos_farmatodo_cofar_historiaV2]
    select *,getdate() FROM [monkeyland].[dbo].[pedidos_farmatodo_cofar] 
    where convert(varchar,fecha_pedido,112)<=convert(varchar,getdate()-2,112)

	
    delete FROM [monkeyland].[dbo].[pedidos_farmatodo_cofar] 
    where convert(varchar,fecha_pedido,112)<=convert(varchar,getdate()-2,112)
END

GO

