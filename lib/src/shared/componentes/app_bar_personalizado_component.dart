import 'dart:ui';
import 'package:flutter/material.dart';

class AppBarPersonalizadoComponent extends StatelessWidget implements PreferredSizeWidget {
	final String titulo;
	final VoidCallback? onBackPressed;
	final List<Widget>? actions;
	final bool showBackButton;

	const AppBarPersonalizadoComponent({
		super.key,
		required this.titulo,
		this.onBackPressed,
		this.actions,
		this.showBackButton = true,
	});

	@override
	Widget build(BuildContext context) {
		return AppBar(
			title: ClipRRect(
				borderRadius: BorderRadius.circular(20),
				child: BackdropFilter(
					filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
					child: Container(
						padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
						decoration: BoxDecoration(
							color: Colors.white.withValues(alpha: 0.15),
							borderRadius: BorderRadius.circular(20),
							border: Border.all(
								color: Colors.white.withValues(alpha: 0.3),
								width: 1,
							),
						),
						child: Text(
							titulo,
							style: const TextStyle(
								color: Colors.white,
								fontSize: 18,
								fontWeight: FontWeight.w600,
								shadows: [
									Shadow(
										offset: Offset(0, 2),
										blurRadius: 4,
										color: Colors.black26,
									),
								],
							),
						),
					),
				),
			),
			flexibleSpace: ClipRRect(
				child: BackdropFilter(
					filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
					child: Container(color: Colors.black.withValues(alpha: 0.1)),
				),
			),
			backgroundColor: Colors.transparent,
			elevation: 0,
			leading: showBackButton
				? IconButton(
						icon: const Icon(Icons.arrow_back, color: Colors.white),
						onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
					)
				: null,
			actions: actions,
		);
	}

	@override
	Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
