import 'package:flutter/material.dart';
import 'package:test_project/login.dart';
import 'package:test_project/stopwatch.dart';
import 'package:test_project/timer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _widgetOptions = <Widget>[
    TimerScreen(),
    StopwatchScreen(),
    LoginScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.timelapse_rounded), label: 'Timer'),
            BottomNavigationBarItem(
                icon: Icon(Icons.timer), label: 'Stopwatch'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Login'),
          ],
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          backgroundColor: Colors.green,
          selectedItemColor: Colors.white,
          selectedFontSize: 14.5,
          unselectedIconTheme: const IconThemeData(color: Colors.black),
          unselectedLabelStyle:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          iconSize: 25,
          showUnselectedLabels: true,
          onTap: _onItemTapped,
          elevation: 5),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }
}
