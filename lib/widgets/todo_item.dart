import 'package:flutter/material.dart';
import 'package:project_s/constants/const.dart';
import 'package:project_s/model/todo.dart';

class ToDoItem extends StatelessWidget {
  final ToDo todo;
  final showEditPeriodDialog;
  final onToDoChanged;
  final onDeleteItem;

  const ToDoItem({
    super.key,
    required this.todo,
    required this.showEditPeriodDialog,
    required this.onToDoChanged,
    required this.onDeleteItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: () {
          showEditPeriodDialog(context, todo);
        },
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          tileColor: Colors.white,
          leading: InkWell(
            onTap: () {
              // print('Clicked on Todo Item.');
              onToDoChanged(todo);
            },
            child: Icon(
              todo.isDone ? Icons.check_box : Icons.check_box_outline_blank,
              color: vermelhoPadrao,
            ),
          ),
          title: Text(
            todo.todoText!,
            style: TextStyle(
              fontSize: 16,
              color: pretoPadrao,
              decoration: todo.isDone ? TextDecoration.lineThrough : null,
            ),
          ),
          trailing: Container(
            padding: const EdgeInsets.all(0),
            margin: const EdgeInsets.symmetric(vertical: 12),
            height: 35,
            width: 35,
            decoration: BoxDecoration(
              color: vermelhoPadrao,
              borderRadius: BorderRadius.circular(5),
            ),
            child: IconButton(
              color: Colors.white,
              iconSize: 18,
              icon: const Icon(Icons.delete),
              onPressed: () {
                // print('Clicked on delete icon');
                onDeleteItem(todo.id);
              },
            ),
          ),
        ),
      ),
    );
  }
}
