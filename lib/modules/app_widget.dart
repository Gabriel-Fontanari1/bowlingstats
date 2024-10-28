import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  //interface do widget
  @override
  Widget build(BuildContext context) {
    //material configura o material design e o roteamento do app
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //roteamento
      routerConfig: Modular.routerConfig,
    );
  }
}
