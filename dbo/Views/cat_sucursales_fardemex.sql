
CREATE --	DROP
VIEW [dbo].[cat_sucursales_fardemex] AS
select sucursal, cliente, farmacia, usado, limite, cliente_ibs from clientes_baan
where ctepadre = '052' AND LEFT(status, 1) <> 'B'

GO

