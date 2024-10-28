import 'package:flutter_modular/flutter_modular.dart';
import 'package:bowlingstats/modules/pages/page_home.dart';

class ModuleHome extends Module {
  @override
  void routes(r) {
    r.child('/', child: (context) => const PageHome()); //rota para homepage
  }
}
