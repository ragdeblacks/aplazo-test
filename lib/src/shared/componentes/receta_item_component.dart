import 'package:flutter/material.dart';
import 'package:cocinando_con_flow/src/shared/styles/style_size.dart';
import 'package:cocinando_con_flow/src/shared/componentes/custom_card_component.dart';
import 'package:cocinando_con_flow/src/shared/componentes/categoria_chip_component.dart';
import 'package:cocinando_con_flow/src/shared/componentes/boton_favorito_component.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RecetaItemComponent extends StatelessWidget {
	final String id;
	final String titulo;
	final String? imagenUrl;
	final String? categoria;
	final String? area;
	final bool esFavorito;
	final VoidCallback onTap;
	final VoidCallback onToggleFavorito;
	final EdgeInsets? margin;

	const RecetaItemComponent({
		super.key,
		required this.id,
		required this.titulo,
		this.imagenUrl,
		this.categoria,
		this.area,
		required this.esFavorito,
		required this.onTap,
		required this.onToggleFavorito,
		this.margin,
	});

	@override
	Widget build(BuildContext context) {
		final tamanoImagen = StyleSize.widthPorcent(context, 22);
		final separadorHorizontal = StyleSize.widthPorcent(context, 4.5);

		return CustomCardComponent(
			onTap: onTap,
			isClickable: true,
			margin: margin ?? EdgeInsets.only(bottom: StyleSize.heightPorcent(context, 2)),
			child: Row(
				children: [
					ClipRRect(
						borderRadius: BorderRadius.circular(8),
						child: CachedNetworkImage(
							imageUrl: imagenUrl ?? 'https://via.placeholder.com/80x80',
							width: tamanoImagen,
							height: tamanoImagen,
							fit: BoxFit.cover,
							placeholder: (context, url) => Container(
								width: tamanoImagen,
								height: tamanoImagen,
								color: Colors.grey[200],
							),
							errorWidget: (context, url, error) => Container(
								width: tamanoImagen,
								height: tamanoImagen,
								color: Colors.grey[300],
								child: const Icon(Icons.restaurant, size: 40),
							),
						),
					),
					SizedBox(width: separadorHorizontal),
					Expanded(
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								Text(
									titulo,
									style: const TextStyle(
										fontSize: 18,
										fontWeight: FontWeight.bold,
									),
								),
								if (categoria != null || area != null) ...[
									SizedBox(height: StyleSize.heightPorcent(context, 0.8)),
									Wrap(
										spacing: 8,
										runSpacing: 4,
										children: [
											if (categoria != null) CategoriaChipComponent(categoria: categoria!),
											if (area != null) CategoriaChipComponent(categoria: area!),
										],
									),
								],
							],
						),
					),
					BotonFavoritoComponent(
						recetaId: id,
						esFavorito: esFavorito,
					),
				],
			),
		);
	}
}
