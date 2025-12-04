CREATE TABLE [dbo].[catalogo_maestro_farmacias_union_20130703] (
    [sucursal]         INT            NOT NULL,
    [tipo_movimiento]  VARCHAR (1)    NULL,
    [cod_barras]       VARCHAR (20)   NULL,
    [clave_proveedor]  VARCHAR (7)    NOT NULL,
    [descripcion]      VARCHAR (100)  NULL,
    [desc_corta]       VARCHAR (20)   NULL,
    [familia]          VARCHAR (2)    NULL,
    [laboratorio]      VARCHAR (40)   NULL,
    [presentacion]     VARCHAR (2)    NULL,
    [pcio_farmacia]    MONEY          NULL,
    [pcio_max_pub]     MONEY          NULL,
    [porc_iva]         DECIMAL (5, 2) NULL,
    [porc_ieps]        DECIMAL (5, 2) NULL,
    [porc_oferta]      DECIMAL (5, 2) NULL,
    [escala_oferta]    INT            NULL,
    [porc_oferta_2]    DECIMAL (5, 2) NULL,
    [escala_oferta_2]  INT            NULL,
    [porc_financiero]  DECIMAL (5, 2) NULL,
    [unid_c_cargo]     DECIMAL (7, 2) NULL,
    [unid_s_cargo]     DECIMAL (7, 2) NULL,
    [Caduca]           VARCHAR (1)    NULL,
    [Refrigeracion]    VARCHAR (1)    NULL,
    [Devolucion]       VARCHAR (1)    NULL,
    [c_ssa]            VARCHAR (1)    NULL,
    [clas_fis]         VARCHAR (10)   NULL,
    [grupo_est]        VARCHAR (10)   NULL,
    [timestamp]        SMALLDATETIME  NULL,
    [metodo]           VARCHAR (5)    NULL,
    [vigencia_inicial] DATE           NULL,
    [vigencia_final]   DATE           NULL
);


GO

