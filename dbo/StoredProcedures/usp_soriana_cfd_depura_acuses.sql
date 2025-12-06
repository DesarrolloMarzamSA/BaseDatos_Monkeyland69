
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE	--	CREATE
PROCEDURE [dbo].[usp_soriana_cfd_depura_acuses]

AS

--	query para obtener todas las confirmadas

UPDATE cfd_soriana_acuses_de_recibo 
SET addenda = 1
FROM cfd_soriana_acuses_de_recibo a
INNER JOIN bitacora_soriana_cfd b	ON 
	b.serie_cfd = a.serie_cfd AND b.folio_fiscal = a.folio_fiscal 
	AND (b.confirmada = 1 OR b.pagada = 1)

DELETE FROM cfd_soriana_acuses_de_recibo 
WHERE 
	addenda = 1 --AND fecha_recibo < DATEADD(DD, -15, GETDATE() ) 
	OR
	(addenda = 0 AND fecha_recibo < DATEADD(DD, -365, GETDATE() ) )

GO
