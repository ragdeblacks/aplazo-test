import 'package:flutter/material.dart';
import 'app_localizations.dart';

extension BuildContextExtension on BuildContext {
  AppLocalizations get texto => AppLocalizations.of(this)!;
}
