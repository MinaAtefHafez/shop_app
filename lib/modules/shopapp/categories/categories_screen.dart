
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopappp/layout/shop_app/shopcubit/shopcubit.dart';
import 'package:shopappp/layout/shop_app/shopcubit/states.dart';
import 'package:shopappp/models/shop_app/categories_model.dart';
import 'package:shopappp/shared/components/components.dart';


class CategoriesScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocConsumer <ShopCubit , ShopStates> (
      listener: (context , state){} ,
      builder: (context  , state) {
        return   ListView.separated(
            itemBuilder: (context, index) => buildCatItem ( ShopCubit.get(context).categoryModel!.data!.data[index] )  ,
            separatorBuilder: (context, index) => myDivider() ,
            itemCount: ShopCubit.get(context).categoryModel!.data!.data.length ,

        );
      } ,
    );
  }

  Widget buildCatItem ( DataModel? model ) => Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        Image(image: NetworkImage(model!.image!),
          fit: BoxFit.cover,
          height: 80.0,
          width: 80.0,
        ) ,
        SizedBox(width: 20.0,) ,
        Text( model.name! , style:  TextStyle( fontSize: 20.0 ,fontWeight: FontWeight.bold ), ),
        Spacer() ,
        Icon( Icons.arrow_forward_ios ) ,
      ],
    ),
  );

}