
	create procedure [dbo].[SP_ListaFacturas2] 
    	@factura nvarchar(50)
     as
       begin
	   insert into [monkeyland].[dbo].[superisste3]
	    exec  SP_LlenadoSuperisstefactura  @factura
		select * from  [monkeyland].[dbo].[superisste3] where Factura = @factura 
		delete [monkeyland].[dbo].[superisste2] 
		end

GO

