import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/app_States.dart';
import 'package:todo_app/bloc/cubit.dart';

Widget defaultformfield(
    { @required TextEditingController controller,
      @required TextInputType inputType,
      Function(String) onsubmit,
      Function onTap,
      @required String labeltext,
      @required IconData prefixicon,
      @required Function(String) validator,
      bool obscureText=false,
      IconData suffexicon,
      Function onIconButtonPressed,
    }
    ){
  return TextFormField(controller: controller,
    keyboardType: inputType,
    onFieldSubmitted:onsubmit ,
    obscureText: obscureText,
    onTap: onTap,
    decoration: InputDecoration(
      labelText: labeltext, border: OutlineInputBorder(),
      prefixIcon:Icon(prefixicon) ,
      suffixIcon: IconButton(icon: Icon(suffexicon),onPressed:onIconButtonPressed,),),
    validator: validator,


  );

}

Widget buildItemList(Map model,BuildContext context){

  AppCubit c=BlocProvider.of(context);
  return Dismissible(
    key:UniqueKey(),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(children: [
        CircleAvatar(child: Text("${model['time']}",style: TextStyle(color: Colors.white),),
        radius: 40,),
        SizedBox(width: 20.0,),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text("${model['title']}",style: TextStyle(fontWeight: FontWeight.bold),),
            Text("${model['date']}",style: TextStyle(color: Colors.grey)),
          ],),
        ),

        IconButton(icon: Icon(Icons.check_box,color: Colors.blue,), onPressed: (){
          c.update(status: "done", id: model['id']);
        }),
        SizedBox(width: 10.0,),
        IconButton(icon: Icon(Icons.archive,color: Colors.grey[400],), onPressed: (){
          c.update(status: "archived", id: model['id']);

        }),


      ],),
    ),
    onDismissed: (direction){
      c.delete(id: model['id']);

    },
  );

}

Widget conditionalBuilder(List<Map> tasks){
   return ConditionalBuilder(condition: tasks.length>0,
     builder: (context){
           return ListView.separated(
               itemBuilder: (context,index){
                 return buildItemList(tasks[index],context);
               }, separatorBuilder: (context,index){
             return Container(width: double.infinity,
               height: 1.0,
               color: Colors.grey[300],);
           }, itemCount:tasks.length);

         },fallback: (context){
         return Center(
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Icon(Icons.menu,color: Colors.grey[300],),
               Text("No Tasks Yet, Please Add Task",style: TextStyle(color: Colors.grey[300],
                   fontSize: 16,fontWeight: FontWeight.bold),),
             ],
           ),
         );


     });
}

