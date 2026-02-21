import 'package:block_app/controllers/cubit/task_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: MyHomePage());
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => TaskCubit(),
        child: BlocBuilder<TaskCubit, TaskState>(
          builder: (context, state) {
            final controllerCubit = context.read<TaskCubit>();
            return SafeArea(
              child: Column(
                children: [
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(hintText: 'Enter a task'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (controller.text.isEmpty) return;
                      controllerCubit.addTask(title: controller.text);
                      controller.clear();
                    },
                    child: Text('Add task'),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.tasks.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(state.tasks[index].title),
                          leading: Checkbox(
                            value: state.tasks[index].isCompleted,
                            onChanged: (value) {
                              controllerCubit.toggleTask(state.tasks[index].id);
                            },
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              controllerCubit.removeTask(state.tasks[index].id);
                            },
                            icon: Icon(Icons.delete),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
