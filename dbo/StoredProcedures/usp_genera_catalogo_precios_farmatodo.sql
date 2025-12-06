
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_genera_catalogo_precios_farmatodo]
	-- Add the parameters for the stored procedure here

WITH ENCRYPTION
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
SELECT * FROM  openquery (AS400,'(SELECT  PJEANP, ''|'', PGDESC,''|'',
(SELECT PSSALP FROM MA4620EF04.SROPRS WHERE PGPRDC = PSPRDC AND PSPRIL = ''02'' ) FARMACIA, ''|'',
(SELECT PSSALP FROM MA4620EF04.SROPRS WHERE PGPRDC = PSPRDC AND PSPRIL = ''03'' ) PUBLICO
FROM MA4620EF04.SROPRG INNER JOIN MA4620EF04.SROEAN ON PGPRDC = PJPRDC INNER JOIN MA4620EF04.SRONAM ON
NANUM = PGMSUP where pgstat <> ''D'' )')
	
END
GO
