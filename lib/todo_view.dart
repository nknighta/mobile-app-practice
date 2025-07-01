import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_class/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String name;
  bool isDone;

  Task({required this.name, this.isDone = false});

  // Methods to convert Task to and from JSON for local storage
  Map<String, dynamic> toJson() => {
        'name': name,
        'isDone': isDone,
      };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        name: json['name'],
        isDone: json['isDone'],
      );
}

class TodoView extends StatefulWidget {
  const TodoView({required this.title}) : super();
  final String title;

  @override
  _TodoViewState createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  final List<Task> _tasks = [];
  final TextEditingController _taskController = TextEditingController();
  final AuthService _authService = AuthService();
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _authService.user.listen((user) {
      setState(() {
        _currentUser = user;
      });
      if (user != null) {
        _loadTasks();
      }
    });
  }

  // --- Firestore Methods ---
  Future<void> _loadTasks() async {
    if (_currentUser == null) return;
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser!.uid)
        .collection('tasks')
        .get();
    setState(() {
      _tasks.clear();
      _tasks.addAll(snapshot.docs.map((doc) => Task.fromJson(doc.data())).toList());
    });
  }

  Future<void> _saveTaskToFirestore(Task task) async {
    if (_currentUser == null) return;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser!.uid)
        .collection('tasks')
        .doc(task.name)
        .set(task.toJson());
  }

  Future<void> _deleteTaskFromFirestore(Task task) async {
    if (_currentUser == null) return;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser!.uid)
        .collection('tasks')
        .doc(task.name)
        .delete();
  }

  // Method to add a new task
  void _addTask(String name) {
    if (name.isNotEmpty) {
      final newTask = Task(name: name);
      setState(() {
        _tasks.add(newTask);
      });
      _saveTaskToFirestore(newTask);
      _taskController.clear();
    }
  }

  // Method to toggle task completion
  void _toggleTaskDone(int index) {
    setState(() {
      _tasks[index].isDone = !_tasks[index].isDone;
    });
    _saveTaskToFirestore(_tasks[index]);
  }

  // Method to remove a task
  void _removeTask(int index) {
    final removedTask = _tasks[index];
    setState(() {
      _tasks.removeAt(index);
    });
    _deleteTaskFromFirestore(removedTask);
  }

  // Method to show a dialog for adding a task
  void _showAddTaskDialog() {
    showDialog(
      context: context, // Added context here
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Task'),
          content: TextField(
            controller: _taskController,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Enter task name'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                _taskController.clear();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                _addTask(_taskController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<User?>(
          stream: _authService.user,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasData) {
              final user = snapshot.data!;
              if (user.isAnonymous) {
                return Text('Guest User');
              }
              return Text(user.email ?? 'Welcome');
            }
            return Text(widget.title);
          },
        ),
        backgroundColor: Colors.deepPurpleAccent,
        actions: <Widget>[
          StreamBuilder<User?>(
            stream: _authService.user,
            builder: (context, snapshot) {
              final user = snapshot.data;
              if (user != null && user.photoURL != null) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(user.photoURL!),
                  ),
                );
              } else {
                return const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                );
              }
            },
          ),
          ElevatedButton(
            onPressed: () async {
              await _authService.signOut();
            },
            child: const Text('Sign Out'),
          )
        ],
      ),
      body: Column( // Changed from Center to Column to allow for list and button
        children: <Widget>[
          Expanded( // Make the ListView take available space
            child: _tasks.isEmpty
                ? const Center(child: Text('No tasks yet!'))
                : ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      final task = _tasks[index];
                      return ListTile(
                        leading: Checkbox(
                          value: task.isDone,
                          onChanged: (bool? value) {
                            _toggleTaskDone(index);
                          },
                        ),
                        title: Text(
                          task.name,
                          style: TextStyle(
                            decoration: task.isDone ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _removeTask(index),
                        ),
                      );
                    },
                  ),
          ),
          // Removed the old static Checkbox and Text(\"test\") Row
          Padding( // Add padding to the button
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50), // Make button wider
              ),
              onPressed: _showAddTaskDialog, // Call the dialog to add a task
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center, // Center button content
                children: <Widget>[
                  Icon(Icons.add),
                  SizedBox(width: 8), // Add space between icon and text
                  Text("add task") // Add Task
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
