import 'package:flutter/material.dart';

class CategoriaColorsFactory {
	static CategoriaColors obtenerColores(String categoria) {
		final c = categoria.toLowerCase();
		if (c.contains('beef') || c.contains('carne') || c.contains('meat')) {
			return const CategoriaColors(Color(0xFFE3F2FD), Color(0xFF1565C0));
		}
		if (c.contains('chicken') || c.contains('pollo')) {
			return const CategoriaColors(Color(0xFFFFF3E0), Color(0xFFF57C00));
		}
		if (c.contains('seafood') || c.contains('pescado') || c.contains('fish')) {
			return const CategoriaColors(Color(0xFFE8F5E8), Color(0xFF2E7D32));
		}
		if (c.contains('vegetarian') || c.contains('veg')) {
			return const CategoriaColors(Color(0xFFF3E5F5), Color(0xFF8E24AA));
		}
		if (c.contains('dessert') || c.contains('postre') || c.contains('sweet')) {
			return const CategoriaColors(Color(0xFFE3F2FD), Color(0xFF1565C0));
		}
		if (c.contains('british') || c.contains('inglesa') || c.contains('english') || c.contains('uk')) {
			return const CategoriaColors(Color(0xFFE8F5E8), Color(0xFF2E7D32));
		}
		if (c.contains('italian') || c.contains('italiana')) {
			return const CategoriaColors(Color(0xFFFFF3E0), Color(0xFFF57C00));
		}
		if (c.contains('mexican') || c.contains('mexicana')) {
			return const CategoriaColors(Color(0xFFFFEBEE), Color(0xFFD32F2F));
		}
		if (c.contains('indian') || c.contains('india')) {
			return const CategoriaColors(Color(0xFFFFF8E1), Color(0xFFF57F17));
		}
		if (c.contains('chinese') || c.contains('china')) {
			return const CategoriaColors(Color(0xFFE0F2F1), Color(0xFF00695C));
		}
		if (c.contains('japanese') || c.contains('japonesa')) {
			return const CategoriaColors(Color(0xFFFCE4EC), Color(0xFFC2185B));
		}
		if (c.contains('french') || c.contains('francesa')) {
			return const CategoriaColors(Color(0xFFE8EAF6), Color(0xFF3F51B5));
		}
		if (c.contains('thai') || c.contains('tailandesa')) {
			return const CategoriaColors(Color(0xFFE0F7FA), Color(0xFF00838F));
		}
		return const CategoriaColors(Color(0xFFF3E5F5), Color(0xFF8E24AA));
	}
}

class CategoriaColors {
	final Color fondo;
	final Color texto;
	const CategoriaColors(this.fondo, this.texto);
}
