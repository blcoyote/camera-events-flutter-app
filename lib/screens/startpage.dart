import 'package:flutter/material.dart';
import '../main.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  MyScreenState createState() => MyScreenState();
}

class MyScreenState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    var appState = context.findAncestorStateOfType<MyAppState>();

    void logout() {
      appState?.setLoggedIn('');
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Screen'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('Hello, World!'),
            const SizedBox(height: 10),
            MaterialButton(
              onPressed: () {
                logout();
              },
            child: const Text('Logout'))
          ]),
        ),
      );
  }
}
