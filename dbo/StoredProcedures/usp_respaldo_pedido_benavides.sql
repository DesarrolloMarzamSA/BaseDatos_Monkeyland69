-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_respaldo_pedido_benavides]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	insert into monkeyland..pedidos_fbenavides_ci_historia
	select * from monkeyland..pedidos_fbenavides_ci 
	where estatus='1' and convert(varchar,timestamp,112)<=convert(varchar,GETDATE()-1,112)
	delete from pedidos_fbenavides_ci where estatus='1' and convert(varchar,timestamp,112)<=convert(varchar,GETDATE()-1,112)

END

GO

