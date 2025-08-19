import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('es')];

  /// No description provided for @appTitle.
  ///
  /// In es, this message translates to:
  /// **'Cocinando con Flow'**
  String get appTitle;

  /// No description provided for @bienvenidoTitulo.
  ///
  /// In es, this message translates to:
  /// **'¡Bienvenido a Cocinando con Flow!'**
  String get bienvenidoTitulo;

  /// No description provided for @bienvenidoDescripcion.
  ///
  /// In es, this message translates to:
  /// **'La aplicación está configurada para el environment: {environment}'**
  String bienvenidoDescripcion(String environment);

  /// No description provided for @sistemaFlavorsTitulo.
  ///
  /// In es, this message translates to:
  /// **'✅ Sistema de Flavors'**
  String get sistemaFlavorsTitulo;

  /// No description provided for @sistemaFlavorsDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Development, Staging y Production configurados'**
  String get sistemaFlavorsDescripcion;

  /// No description provided for @configuracionEnvironmentTitulo.
  ///
  /// In es, this message translates to:
  /// **'✅ Configuración de Environment'**
  String get configuracionEnvironmentTitulo;

  /// No description provided for @configuracionEnvironmentDescripcion.
  ///
  /// In es, this message translates to:
  /// **'URLs de API, logging y analytics por flavor'**
  String get configuracionEnvironmentDescripcion;

  /// No description provided for @temasDinamicosTitulo.
  ///
  /// In es, this message translates to:
  /// **'✅ Temas Dinámicos'**
  String get temasDinamicosTitulo;

  /// No description provided for @temasDinamicosDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Colores y estilos adaptados por environment'**
  String get temasDinamicosDescripcion;

  /// No description provided for @configuracionBaseDatosTitulo.
  ///
  /// In es, this message translates to:
  /// **'✅ Configuración de Base de Datos'**
  String get configuracionBaseDatosTitulo;

  /// No description provided for @configuracionBaseDatosDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Parámetros optimizados por environment'**
  String get configuracionBaseDatosDescripcion;

  /// No description provided for @sistemaLoggingTitulo.
  ///
  /// In es, this message translates to:
  /// **'✅ Sistema de Logging'**
  String get sistemaLoggingTitulo;

  /// No description provided for @sistemaLoggingDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Configuración adaptativa por environment'**
  String get sistemaLoggingDescripcion;

  /// No description provided for @informacionBuildTitulo.
  ///
  /// In es, this message translates to:
  /// **'Información del Build:'**
  String get informacionBuildTitulo;

  /// No description provided for @version.
  ///
  /// In es, this message translates to:
  /// **'Versión: {version}'**
  String version(String version);

  /// No description provided for @build.
  ///
  /// In es, this message translates to:
  /// **'Build: {build}'**
  String build(String build);

  /// No description provided for @environment.
  ///
  /// In es, this message translates to:
  /// **'Environment: {environment}'**
  String environment(String environment);

  /// No description provided for @logging.
  ///
  /// In es, this message translates to:
  /// **'Logging: {estado}'**
  String logging(String estado);

  /// No description provided for @analytics.
  ///
  /// In es, this message translates to:
  /// **'Analytics: {estado}'**
  String analytics(String estado);

  /// No description provided for @habilitado.
  ///
  /// In es, this message translates to:
  /// **'Habilitado'**
  String get habilitado;

  /// No description provided for @deshabilitado.
  ///
  /// In es, this message translates to:
  /// **'Deshabilitado'**
  String get deshabilitado;

  /// No description provided for @api.
  ///
  /// In es, this message translates to:
  /// **'API: {url}'**
  String api(String url);

  /// No description provided for @aplicacionIniciando.
  ///
  /// In es, this message translates to:
  /// **'💡 Aplicación iniciando...'**
  String get aplicacionIniciando;

  /// No description provided for @recetasTitulo.
  ///
  /// In es, this message translates to:
  /// **'Recetas'**
  String get recetasTitulo;

  /// No description provided for @recetasDescripcion.
  ///
  /// In es, this message translates to:
  /// **'Descubre deliciosas recetas'**
  String get recetasDescripcion;

  /// No description provided for @recetaNoEncontrada.
  ///
  /// In es, this message translates to:
  /// **'Receta no encontrada'**
  String get recetaNoEncontrada;

  /// No description provided for @ingredientes.
  ///
  /// In es, this message translates to:
  /// **'Ingredientes'**
  String get ingredientes;

  /// No description provided for @instrucciones.
  ///
  /// In es, this message translates to:
  /// **'Instrucciones'**
  String get instrucciones;

  /// No description provided for @agregarFavoritos.
  ///
  /// In es, this message translates to:
  /// **'Agregar a favoritos'**
  String get agregarFavoritos;

  /// No description provided for @quitarFavoritos.
  ///
  /// In es, this message translates to:
  /// **'Quitar de favoritos'**
  String get quitarFavoritos;

  /// No description provided for @favoritos.
  ///
  /// In es, this message translates to:
  /// **'Favoritos'**
  String get favoritos;

  /// No description provided for @buscarRecetas.
  ///
  /// In es, this message translates to:
  /// **'Buscar recetas'**
  String get buscarRecetas;

  /// No description provided for @buscarPlaceholder.
  ///
  /// In es, this message translates to:
  /// **'Buscar por nombre de receta...'**
  String get buscarPlaceholder;

  /// No description provided for @sinResultados.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron resultados'**
  String get sinResultados;

  /// No description provided for @cargando.
  ///
  /// In es, this message translates to:
  /// **'Cargando...'**
  String get cargando;

  /// No description provided for @errorCargar.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar'**
  String get errorCargar;

  /// No description provided for @reintentar.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get reintentar;

  /// No description provided for @detalleReceta.
  ///
  /// In es, this message translates to:
  /// **'Detalle de receta'**
  String get detalleReceta;

  /// No description provided for @categoria.
  ///
  /// In es, this message translates to:
  /// **'Categoría'**
  String get categoria;

  /// No description provided for @area.
  ///
  /// In es, this message translates to:
  /// **'Área'**
  String get area;

  /// No description provided for @tiempoPreparacion.
  ///
  /// In es, this message translates to:
  /// **'Tiempo de preparación'**
  String get tiempoPreparacion;

  /// No description provided for @dificultad.
  ///
  /// In es, this message translates to:
  /// **'Dificultad'**
  String get dificultad;

  /// No description provided for @porciones.
  ///
  /// In es, this message translates to:
  /// **'Porciones'**
  String get porciones;

  /// No description provided for @homeHeaderTitulo.
  ///
  /// In es, this message translates to:
  /// **'Cocinando'**
  String get homeHeaderTitulo;

  /// No description provided for @homeHeaderSubtitulo.
  ///
  /// In es, this message translates to:
  /// **'Con Flow'**
  String get homeHeaderSubtitulo;

  /// No description provided for @homeNoRecetas.
  ///
  /// In es, this message translates to:
  /// **'No hay recetas'**
  String get homeNoRecetas;

  /// No description provided for @homeMostrarMas.
  ///
  /// In es, this message translates to:
  /// **'Mostrar más recetas'**
  String get homeMostrarMas;

  /// No description provided for @homePlaceholderImagen.
  ///
  /// In es, this message translates to:
  /// **'https://via.placeholder.com/80x80'**
  String get homePlaceholderImagen;

  /// No description provided for @homeBotonBusqueda.
  ///
  /// In es, this message translates to:
  /// **'Búsqueda'**
  String get homeBotonBusqueda;

  /// No description provided for @homeErrorCargar.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar recetas'**
  String get homeErrorCargar;

  /// No description provided for @busquedaHintText.
  ///
  /// In es, this message translates to:
  /// **'Buscar recetas...'**
  String get busquedaHintText;

  /// No description provided for @busquedaNoResultados.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron recetas'**
  String get busquedaNoResultados;

  /// No description provided for @busquedaIngresarTermino.
  ///
  /// In es, this message translates to:
  /// **'Ingresa un término para buscar'**
  String get busquedaIngresarTermino;

  /// No description provided for @busquedaPlaceholderImagen.
  ///
  /// In es, this message translates to:
  /// **'https://via.placeholder.com/80x80'**
  String get busquedaPlaceholderImagen;

  /// No description provided for @busquedaInvitacion.
  ///
  /// In es, this message translates to:
  /// **'¿Qué tal si buscas tu receta favorita?'**
  String get busquedaInvitacion;

  /// No description provided for @busquedaNoExiste.
  ///
  /// In es, this message translates to:
  /// **'Parece que esa receta no existe, revisa si el nombre es correcto.'**
  String get busquedaNoExiste;

  /// No description provided for @detalleTitulo.
  ///
  /// In es, this message translates to:
  /// **'Detalle de Receta'**
  String get detalleTitulo;

  /// No description provided for @detalleVolverListado.
  ///
  /// In es, this message translates to:
  /// **'Volver al listado'**
  String get detalleVolverListado;

  /// No description provided for @detallePlaceholderImagen.
  ///
  /// In es, this message translates to:
  /// **'https://via.placeholder.com/80x80'**
  String get detallePlaceholderImagen;

  /// No description provided for @errorNoConexion.
  ///
  /// In es, this message translates to:
  /// **'No hay conexión a internet'**
  String get errorNoConexion;

  /// No description provided for @errorRecetaNoEncontrada.
  ///
  /// In es, this message translates to:
  /// **'Receta no encontrada'**
  String get errorRecetaNoEncontrada;

  /// No description provided for @errorCargarDetalle.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar detalle: {error}'**
  String errorCargarDetalle(String error);

  /// No description provided for @errorAgregarFavoritos.
  ///
  /// In es, this message translates to:
  /// **'Error al agregar a favoritos: {error}'**
  String errorAgregarFavoritos(String error);

  /// No description provided for @errorQuitarFavoritos.
  ///
  /// In es, this message translates to:
  /// **'Error al quitar de favoritos: {error}'**
  String errorQuitarFavoritos(String error);

  /// No description provided for @errorBusqueda.
  ///
  /// In es, this message translates to:
  /// **'Error en búsqueda: {error}'**
  String errorBusqueda(String error);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
