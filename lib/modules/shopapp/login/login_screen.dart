import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shopappp/layout/shop_app/shop_layout.dart';
import 'package:shopappp/layout/shop_app/shopcubit/shopcubit.dart';
import 'package:shopappp/modules/shopapp/login/cubit/cubit.dart';
import 'package:shopappp/modules/shopapp/login/cubit/states.dart';
import 'package:shopappp/modules/shopapp/register/shop_register_screen.dart';
import 'package:shopappp/shared/components/components.dart';
import 'package:shopappp/shared/components/constants.dart';
import 'package:shopappp/shared/network/local/remote/cache_helper.dart';

class ShopLoginScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return ShopLoginCubit();
      },
      child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
        listener: (context, state) {
          if (state is ShopLoginSuccessState) {
            if (state.loginModel.status!) {
              CacheHelper.saveData(
                      key: 'token', value: state.loginModel.data!.token)
                  .then((value) {
                navigateAndFinish(context, ShopLayout());
                token = state.loginModel.data!.token;
                ShopCubit.get(context).getUserData();
              });
            } else {
              showToast(
                message: state.loginModel.message!,
                state: ToastState.ERROR,
              );
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Login',
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(color: Colors.black),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'login now to browse our hot offers',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(color: Colors.grey),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              labelText: 'Email Address',
                              prefixIcon: Icon(Icons.email_outlined),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(2),
                              ),
                              hoverColor: Colors.blue),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please , enter your email address';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        TextFormField(
                          controller: passwordController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.email_outlined),
                              suffixIcon: IconButton(
                                icon: Icon(ShopLoginCubit.get(context).suffix),
                                onPressed: () {
                                  ShopLoginCubit.get(context)
                                      .changePasswordVisibility();
                                },
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(2),
                              ),
                              hoverColor: Colors.blue),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please , enter your password';
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            if (formkey.currentState!.validate()) {
                              ShopLoginCubit.get(context).userLogin(
                                  email: emailController.text,
                                  password: passwordController.text);
                            }
                          },
                          obscureText: ShopLoginCubit.get(context).isPassword,
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Container(
                          height: 45,
                          width: double.infinity,
                          child: ConditionalBuilder(
                            condition: state is! ShopLoginLoadingState,
                            builder: (context) => MaterialButton(
                              onPressed: () {
                                if (formkey.currentState!.validate()) {
                                  ShopLoginCubit.get(context).userLogin(
                                      email: emailController.text,
                                      password: passwordController.text);
                                }
                              },
                              child: Text('LOGIN'),
                              color: Colors.blue,
                            ),
                            fallback: (context) =>
                                Center(child: CircularProgressIndicator()),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Don\'t have an account?'),
                            TextButton(
                              onPressed: () {
                                navigateTo(context, ShopRegisterScreen());
                              },
                              child: Text('Register'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
