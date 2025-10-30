import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'form/form_screen.dart';
import 'tasks/task_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    FormScreen(),
    TaskListScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'Formulário' : 'Lista de Tarefas'),
        backgroundColor: _selectedIndex == 0 ? Colors.blue : Colors.purple,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              
            },
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Mais Opções',
        elevation: 2.0,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.assignment,
                color: _selectedIndex == 0 ? Theme.of(context).primaryColor : Colors.grey,
              ),
              onPressed: () => _onItemTapped(0),
              tooltip: 'Formulário',
            ),
            const SizedBox(width: 40),
            IconButton(
              icon: Icon(
                Icons.check_circle_outline,
                color: _selectedIndex == 1 ? Theme.of(context).primaryColor : Colors.grey,
              ),
              onPressed: () => _onItemTapped(1),
              tooltip: 'Tarefas',
            ),
          ],
        ),
      ),
    );
  }
}