import 'package:flutter/material.dart';

/// Helper class para detectar tipo de dispositivo
class DeviceHelper {
  /// Detecta se é Wear OS (relógio redondo)
  static bool isWearOS(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Wear OS típico: < 300px width, < 350px height, aspecto próximo a 1:1
    return size.width < 300 && size.height < 350;
  }

  /// Detecta se é tela pequena (smartphone pequeninino)
  static bool isSmallScreen(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.width < 400;
  }

  /// Detecta se é tela redonda (Wear OS)
  static bool isRoundScreen(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final diff = (size.width - size.height).abs();
    return diff < 30 && size.shortestSide < 350;
  }

  /// Retorna padding adaptativo
  static EdgeInsets getAdaptivePadding(BuildContext context) {
    if (isWearOS(context)) {
      return const EdgeInsets.all(8);
    } else if (isSmallScreen(context)) {
      return const EdgeInsets.all(12);
    }
    return const EdgeInsets.all(16);
  }

  /// Retorna font size adaptativo
  static double getAdaptiveFontSize(BuildContext context, double defaultSize) {
    if (isWearOS(context)) {
      return defaultSize * 0.7;
    } else if (isSmallScreen(context)) {
      return defaultSize * 0.85;
    }
    return defaultSize;
  }

  /// Retorna altura adaptativa de botões
  static double getAdaptiveButtonHeight(BuildContext context) {
    if (isWearOS(context)) return 36;
    if (isSmallScreen(context)) return 42;
    return 50;
  }
}
