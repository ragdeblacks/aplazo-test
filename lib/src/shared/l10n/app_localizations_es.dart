// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Cocinando con Flow';

  @override
  String get bienvenidoTitulo => '¡Bienvenido a Cocinando con Flow!';

  @override
  String bienvenidoDescripcion(String environment) {
    return 'La aplicación está configurada para el environment: $environment';
  }

  @override
  String get sistemaFlavorsTitulo => '✅ Sistema de Flavors';

  @override
  String get sistemaFlavorsDescripcion =>
      'Development, Staging y Production configurados';

  @override
  String get configuracionEnvironmentTitulo => '✅ Configuración de Environment';

  @override
  String get configuracionEnvironmentDescripcion =>
      'URLs de API, logging y analytics por flavor';

  @override
  String get temasDinamicosTitulo => '✅ Temas Dinámicos';

  @override
  String get temasDinamicosDescripcion =>
      'Colores y estilos adaptados por environment';

  @override
  String get configuracionBaseDatosTitulo => '✅ Configuración de Base de Datos';

  @override
  String get configuracionBaseDatosDescripcion =>
      'Parámetros optimizados por environment';

  @override
  String get sistemaLoggingTitulo => '✅ Sistema de Logging';

  @override
  String get sistemaLoggingDescripcion =>
      'Configuración adaptativa por environment';

  @override
  String get informacionBuildTitulo => 'Información del Build:';

  @override
  String version(String version) {
    return 'Versión: $version';
  }

  @override
  String build(String build) {
    return 'Build: $build';
  }

  @override
  String environment(String environment) {
    return 'Environment: $environment';
  }

  @override
  String logging(String estado) {
    return 'Logging: $estado';
  }

  @override
  String analytics(String estado) {
    return 'Analytics: $estado';
  }

  @override
  String get habilitado => 'Habilitado';

  @override
  String get deshabilitado => 'Deshabilitado';

  @override
  String api(String url) {
    return 'API: $url';
  }

  @override
  String get aplicacionIniciando => '💡 Aplicación iniciando...';

  @override
  String get recetasTitulo => 'Recetas';

  @override
  String get recetasDescripcion => 'Descubre deliciosas recetas';

  @override
  String get recetaNoEncontrada => 'Receta no encontrada';

  @override
  String get ingredientes => 'Ingredientes';

  @override
  String get instrucciones => 'Instrucciones';

  @override
  String get agregarFavoritos => 'Agregar a favoritos';

  @override
  String get quitarFavoritos => 'Quitar de favoritos';

  @override
  String get favoritos => 'Favoritos';

  @override
  String get buscarRecetas => 'Buscar recetas';

  @override
  String get buscarPlaceholder => 'Buscar por nombre de receta...';

  @override
  String get sinResultados => 'No se encontraron resultados';

  @override
  String get cargando => 'Cargando...';

  @override
  String get errorCargar => 'Error al cargar';

  @override
  String get reintentar => 'Reintentar';

  @override
  String get detalleReceta => 'Detalle de receta';

  @override
  String get categoria => 'Categoría';

  @override
  String get area => 'Área';

  @override
  String get tiempoPreparacion => 'Tiempo de preparación';

  @override
  String get dificultad => 'Dificultad';

  @override
  String get porciones => 'Porciones';

  @override
  String get homeHeaderTitulo => 'Cocinando';

  @override
  String get homeHeaderSubtitulo => 'Con Flow';

  @override
  String get homeNoRecetas => 'No hay recetas';

  @override
  String get homeMostrarMas => 'Mostrar más recetas';

  @override
  String get homePlaceholderImagen => 'https://via.placeholder.com/80x80';

  @override
  String get homeBotonBusqueda => 'Búsqueda';

  @override
  String get homeErrorCargar => 'Error al cargar recetas';

  @override
  String get busquedaHintText => 'Buscar recetas...';

  @override
  String get busquedaNoResultados => 'No se encontraron recetas';

  @override
  String get busquedaIngresarTermino => 'Ingresa un término para buscar';

  @override
  String get busquedaPlaceholderImagen => 'https://via.placeholder.com/80x80';

  @override
  String get busquedaInvitacion => '¿Qué tal si buscas tu receta favorita?';

  @override
  String get busquedaNoExiste =>
      'Parece que esa receta no existe, revisa si el nombre es correcto.';

  @override
  String get detalleTitulo => 'Detalle de Receta';

  @override
  String get detalleVolverListado => 'Volver al listado';

  @override
  String get detallePlaceholderImagen => 'https://via.placeholder.com/80x80';

  @override
  String get errorNoConexion => 'No hay conexión a internet';

  @override
  String get errorRecetaNoEncontrada => 'Receta no encontrada';

  @override
  String errorCargarDetalle(String error) {
    return 'Error al cargar detalle: $error';
  }

  @override
  String errorAgregarFavoritos(String error) {
    return 'Error al agregar a favoritos: $error';
  }

  @override
  String errorQuitarFavoritos(String error) {
    return 'Error al quitar de favoritos: $error';
  }

  @override
  String errorBusqueda(String error) {
    return 'Error en búsqueda: $error';
  }
}
