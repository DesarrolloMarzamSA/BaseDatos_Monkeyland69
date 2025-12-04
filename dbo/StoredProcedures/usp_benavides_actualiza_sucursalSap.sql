
-- =============================================
-- Author:		mandrade
-- Create date: 31-03-2021
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_benavides_actualiza_sucursalSap]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   

SELECT distinct [PARTNER] as cliente_ibs,0 as frontera,IDNUMBER as cia,'0001' as mostrador,'SAP'as descripcion,
VWERK as sucursal,[PARTNER] as cuenta,getdate() as fecha_alta,'BENAVIDES' as franquicia,'Z'as ibs_letra,0 as controlados,1 as activo
  into #temp_cat_sucursales_sap
  from openquery([192.168.90.209], ' select distinct [PARTNER],IDNUMBER,VWERK from [MiddleWare].[sapdm].[MClientes] where [KNRZE]=''0011000008''')
  where IDNUMBER is not null
  update c set c.sucursal=c1.sucursal
		--select * 
		from 
		#temp_cat_sucursales_sap c
		inner join [dbo].[cat_sucursales_benavides] c1 on c.[cia]=c1.cia

  MERGE monkeyland.[dbo].[cat_sucursales_benavides_sap] AS T  
    USING (
	        SELECT [cliente_ibs],[frontera] ,[cia],[mostrador],[descripcion],[sucursal],[cuenta],[fecha_alta],[franquicia],[ibs_letra],[controlados],[activo]
			  FROM #temp_cat_sucursales_sap
		   ) AS S  
	ON (T.[cia] = S.[cia] AND T.[sucursal] = S.[sucursal] AND T.[cuenta] = S.[cuenta])  
   
    WHEN NOT MATCHED THEN  
        INSERT ([cliente_ibs],[frontera] ,[cia],[mostrador],[descripcion],[sucursal],[cuenta],[fecha_alta],[franquicia],[ibs_letra],[controlados],[activo])  
        VALUES ([cliente_ibs],[frontera] ,[cia],[mostrador],[descripcion],[sucursal],[cuenta],[fecha_alta],[franquicia],[ibs_letra],[controlados],[activo]); 
		--select * from monkeyland.[dbo].[cat_sucursales_benavides_sap] where sucursal='1104'
		--select * from monkeyland.[dbo].[cat_sucursales_benavides_sap] where sucursal='1108'
		--select * from monkeyland.[dbo].[cat_sucursales_benavides_sap] where sucursal='1106'
	update	monkeyland.[dbo].[cat_sucursales_benavides_sap] set sucursal='18' where sucursal='1108'
	update	monkeyland.[dbo].[cat_sucursales_benavides_sap] set sucursal='17' where sucursal='1104'
	update	monkeyland.[dbo].[cat_sucursales_benavides_sap] set sucursal='23' where sucursal='1106'
	update	monkeyland.[dbo].[cat_sucursales_benavides_sap] set sucursal='3' where sucursal='1102'

		drop table #temp_cat_sucursales_sap

END

GO

