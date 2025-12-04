CREATE VIEW dbo.encabezado_soriana
AS
SELECT     CONVERT(DATE, e.fechaprog) AS fechaprog, e.sucursal, e.factura, e.cliente, 
                      CASE WHEN e.fechaprog < s.fecha_fusion THEN s.serie_cfd_old ELSE s.serie_cfd END AS serie_cfd, e.folio_fiscal, e.farmacia, CONVERT(DATE, e.fecha_tandem) 
                      AS fecha_tandem, c.cliente_ibs, r.numTienda, e.orden, e.segto, e.ctepadre, e.timestamp, c.rfc, s.IATA
FROM         Historica.dbo.encabezado_soriana AS e WITH (nolock) INNER JOIN
                      dbo.sucursales AS s WITH (nolock) ON s.sucursal = e.sucursal INNER JOIN
                      dbo.clientes_baan AS c WITH (nolock) ON c.sucursal = e.sucursal AND c.cliente = e.cliente LEFT OUTER JOIN
                      dbo.CatTiendasSoriana AS r ON r.sucursal = e.sucursal AND r.cliente = e.cliente
WHERE     (e.fechaprog >= CONVERT(SMALLDATETIME, '2010-08-01', 121)) AND (e.segto = 'E1') AND (e.ctepadre IN ('044', '032')) AND (e.cliente NOT IN ('99044', '99032')) AND 
                      (e.farmacia NOT LIKE '%ISSSTE%')

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
         Begin Table = "s"
            Begin Extent = 
               Top = 6
               Left = 236
               Bottom = 125
               Right = 400
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "c"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 245
               Right = 211
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "r"
            Begin Extent = 
               Top = 126
               Left = 249
               Bottom = 245
               Right = 409
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "e"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 198
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'encabezado_soriana';


GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'encabezado_soriana';


GO

