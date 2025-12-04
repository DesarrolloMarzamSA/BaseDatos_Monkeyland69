
-- =============================================
-- Author:		<JCPM>
-- Create date: <19/05/2021>
-- Description:	<obtiene las cargas iniciales de la notas de crédito>
-- exec [sap].[usp_NCCargaIncial]
-- =============================================
CREATE PROCEDURE [sap].[usp_NCCargaIncial]
AS
BEGIN
	-- Opciones iniciales
	SET NOCOUNT ON;
	
	
	update sap.ControlEnvioCINC set apiWeb=1 where idSeg in(select top 1 idSeg from sap.ControlEnvioCINC where estatus=20 order by idseg)
				
	select ci.* from sap.CargasInicialesNC ci
	left join sap.ControlEnvioCINC cc on cc.idSeg=ci.idSeguimiento
	where (cc.apiWeb=1 or ci.apiWeb=1) and ci.idref=0
	
END
--select * from sap.CargasInicialesNC
--update sap.CargasInicialesNC set apiWeb=1,idSeguimiento=5
--1.- truncate table sap.CargasInicialesNC
--2.- exec [sap].[usp_JobCargasInciales]
--select * from sap.ControlEnvioCINC
--select * from  openquery(AS400,'select COUNT(1) FROM MA4620EC.Z3OCARNC A')
--select * from  openquery(AS400,'select count(DISTINCT IDINVN) FROM MA4620EC.Z3OCARNC A')

GO

