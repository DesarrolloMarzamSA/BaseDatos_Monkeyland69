
-- =============================================
-- Author:		mandrade
-- Create date: 04/06/2014
-- Description:	insertar datos bitacora Muguerza
-- =============================================
CREATE PROCEDURE [dbo].[ups_actualiza_bitacora_muguerza] 
@serie varchar(2),@folio_fiscal varchar(8),@importe money,@confirmada bit,@codigoWeb varchar(50),@msg_error varchar(255),@archivo_xml varchar(max)
AS
BEGIN
--exec [monkeyland].[dbo].ups_actualiza_bitacora_muguerza '','',0,1,'','',''	
	SET NOCOUNT OFF;
	select serie_cfd,folio_fiscal from  [monkeyland].[dbo].[bitacora_muguerza_cfdi] where serie_cfd=@serie and folio_fiscal=@folio_fiscal
	if(@@ROWCOUNT=1)
	begin
	update [monkeyland].[dbo].[bitacora_muguerza_cfdi] set [registro]=getdate(),[codigoWeb]=@codigoWeb,[msg_error]=@msg_error,[archivo_xml]=@archivo_xml
	where [serie_cfd]=@serie and [folio_fiscal]=@folio_fiscal and ltrim(rtrim(codigoWeb)) not in ('0')
		update b set b.sucursal=e.sucursal,b.cliente_ibs=e.noalta
		from  [monkeyland].[dbo].[bitacora_muguerza_cfdi] b
		inner join Historica.dbo.encabezado e on 
		replicate('0',8-len(b.folio_fiscal))+b.folio_fiscal=e.folio_fiscal and b.serie_cfd=e.serie
		where e.ctepadre='341' and b.serie_cfd=@serie and b.folio_fiscal=@folio_fiscal and ltrim(rtrim(codigoWeb)) not in ('0')
	end
	else
	begin	
   INSERT INTO [monkeyland].[dbo].[bitacora_muguerza_cfdi]
           ([registro],[serie_cfd],[folio_fiscal],[importe],[confirmada],[codigoWeb],[msg_error],[archivo_xml])
     VALUES (getdate(),@serie,@folio_fiscal,@importe,@confirmada,@codigoWeb,@msg_error,@archivo_xml)
		   
		    update b set b.sucursal=e.sucursal,b.cliente_ibs=e.noalta
			 from  [monkeyland].[dbo].[bitacora_muguerza_cfdi] b
			 inner join Historica.dbo.encabezado e on 
			 replicate('0',8-len(b.folio_fiscal))+b.folio_fiscal=e.folio_fiscal and b.serie_cfd=e.serie
			 where e.ctepadre='341' and b.serie_cfd=@serie and b.folio_fiscal=@folio_fiscal 
		   end
END

GO

