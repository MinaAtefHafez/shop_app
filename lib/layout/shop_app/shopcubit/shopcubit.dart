import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopappp/layout/shop_app/shopcubit/states.dart';
import 'package:shopappp/models/shop_app/categories_model.dart';
import 'package:shopappp/models/shop_app/change_favorites_model.dart';
import 'package:shopappp/models/shop_app/favorites_model.dart';
import 'package:shopappp/models/shop_app/home_model.dart';
import 'package:shopappp/models/shop_app/login_model.dart';
import 'package:shopappp/modules/shopapp/categories/categories_screen.dart';
import 'package:shopappp/modules/shopapp/favorites/favorites_screen.dart';
import 'package:shopappp/modules/shopapp/products/products_screen.dart';
import 'package:shopappp/modules/shopapp/settings_screen/settings_screen.dart';
import 'package:shopappp/shared/components/constants.dart';
import 'package:shopappp/shared/network/end_points.dart';
import 'package:shopappp/shared/network/local/remote/dio_helper.dart';


class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  Map<int, bool> favorites = {};

  List<Widget> bottomScreens = [
    ProductsScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    SettingsScreen()
  ];

  void changeBottom(int index) {
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }

  HomeModel? homeModel;

  void getHomeData() {
    emit(ShopLoadingHomeDataState());

    DioHelper.getData(
      url: HOME,
      token: token,
    ).then((value) {
      homeModel = HomeModel.fromJson(value.data);

      homeModel!.data!.products.forEach((element) {
        favorites.addAll({element.id!: element.inFavorite!});
      });

      emit(ShopSuccessHomeDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorHomeDataState());
    });
  }

  CategoriesModel? categoryModel;

  void getCategoriesData() {
    emit(ShopLoadingHomeDataState());

    DioHelper.getData(
      url: GET_CATEGORIES,
    ).then((value) {
      categoryModel = CategoriesModel.fromJson(value.data);

      emit(ShopSuccessCategoriesDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorCategoriesDataState());
    });
  }

  ChangeFavoritesModel? favoritesChangeModel;

  void changeFavorites(int productId) {
    favorites[productId] = !favorites[productId]!;

    emit(ShopChangeFavoritesState());

    DioHelper.postData(
      url: FAVORITES,
      data: {
        'product_id': productId,
      },
      token: token,
    ).then((value) {
      favoritesChangeModel = ChangeFavoritesModel.fromJson(value.data);
      if (!favoritesModel!.status!) {
        favorites[productId] = !favorites[productId]!;
      } else {
        getFavorites();
      }

      emit(ShopSuccessChangeFavoritesState(favoritesChangeModel!));
    }).catchError((error) {
      favorites[productId] = !favorites[productId]!;
      emit(ShopErrorChangeFavoritesState());
    });
  }

  FavoritesModel? favoritesModel;

  void getFavorites() {
    emit(ShopLoadingGetFavoritesState());

    DioHelper.getData(url: FAVORITES, token: token).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);

      emit(ShopSuccessGetFavoritesState());
    }).catchError((error) {
      emit(ShopErrorGetFavoritesState());
    });
  }

  ShopLoginModel? userModel;

  void getUserData() {
    emit(ShopLoadingUserDataState());

    DioHelper.getData(url: PROFILE, token: token).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);

      emit(ShopSuccessUserDataState());
    }).catchError((error) {
      emit(ShopErrorUserDataState());
    });
  }

  void updateUserData({
    required String name,
    required String email,
    required String phone,
  }) {
    emit(ShopLoadingUpdateUserState());

    DioHelper.putData(
      url: UPDATE_USER,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
      },
      token: token,
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);

      emit(ShopSuccessUpdateUserState(userModel!));
    }).catchError((error) {
      emit(ShopErrorUpdateUserState());
    });
  }
}
