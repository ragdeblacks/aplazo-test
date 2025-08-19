import 'package:flutter/material.dart';

class StyleSize {
  /// Calcula el ancho basado en porcentaje de la pantalla
  /// Considera SafeArea automáticamente
  static double widthPorcent(BuildContext context, double porcentaje) {
    final consultaMedia = MediaQuery.of(context);
    final areaSegura = consultaMedia.padding;
    final anchoPantalla = consultaMedia.size.width;
    final anchoSeguro = anchoPantalla - areaSegura.left - areaSegura.right;
    
    return (anchoSeguro * porcentaje) / 100;
  }

  /// Calcula la altura basada en porcentaje de la pantalla
  /// Considera SafeArea automáticamente
  static double heightPorcent(BuildContext context, double porcentaje) {
    final consultaMedia = MediaQuery.of(context);
    final areaSegura = consultaMedia.padding;
    final alturaPantalla = consultaMedia.size.height;
    final alturaSegura = alturaPantalla - areaSegura.top - areaSegura.bottom;
    
    return (alturaSegura * porcentaje) / 100;
  }

  /// Obtiene el ancho total de la pantalla
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Obtiene la altura total de la pantalla
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Obtiene el ancho seguro (sin SafeArea)
  static double safeWidth(BuildContext context) {
    final consultaMedia = MediaQuery.of(context);
    final areaSegura = consultaMedia.padding;
    return consultaMedia.size.width - areaSegura.left - areaSegura.right;
  }

  /// Obtiene la altura segura (sin SafeArea)
  static double safeHeight(BuildContext context) {
    final consultaMedia = MediaQuery.of(context);
    final areaSegura = consultaMedia.padding;
    return consultaMedia.size.height - areaSegura.top - areaSegura.bottom;
  }

  /// Calcula el padding horizontal basado en porcentaje
  static EdgeInsets horizontalPadding(BuildContext context, double porcentaje) {
    final padding = widthPorcent(context, porcentaje);
    return EdgeInsets.symmetric(horizontal: padding);
  }

  /// Calcula el padding vertical basado en porcentaje
  static EdgeInsets verticalPadding(BuildContext context, double porcentaje) {
    final padding = heightPorcent(context, porcentaje);
    return EdgeInsets.symmetric(vertical: padding);
  }

  /// Calcula el padding completo basado en porcentaje
  static EdgeInsets allPadding(BuildContext context, double porcentaje) {
    final horizontal = widthPorcent(context, porcentaje);
    final vertical = heightPorcent(context, porcentaje);
    return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
  }

  /// Calcula el margin basado en porcentaje
  static EdgeInsets margin(BuildContext context, double porcentaje) {
    final margen = widthPorcent(context, porcentaje);
    return EdgeInsets.all(margen);
  }

  /// Calcula el border radius basado en porcentaje del ancho
  static double borderRadius(BuildContext context, double porcentaje) {
    return widthPorcent(context, porcentaje);
  }

  /// Calcula el tamaño de fuente responsivo
  static double fontSize(BuildContext context, double porcentaje) {
    return widthPorcent(context, porcentaje);
  }

  /// Calcula el espaciado entre elementos basado en porcentaje
  static double spacing(BuildContext context, double porcentaje) {
    return heightPorcent(context, porcentaje);
  }

  /// Obtiene el tamaño de icono responsivo
  static double iconSize(BuildContext context, double porcentaje) {
    return widthPorcent(context, porcentaje);
  }

  /// Calcula el ancho máximo para un elemento
  static double maxWidth(BuildContext context, double porcentaje) {
    return widthPorcent(context, porcentaje);
  }

  /// Calcula la altura máxima para un elemento
  static double maxHeight(BuildContext context, double porcentaje) {
    return heightPorcent(context, porcentaje);
  }

  /// Calcula el ancho mínimo para un elemento
  static double minWidth(BuildContext context, double porcentaje) {
    return widthPorcent(context, porcentaje);
  }

  /// Calcula la altura mínima para un elemento
  static double minHeight(BuildContext context, double porcentaje) {
    return heightPorcent(context, porcentaje);
  }
}
