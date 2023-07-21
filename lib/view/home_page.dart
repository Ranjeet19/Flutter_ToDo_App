import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:todo/model/todo.dart';
import 'package:todo/providers/todo_providers.dart';

import '../constants/sizedbox.dart';

class HomePage extends StatelessWidget {
  final todoController = TextEditingController();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Consumer(builder: (context, ref, child) {
          final todoData = ref.watch(todoProvider);
          return Column(children: [
            TextFormField(
              controller: todoController,
              onFieldSubmitted: (val) {

                final addTodo = Todo(title: val, dateTime: DateTime.now().toString());

                ref.read(todoProvider.notifier).addTodo(addTodo);
                todoController.clear();


              },
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(top: 20, left: 10),
                border: OutlineInputBorder(),
                hintText: "Add Note",
                suffixIcon: Icon(CupertinoIcons.add),
              ),
            ),
            Sizes.gapH10,
            Expanded(
                child: ListView.builder(
              itemCount: todoData.length,
              itemBuilder: (context, index) {
                final todo = todoData[index];
                return Card(
                  child: ListTile(
                    leading:const Icon(CupertinoIcons.calendar),
                    title: Text(todo.title),
                    subtitle: Text(todo.dateTime),
                    trailing: SizedBox(
                      width: 80,
                        child: Row(
                      children: [
                        IconButton(
                            onPressed: () {}, icon:const Icon(CupertinoIcons.pencil, size: 14,color: Colors.blueAccent,)),
                        IconButton(
                            onPressed: () {
                              Get.defaultDialog(
                                title: "Caution!!",
                                content: const Column(
                                  children: [
                                     Text("Are You Sure!!", style: TextStyle(color: Colors.red, fontSize: 18),),
                                     Sizes.gapH10,
                                     Text("You Really Want To Remove it!", style: TextStyle(color: Colors.red,fontSize: 14),),
                                  ],
                                ),
                                actions: [
                                  TextButton(onPressed: (){
                                    ref.watch(todoProvider.notifier).removeTodo(index);Get.back();
                                  }, child: const Text("Yes")),
                                  TextButton(onPressed: (){Get.back();}, child: const Text("No")),
                                ]
                              );
                            }, icon: const Icon(CupertinoIcons.delete,size: 14, color: Colors.red,)),
                      ],
                    )),
                  ),
                );
              },
            ))
          ]);
        }),
      ),
    );
  }
}
