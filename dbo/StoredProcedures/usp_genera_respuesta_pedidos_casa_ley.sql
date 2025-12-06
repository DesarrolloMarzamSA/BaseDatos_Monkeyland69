
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_genera_respuesta_pedidos_casa_ley]  
 @arch_cliente varchar(50),
 @hash_md5 varchar(50)

as  
 --declare @arch_cliente varchar(50)  
 --declare @hash_md5 varchar(50)  
select	'Listo' +
			'archivo' + 
			'de' + 
			'respuesta'
GO
