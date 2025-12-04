SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_cargar_respuestasley] --@fecha varchar(10)
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--declare @sqlResp varchar(max)
delete from respuestas_casaley
drop table respuestas_casaley
select SUCURSAL,IHCUNO,IDPRDC,COD_BARRAS,cast(IDQTY as int)as surtido,IHSURF
 into respuestas_casaley from openquery(As400,'
 select substring(idarea,2,3) as sucursal,ihcuno,idprdc,
right(''0000000000000'' || replace(left(ltrim(IFNULL(CASE e.pjeanp 
WHEN ''             '' THEN NULL ELSE e.pjeanp 
END, IFNULL(e.pjeanp, ''0000000000000''))), 13), '' '', ''''), 13) cod_barras,
idqty,ihsurf
from ma4620ef04.SRBISH h
inner join ma4620ef04.SRBISD d
on ihinvn=idinvn and ihcuno=idcuno
inner join ma4620ef04.SRBEAN e
on d.idprdc=e.pjprdc
where idcca1=''99610'' and ihtypp=1 and ididat>=''20130304''')
    
update p set p.cantidad_surtida=cast(isnull(r.surtido,0) as int)
from dbo.pedidos_servidor_ftp p 
inner join cat_tiendas_casa_ley t on p.cuenta=SUBSTRING(t.cliente,2,6) 
left join dbo.respuestas_casaley r on p.codigo=r.IDPRDC 
and p.cod_barras=r.COD_BARRAS and substring(r.ihcuno,2,6)=p.cuenta and r.sucursal=p.sucursal
where p.nombre='fcasaly' and  codigo not in('0000000') 
select * from respuestas_casaley

END
GO
