import 'package:flutter_modular/flutter_modular.dart';
import 'package:bowlingstats/modules/pages/page_home.dart';

//rotas e dependencias
class ModuleHome extends Module {
  @override
  void routes(r) {
    //rota para abrir o pagehome
    r.child('/', child: (context) => const PageHome());
  }
}
