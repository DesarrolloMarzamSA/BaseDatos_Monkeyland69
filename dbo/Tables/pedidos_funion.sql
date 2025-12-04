CREATE TABLE [dbo].[pedidos_funion] (
    [sucursal]         INT          NOT NULL,
    [letra]            VARCHAR (1)  NULL,
    [cuenta]           VARCHAR (5)  NOT NULL,
    [cod_barras]       VARCHAR (13) NULL,
    [codigo]           VARCHAR (12) NOT NULL,
    [pedido]           VARCHAR (10) NOT NULL,
    [cantidad_surtida] INT          NULL,
    [cantidad_pedida]  INT          NOT NULL,
    [arch_cliente]     VARCHAR (20) NOT NULL,
    [hora_resp_tandem] DATETIME     NULL,
    [arch_tandem]      VARCHAR (20) NULL,
    [rftp]             VARCHAR (1)  NULL,
    [tftp]             DATETIME     NULL,
    [hash_md5]         VARCHAR (50) NULL,
    [orden]            INT          NOT NULL,
    [mostrador]        VARCHAR (6)  NULL,
    [descripcion]      VARCHAR (30) NULL,
    CONSTRAINT [PK__pedidos_funion__3B01A16B] PRIMARY KEY CLUSTERED ([sucursal] ASC, [cuenta] ASC, [pedido] ASC, [codigo] ASC, [cantidad_pedida] ASC, [orden] ASC) WITH (FILLFACTOR = 90)
);


GO

CREATE TRIGGER union_agrega_sucursal ON pedidos_funion
 AFTER INSERT  
 AS  
 BEGIN  
	Declare @sucursal int,
			@cuenta_ibs varchar(10),
			@cuenta_union varchar(10);
	
    UPDATE pedidos_funion
     SET sucursal=isnull((SELECT top 1 sucursal FROM cat_cuentas_funion where cliente=inserted.cuenta),0),
		 codigo=isnull((select top 1 codigo from [capa_ibs].[dbo].[maestro_productos] where cod_barras=RIGHT(REPLICATE('0',13)+inserted.cod_barras,13) order by codigo),0)
		FROM pedidos_funion as A 
		INNER JOIN inserted 
		 ON A.cuenta=inserted.cuenta
		 and A.codigo=inserted.codigo
		 and A.pedido=inserted.pedido
		 and A.cantidad_pedida=inserted.cantidad_pedida
		 and A.orden=inserted.orden	
	
	insert into pedidos_funion_auditoria_insert
				([sucursal],[letra],[cuenta],[cod_barras],[codigo],[pedido],[cantidad_surtida],[cantidad_pedida]
				,[arch_cliente],[hora_resp_tandem],[arch_tandem],[rftp],[tftp],[hash_md5],[orden],[mostrador],[descripcion])
	select [sucursal],[letra],[cuenta],[cod_barras],[codigo],[pedido],[cantidad_surtida],[cantidad_pedida]
				,[arch_cliente],[hora_resp_tandem],[arch_tandem],[rftp],[tftp],[hash_md5],[orden],[mostrador],[descripcion]
	from inserted
	
 END

GO


 create TRIGGER union_audita_borrados ON pedidos_funion
 AFTER DELETE
 AS  
 BEGIN  
	insert into pedidos_funion_auditoria_delete
				([sucursal],[letra],[cuenta],[cod_barras],[codigo],[pedido],[cantidad_surtida],[cantidad_pedida]
				,[arch_cliente],[hora_resp_tandem],[arch_tandem],[rftp],[tftp],[hash_md5],[orden],[mostrador],[descripcion])
	select [sucursal],[letra],[cuenta],[cod_barras],[codigo],[pedido],[cantidad_surtida],[cantidad_pedida]
				,[arch_cliente],[hora_resp_tandem],[arch_tandem],[rftp],[tftp],[hash_md5],[orden],[mostrador],[descripcion]
	from deleted
	
 END

GO

