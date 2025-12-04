CREATE VIEW dbo.vw_fes_sucursal_correcta
AS
SELECT     t1.sucursal, t1.cliente, dbo.fn_digito_verificador(t1.cliente) AS digito_verificador, t1.serie, t1.factura, CONVERT(datetime, t1.fechaprog) AS fecha_factura, 
                      RIGHT(t2.codigos, 7) AS codigo, t3.descripcion, RIGHT('0000000000000' + RTRIM(LTRIM(t3.cod_barras)), 13) AS Expr1, t2.clas_fis, 
                      t2.cant_ped AS piezas_surtidas_con_cargo, 0 AS piezas_surtidas_sin_cargo, t2.prec_farm AS precio_farm_sin_imp, t2.prec_pub AS precio_pub_sin_imp, 
                      t2.prec_pub * (1 + CONVERT(money, CONVERT(money, t2.def_iva) / 10000)) AS precio_pub_con_imp, t2.prec_farm * t2.cant_ped AS importe_bruto, CONVERT(money, 
                      t2.porcentaje) / 100 AS porcentaje_descto_oferta, dbo.fn_redondearas(CONVERT(money, CONVERT(money, t2.prec_farm * CONVERT(money, CONVERT(money, 
                      t2.porcentaje) / 10000)) * t2.cant_ped), 2) AS descto_oferta, CONVERT(money, t2.desc_base) / 100 AS porcentaje_descto_comercial, 
                      dbo.fn_redondearas((CONVERT(money, t2.prec_farm * CONVERT(money, CONVERT(money, t2.desc_base) / 10000)) - CONVERT(money, 
                      t2.prec_farm * CONVERT(money, CONVERT(money, t2.desc_base) / 10000)) * CONVERT(money, CONVERT(money, t2.porcentaje) / 10000)) * t2.cant_ped, 2) 
                      AS descto_comercial, 0 AS ieps, dbo.fn_redondearas((t2.prec_farm - t2.prec_farm * CONVERT(money, t2.porcentaje) / 10000) * CONVERT(money, t2.def_iva) 
                      / 10000 * t2.cant_ped, 2) AS iva, dbo.fn_redondearas((t2.prec_farm - t2.prec_farm * CONVERT(money, t2.porcentaje) / 10000) * CONVERT(money, t2.def_iva) 
                      / 10000 * CONVERT(money, t2.desc_base) / 10000 * t2.cant_ped, 2) AS bonificacion_iva, dbo.fn_redondearas((t2.prec_pub - (t2.prec_farm - CONVERT(money, 
                      t2.prec_farm * CONVERT(money, CONVERT(money, t2.porcentaje) / 10000)))) / t2.prec_pub * 100, 2) AS porcentaje_utilidad, 
                      dbo.fn_redondearas(((((t2.prec_farm - t2.prec_farm * CONVERT(money, t2.porcentaje) / 10000) - (t2.prec_farm - t2.prec_farm * CONVERT(money, t2.porcentaje) / 10000) 
                      * CONVERT(money, t2.desc_base) / 10000) + (t2.prec_farm - t2.prec_farm * CONVERT(money, t2.porcentaje) / 10000) * CONVERT(money, t2.def_iva) / 10000) 
                      - (t2.prec_farm - t2.prec_farm * CONVERT(money, t2.porcentaje) / 10000) * CONVERT(money, t2.def_iva) / 10000 * CONVERT(money, t2.desc_base) / 10000) 
                      * t2.cant_ped, 2) AS importe_neto, RIGHT(REPLACE(t1.orden, ' ', ''), 10) AS orden, CONVERT(money, t2.def_iva / 100) AS porcentaje_iva, '00000' AS filler, 
                      0 AS no_registro, dbo.fn_redondearas((CONVERT(money, t2.prec_farm * CONVERT(money, CONVERT(money, t2.desc_base) / 10000)) - CONVERT(money, 
                      t2.prec_farm * CONVERT(money, CONVERT(money, t2.desc_base) / 10000)) * CONVERT(money, CONVERT(money, t2.porcentaje) / 10000)) * t2.cant_ped, 2) 
                      AS desc_comerc_prod, 0 AS porcentaje_iva2, 0 AS iva2, 0 AS bonificacion_iva2, 0 AS porcentaje_ieps, 0 AS desc_comerc_ieps, 0 AS iva_del_iesps, 
                      0 AS bonificacion_iva_del_iesps, CURRENT_TIMESTAMP AS timestamp, t1.segto, t1.ctepadre, LEFT(t5.rfc + '             ', 13) AS rfc, 'R' AS tipo_documento, t1.folio_fiscal, 
                      t1.fecha_tandem
FROM         Historica.dbo.encabezado_benavides AS t1 WITH (nolock) INNER JOIN
                      Historica.dbo.detalle_benavides AS t2 WITH (nolock) ON t1.sucursal = t2.sucursal AND t1.serie = t2.serie AND t1.factura = t2.factura AND 
                      t2.dest_det = 'AAA' INNER JOIN
                      capa_ibs.dbo.maestro_productos_baan AS t3 WITH (nolock) ON t2.codigos = '00' + t3.codigo INNER JOIN
                      capa_ibs.dbo.clientes_baan AS t5 WITH (nolock) ON t1.sucursal = t5.sucursal AND t1.cliente = t5.cliente
WHERE     (t1.fechaprog >= DATEADD(dd, - 1, CONVERT(datetime, GETDATE(), 112)))

GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'  End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_fes_sucursal_correcta';


GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_fes_sucursal_correcta';


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
         Begin Table = "t1"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 198
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "t2"
            Begin Extent = 
               Top = 6
               Left = 236
               Bottom = 125
               Right = 396
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "t3"
            Begin Extent = 
               Top = 6
               Left = 434
               Bottom = 125
               Right = 635
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "t5"
            Begin Extent = 
               Top = 6
               Left = 673
               Bottom = 125
               Right = 846
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
      Begin ColumnWidths = 10
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
 ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_fes_sucursal_correcta';


GO

