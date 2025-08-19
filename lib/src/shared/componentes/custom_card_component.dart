import 'package:flutter/material.dart';

/// Componente personalizado de tarjeta blanca con esquinas redondeadas
/// Adaptable para contener cualquier cantidad de widgets o elementos
class CustomCardComponent extends StatelessWidget {
  /// Contenido de la tarjeta
  final Widget child;
  
  /// Padding interno de la tarjeta
  final EdgeInsetsGeometry? padding;
  
  /// Margen externo de la tarjeta
  final EdgeInsetsGeometry? margin;
  
  /// Ancho de la tarjeta (null = ancho automático)
  final double? width;
  
  /// Alto de la tarjeta (null = alto automático)
  final double? height;
  
  /// Radio de las esquinas redondeadas
  final double borderRadius;
  
  /// Elevación de la sombra
  final double elevation;
  
  /// Color de la sombra
  final Color? shadowColor;
  
  /// Color del borde (opcional)
  final Color? borderColor;
  
  /// Ancho del borde (opcional)
  final double? borderWidth;
  
  /// Color de fondo (por defecto blanco)
  final Color? backgroundColor;
  
  /// Función de callback al tocar la tarjeta (opcional)
  final VoidCallback? onTap;
  
  /// Función de callback al mantener presionada la tarjeta (opcional)
  final VoidCallback? onLongPress;
  
  /// Indica si la tarjeta es clickeable
  final bool isClickable;

  const CustomCardComponent({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.borderRadius = 12.0,
    this.elevation = 4.0,
    this.shadowColor,
    this.borderColor,
    this.borderWidth,
    this.backgroundColor,
    this.onTap,
    this.onLongPress,
    this.isClickable = false,
  });

  @override
  Widget build(BuildContext context) {
    // Widget base de la tarjeta
    Widget cardWidget = Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        border: borderColor != null && borderWidth != null
            ? Border.all(
                color: borderColor!,
                width: borderWidth!,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: shadowColor ?? Colors.black.withValues(alpha: 0.1),
            blurRadius: elevation,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16.0),
        child: child,
      ),
    );

    // Si la tarjeta es clickeable, envolver en GestureDetector
    if (isClickable && (onTap != null || onLongPress != null)) {
      return GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: cardWidget,
      );
    }

    return cardWidget;
  }
}

/// Extensión para facilitar la creación de tarjetas con estilos predefinidos
extension CustomCardComponentExtension on CustomCardComponent {
  /// Tarjeta con estilo de información
  static CustomCardComponent info({
    Key? key,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? width,
    double? height,
    VoidCallback? onTap,
    required Widget child,
  }) {
    return CustomCardComponent(
      key: key,
      padding: padding,
      margin: margin,
      width: width,
      height: height,
      borderRadius: 16.0,
      elevation: 6.0,
      shadowColor: Colors.blue.withValues(alpha: 0.15),
      onTap: onTap,
      isClickable: onTap != null,
      child: child,
    );
  }

  /// Tarjeta con estilo de acción
  static CustomCardComponent action({
    Key? key,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? width,
    double? height,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return CustomCardComponent(
      key: key,
      padding: padding,
      margin: margin,
      width: width,
      height: height,
      borderRadius: 20.0,
      elevation: 8.0,
      shadowColor: Colors.green.withValues(alpha: 0.2),
      onTap: onTap,
      isClickable: true,
      child: child,
    );
  }

  /// Tarjeta con estilo minimalista
  static CustomCardComponent minimal({
    Key? key,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? width,
    double? height,
    required Widget child,
  }) {
    return CustomCardComponent(
      key: key,
      padding: padding,
      margin: margin,
      width: width,
      height: height,
      borderRadius: 8.0,
      elevation: 2.0,
      shadowColor: Colors.black.withValues(alpha: 0.05),
      child: child,
    );
  }
}
