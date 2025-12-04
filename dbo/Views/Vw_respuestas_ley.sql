CREATE VIEW dbo.Vw_respuestas_ley
AS
SELECT     p.arch_cliente, p.sucursal, p.cuenta, p.cod_barras, p.cantidad_pedida - CAST(ISNULL(r.IDQTY, 0) AS int) AS surtida, p.num_pedido, '00000000' AS filler, p.codigo, 
                      '0000000000' AS filler2, '00000000000000000000' AS filler3, t.num_tienda, '217357' AS proveedor
FROM         dbo.pedidos_servidor_ftp AS p INNER JOIN
                      dbo.cat_tiendas_casa_ley AS t ON p.cuenta = SUBSTRING(t.cliente, 2, 6) INNER JOIN
                      OPENQUERY(As400, 
                      '
select substring(idarea,2,3) as sucursal,ihcuno,idprdc,
right(''0000000000000'' || replace(left(ltrim(IFNULL(CASE e.pjeanp 
WHEN ''             '' 
THEN NULL ELSE e.pjeanp 
END, IFNULL(e.pjeanp, ''0000000000000''))), 13), '' '', ''''), 13) cod_barras,
idqty,ihsurf
from ma4620ef04.SRBISH h
inner join ma4620ef04.SRBISD d
on ihinvn=idinvn and ihcuno=idcuno
inner join ma4620ef04.SRBEAN e
on d.idprdc=e.pjprdc
where ididat=''20130214'' and idcca1=''99610'' and ihtypp=1')
                       AS r ON p.codigo = r.IDPRDC AND p.cod_barras = r.COD_BARRAS AND SUBSTRING(r.IHCUNO, 2, 6) = p.cuenta
WHERE     (p.nombre = 'fcasaly')

GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Vw_respuestas_ley';


GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "t"
            Begin Extent = 
               Top = 6
               Left = 271
               Bottom = 110
               Right = 447
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "p"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 231
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "r"
            Begin Extent = 
               Top = 6
               Left = 485
               Bottom = 125
               Right = 661
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 13
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Vw_respuestas_ley';


GO

