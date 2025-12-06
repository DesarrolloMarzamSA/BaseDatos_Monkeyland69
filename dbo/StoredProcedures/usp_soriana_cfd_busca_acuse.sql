USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE	--	CREATE
PROCEDURE [dbo].[usp_soriana_cfd_busca_acuse]
--DECLARE 
@serie_cfd VARCHAR(2), @folio_fiscal VARCHAR(8)

/*
EXECUTE usp_soriana_cfd_busca_acuse 'FK','00057797'
*/

WITH ENCRYPTION
AS

SELECT numTienda, serie_cfd, folio_fiscal, folio_acuse, documento_soriana, usr 
FROM cfd_soriana_acuses_de_recibo 
WHERE serie_cfd = @serie_cfd AND folio_fiscal = @folio_fiscal 
GO
