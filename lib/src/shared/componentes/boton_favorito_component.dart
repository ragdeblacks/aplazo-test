import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cocinando_con_flow/src/feature/detalle/domain/bloc/detalle_bloc.dart';
import 'package:cocinando_con_flow/src/feature/detalle/domain/bloc/detalle_event.dart' as detalle_event;

import 'package:cocinando_con_flow/src/feature/home/domain/bloc/home_bloc.dart';
import 'package:cocinando_con_flow/src/feature/home/domain/bloc/home_event.dart' as home_event;

import 'package:cocinando_con_flow/src/feature/busqueda/domain/bloc/busqueda_bloc.dart';
import 'package:cocinando_con_flow/src/feature/busqueda/domain/bloc/busqueda_event.dart' as busqueda_event;

class BotonFavoritoComponent extends StatelessWidget {
	final String recetaId;
	final bool esFavorito;
	final bool conFondo;
	final double? iconSize;

	const BotonFavoritoComponent({
		super.key,
		required this.recetaId,
		required this.esFavorito,
		this.conFondo = false,
		this.iconSize,
	});

	void _toggleFavorito(BuildContext context) {
		try {
			final detalleBloc = context.read<DetalleBloc>();
			if (esFavorito) {
				detalleBloc.add(detalle_event.QuitarDeFavoritos(recetaId));
			} else {
				detalleBloc.add(detalle_event.AgregarAFavoritos(recetaId));
			}
			return;
		} catch (_) {}

		try {
			final homeBloc = context.read<HomeBloc>();
			if (esFavorito) {
				homeBloc.add(home_event.QuitarDeFavoritos(recetaId));
			} else {
				homeBloc.add(home_event.AgregarAFavoritos(recetaId));
			}
			return;
		} catch (_) {}

		try {
			final busquedaBloc = context.read<BusquedaBloc>();
			if (esFavorito) {
				busquedaBloc.add(busqueda_event.QuitarDeFavoritos(recetaId));
			} else {
				busquedaBloc.add(busqueda_event.AgregarAFavoritos(recetaId));
			}
			return;
		} catch (_) {}
	}

	@override
	Widget build(BuildContext context) {
		final icon = Icon(
			esFavorito ? Icons.favorite : Icons.favorite_border,
			color: esFavorito ? Colors.red : null,
			size: iconSize ?? 24,
		);

		final button = IconButton(
			icon: icon,
			onPressed: () => _toggleFavorito(context),
		);

		if (!conFondo) return button;

		return Container(
			decoration: BoxDecoration(
				color: esFavorito ? Colors.red : Colors.grey[200],
				borderRadius: BorderRadius.circular(50),
			),
			child: IconButton(
				icon: Icon(
					esFavorito ? Icons.favorite : Icons.favorite_border,
					color: esFavorito ? Colors.white : Colors.grey[600],
					size: iconSize ?? 26,
				),
				onPressed: () => _toggleFavorito(context),
			),
		);
	}
}
