
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopappp/layout/shop_app/shopcubit/shopcubit.dart';
import 'package:shopappp/layout/shop_app/shopcubit/states.dart';
import 'package:shopappp/modules/shopapp/search/search_screen.dart';
import 'package:shopappp/shared/components/components.dart';


class ShopLayout extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return BlocConsumer <ShopCubit , ShopStates> (
      listener: (context, state) {

      } ,
      builder: (context, state) {

        var cubit = ShopCubit.get(context) ; 

        return Scaffold(
          appBar: AppBar(
            title: Text('Salla'),
          actions: [
            IconButton(icon: Icon(Icons.search), onPressed: (){
              navigateTo(context,  SearchScreen());
            }),
          ],
          ),
          body: cubit.bottomScreens[cubit.currentIndex] ,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
              onTap: (index){
              cubit.changeBottom(index);
              },
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home) , label: 'Home' ) ,
                BottomNavigationBarItem(icon: Icon(Icons.apps) , label: 'Categories' ) ,
                BottomNavigationBarItem(icon: Icon(Icons.favorite) , label: 'Favorites' ) ,
                BottomNavigationBarItem(icon: Icon(Icons.settings) , label: 'Settings' ) ,
              ]
          ),
        );
      },
    );
  }
}
