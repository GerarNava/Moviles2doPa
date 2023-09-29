import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TAREAS',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: const TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({Key? key}) : super(key: key);

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<TodoTask> _tasks = [];
  final List<TodoTask> _deletedTasks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tareas'),
      ),
      body: Container(
        color: Colors.green, // Fondo verde para la lista de tareas
        child: ListView.builder(
          itemCount: _tasks.length,
          itemBuilder: (context, index) {
            return Row(
              children: [
                Checkbox(
                  value: _tasks[index].isCompleted,
                  onChanged: (value) {
                    setState(() {
                      _tasks[index].isCompleted = value!;
                    });
                  },
                ),
                Expanded(
                  child: ListTile(
                    title: Text(_tasks[index].title),
                    subtitle: Text(_tasks[index].description),
                    onTap: () {
                      _editTask(_tasks[index]);
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _deleteTask(_tasks[index]);
                  },
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: 'TAREAS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.delete),
            label: 'ELIMINADAS',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            _showDeletedTasks();
          }
        },
      ),
    );
  }

  void _addTask() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTaskScreen()),
    );

    if (result != null) {
      setState(() {
        _tasks.add(result);
      });
    }
  }

  void _editTask(TodoTask task) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditTaskScreen(task)),
    );

    if (result != null) {
      setState(() {
        task.title = result.title;
        task.description = result.description;
      });
    }
  }

  void _deleteTask(TodoTask task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Eliminar Tarea"),
          content:
              const Text("¿Estás seguro de que deseas eliminar esta tarea?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _tasks.remove(task);
                  _deletedTasks.add(task);
                  Navigator.of(context).pop();
                });
              },
              child: const Text("Eliminar"),
            ),
          ],
        );
      },
    );
  }

  void _showDeletedTasks() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DeletedTasksScreen(_deletedTasks)),
    );
  }
}

class AddTaskScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  AddTaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Tarea'),
      ),
      body: Container(
        color: Colors.green, // Fondo verde para la pantalla de agregar
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Título'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor ingresa un título';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pop(
                        context,
                        TodoTask(
                          title: _titleController.text,
                          description: _descriptionController.text,
                        ),
                      );
                    }
                  },
                  child: const Text('Agregar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EditTaskScreen extends StatelessWidget {
  final TodoTask task;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  EditTaskScreen(this.task, {Key? key}) : super(key: key) {
    _titleController.text = task.title;
    _descriptionController.text = task.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Tarea'),
      ),
      body: Container(
        color: Colors.green, // Fondo verde para la pantalla de edición
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Título'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor ingresa un título';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pop(
                        context,
                        TodoTask(
                          title: _titleController.text,
                          description: _descriptionController.text,
                        ),
                      );
                    }
                  },
                  child: const Text('Guardar'),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, null);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                  child: const Text('Eliminar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DeletedTasksScreen extends StatelessWidget {
  final List<TodoTask> deletedTasks;

  DeletedTasksScreen(this.deletedTasks);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tareas Eliminadas'),
      ),
      body: Container(
        color: Colors.green, // Fondo verde para la lista de tareas eliminadas
        child: ListView.builder(
          itemCount: deletedTasks.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(deletedTasks[index].title),
              subtitle: Text(deletedTasks[index].description),
            );
          },
        ),
      ),
    );
  }
}

class TodoTask {
  String title;
  String description;
  bool isCompleted;

  TodoTask({
    required this.title,
    required this.description,
    this.isCompleted = false,
  });
}
