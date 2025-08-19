import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:cocinando_con_flow/src/core/config/environment_config.dart';
import 'package:cocinando_con_flow/src/shared/di/service_locator.dart';
import 'package:cocinando_con_flow/src/shared/routing/app_router.dart';
import 'package:cocinando_con_flow/src/feature/home/domain/bloc/home_bloc.dart';
import 'package:cocinando_con_flow/src/shared/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initDependencies();
  
  final configuracionEntorno = ConfiguracionEntorno.esDesarrollo;
  
  runApp(MyApp(configuracionEntorno: configuracionEntorno));
}

class MyApp extends StatelessWidget {
  final bool configuracionEntorno;
  
  const MyApp({super.key, required this.configuracionEntorno});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Cocinando con Flow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      routerConfig: appRouter,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('es'),
      builder: (context, child) {
        return BlocProvider<HomeBloc>(
          create: (context) => locator<HomeBloc>(),
          child: child!,
        );
      },
    );
  }
}
