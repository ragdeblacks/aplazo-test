import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cocinando_con_flow/src/shared/componentes/custom_fondo_base_component.dart';
import 'package:cocinando_con_flow/src/shared/componentes/custom_card_component.dart';
import 'package:cocinando_con_flow/src/shared/componentes/app_bar_personalizado_component.dart';
import 'package:cocinando_con_flow/src/shared/l10n/build_context_extension.dart';
import 'package:cocinando_con_flow/src/shared/componentes/boton_favorito_component.dart';
import '../../domain/bloc/detalle_bloc.dart';
import '../../domain/bloc/detalle_state.dart';
import '../../domain/bloc/detalle_event.dart' as detalle_event;
import 'package:cached_network_image/cached_network_image.dart';

class DetalleScreen extends StatefulWidget {
  final String recetaId;
  const DetalleScreen({super.key, required this.recetaId});

  @override
  State<DetalleScreen> createState() => _DetalleScreenState();
}

class _DetalleScreenState extends State<DetalleScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.4, 1.0, curve: Curves.elasticOut),
    ));

    _animationController.forward();
    
    // Cargar la receta automáticamente
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<DetalleBloc>().add(detalle_event.CargarDetalle(widget.recetaId));
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomFondoBaseComponent(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBarPersonalizadoComponent(
          titulo: context.texto.detalleTitulo,
          onBackPressed: () => context.pop(),
        ),
        body: BlocBuilder<DetalleBloc, DetalleState>(
          builder: (context, state) {
            if (state is DetalleLoading) {
              return _buildHeroPlaceholder();
            }

            if (state is DetalleError) {
              return Center(
                child: CustomCardComponent(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        state.mensaje,
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          context.read<DetalleBloc>().add(detalle_event.CargarDetalle(widget.recetaId));
                        },
                        child: Text(context.texto.reintentar),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is DetalleCargado) {
              return _buildDetalleReceta(state);
            }

            return _buildHeroPlaceholder();
          },
        ),
      ),
    );
  }

  Widget _buildHeroPlaceholder() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Hero(
        tag: 'receta-card-${widget.recetaId}',
        child: CustomCardComponent(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Título placeholder - reducido
                Container(
                  height: 20,
                  width: 160,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 8),
                // Imagen placeholder - reducido
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                const SizedBox(height: 8),
                // Contenido placeholder - reducido
                Container(
                  height: 12,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetalleReceta(DetalleCargado estado) {
    final receta = estado.receta;
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Hero(
                      tag: 'receta-card-${receta.id}',
                      child: CustomCardComponent(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      receta.nombre,
                                      style: const TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  BotonFavoritoComponent(
                                     	recetaId: receta.id,
                                     	esFavorito: receta.esFavorito,
                                     	conFondo: true,
                                     	iconSize: 26,
                                     ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              if (receta.categoria != null || receta.area != null) ...[
                                Row(
                                  children: [
                                    if (receta.categoria != null) ...[
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.blue[100],
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          receta.categoria!,
                                          style: TextStyle(
                                            color: Colors.blue[800],
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                    if (receta.categoria != null && receta.area != null)
                                      const SizedBox(width: 12),
                                    if (receta.area != null) ...[
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.green[100],
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          receta.area!,
                                          style: TextStyle(
                                            color: Colors.green[800],
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 24),
                              ],

                              if (receta.imagen != null) ...[
                                Center(
                                  child: Container(
                                    width: double.infinity,
                                    height: 180,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.1),
                                          offset: const Offset(0, 4),
                                          blurRadius: 12,
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: CachedNetworkImage(
                                        imageUrl: receta.imagen!,
                                        width: double.infinity,
                                        height: 180,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Container(
                                          width: double.infinity,
                                          height: 180,
                                          color: Colors.grey[200],
                                        ),
                                        errorWidget: (context, url, error) => Container(
                                          width: double.infinity,
                                          height: 180,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          child: const Icon(
                                            Icons.restaurant,
                                            size: 60,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                              ],

                              if (receta.ingredientes.isNotEmpty) ...[
                                ExpansionTile(
                                  initiallyExpanded: estado.ingredientesExpandido,
                                  onExpansionChanged: (expanded) {
                                    context.read<DetalleBloc>().add(const detalle_event.ToggleIngredientes());
                                  },
                                  leading: Icon(
                                    Icons.shopping_basket,
                                    color: Colors.orange[600],
                                    size: 24,
                                  ),
                                  title: Text(
                                    context.texto.ingredientes,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                      child: Column(
                                        children: List.generate(receta.ingredientes.length, (index) {
                                          final ingrediente = receta.ingredientes[index];
                                          final medida = index < receta.medidas.length ? receta.medidas[index] : '';
                                          return Padding(
                                            padding: const EdgeInsets.only(bottom: 12),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 8,
                                                  height: 8,
                                                  decoration: BoxDecoration(
                                                    color: Colors.orange[400],
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                                Expanded(
                                                  child: Text(
                                                    '$medida $ingrediente',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                      ),
                                    ),
                                  ],
                                ),
                              ],

                              if (receta.instrucciones != null && receta.instrucciones!.isNotEmpty) ...[
                                ExpansionTile(
                                  initiallyExpanded: estado.instruccionesExpandido,
                                  onExpansionChanged: (expanded) {
                                    context.read<DetalleBloc>().add(const detalle_event.ToggleInstrucciones());
                                  },
                                  leading: Icon(
                                    Icons.format_list_numbered,
                                    color: Colors.purple[600],
                                    size: 24,
                                  ),
                                  title: Text(
                                    context.texto.instrucciones,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                      child: Text(
                                        receta.instrucciones!,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          height: 1.6,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.arrow_back),
                        label: Text(
                          context.texto.detalleVolverListado,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[600],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
