-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE usp_depurar_pedidoshh_benavides
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    insert into [monkeyland].[dbo].[pedidos_fbenavides_hh_historico]
select * from [monkeyland].[dbo].[pedidos_fbenavides_hh] 
where convert(varchar,tftp,112)<=convert(varchar,getdate()-1,112)

delete from [monkeyland].[dbo].[pedidos_fbenavides_hh] 
where convert(varchar,tftp,112)<=convert(varchar,getdate()-1,112)
END

GO

