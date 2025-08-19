import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cocinando_con_flow/src/feature/home/domain/bloc/home_bloc.dart';
import 'package:cocinando_con_flow/src/feature/home/domain/bloc/home_event.dart';
import 'package:cocinando_con_flow/src/feature/home/domain/bloc/home_state.dart';
import 'package:cocinando_con_flow/src/feature/home/domain/entities/receta_lista_entity.dart';
import 'package:cocinando_con_flow/src/shared/componentes/custom_fondo_base_component.dart';
import 'package:cocinando_con_flow/src/shared/l10n/build_context_extension.dart';
import 'package:cocinando_con_flow/src/shared/styles/style_size.dart';
import 'package:cocinando_con_flow/src/core/config/theme_config.dart';
import 'package:cocinando_con_flow/src/shared/componentes/receta_item_component.dart';
import 'dart:ui' as ui;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(const CargarRecetas());
  }

  @override
  Widget build(BuildContext context) {
    final paddingHorizontal = StyleSize.widthPorcent(context, 6.5);
    final paddingSuperiorHeader = StyleSize.heightPorcent(context, 7);
    final paddingInferiorHeader = StyleSize.heightPorcent(context, 2.5);
    final paddingHorizontalLista = StyleSize.widthPorcent(context, 4.5);
    final paddingVerticalLista = StyleSize.heightPorcent(context, 1.5);
    final espaciadoPequeno = StyleSize.heightPorcent(context, 1);

    return CustomFondoBaseComponent(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(paddingHorizontal, paddingSuperiorHeader, paddingHorizontal, paddingInferiorHeader),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: StyleSize.widthPorcent(context, 3.5),
                      vertical: StyleSize.heightPorcent(context, 2.5),
                    ),
                    decoration: BoxDecoration(
                      color: ColoresApp.fondoPill,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: ColoresApp.bordePill,
                        width: 1.5,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: ColoresApp.sombraSuave,
                          offset: Offset(0, 4),
                          blurRadius: 12,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.texto.homeHeaderTitulo,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: ColoresApp.textoContraste,
                            letterSpacing: -0.5,
                            shadows: [
                              Shadow(
                                offset: Offset(0, 2),
                                blurRadius: 8,
                                color: ColoresApp.sombraMedia,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          context.texto.homeHeaderSubtitulo,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w300,
                            color: ColoresApp.textoContraste.withValues(alpha: 0.85),
                            letterSpacing: 1.2,
                            shadows: const [
                              Shadow(
                                offset: Offset(0, 2),
                                blurRadius: 8,
                                color: ColoresApp.sombraSuave,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: espaciadoPequeno),
                        Container(
                          width: StyleSize.widthPorcent(context, 16.5),
                          height: 3,
                          decoration: BoxDecoration(
                            color: ColoresApp.textoContraste,
                            borderRadius: BorderRadius.circular(2),
                            boxShadow: const [
                              BoxShadow(
                                color: ColoresApp.sombraFuerte,
                                offset: Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: paddingHorizontalLista, vertical: paddingVerticalLista),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.texto.recetasTitulo,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: ColoresApp.tituloSeccion,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => context.push('/busqueda'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColoresApp.botonBusqueda,
                      foregroundColor: ColoresApp.botonBusquedaTexto,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      context.texto.homeBotonBusqueda,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is HomeError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(context.texto.homeErrorCargar),
                          ElevatedButton(
                            onPressed: () {
                              context.read<HomeBloc>().add(const CargarRecetas());
                            },
                            child: Text(context.texto.reintentar),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is HomeLoaded) {
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: paddingHorizontalLista, vertical: paddingVerticalLista),
                      itemCount: state.recetas.length,
                      itemBuilder: (context, index) {
                        return _buildTarjetaReceta(state.recetas[index]);
                      },
                    );
                  }

                  return Center(child: Text(context.texto.homeNoRecetas));
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoaded && state.tieneMasPaginas) {
              return SafeArea(
                minimum: EdgeInsets.fromLTRB(paddingHorizontalLista, paddingVerticalLista, paddingHorizontalLista, StyleSize.heightPorcent(context, 2)),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.read<HomeBloc>().add(const CargarMasRecetas()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColoresApp.botonSecundario,
                      foregroundColor: ColoresApp.botonSecundarioTexto,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: state.estaCargandoMas
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            context.texto.homeMostrarMas,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildTarjetaReceta(RecetaListaEntity receta) {
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
            context.read<HomeBloc>().add(QuitarDeFavoritos(receta.id));
          } else {
            context.read<HomeBloc>().add(AgregarAFavoritos(receta.id));
          }
        },
        margin: EdgeInsets.only(bottom: StyleSize.heightPorcent(context, 2)),
      ),
    );
  }
}
