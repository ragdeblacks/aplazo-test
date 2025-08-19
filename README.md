# 🍳 Cocinando con Flow

**App de recetas que hice con Flutter usando mi arquitectura híbrida**

## **¿Qué es esto?**

Una app móvil para ver recetas de cocina. La hice siguiendo mi estilo de arquitectura que combina Clean Architecture con Feature-based structure. Tiene tres pantallas principales: Home (lista de recetas), Detalle de la receta y Búsqueda de recetas por nombre.

## **¿Cómo está organizado mi código?**

### **Mi arquitectura híbrida**

Uso una combinación de Clean Architecture + Feature-based porque me da lo mejor de ambos mundos:

- **Cada pantalla es independiente**: Home, Detalle y Búsqueda funcionan por separado
- **Código reutilizable**: Componentes que uso en varias pantallas
- **Fácil de mantener**: Si cambio algo en una feature, no afecta las otras

### **Patrones que uso**

1. **BLoC**: Para manejar el estado y acciones de la aplicacion
2. **Repository**: Para acceder a datos de manera consistente y separar logica de negocios de logica persistente (UI)
3. **Injection**: Con GetIt para conectar todas las piezas
4. **Observer**: Para que la UI se actualice sola

### **Estructura de carpetas**

```
lib/
├── src/
│   ├── feature/          # Mis funcionalidades principales
│   │   ├── home/
│   │   ├── detalle/
│   │   └── busqueda/
│   ├── shared/           # Código compartido que uso en varias features
│   │   ├── componentes/
│   │   ├── styles/
│   │   └── network/
│   └── core/             # Configuración general de la app
```

### **Implementación específica**

```
lib/src/
├── feature/
│   ├── home/
│   │   ├── domain/           # Lógica de negocio
│   │   │   ├── bloc/         # Gestión de estado
│   │   │   ├── entities/     # Entidades del dominio
│   │   │   └── repository/   # Interfaces de datos
│   │   ├── data/             # Implementación de datos
│   │   │   ├── models/       # Modelos de datos
│   │   │   ├── repository/   # Implementación de repositorios
│   │   │   └── services/     # Servicios de API
│   │   └── presentation/     # Capa de presentación
│   │       ├── screen/       # Pantallas
│   │       └── componentes/  # Componentes específicos
│   ├── detalle/
│   └── busqueda/
├── shared/                    # Código compartido
│   ├── componentes/          # Componentes reutilizables
│   ├── styles/               # Estilos centralizados
│   ├── network/              # Servicios de red
│   └── storage/              # Almacenamiento local
└── core/                     # Configuración general
    └── config/
```


## **¿Cómo ejecutar mi proyecto?**

### **Lo que necesitas**
- Flutter 3.0 o superior
- Dart 3.0 o superior
- Android Studio / VS Code
- Un teléfono Android/iOS o emulador

### **Sistema de Flavors**

Mi proyecto tiene configurado un sistema de flavors para diferentes entornos:

- **development**: Completamente configurado para desarrollo local y testing
- **staging**: Estructura creada, pendiente de configuración completa
- **production**: Estructura creada, pendiente de configuración completa

### **Pasos para ejecutar**

1. **Clona el repo**
   ```bash
   git clone git@github.com:ragdeblacks/aplazo-test.git
   cd aplazo-test
   ```

2. **Instala dependencias**
   ```bash
   flutter pub get
   ```

3. **Ejecuta la app**
   ```bash
   flutter run --flavor development
   ```

### **Comandos útiles**

```bash
# Ver si todo está bien configurado
flutter doctor

# Buscar errores en el código
flutter analyze

# Ejecutar mis tests
flutter test

# Generar archivos de localización
flutter gen-l10n

# Correr sobre emularor o dispositivo 
flutter run --flavor development

### **📱 Instalación del APK generado**
```
### **Artefacto generado disponible en la raiz del proyecto en formato apk**

```
app-development-release.apk
```

**Para instalar en tu dispositivo:**
1. Transfiere el APK a tu teléfono Android
2. Habilita "Instalar apps de fuentes desconocidas" en Configuración > Seguridad
3. Toca el archivo APK para instalarlo

**Nota**: El APK de development incluye logs y debugging, ideal para testing pero no para distribución final.

## **Despliegue en iOS - Configuraciones Necesarias**

### **Requisitos previos para iOS**
- **macOS**: Solo se puede desarrollar para iOS desde macOS
- **Xcode**: Versión 14.0 o superior
- **CocoaPods**: Versión 1.11.0 o superior
- **Flutter iOS toolchain**: Configurado correctamente

### **Configuraciones actuales del proyecto**

#### **Info.plist (iOS)**
```xml
<!-- Configuraciones básicas ya implementadas -->
<key>CFBundleDisplayName</key>
<string>Cocinando Con Flow</string>
<key>CFBundleIdentifier</key>
<string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
<key>UISupportedInterfaceOrientations</key>
<array>
    <string>UIInterfaceOrientationPortrait</string>
    <string>UIInterfaceOrientationLandscapeLeft</string>
    <string>UIInterfaceOrientationLandscapeRight</string>
</array>
```

#### **AndroidManifest.xml (Android)**
```xml
<application
    android:label="cocinando_con_flow"
    android:icon="@mipmap/ic_launcher">
</application>
```

#### **Configuración de flavors para iOS**
```bash
# Crear esquemas en Xcode para cada flavor
# Development, Staging, Production

# Configurar Bundle IDs únicos:
# Development: com.tuempresa.cocinando.dev
# Staging: com.tuempresa.cocinando.staging  
# Production: com.tuempresa.cocinando
```

#### **Configuración de certificados y provisioning**
```bash
# En Xcode:
# 1. Configurar Team ID de Apple Developer
# 2. Crear certificados de desarrollo y distribución
# 3. Configurar provisioning profiles para cada flavor
# 4. Configurar App ID con capacidades necesarias
```


### **Configuraciones para Android**

#### **Configuración de flavors para Android**
```kotlin
android {
    flavorDimensions += "environment"
    
    productFlavors {
        create("development") {
            dimension = "environment"
            applicationIdSuffix = ".dev"
            versionNameSuffix = "-dev"
        }
        create("staging") {
            dimension = "environment"
            applicationIdSuffix = ".staging"
            versionNameSuffix = "-staging"
        }
        create("production") {
            dimension = "environment"
            // Sin sufijos para producción
        }
    }
}
```

### **Comandos de build para producción**

#### **iOS**
```bash
# Build para desarrollo
flutter build ios --flavor development

```

#### **Android**
```bash
# Correr sobre emularor o dispositivo 
flutter run --flavor development

# Build APK para desarrollo
flutter build apk --flavor development
# 📱 APK generado: build/app/outputs/flutter-apk/app-development-release.apk

# Build APK para staging
flutter build apk --flavor staging
# 📱 APK generado: build/app/outputs/flutter-apk/app-staging-release.apk

# Build APK para producción
flutter build apk --flavor production
# 📱 APK generado: build/app/outputs/flutter-apk/app-production-release.apk

# Build App Bundle para producción (recomendado para Play Store)
flutter build appbundle --flavor production
```

### **Consideraciones de seguridad para producción**

#### **Configuración de flavors**
- **Development**: Logs detallados, debugging habilitado
- **Staging**: Logs moderados, algunas validaciones
- **Production**: Logs mínimos, todas las validaciones, optimizaciones

### **Solución de problemas comunes**

#### **Error de NDK Android**
Si ves este error al hacer build:
```
Your project is configured with Android NDK 26.3.11579264, but the following plugin(s) depend on a different Android NDK version
```

**Solución**: Ya está configurado en `android/app/build.gradle.kts` con la versión correcta `27.0.12077973`.

#### **Error de dependencias de Google Play**
Si ves este error:
```
ERROR: Missing class com.google.android.play.core.splitcompat.SplitCompatApplication
```

**Solución**: Ya están agregadas las dependencias necesarias en el build.gradle.kts.

#### **Si sigues teniendo problemas**
1. **Limpia el proyecto**: `flutter clean`
2. **Reinstala dependencias**: `flutter pub get`
3. **Verifica que tienes la última versión de Flutter**: `flutter doctor`
4. **Asegúrate de tener Android SDK actualizado**


### **Notas importantes**

1. **iOS requiere macOS**: No se puede desarrollar para iOS desde Windows/Linux
2. **Apple Developer Account**: Necesario para distribución en App Store ($99/año)
3. **Review process**: Apple revisa todas las apps antes de publicarlas
4. **Guidelines**: Cumplir con las App Store Review Guidelines
5. **Testing**: Usar TestFlight para testing interno antes de publicación

## **¿Qué hace cada pantalla?**

### **Home (Pantalla Principal)**
- Lista infinita de recetas con scroll automático
- Botón "Mostrar más" para cargar más recetas
- Caché para no hacer llamadas repetidas a la API
- Botón de búsqueda que lleva a la pantalla de búsqueda
- Marcado de favoritos que se guarda localmente

### **Búsqueda**
- Campo de texto para buscar recetas por nombre
- Debounce automático para no saturar la API
- Resultados en tiempo real
- Estados vacíos informativos cuando no hay búsquedas o resultados

### **Detalle de Receta**
- Imagen completa de la receta
- Info detallada (categoría, área, ingredientes)
- Botón de favorito integrado

## **¿Cómo se ve mi app?**

### **Diseño y estilo**
- **Colores centralizados**: Todos los colores están en una sola clase para consistencia
- **Tamaños responsivos**: La app se adapta a diferentes tamaños de pantalla
- **Componentes reutilizables**: Botones, tarjetas y elementos que se ven igual en todas partes
- **Animaciones suaves**: Transiciones entre pantallas y efectos visuales

### **Características de UX**
- **Estados de carga**: Indicadores visuales mientras se cargan los datos
- **Manejo de errores**: Mensajes claros cuando algo falla
- **Persistencia**: Los favoritos se guardan localmente
- **Caché inteligente**: Las recetas se guardan temporalmente para mejor rendimiento

## **¿Qué tecnologías uso?**

### **Frontend**
- **Flutter**: Framework principal para la app móvil
- **Dart**: Lenguaje de programación
- **Material Design**: Componentes visuales de Google

### **Backend y datos**
- **TheMealDB API**: Servicios implementados
- **Dio**: Cliente HTTP para llamadas a APIs
- **SharedPreferences**: Almacenamiento local simple
- **Cached Network Image**: Optimización de imágenes

### **Arquitectura y patrones**
- **BLoC**: Para gestión de estado
- **GetIt**: Para inyección de dependencias
- **GoRouter**: Para navegación entre pantallas
- **Repository Pattern**: Para acceso a datos

### **Sistema de flavors**
- **Development**: Entorno de desarrollo local completamente configurado
- **Staging**: Estructura creada, pendiente de configuración
- **Production**: Estructura creada, pendiente de configuración
- **Configuración automática**: Solo development tiene configuración completa de API, logging y debugging

## **Internacionalización (L10N)**

La app está preparada para múltiples idiomas:
- **Español**: Idioma principal implementado
- **Archivos ARB**: Formato estándar de Flutter para traducciones
- **Context.texto**: Acceso fácil a textos desde cualquier parte de la app

## **Testing y calidad de código**

### **Cobertura de pruebas**
- **Pruebas unitarias**: Para lógica de negocio y BLoCs
- **Pruebas de integración**: Para repositorios y servicios
- **Mocking**: Simulación de dependencias externas

### **Estructura de testing**

```
test/
├── feature/                  # Tests por feature
│   ├── home/
│   │   ├── domain/
│   │   │   ├── bloc/        # Tests de BLoCs
│   │   │   └── repository/  # Tests de repositorios
│   │   └── data/
│   ├── detalle/
│   └── busqueda/
└── shared/                   # Tests de componentes compartidos
    ├── componentes/
    └── services/
```

### **Herramientas que uso**

1. **flutter_test**: Framework base de testing
2. **bloc_test**: Testing específico para BLoCs
3. **mockito**: Mocking de dependencias
4. **build_runner**: Generación de mocks

### **Análisis de código**
- **Flutter Lints**: Reglas de calidad automáticas
- **Análisis estático**: Detección de problemas antes de ejecutar


## **Limitaciones actuales desde mi perspectiva**

- **API externa**: Dependo de TheMealDB, que puede tener limitaciones
- **Imágenes**: Algunas recetas pueden no tener imágenes disponibles

## **Mejoras**

- [ ] Aumentar cobertura de pruebas al 100%
- [ ] Implementar modo offline completo
- [ ] Agregar filtros por categoría y área
- [ ] Sistema de usuarios y perfiles
- [ ] Compartir recetas



### **Estándares de código**
- Usar nombres de variables en español
- Seguir mi arquitectura feature-based
- Mantener la consistencia en el diseño
- Agregar pruebas para nueva funcionalidad


## **¿Por qué estas decisiones?**

## **Mi arquitectura híbrida: Clean + Feature-Based**

### **¿Por qué esta combinación?**

**Clean Architecture** me da:
- Separación clara de responsabilidades
- Testabilidad de la lógica de negocio
- Reglas de dependencias claras

**Feature-Based Structure** me da:
- Organización por funcionalidad
- Código que se puede desplegar por features
- Fácil navegación del código

## **Componentes reutilizables: Principio DRY**

### **¿Qué componentes he creado?**

1. **RecetaItemComponent**: Tarjeta de receta para listas
2. **CategoriaChipComponent**: Chip de categoría con colores
3. **BotonFavoritoComponent**: Botón de favorito inteligente
4. **AppBarPersonalizadoComponent**: AppBar con estilo consistente
5. **CustomCardComponent**: Tarjeta base reutilizable


## **Cómo agregar nueva funcionalidad**

### **Paso 1: Crear la estructura de feature**

```bash
mkdir -p lib/src/feature/nueva_feature/{domain,data,presentation}
mkdir -p lib/src/feature/nueva_feature/domain/{bloc,repository,entities}
mkdir -p lib/src/feature/nueva_feature/data/{repository,services,models}
mkdir -p lib/src/feature/nueva_feature/presentation/{screen,componentes}
```

### **Paso 2: Definir la entidad del dominio**

```dart
class NuevaEntidad extends Equatable {
  final String id;
  final String nombre;
  final String descripcion;

  const NuevaEntidad({
    required this.id,
    required this.nombre,
    required this.descripcion,
  });

  @override
  List<Object?> get props => [id, nombre, descripcion];
}
```

### **Paso 3: Crear el repositorio**

```dart
abstract class NuevaFeatureRepository {
  Future<List<NuevaEntidad>> obtenerEntidades();
  Future<NuevaEntidad?> obtenerEntidadPorId(String id);
}
```

### **Paso 4: Implementar el BLoC**

```dart
class NuevaFeatureBloc extends Bloc<NuevaFeatureEvent, NuevaFeatureState> {
  final NuevaFeatureRepository _repository;

  NuevaFeatureBloc(this._repository) : super(NuevaFeatureInitial()) {
    on<CargarEntidades>(_onCargarEntidades);
  }

  Future<void> _onCargarEntidades(
    CargarEntidades event,
    Emitter<NuevaFeatureState> emit,
  ) async {
    try {
      emit(NuevaFeatureLoading());
      final entidades = await _repository.obtenerEntidades();
      emit(NuevaFeatureLoaded(entidades));
    } catch (e) {
      emit(NuevaFeatureError(ErrorMapper.mapToFailure(e).message));
    }
  }
}
```

### **Paso 5: Registrar en el Service Locator**

```dart
void initDependencies() {

  getIt.registerLazySingleton<NuevaFeatureRepository>(
    () => NuevaFeatureRepositoryImpl(
      getIt<NuevaFeatureApiService>(),
      getIt<LocalStorageService>(),
    ),
  );
  
  getIt.registerLazySingleton<NuevaFeatureBloc>(
    () => NuevaFeatureBloc(getIt<NuevaFeatureRepository>()),
  );
}
```

### **Paso 6: Crear la pantalla**

```dart
class NuevaFeatureScreen extends StatelessWidget {
  const NuevaFeatureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<NuevaFeatureBloc>()
        ..add(const CargarEntidades()),
      child: Scaffold(
      ),
    );
  }
}
```

### **Paso 7: Agregar rutas**

```dart
GoRoute(
  path: '/nueva-feature',
  builder: (context, state) => const NuevaFeatureScreen(),
),
```

### **Paso 8: Agregar textos de localización**

```json
{
  "nuevaFeatureTitulo": "Nueva Funcionalidad",
  "nuevaFeatureCargando": "Cargando...",
  "nuevaFeatureError": "Error al cargar datos"
}
```
