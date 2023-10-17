import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/bloc/app_States.dart';
import 'package:todo_app/modules/archived_tasks_screen.dart';
import 'package:todo_app/modules/done_tasks_screen.dart';
import 'package:todo_app/modules/new_tasks_screen.dart';

class AppCubit extends Cubit<AppStates>{


  AppCubit() : super(AppIntState()){
    createDataBase().then((value) => database=value);
  }
  static AppCubit get(context){
    return BlocProvider.of(context);
  }
  IconData bottomSheetIcon=Icons.edit_outlined;
  Database database;
  List<Map> newTasks;
  List<Map> doneTasks;
  List<Map> archivedTasks;

  int current_index = 0;
 bool isBottomSheetOn=false;

  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen()
  ];

  void changeNavIndex(int index){
    current_index=index;
    emit(AppNavBarChangeIndexState());
  }

  Future<Database> createDataBase() async {
    return await openDatabase('todo.db', version: 1,
        onCreate: (database, version) async {
          print("database created");
          try {
            await database.execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT,date TEXT, time TEXT, status TEXT)');
            print("table created");
          } catch (error) {
            print("error when create table ${error.toString()}");
          }
        }, onOpen: (database) {
          print("database opened");
          getFromDataBase(database);
        });
  }

  void changeBottomSheetStatus({@required bottomsheetstatus,@required icon}){
    isBottomSheetOn=bottomsheetstatus;
    bottomSheetIcon=icon;
    emit(ChangeBottomSheetState());

  }

  void update({@required status,@required id}){
    updateDataBase(status: status,id: id).then((value) {
      getFromDataBase(database);
    });
  }

  void delete({@required int id}){
    //call delete from database
    deleteFromDataBase(id).then((value) {
      getFromDataBase(database);
    });
  }

  Future deleteFromDataBase(int id)async{

    await database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]);
  }


  Future updateDataBase({@required status,@required id})async{
    return  await database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]);

  }
  void insert( {@required name, @required time, @required date}){
    insetToDataBase(name,time,date).then((value) {
      changeBottomSheetStatus(bottomsheetstatus: false, icon: Icons.edit_outlined);
      getFromDataBase(database);
      });


  }
   Future insetToDataBase(  name, time,  date) async {
    await database.transaction((txn) {
      txn
          .rawInsert(
          'INSERT INTO tasks (title,date,time,status) VALUES ("$name","$date","$time","new")')
          .then((value) {
        print("inserted succsessfully ${value}");
        emit(InsertToDataBaseState());

      }).catchError((error) {
        print("error when insert  ${error.toString()}");
      });

      return null;
    });
  }

  void  getFromDataBase(Database database)  {

     database.rawQuery("SELECT * FROM tasks").then((value){
       newTasks=[];
       doneTasks=[];
       archivedTasks=[];
       value.forEach((element) {
         if(element['status']=='new'){
           newTasks.add(element);
         }
         else if(element['status']=='done'){
           doneTasks.add(element);

         }
         else{
           archivedTasks.add(element);

         }
       });
       print("new tasks + $newTasks");
       print("done tasks + $doneTasks");
       print("archived tasks + $archivedTasks");

       emit(GetFromDataBaseState());
     });
  }





}

