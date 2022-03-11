import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shopappp/layout/shop_app/shopcubit/shopcubit.dart';
import 'package:shopappp/shared/styles/colors.dart';


Widget defultTextFormFeild({
  required String? labelText,
  String? hintText,
  required IconData? prefixIcon,
  IconData? suffixIcon,
  TextEditingController? controller,
  required TextInputType? keyboardType,
  bool obscureText = false,
  double radius = 3.0,
  Function? onSubmit,
  Function? onChange,
  Function? ontap,
  Function? onPressedSuffix,
  required Function? validator,
}) {
  return Container(
    child: TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(radius)),
        prefixIcon: Icon(prefixIcon),
        suffixIcon: IconButton(
            icon: Icon(suffixIcon),
            onPressed: () {
              onPressedSuffix!();
            }),
      ),
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: (c) {
        onChange!(c);
      },
      onFieldSubmitted: (s) {
        onSubmit!(s);
      },
      onTap: () {
        ontap!();
      },
      validator: (val) {
        validator!(val);
      },
    ),
  );
}

Widget buildTaskItem({
  required Map model,
}) {
  return Row(
    children: [
      CircleAvatar(
        backgroundColor: Colors.blue.shade900,
        child: Text(
          '${model['time']}',
          style: TextStyle(color: Colors.white),
        ),
        radius: 40.0,
      ),
      SizedBox(
        width: 20.0,
      ),
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${model['title']}',
            style: TextStyle(
                fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          Text(
            '2 , april , 2021',
            style: TextStyle(color: Colors.grey.shade700),
          ),
        ],
      ),
    ],
  );
}

Widget buildArticleItem(article, context) {
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: NetworkImage('${article['urlToImage']}'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Expanded(
          child: Container(
            height: 120.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Text(
                  '${article['title']}',
                  style: Theme.of(context).textTheme.bodyText1,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                )),
                Text(
                  '${article['publishedAt']}',
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget myDivider() => Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Container(
        width: double.infinity,
        height: 1.5,
        color: Colors.grey.shade300,
      ),
    );

void navigateTo(context, widget) => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ));

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
    context, MaterialPageRoute(builder: (context) => widget), (route) => false);

Future<bool?> showToast({
  required String message,
  required ToastState state,
}) =>
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: chooseToastColor(state),
        textColor: Colors.white,
        fontSize: 20.0);

enum ToastState { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastState state) {
  Color color;

  switch (state) {
    case ToastState.SUCCESS:
      color = Colors.green;
      break;
    case ToastState.ERROR:
      color = Colors.red;
      break;
    case ToastState.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}

Widget buildListProduct(model, context, {bool isOldPrice = true}) => Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        height: 120.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Image(
                  image: NetworkImage(model.image!),
                  width: 120.0,
                  fit: BoxFit.cover,
                ),
                if (model.discount != 0 && isOldPrice)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    color: Colors.red,
                    child: Text(
                      'DISCOUNT',
                      style: TextStyle(fontSize: 9.5, color: Colors.white),
                    ),
                  ),
              ],
            ),
            SizedBox(
              width: 13.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14.0, height: 1.3),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Text(
                        model.price.toString(),
                        style: TextStyle(
                            fontSize: 13.0, height: 1.3, color: defaultColor),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      if (model.discount != 0 && isOldPrice)
                        Text(
                          model.oldPrice.toString(),
                          style: TextStyle(
                            fontSize: 12.0,
                            height: 1.3,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      Spacer(),
                      CircleAvatar(
                        child: IconButton(
                            icon: Icon(
                              Icons.favorite_border,
                              size: 16.0,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              ShopCubit.get(context).changeFavorites(model.id!);
                              // print(model.id);
                            }),
                        backgroundColor:
                            ShopCubit.get(context).favorites[model.id]!
                                ? defaultColor
                                : Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
