
CREATE --	CREATE	--	DROP
PROCEDURE usp_lab_sanofi_puebla_detalle_sanofi
@fecha VARCHAR(10)
AS

/*
execute usp_lab_sanofi_puebla_detalle_sanofi '2012-01-05'
*/

IF(SELECT COUNT(*) FROM sys.sysobjects WHERE name = 'lab_sanofi_detalle')=0
BEGIN
	CREATE --	DROP	--	TRUNCATE
	TABLE 
	lab_sanofi_detalle (
/*		fecha				DATE					,
		sucursal		TINYINT				,
		factura			varchar(8)		,
		codigos			VARCHAR(9)		,
		dest_det		VARCHAR(3)		,
		cant_ped		INT						,
		cant_surt		INT						,
		prec_farm		money					,
		prec_pub		money					,		
		timestamp		DATETIME			*/
	fecha					date				NOT	NULL,
	sucursal			tinyint			NOT	NULL,
	factura				char(8)			NOT	NULL,
	--serie					char(2)			NOT	NULL,
	ubicacion			char(6)			NOT	NULL,
	pichonera			char(4)			NULL,
	codigos				char(9)			NOT	NULL,
	cant_ped			int					NOT	NULL,
	cant_surt			int					NULL,
	cant_base			int					NULL,
	cant_ofert		int					NULL,
	clas_fis_r		char(2)			NULL,
	prec_farm			money				NULL,
	prec_pub			money				NULL,
	num_fol				char(8)			NULL,
	agru_sep			char(1)			NULL,
	clas_fis			char(2)			NULL,
	id_prog				char(1)			NULL,
	validas				char(1)			NULL,
	poss					char(1)			NULL,
	netos					char(1)			NULL,
	fol_ctl				char(8)			NULL,
	dest_det			char(3)			NULL,
	nom_prod			char(15)		NULL,
	tipo_grup			char(1)			NULL,
	real_s_cos		char(2)			NULL,
	pcosto				money				NULL,
	pfarm_inv			money				NULL,
	seg_oferta		char(5)			NULL,
	pzaofercos		char(7)			NULL,
	tipo_ofert		char(1)			NULL,
	proveedor			char(4)			NULL,
	porcentaje		real				NULL,
	cant_real			int					NULL,
	desc_base			char(4)			NULL,
	canc_ofer			char(1)			NULL,
	prec_inc_p		char(1)			NULL,
	ubi_bodega		char(10)		NULL,
	emp_origin		char(4)			NULL,
	bul_emp				char(5)			NULL,
	lote1					char(7)			NULL,
	lote2					char(7)			NULL,
	lote3					char(7)			NULL,
	tipo_grupo		char(1)			NULL,
	ofedel_dis		char(7)			NULL,
	ofede_ret			char(7)			NULL,
	def_iva				char(4)			NULL,
	negado_nvo		char(1)			NULL,
	imp_nota_v		char(5)			NULL,
	filler				char(2)			NULL,
	timestamp			datetime		NULL,
		
		PRIMARY KEY (sucursal, factura, codigos, cant_ped)
		)
END

IF(SELECT COUNT(*) FROM lab_sanofi_detalle WHERE fecha = CONVERT(DATE,@fecha, 121))=0
BEGIN
	INSERT INTO lab_sanofi_detalle
	SELECT 
		e.fechaprog			fecha	,
		d.sucursal			,
		d.factura				,
		--d.serie					,
		d.ubicacion			,
		d.pichonera			,
		d.codigos				,
		d.cant_ped			,
		d.cant_surt			,
		d.cant_base			,
		d.cant_ofert		,
		d.clas_fis_r		,
		d.prec_farm			,
		d.prec_pub			,
		d.num_fol				,
		d.agru_sep			,
		d.clas_fis			,
		d.id_prog				,
		d.validas				,
		d.poss					,
		d.netos					,
		d.fol_ctl				,
		d.dest_det			,
		d.nom_prod			,
		d.tipo_grup			,
		d.real_s_cos		,
		d.pcosto				,
		d.pfarm_inv			,
		d.seg_oferta		,
		d.pzaofercos		,
		d.tipo_ofert		,
		d.proveedor			,
		d.porcentaje		,
		d.cant_real			,
		d.desc_base			,
		d.canc_ofer			,
		d.prec_inc_p		,
		d.ubi_bodega		,
		d.emp_origin		,
		d.bul_emp				,
		d.lote1					,
		d.lote2					,
		d.lote3					,
		d.tipo_grupo		,
		d.ofedel_dis		,
		d.ofede_ret			,
		d.def_iva				,
		d.negado_nvo		,
		d.imp_nota_v		,
		d.filler				,
		d.timestamp		
	FROM encabezado e
	INNER JOIN detalle d ON 
		d.sucursal = e.sucursal AND 
		d.factura = e.factura
	INNER JOIN lab_sanofi_cat_productos ps ON 
		ps.codigo = SUBSTRING(d.codigos, 3, 9 )
	WHERE E.fechaprog = CONVERT(SMALLDATETIME, @fecha, 121)
END

--SELECT * FROM lab_sanofi_detalle

GO

