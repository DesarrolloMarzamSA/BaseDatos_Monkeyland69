
	create
	PROCEDURE [dbo].[usp_fbenavides_pedidos_rechazos_pc]
					 
AS
BEGIN

	SELECT   distinct
		'05'   +
		RIGHT('00'+ CONVERT(VARCHAR(2),ped.sucursal),2)   +
		ped.cia   +
		ped.mostrador   +
		RIGHT(REPLICATE('0',18) + ped.cod_bena,18)   +
		RIGHT(REPLICATE('0', 6) + CONVERT(VARCHAR,cantidad_pedida),6)  +
		convert(varchar,fecha_pedido,112)    +
		RIGHT(REPLICATE('0',10) + ped.pedido,10)   +
		case when ped.cliente='00000' then '1' 
		 when ped.codigo='0000000'   then '2' end
	FROM  monkeyland..pedidos_fbenavides_ci_pc  ped   
	WHERE	ped.cliente='00000' or ped.codigo='0000000' 
	and convert(varchar,ped.timestamp,112)>=convert(varchar,getdate(),112)
	

END

GO

