import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/app_States.dart';
import 'package:todo_app/bloc/cubit.dart';
import 'package:todo_app/shared/Shared_data.dart';
import 'package:todo_app/shared/shared_compunents.dart';

class NewTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(listener: (context,state){},
      builder: (context,state){
        AppCubit c=BlocProvider.of(context);
        return conditionalBuilder(c.newTasks);

      },);
  }
}
