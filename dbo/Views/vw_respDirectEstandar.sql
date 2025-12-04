CREATE VIEW dbo.vw_respDirectEstandar
AS
SELECT     p.sucursal, p.cuenta, p.cod_barras, p.cantidad_pedida, p.num_pedido, p.filler1, p.codigo, p.filler2, p.filler3, p.precio, p.porcentaje_oferta, p.cod_credito, 
                      p.arch_cliente, p.hash_md5, p.nombre, CASE WHEN r.estatus_resp = 'S' THEN ISNULL(r.cantidad_surtida, 0) 
                      WHEN r.estatus_resp = 'F' THEN p.cantidad_pedida - ISNULL(r.cantidad_surtida, 0) ELSE 0 END AS cantidad_surtida, ISNULL(ccl.NUM_TIENDA, 0) 
                      AS numTienda, p.orden
FROM         dbo.pedidos_servidor_ftp AS p LEFT OUTER JOIN
                      dbo.respuestas_cltestandar_Ibs AS r ON r.cuenta = p.cuenta AND r.nombre = p.nombre AND r.codigo_producto = p.codigo AND 
                      p.arch_cliente = r.arch_cliente LEFT OUTER JOIN
                      OPENQUERY(as400, 
                      'select ADNUM as cliente,admxglnc as num_tienda,ADMXNAME from MA4620EF04.MXONAD where ADADNO=2 and ADNUM in 
(SELECT nanum FROM MA4620EF04.SRONAM where NANCA1 =''99610'') and admxglnc<>''''
order by ADNUM')
                       AS ccl ON SUBSTRING(ccl.CLIENTE, 2, 200) = p.cuenta

GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[22] 4[18] 2[24] 3) )"
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
         Begin Table = "p"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 215
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "r"
            Begin Extent = 
               Top = 6
               Left = 253
               Bottom = 125
               Right = 429
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ccl"
            Begin Extent = 
               Top = 6
               Left = 467
               Bottom = 106
               Right = 619
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
      Begin ColumnWidths = 19
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_respDirectEstandar';


GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_respDirectEstandar';


GO

