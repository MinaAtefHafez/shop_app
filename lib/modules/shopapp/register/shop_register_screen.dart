import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopappp/modules/shopapp/login/login_screen.dart';
import 'package:shopappp/modules/shopapp/register/cubit/register_cubit.dart';
import 'package:shopappp/modules/shopapp/register/cubit/states.dart';
import 'package:shopappp/shared/components/components.dart';


class ShopRegisterScreen extends StatelessWidget {
  var formkey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return ShopRegisterCubit();
      },
      child: BlocConsumer<ShopRegisterCubit, ShopRegisterStates>(
        listener: (context, state) {
          if (state is ShopRegisterSuccessState) {
            if (state.registerModel.status!) {
              showToast(
                      message: state.registerModel.message!,
                      state: ToastState.SUCCESS)
                  .then((value) {
                navigateAndFinish(context, ShopLoginScreen());
              });
            } else if (!state.registerModel.status!) {
              showToast(
                  message: state.registerModel.message!,
                  state: ToastState.ERROR);
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
                          'Register',
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(color: Colors.black),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'register now to browse our hot offers',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(color: Colors.grey),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(fontWeight: FontWeight.bold),
                            labelText: 'Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3.0),
                            ),
                            prefixIcon: Icon(Icons.person),
                          ),
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value!.isEmpty)
                              return ' please , name must not be empty ';

                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(fontWeight: FontWeight.bold),
                            labelText: 'Email Address',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3.0),
                            ),
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
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
                              icon: Icon(ShopRegisterCubit.get(context).suffix),
                              onPressed: () {
                                ShopRegisterCubit.get(context)
                                    .changePasswordVisibility();
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please , enter your password';
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {},
                          obscureText:
                              ShopRegisterCubit.get(context).isPassword,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        TextFormField(
                          controller: phoneController,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(fontWeight: FontWeight.bold),
                            labelText: 'Phone',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3.0),
                            ),
                            prefixIcon: Icon(Icons.phone),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value!.isEmpty)
                              return 'please , phone must not be empty ';

                            return null;
                          },
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Container(
                          height: 45,
                          width: double.infinity,
                          child: ConditionalBuilder(
                            condition: state is! ShopRegisterLoadingState,
                            builder: (context) => MaterialButton(
                              onPressed: () {
                                if (formkey.currentState!.validate()) {
                                  ShopRegisterCubit.get(context).userRegister(
                                    email: emailController.text,
                                    password: passwordController.text,
                                    name: nameController.text,
                                    phone: phoneController.text,
                                  );
                                }
                              },
                              child: Text('Register'),
                              color: Colors.blue,
                            ),
                            fallback: (context) =>
                                Center(child: CircularProgressIndicator()),
                          ),
                        ),
                        SizedBox(
                          height: 15,
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
