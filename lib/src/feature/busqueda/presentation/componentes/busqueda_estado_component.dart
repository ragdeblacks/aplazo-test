import 'package:flutter/material.dart';
import 'package:cocinando_con_flow/src/shared/componentes/custom_card_component.dart';
import 'package:cocinando_con_flow/src/shared/styles/style_size.dart';

class BusquedaEstadoComponent extends StatelessWidget {
	final String mensaje;
	const BusquedaEstadoComponent({super.key, required this.mensaje});

	@override
	Widget build(BuildContext context) {
		final ancho = StyleSize.widthPorcent(context, 86);
		final alto = StyleSize.heightPorcent(context, 28);
		return Center(
			child: SizedBox(
				width: ancho,
				height: alto,
				child: CustomCardComponent(
					child: Padding(
						padding: EdgeInsets.symmetric(
							horizontal: StyleSize.widthPorcent(context, 6),
							vertical: StyleSize.heightPorcent(context, 3),
						),
						child: Center(
							child: Text(
								mensaje,
								textAlign: TextAlign.center,
								style: const TextStyle(
									fontSize: 18,
									fontWeight: FontWeight.w600,
								),
							),
						),
					),
				),
			),
		);
	}
}
