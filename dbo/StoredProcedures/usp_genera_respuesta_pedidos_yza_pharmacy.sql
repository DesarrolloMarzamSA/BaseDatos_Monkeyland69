USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_genera_respuesta_pedidos_yza_pharmacy]
	@arch_cliente varchar(50),  
	@hash_md5 varchar(50)
WITH ENCRYPTION
as
select 'Pedidos Respuestas Yza Pharmacy esta listo para entregar respuesta'
GO
