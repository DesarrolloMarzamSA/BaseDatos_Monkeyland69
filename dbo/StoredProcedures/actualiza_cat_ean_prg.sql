CREATE procedure [dbo].[actualiza_cat_ean_prg]
as

delete from cat_ean_prg;
insert into cat_ean_prg
SELECT LTRIM(PJPRDC) codigo,LTRIM(PJEANP) cod_barras,PJDESC descripcion,PGSTAT estatus FROM OPENQUERY(as400,'
select PJPRDC,PJEANP,PJDESC,PGSTAT from MA4620EF04.SR1EAN
inner join MA4620EF04.SRBPRG on PJPRDC=PGPRDC
')
GO
