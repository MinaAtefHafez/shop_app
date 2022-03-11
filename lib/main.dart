
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shopappp/layout/shop_app/shop_layout.dart';
import 'package:shopappp/layout/shop_app/shopcubit/shopcubit.dart';
import 'package:shopappp/modules/shopapp/login/login_screen.dart';
import 'package:shopappp/modules/shopapp/on_boarding/on_boarding_screen.dart';
import 'package:shopappp/shared/components/constants.dart';
import 'package:shopappp/shared/network/local/remote/cache_helper.dart';
import 'package:shopappp/shared/network/local/remote/dio_helper.dart';
import 'package:shopappp/shared/styles/themes.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //await Firebase.initializeApp();
  DioHelper.init();
  await CacheHelper.init();

  bool? onBoarding = CacheHelper.getData(key: 'onBoarding');
  token = CacheHelper.getData(key: 'token');
  token =null ;
  

  Widget widget;

  if (onBoarding != null) {
    if (token != null) {
      widget = ShopLayout();
    } else {
      widget = ShopLoginScreen();
    }
  } else {
    widget = OnBoardingScreen();
  }

  return runApp(MyApp(widget));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;

  MyApp(this.startWidget);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        
       
        BlocProvider(
          create: (BuildContext context) {
            return ShopCubit()
              ..getHomeData()
              ..getCategoriesData()
              ..getFavorites()
              ..getUserData();
          },
        ),
      ],

      child: MaterialApp(
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.light ,
                
            debugShowCheckedModeBanner: false,
            home: startWidget,
          ),
      
    );
  }
}