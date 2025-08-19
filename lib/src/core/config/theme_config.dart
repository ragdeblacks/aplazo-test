import 'package:flutter/material.dart';

/// Colores extraídos de la imagen "aplazo" y paleta de la aplicación
class ColoresApp {
  // Colores extraídos de la imagen "aplazo"
  static const Color azulAplazo = Color(0xFF87CEEB); // Azul claro de la imagen
  static const Color azulAplazoClaro = Color(0xFFB0E0E6); // Versión más clara
  static const Color azulAplazoOscuro = Color(0xFF5F9EA0); // Versión más oscura
  
  // Colores del grid/reja
  static const Color colorGridLineas = Color(0xFF2F4F4F); // Gris azulado oscuro para líneas
  static const Color colorGridFondo = Color(0xFF000000); // Negro para fondo del grid
  
  // Colores de la aplicación
  static const Color verdeEntorno = Color(0xFF00EEFB); // Color #00EEFB especificado
  static const Color grisInferior = Color(0xFF2F2F2F); // Gris oscuro inferior

  // Colores para títulos y texto con mejor contraste
  static const Color tituloPrincipal = Color(0xFFFFFFFF); // Blanco para títulos principales
  static const Color tituloSecundario = Color(0xFFE0E0E0); // Gris claro para subtítulos
  static const Color tituloSeccion = Color(0xFF1A1A1A); // Negro suave para títulos de sección
  static const Color textoContraste = Color(0xFF2C3E50); // Azul oscuro para texto que debe contrastar
  
  // Colores de fondo y transparencias
  static const Color transparente = Colors.transparent;
  static const Color fondoBlur = Color(0x26000000); // Negro con alpha 0.15
  static const Color fondoPill = Color(0x2EFFFFFF); // Blanco con alpha 0.18
  static const Color bordePill = Color(0x33FFFFFF); // Blanco con alpha 0.2
  
  // Colores de sombras
  static const Color sombraSuave = Color(0x1A000000); // Negro con alpha 0.1
  static const Color sombraMedia = Color(0x26000000); // Negro con alpha 0.15
  static const Color sombraFuerte = Color(0x1F000000); // Negro con alpha 0.12
  
  // Colores de botones
  static const Color botonBusqueda = Color(0xFFFB8C00); // Naranja [600]
  static const Color botonBusquedaTexto = Colors.white;
  static const Color botonSecundario = Colors.white;
  static const Color botonSecundarioTexto = Color(0xFF424242); // Black87
  
  // Colores de estado
  static const Color favorito = Colors.red;
  static const Color? noFavorito = null; // Para usar con operador ternario
  
  // Colores de categorías
  static const Color categoriaCarne = Color(0xFFE3F2FD); // Azul [100]
  static const Color categoriaCarneTexto = Color(0xFF1565C0); // Azul [800]
  static const Color categoriaPescado = Color(0xFFE8F5E8); // Verde [100]
  static const Color categoriaPescadoTexto = Color(0xFF2E7D32); // Verde [800]
  static const Color categoriaPollo = Color(0xFFFFF3E0); // Naranja [100]
  static const Color categoriaPolloTexto = Color(0xFFF57C00); // Naranja [400]
  static const Color categoriaVegetariano = Color(0xFFF3E5F5); // Púrpura [100]
  static const Color categoriaVegetarianoTexto = Color(0xFF8E24AA); // Púrpura [600]
  
  // Colores de botones de acción
  static const Color botonVolver = Color(0xFF1976D2); // Azul [600]
  static const Color botonVolverTexto = Colors.white;
  
  // Colores de texto y elementos
  static const Color textoGrisClaro = Color(0xFFE0E0E0); // Grey [300]
  static const Color textoGrisMedio = Color(0xFF757575); // Grey [600]
  static const Color textoGrisOscuro = Color(0xFF9E9E9E); // Grey [400]
  static const Color textoGris = Colors.grey;
  
  // Colores de error y estados
  static const Color error = Colors.red;
  static const Color exito = Colors.green;
  static const Color advertencia = Colors.orange;
  static const Color informacion = Colors.blue;
}
