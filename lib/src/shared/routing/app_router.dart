import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cocinando_con_flow/src/feature/home/domain/bloc/home_bloc.dart';
import 'package:cocinando_con_flow/src/feature/detalle/domain/bloc/detalle_bloc.dart';
import 'package:cocinando_con_flow/src/feature/busqueda/domain/bloc/busqueda_bloc.dart';
import 'package:cocinando_con_flow/src/feature/home/presentation/screen/home_screen.dart';
import 'package:cocinando_con_flow/src/feature/detalle/presentation/screen/detalle_screen.dart';
import 'package:cocinando_con_flow/src/feature/busqueda/presentation/screen/busqueda_screen.dart';
import 'package:cocinando_con_flow/src/shared/di/service_locator.dart';

class DetallePageTransition extends CustomTransitionPage<void> {
  DetallePageTransition({
    required super.child,
    required LocalKey key,
  }) : super(
          key: key,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const curve = Curves.easeInOutCubic;
            final curved = CurvedAnimation(parent: animation, curve: curve);
            final slide = Tween<Offset>(begin: const Offset(0.0, 0.08), end: Offset.zero)
                .chain(CurveTween(curve: curve))
                .animate(curved);
            final fade = Tween<double>(begin: 0.0, end: 1.0)
                .chain(CurveTween(curve: curve))
                .animate(curved);
            return FadeTransition(
              opacity: fade,
              child: SlideTransition(position: slide, child: child),
            );
          },
          transitionDuration: const Duration(milliseconds: 350),
        );
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => BlocProvider(
        create: (context) => locator<HomeBloc>(),
        child: const HomeScreen(),
      ),
    ),
    GoRoute(
      path: '/detalle/:recetaId',
      pageBuilder: (context, state) {
        final recetaId = state.pathParameters['recetaId']!;
        return DetallePageTransition(
          key: ValueKey('detalle_$recetaId'),
          child: BlocProvider(
            create: (context) => locator<DetalleBloc>(),
            child: DetalleScreen(recetaId: recetaId),
          ),
        );
      },
    ),
    GoRoute(
      path: '/busqueda',
      builder: (context, state) => BlocProvider(
        create: (context) => locator<BusquedaBloc>(),
        child: const BusquedaScreen(),
      ),
    ),
  ],
);
