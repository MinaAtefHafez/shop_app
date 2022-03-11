import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopappp/modules/shopapp/search/cubit/search_cubit.dart';
import 'package:shopappp/modules/shopapp/search/cubit/states.dart';
import 'package:shopappp/shared/components/components.dart';


class SearchScreen extends StatelessWidget {
  var searchController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(20.0), 
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(   
                      controller: searchController,
                      keyboardType: TextInputType.text,  
                      decoration: InputDecoration(
                        labelText: 'Search',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(3.0)),
                        prefixIcon: Icon(Icons.search),
                      ),
                      onFieldSubmitted: (value) {
                        if (formKey.currentState!.validate()) { 
                          SearchCubit.get(context)
                              .search(searchController.text);
                        }
                      },
                      validator: (value) {
                        if (value!.isEmpty)
                          return ' please , search must not be empty ';

                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (state is SearchLoadingState) LinearProgressIndicator(), 
                    SizedBox(
                      height: 10,
                    ),
                    if (state is SearchSuccessState)
                      Expanded(
                        child: ListView.separated(
                          itemBuilder: (context, index) => buildListProduct(
                              SearchCubit.get(context)
                                  .searchModel!
                                  .data!
                                  .data[index],
                              context,
                              isOldPrice: false),
                          separatorBuilder: (context, index) => myDivider(),
                          itemCount: SearchCubit.get(context)
                              .searchModel!
                              .data!
                              .data
                              .length,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
