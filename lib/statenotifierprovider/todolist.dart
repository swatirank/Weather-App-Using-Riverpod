import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: ToDoList()));
}

class Task {
  String name;
  bool isCompleted;

  Task({required this.name, this.isCompleted = false});
}

class TodoNotifier extends StateNotifier<List<Task>> {
  TodoNotifier() : super([]);

  void add(Task task) {
    state = [
      ...state,
      task,
    ]; // state => list<Task> , ...state => existing tasks , task => new tasks
  }

  void remove(Task task) {
    state =
        state
            .where((t) => t.name != task.name)
            .toList(); //.where((t) => t.name(the task we need to remove) != task.name(all the task to be checked either same or not) => filter out the task to be removed , .toList() => convert the filtered result back to new list
  }

  void completed(Task task) {
    state =
        state.map((t) {
          return t.name == task.name
              ? Task(
                name: t.name,
                isCompleted: !t.isCompleted,
              ) // iscompleted false hse to true thase to ena mate name bhi joshe  ji same rese ne to atle t.name use kryu che
              : t;
        }).toList();
  }
}

final todoProvider = StateNotifierProvider<TodoNotifier, List<Task>>((ref) {
  return TodoNotifier();
});

class ToDoList extends ConsumerWidget {
  const ToDoList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoList = ref.watch(todoProvider); // gets the task list
    final todoNotifier = ref.read(
      todoProvider.notifier,
    ); // gets the state notifier to modify tasks and to access the methods of todoProvider

    TextEditingController controller = TextEditingController();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 175, 226, 250),
        appBar: AppBar(
          title: const Text('To-do App'),
          backgroundColor: const Color.fromARGB(255, 51, 122, 202),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter a Task",
                      ),
                      onFieldSubmitted: (value) {
                        if (value.isNotEmpty) {
                          todoNotifier.add(Task(name: value));
                          controller.clear();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: ListView.builder(
                  itemCount: todoList.length,
                  itemBuilder: (context, index) {
                    final task = todoList[index];

                    return Column(
                      children: [
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: Color.fromARGB(255, 200, 218, 251),
                          child: ListTile(
                            title: Text(
                              task.name,
                              style: TextStyle(
                                decoration:
                                    task.isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                color:
                                    task.isCompleted
                                        ? Colors.grey
                                        : Colors.black87,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    todoNotifier.completed(task);
                                  },
                                  icon: Icon(
                                    Icons.check_circle,
                                    color:
                                        task.isCompleted
                                            ? Colors.blue
                                            : Colors.grey,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    todoNotifier.remove(task);
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Color.fromARGB(255, 249, 72, 59),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
