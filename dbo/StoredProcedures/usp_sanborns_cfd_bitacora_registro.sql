
CREATE	--	CREATE	--	DROP
PROCEDURE [dbo].[usp_sanborns_cfd_bitacora_registro]
@serie_cfd VARCHAR(2),
@folio_fiscal VARCHAR(8),
@fecha VARCHAR(8), 
@registro VARCHAR(8), 
@remision VARCHAR(8), 
@sucursal VARCHAR(8), 
@cliente VARCHAR(8), 
@importe VARCHAR(8), 
@no_error VARCHAR(8), 
@confirmada VARCHAR(8), 
@intento VARCHAR(8), 
@msg_error VARCHAR(8), 
@archivo VARCHAR(8), 
@confirmacion VARCHAR(8) 
AS

IF(SELECT COUNT(*) FROM bitacora_sanborns_cfd WHERE serie_cfd=@serie_cfd AND folio_fiscal=@folio_fiscal)=0
INSERT INTO bitacora_sanborns_cfd (
fecha, 
registro, 
serie_cfd, 
folio_fiscal, 
remision, 
sucursal, 
cliente, 
importe, 
no_error, 
confirmada, 
intento, 
msg_error, 
archivo, 
confirmacion 
) VALUES ( 
CONVERT(DATETIME,'2012-08-17',121) , 
GETDATE(), 
'FA', '02876987', 
'', 
1, 
'', 
1189.22, 
0, 
1, 
1, 
'0.- XML enviado con Exito Numero de Control=[102390362]', 
'Factura2876987FA2012-08-17T222225.xml1',
',02390362'
)
--ELSE

GO

