import 'package:bowlingstats/modules/app_module.dart';
import 'package:bowlingstats/modules/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

void main() {
  //starta o app
  runApp(ModularApp(module: AppModule(), child: const AppWidget()));
}
