import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/bloc/app_States.dart';
import 'package:todo_app/bloc/cubit.dart';
import 'package:todo_app/modules/archived_tasks_screen.dart';
import 'package:todo_app/modules/done_tasks_screen.dart';
import 'package:todo_app/modules/new_tasks_screen.dart';
import 'package:todo_app/shared/Shared_data.dart';
import 'package:todo_app/shared/shared_compunents.dart';

class HomeLayout extends StatefulWidget {
  @override
  _HomeLayoutState createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    return BlocProvider(create: (context){return AppCubit();},
      child:BlocConsumer<AppCubit,AppStates>(listener:(context,state){
        if(state is InsertToDataBaseState){
          Navigator.pop(context);
        }
       } ,
      builder:(context,state){
        AppCubit c=BlocProvider.of(context);


        return Scaffold(
          key: scaffoldkey,
          appBar: AppBar(
            title: Text("ToDo App"),
          ),
          body: ConditionalBuilder(
            condition: c.newTasks!=null,
            builder: (context) {
                  return c.screens[c.current_index];
                },

           fallback: (context){
            return Center(child: CircularProgressIndicator());
          },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (c.isBottomSheetOn) {
                if (formKey.currentState.validate()) {
                  c.insert(
                      name: titleController.text,
                      time: timeController.text,
                      date: dateController.text);
                }
              } else {
                scaffoldkey.currentState
                    .showBottomSheet(
                        (context) => Container(
                      width: double.infinity,
                      color: Colors.white,
                      padding: EdgeInsets.all(20),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            defaultformfield(
                                controller: titleController,
                                prefixicon: Icons.title,
                                inputType: TextInputType.text,
                                labeltext: "Title",
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return " Title must not be empty";
                                  }
                                  return null;
                                }),
                            SizedBox(
                              height: 10,
                            ),
                            defaultformfield(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return " Time must not be empty";
                                }
                                return null;
                              },
                              controller: timeController,
                              prefixicon: Icons.watch_later_outlined,
                              inputType: TextInputType.datetime,
                              labeltext: "Time",
                              onTap: () {
                                showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now())
                                    .then((value) {
                                  timeController.text =
                                      value.format(context);
                                });
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            defaultformfield(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return " Date must not be empty";
                                }
                                return null;
                              },
                              controller: dateController,
                              prefixicon: Icons.date_range_outlined,
                              inputType: TextInputType.datetime,
                              labeltext: "Date",
                              onTap: () {
                                showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate:
                                    DateTime.parse("2021-12-31"))
                                    .then((DateTime value) {
                                  dateController.text =
                                      DateFormat.yMMMd().format(value);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    elevation: 20.0)
                    .closed
                    .then((value) {
                 c.changeBottomSheetStatus(bottomsheetstatus: false, icon: Icons.edit_outlined);
                });
                c.changeBottomSheetStatus(bottomsheetstatus: true, icon:Icons.add);
              }
            },
            child: Icon(c.bottomSheetIcon),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: c.current_index,
            onTap: (index) {

              c.changeNavIndex(index);

            },
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.menu), label: "New Tasks"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle), label: "DoneTasks"),
              BottomNavigationBarItem(icon: Icon(Icons.archive), label: "Archived"),
            ],
          ),
        );

      } ,) ,);
  }

  void testFutures() async {
    String s = await Future.delayed(Duration(seconds: 5), () {
      return "this is future value";
    });

    print(s);

    print("this is first value");
  }



}
