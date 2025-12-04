-- =============================================
-- Author:		Luis Angel Fernandez
-- Create date: 16-01-2018
-- Description:	obtiene facturas por cliente, cliente padre y fecha
-- spr_obtener_facturasCtaCtePadre '20180114','15171%','009'
-- =============================================
CREATE  PROCEDURE spr_obtener_facturasCtaCtePadre @fecha as varchar(10),@cliente as varchar(10),@ctePadre as varchar(3)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT t1.Serie,folio_fiscal as FacturaFiscal,cast(t1.folio_fiscal as numeric) as FolioFiscal,t1.noalta as Cliente,c.[NATREG] as rfc,t1.filler as FacturaIBS,
	substring(convert(varchar,t1.fechaprog,111),0,5)+'/'+cast(cast(substring(convert(varchar,t1.fechaprog,111),6,2) as int)as varchar)+'/'+cast(cast(substring(convert(varchar,t1.fechaprog,111),9,2) as int)as varchar) as Ruta
    FROM	Historica.dbo.encabezado t1
	inner join [capa_ibs].[dbo].[cliente_rfc] c on t1.noalta=rtrim(c.nanum)
    where t1.ctepadre like @ctePadre and t1.cliente like @cliente
	--t1.ctepadre=@ctePadre
	 and convert(varchar,t1.fechaprog,112)>=@fecha 

END

GO

