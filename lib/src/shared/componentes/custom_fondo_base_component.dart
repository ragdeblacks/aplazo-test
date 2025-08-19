import 'package:flutter/material.dart';
import 'package:cocinando_con_flow/src/core/config/theme_config.dart';

/// Widget personalizado para el fondo base de la aplicación
/// Incluye dos secciones: superior (verde con grid isométrico) e inferior (gris)
/// Con una reja/grid animada que palpite en la sección superior
class CustomFondoBaseComponent extends StatefulWidget {
  final Widget child;
  final bool mostrarPatron;

  const CustomFondoBaseComponent({
    super.key,
    required this.child,
    this.mostrarPatron = true,
  });

  @override
  State<CustomFondoBaseComponent> createState() => _CustomFondoBaseComponentState();
}

class _CustomFondoBaseComponentState extends State<CustomFondoBaseComponent>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            ColoresApp.verdeEntorno,
            ColoresApp.grisInferior,
          ],
          stops: [0.6, 0.6], // Separación en 60% de la altura
        ),
      ),
      child: Stack(
        children: [
          if (widget.mostrarPatron) _buildPatronIsometrico(),
          widget.child,
        ],
      ),
    );
  }

  Widget _buildPatronIsometrico() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return CustomPaint(
          painter: _PatronIsometricoPainter(
            opacity: 0.1 + (_pulseAnimation.value * 0.2), // Pulsar entre 0.1 y 0.3
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

/// CustomPainter para dibujar el grid/reja isométrico como en la imagen
class _PatronIsometricoPainter extends CustomPainter {
  final double opacity;
  
  _PatronIsometricoPainter({required this.opacity});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ColoresApp.colorGridLineas.withValues(alpha: opacity)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    
    // Tamaño de cada celda del grid isométrico
    const double cellSize = 40.0;
    
    // Solo dibujar en la sección superior (60% de la altura)
    final maxHeight = size.height * 0.6;
    
    // Dibujar líneas horizontales
    for (double y = 0; y < maxHeight; y += cellSize) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
    
    // Dibujar líneas verticales
    for (double x = 0; x < size.width; x += cellSize) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, maxHeight),
        paint,
      );
    }
    
    // Dibujar líneas diagonales para efecto isométrico (como en la imagen)
    for (double i = 0; i < size.width + maxHeight; i += cellSize) {
      // Diagonal principal (izquierda a derecha)
      canvas.drawLine(
        Offset(i, 0),
        Offset(0, i),
        paint,
      );
      
      // Diagonal secundaria (derecha a izquierda)
      canvas.drawLine(
        Offset(size.width - i, 0),
        Offset(size.width, i),
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
