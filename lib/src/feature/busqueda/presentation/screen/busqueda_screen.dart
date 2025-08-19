import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cocinando_con_flow/src/shared/componentes/custom_fondo_base_component.dart';
import 'package:cocinando_con_flow/src/shared/componentes/receta_item_component.dart';
import 'package:cocinando_con_flow/src/shared/componentes/app_bar_personalizado_component.dart';
import 'package:cocinando_con_flow/src/shared/l10n/build_context_extension.dart';
import 'package:cocinando_con_flow/src/shared/styles/style_size.dart';
import '../componentes/busqueda_estado_component.dart';
import '../../domain/bloc/busqueda_bloc.dart';
import '../../domain/bloc/busqueda_state.dart';
import '../../domain/bloc/busqueda_event.dart' as busqueda_event;
import 'package:cocinando_con_flow/src/shared/domain/entities/entities.dart';

class BusquedaScreen extends StatefulWidget {
  const BusquedaScreen({super.key});

  @override
  State<BusquedaScreen> createState() => _BusquedaScreenState();
}

class _BusquedaScreenState extends State<BusquedaScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onBusquedaCambio(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (query.trim().isNotEmpty) {
        context.read<BusquedaBloc>().add(busqueda_event.EjecutarBusqueda(query));
      } else {
        context.read<BusquedaBloc>().add(const busqueda_event.LimpiarBusqueda());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final paddingGeneral = StyleSize.widthPorcent(context, 4.5);

    return CustomFondoBaseComponent(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBarPersonalizadoComponent(
          titulo: context.texto.buscarRecetas,
          onBackPressed: () => context.pop(),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(paddingGeneral),
              child: TextField(
                controller: _searchController,
                onChanged: _onBusquedaCambio,
                decoration: InputDecoration(
                  hintText: context.texto.busquedaHintText,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<BusquedaBloc, BusquedaState>(
                builder: (context, state) {
                  if (state is BusquedaCargando) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is BusquedaError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(context.texto.errorBusqueda(state.mensaje)),
                          ElevatedButton(
                            onPressed: () {
                              if (_searchController.text.trim().isNotEmpty) {
                                context.read<BusquedaBloc>().add(busqueda_event.EjecutarBusqueda(_searchController.text));
                              }
                            },
                            child: Text(context.texto.reintentar),
                          ),
                        ],
                      ),
                    );
                  }
                  if (state is BusquedaSinResultados) {
                    return BusquedaEstadoComponent(mensaje: context.texto.busquedaNoExiste);
                  }
                  if (state is BusquedaExitoso) {
                    return ListView.builder(
                      padding: EdgeInsets.all(paddingGeneral),
                      itemCount: state.recetas.length,
                      itemBuilder: (context, index) {
                        return _buildTarjetaReceta(state.recetas[index]);
                      },
                    );
                  }
                  return BusquedaEstadoComponent(mensaje: context.texto.busquedaInvitacion);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTarjetaReceta(RecetaEntity receta) {
    return Hero(
      tag: 'receta-card-${receta.id}',
      child: RecetaItemComponent(
        id: receta.id,
        titulo: receta.nombre,
        imagenUrl: receta.imagen,
        categoria: receta.categoria,
        area: receta.area,
        esFavorito: receta.esFavorito,
        onTap: () => context.push('/detalle/${receta.id}'),
        onToggleFavorito: () {
          if (receta.esFavorito) {
            context.read<BusquedaBloc>().add(busqueda_event.QuitarDeFavoritos(receta.id));
          } else {
            context.read<BusquedaBloc>().add(busqueda_event.AgregarAFavoritos(receta.id));
          }
        },
        margin: EdgeInsets.only(bottom: StyleSize.heightPorcent(context, 2)),
      ),
    );
  }
}
