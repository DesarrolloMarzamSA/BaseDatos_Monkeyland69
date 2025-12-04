CREATE TABLE [FormatoUnion].[pedidos_Farmatodo] (
    [sucursal]         INT          NOT NULL,
    [letra]            VARCHAR (1)  NULL,
    [cuenta]           VARCHAR (6)  NOT NULL,
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


create TRIGGER  [FormatoUnion].[pedidos_Farmatodo_Auditoria_Borrados] ON [FormatoUnion].[pedidos_Farmatodo]
 AFTER DELETE
 AS  
 BEGIN  
	insert into [FormatoUnion].[pedidos_Farmatodo_Auditoria_Delete]
				([sucursal],[letra],[cuenta],[cod_barras],[codigo],[pedido],[cantidad_surtida],[cantidad_pedida]
				,[arch_cliente],[hora_resp_tandem],[arch_tandem],[rftp],[tftp],[hash_md5],[orden],[mostrador],[descripcion])
	select [sucursal],[letra],[cuenta],[cod_barras],[codigo],[pedido],[cantidad_surtida],[cantidad_pedida]
				,[arch_cliente],[hora_resp_tandem],[arch_tandem],[rftp],[tftp],[hash_md5],[orden],[mostrador],[descripcion]
	from deleted
	
 END

GO


CREATE TRIGGER [FormatoUnion].[farmatodo_agrega_sucursal] ON [FormatoUnion].[pedidos_Farmatodo]
 AFTER INSERT  
 AS  
 BEGIN  
	 
    UPDATE [FormatoUnion].[pedidos_Farmatodo]
     SET sucursal=isnull((SELECT TOP 1 sucursal FROM [dbo].[cat_farmatodo_cofar] WITH(NOLOCK) WHERE cliente = inserted.cuenta),0),--ANTES: cliente= SUBSTRING( inserted.cuenta,2,len(inserted.cuenta)-1) 
		 codigo=isnull((SELECT TOP 1 codigo from [capa_ibs].[dbo].[maestro_productos] WITH(NOLOCK) WHERE cod_barras=RIGHT(REPLICATE('0',13)+inserted.cod_barras,13) order by codigo),0)
		FROM [FormatoUnion].[pedidos_Farmatodo] as A 
		INNER JOIN inserted 
		 ON A.cuenta=inserted.cuenta
		 and A.codigo=inserted.codigo
		 and A.pedido=inserted.pedido
		 and A.cantidad_pedida=inserted.cantidad_pedida
		 and A.orden=inserted.orden	
	
	insert into [FormatoUnion].[pedidos_Farmatodo_Auditoria_Insert]
				([sucursal],[letra],[cuenta],[cod_barras],[codigo],[pedido],[cantidad_surtida],[cantidad_pedida]
				,[arch_cliente],[hora_resp_tandem],[arch_tandem],[rftp],[tftp],[hash_md5],[orden],[mostrador],[descripcion])
	select [sucursal],[letra],[cuenta],[cod_barras],[codigo],[pedido],[cantidad_surtida],[cantidad_pedida]
				,[arch_cliente],[hora_resp_tandem],[arch_tandem],[rftp],[tftp],[hash_md5],[orden],[mostrador],[descripcion]
	from inserted
	
 END

GO

