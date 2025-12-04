/*or 
t(1.fuente ='baan' and t1.codigo_int >= 7000000)*/
CREATE VIEW dbo.maestro_productos_baan
AS
SELECT        t1.codigo, t1.cod_barras, t1.descripcion, t1.desc_corta, t1.grupo_est, t1.clas_fis, t1.clas_ssa, t1.clas_abc, t1.cod_lab, t1.lab_corto, t1.lab_largo, t1.lab_rfc, 
                         t1.tipo_prod, t1.sus_act1, t1.desc_sus_act1, t1.sus_act2, t1.desc_sus_act2, ROUND(t1.prec_farm, 2, 1) AS prec_farm, ROUND(t1.prec_pub, 2, 1) AS prec_pub, 
                         ROUND(t1.p_costo, 2, 1) AS p_costo, t1.descto, t1.descto_prod, t1.iva, ISNULL(t2.refrigerado, ' ') AS refrigerado, t1.fecha_alta, t1.fecha_baja, t1.grupo_producto, 
                         t1.pzas_empaque_original, t1.status, t1.cod_barras_tandem, t1.derecho_devolucion, t1.clave_clas_promocion, t1.clas_promocion, t1.desc_grupo_est, 
                         t1.timestamp
FROM            capa_ibs.dbo.maestro_productos AS t1 WITH (nolock) LEFT OUTER JOIN
                         capa_ibs.dbo.refrigerados AS t2 WITH (nolock) ON t1.codigo = t2.codigo LEFT OUTER JOIN
                         capa_ibs.dbo.maestro_bajas AS t3 ON t1.codigo = t3.codigo
WHERE        (t1.codigo_int NOT BETWEEN 6900000 AND 700000) AND (t1.codigo NOT IN
                             (SELECT        codigo
                               FROM            capa_ibs.dbo.maestro_bajas
                               WHERE        (codigo = '2391378')))

GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'maestro_productos_baan';


GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[35] 4[4] 2[43] 3) )"
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
         Begin Table = "t1"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 231
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "t2"
            Begin Extent = 
               Top = 6
               Left = 269
               Bottom = 106
               Right = 459
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "t3"
            Begin Extent = 
               Top = 108
               Left = 269
               Bottom = 193
               Right = 459
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
      Begin ColumnWidths = 9
         Width = 284
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'maestro_productos_baan';


GO

