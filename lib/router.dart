import 'package:fluro/fluro.dart';
import 'constants/app_contstants.dart';
import 'ui/Home_View.dart';

class RouterFluro {
  static Router router = new Router();

  static final homeHandler = Handler(handlerFunc: (context, params) {
    return HomeView();
  });

  static configRouter() {
    router.define(RoutePaths.Home, handler: homeHandler);
  }
}
