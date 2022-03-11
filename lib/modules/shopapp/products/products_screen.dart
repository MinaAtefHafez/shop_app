


import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopappp/layout/shop_app/shopcubit/shopcubit.dart';
import 'package:shopappp/layout/shop_app/shopcubit/states.dart';
import 'package:shopappp/models/shop_app/categories_model.dart';
import 'package:shopappp/models/shop_app/home_model.dart';
import 'package:shopappp/shared/components/components.dart';
import 'package:shopappp/shared/styles/colors.dart';


class ProductsScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocConsumer <ShopCubit , ShopStates> (
      listener: (context, state) {
        if ( state is ShopSuccessChangeFavoritesState ) {
           if (!state.model.status!) {
             showToast(message: state.model.message! , state: ToastState.ERROR   ) ;
           }
        }
      },
      builder: (context, state) {
        return ConditionalBuilder(
          condition: ShopCubit
              .get(context)
              .homeModel != null && ShopCubit.get(context).categoryModel != null ,
          builder: (context) => builderWidget(ShopCubit.get(context).homeModel , ShopCubit.get(context).categoryModel ,context ),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget builderWidget( HomeModel? model  , CategoriesModel? categoriesModel , context ) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           CarouselSlider(
               items: model!.data!.banners.map((e) => Image(image: NetworkImage('${e.image}') , fit: BoxFit.cover, width: double.infinity, )  ).toList() ,
               options: CarouselOptions(
                 height: 250.0 ,
                 initialPage: 0 ,
                 viewportFraction: 1.0,
                 enableInfiniteScroll: true,
                 reverse: false ,
                 autoPlay: true ,
                 autoPlayInterval: Duration(seconds: 3) ,
                 autoPlayAnimationDuration: Duration(seconds: 1) ,
                 autoPlayCurve: Curves.fastOutSlowIn ,
                 scrollDirection: Axis.horizontal ,

               ) ,
           ),
           SizedBox(height: 10.0,),

         Padding(
           padding: const EdgeInsets.symmetric( horizontal: 10.0 ),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Padding(
                 padding: const EdgeInsets.symmetric(vertical: 10.0),
                 child: Text('Categories' ,
                   style: TextStyle(  fontSize:  24 , fontWeight: FontWeight.w800 ) ,  ),
               ) ,

                 Container(
                   height: 100,
                   child: ListView.separated(

                     physics:BouncingScrollPhysics() ,
                     scrollDirection: Axis.horizontal ,
                       itemBuilder: (context, index) => buildCategoryItem(categoriesModel!.data!.data[index]) ,
                       separatorBuilder: (context, index) => SizedBox(width: 10.0,) ,
                       itemCount: categoriesModel!.data!.data.length ,
                   ),
                 ) ,

                 Padding(
                   padding: const EdgeInsets.symmetric(vertical: 25) ,
                   child: Text('New Products' ,
                     style: TextStyle(  fontSize:  24 , fontWeight: FontWeight.w800 ) ,  ),
                 ),
             ],
           ),
         ) ,

         Container(
           color: Colors.grey.shade300,
           child: GridView.count(

             shrinkWrap: true ,
             physics: NeverScrollableScrollPhysics() ,
             mainAxisSpacing: 1.0,
             crossAxisSpacing: 1.0,
             crossAxisCount: 2 ,
             childAspectRatio: 1/1.51 ,
             children: List.generate(model.data!.products.length, (index) => buildGridProduct(model.data!.products[index] , context) ) ,
           ),
         ),

         ],
      ),
    );
  }

  Widget buildCategoryItem (DataModel? model) => Container(
    width: 100.0,
    height: 100.0,
    child: Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        Image(image: NetworkImage( '${model!.image}') ,
          fit: BoxFit.cover,
          height: 100.0,
          width: 100.0,
        ) ,
        Container(
          child: Text( '${model.name}' ,
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ) ,
          color:  Colors.black.withOpacity(0.8)
          , width: double.infinity,

        ) ,
      ],
    ),
  ) ;

  Widget buildGridProduct ( ProductsModel model , context ) => Container(
    color: Colors.white,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomStart ,
          children: [
            Image(image: NetworkImage(model.image!)  ,
              width: double.infinity,
              height: 200.0,
              fit: BoxFit.cover,

            ),
            if (model.discount != 0 )
            Container (
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              color: Colors.red,
              child: Text ( 'DISCOUNT' , style: TextStyle(
                fontSize: 9.5 ,
                color: Colors.white
              ) , ) ,
            ) ,

          ],
        ),
        Padding(
          padding: EdgeInsets.all (12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text( model.name! , maxLines:  2, overflow: TextOverflow.ellipsis ,
                style: TextStyle( fontSize: 14.0 , height: 1.3 ),
              ),
              Row(
                children: [
                  Text( '${model.price.round()}' ,
                    style: TextStyle( fontSize: 13.0 , height: 1.3 , color: defaultColor  ),
                  ),
                  SizedBox(width: 5.0,) ,
                  if (model.discount != 0 )
                    Text( '${model.oldPrice.round()}' ,
                      style: TextStyle( fontSize: 12.0 , height: 1.3 , color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  Spacer() ,
                       CircleAvatar(child: IconButton(icon: Icon(Icons.favorite_border , size: 16.0, color: Colors.white, ) ,
                           onPressed: (){
                             ShopCubit.get(context).changeFavorites(model.id!) ;

                           }) ,
                       backgroundColor:  ShopCubit.get(context).favorites[model.id]! ? defaultColor : Colors.grey ,
                       ) ,
                ],
              ),
            ],
          ) ,
        ) ,

      ],
    ),
  ) ;
}
