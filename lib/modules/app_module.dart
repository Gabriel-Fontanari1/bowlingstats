import 'package:bowlingstats/modules/pages/home_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  //dependencias para ser injetadas
  @override
  void binds(i) {}

  //rotas
  @override
  void routes(r) {
    r.module('/', module: ModuleHome());
  }
}
