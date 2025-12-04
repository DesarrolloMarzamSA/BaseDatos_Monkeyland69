-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_actualiza_ProdClte_Miniatura]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   update pm set pm.codigoMarzam=p.codigo
--SELECT distinct pm.*,p.codigo
--delete 
  FROM [monkeyland].[dbo].[pedidos_miniatura] pm
  inner join monkeyland..maestro_productos p 
  on ltrim(rtrim(pm.codigoArticulo)) =ltrim(rtrim(p.cod_barras))

  update pm set pm.codigoMarzam=p.codigo
--SELECT distinct pm.*,p.codigo
--delete 
  FROM [monkeyland].[dbo].[pedidos_miniatura_historia] pm
  inner join monkeyland..maestro_productos p 
  on ltrim(rtrim(pm.codigoArticulo)) =ltrim(rtrim(p.cod_barras))

  update pm set pm.sucursal=
			CASE
			WHEN RTRIM(LTRIM(NOI.noz3lent))='821' AND SUBSTRING(pm.clienteInterno,1,1)='D' THEN CAST('04' AS INT) 
			WHEN RTRIM(LTRIM(NOI.noz3lent))='807' AND SUBSTRING(pm.clienteInterno,1,1)='X' AND RTRIM(LTRIM(T2.CMCSTS))='075' THEN CAST('24' AS INT) 
			WHEN RTRIM(LTRIM(NOI.noz3lent))='807' AND SUBSTRING(pm.clienteInterno,1,1)='X' THEN CAST('23' AS INT) 
			WHEN RTRIM(LTRIM(NOI.noz3lent))='808' AND SUBSTRING(pm.clienteInterno,1,1)='X' THEN CAST('24' AS INT) 
			WHEN RTRIM(LTRIM(NOI.noz3lent))='855' THEN CAST('09' AS INT) 
			WHEN NOI.NOZ3LENT IS NULL then CAST('0' AS INT) 
			ELSE CAST(SUBSTRING(NOI.noz3lent,2,3)AS INT) 
			END --select pm.*
		from [monkeyland].[dbo].[pedidos_miniatura] pm 
		--INNER JOIN AS400.[S101FEBT].MA4620EF04.Z3BNOI NOI ON pm.clienteInterno=RTRIM(LTRIM(NOI.NONUM))
		--INNER JOIN AS400.[S101FEBT].MA4620EF04.SRBCMA AS T2 ON pm.clienteInterno=RTRIM(LTRIM(T2.CMCUNO))
		INNER JOIN AS400.[S78E2DC0].MA4620EF04.Z3BNOI NOI ON pm.clienteInterno=RTRIM(LTRIM(NOI.NONUM))
		INNER JOIN AS400.[S78E2DC0].MA4620EF04.SRBCMA AS T2 ON pm.clienteInterno=RTRIM(LTRIM(T2.CMCUNO))
			where pm.sucursal is null

	update pm set pm.sucursal=
			CASE
			WHEN RTRIM(LTRIM(NOI.noz3lent))='821' AND SUBSTRING(pm.clienteInterno,1,1)='D' THEN CAST('04' AS INT) 
			WHEN RTRIM(LTRIM(NOI.noz3lent))='807' AND SUBSTRING(pm.clienteInterno,1,1)='X' AND RTRIM(LTRIM(T2.CMCSTS))='075' THEN CAST('24' AS INT) 
			WHEN RTRIM(LTRIM(NOI.noz3lent))='807' AND SUBSTRING(pm.clienteInterno,1,1)='X' THEN CAST('23' AS INT) 
			WHEN RTRIM(LTRIM(NOI.noz3lent))='808' AND SUBSTRING(pm.clienteInterno,1,1)='X' THEN CAST('24' AS INT) 
			WHEN RTRIM(LTRIM(NOI.noz3lent))='855' THEN CAST('09' AS INT) 
			WHEN NOI.NOZ3LENT IS NULL then CAST('0' AS INT) 
			ELSE CAST(SUBSTRING(NOI.noz3lent,2,3)AS INT) 
			END --select pm.*
		from [monkeyland].[dbo].[pedidos_miniatura_historia] pm 
		--INNER JOIN AS400.[S101FEBT].MA4620EF04.Z3BNOI NOI ON pm.clienteInterno=RTRIM(LTRIM(NOI.NONUM))
		--INNER JOIN AS400.[S101FEBT].MA4620EF04.SRBCMA AS T2 ON pm.clienteInterno=RTRIM(LTRIM(T2.CMCUNO))
		INNER JOIN AS400.[S78E2DC0].MA4620EF04.Z3BNOI NOI ON pm.clienteInterno=RTRIM(LTRIM(NOI.NONUM))
		INNER JOIN AS400.[S78E2DC0].MA4620EF04.SRBCMA AS T2 ON pm.clienteInterno=RTRIM(LTRIM(T2.CMCUNO))
			where pm.sucursal is null
END

GO

