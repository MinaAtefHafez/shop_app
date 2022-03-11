import 'package:shopappp/models/shop_app/register_model.dart';


abstract class ShopRegisterStates {}

class ShopRegisterInitialState extends ShopRegisterStates {}

class ShopRegisterLoadingState extends ShopRegisterStates {}

class ShopRegisterSuccessState extends ShopRegisterStates {
  final RegisterModel registerModel;

  ShopRegisterSuccessState(this.registerModel);
}

class ShopRegistererrorState extends ShopRegisterStates {
  final String error;

  ShopRegistererrorState(this.error);
}

class ShopRegisterChangePasswordVisibilityState extends ShopRegisterStates {}
