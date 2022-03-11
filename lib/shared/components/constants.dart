
import 'package:shopappp/modules/shopapp/login/login_screen.dart';
import 'package:shopappp/shared/components/components.dart';
import 'package:shopappp/shared/network/local/remote/cache_helper.dart';

void signOut(context) {
  CacheHelper.removeData(key: 'token').then((value) {
    if (value) {
      navigateAndFinish(context, ShopLoginScreen());
    }
  });
}

String? token;
