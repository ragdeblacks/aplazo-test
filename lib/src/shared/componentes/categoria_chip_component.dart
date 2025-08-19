import 'package:flutter/material.dart';
import 'package:cocinando_con_flow/src/shared/styles/categoria_colors_factory.dart';

class CategoriaChipComponent extends StatelessWidget {
	final String categoria;
	final EdgeInsets? padding;
	final double? fontSize;
	final double? borderRadius;

	const CategoriaChipComponent({
		super.key,
		required this.categoria,
		this.padding,
		this.fontSize,
		this.borderRadius,
	});

	@override
	Widget build(BuildContext context) {
		final colors = CategoriaColorsFactory.obtenerColores(categoria);
		return Container(
			padding: padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
			decoration: BoxDecoration(
				color: colors.fondo,
				borderRadius: BorderRadius.circular(borderRadius ?? 12),
			),
			child: Text(
				categoria,
				style: TextStyle(
					color: colors.texto,
					fontSize: fontSize ?? 12,
					fontWeight: FontWeight.w600,
				),
			),
		);
	}
}
