import 'package:flutter/material.dart';
import 'package:io1/userscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Chat App',
      home: MyHomeScreen(),
    );
  }
}

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  TextEditingController urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Scaffold(
        body: Column(
          children: [
            const Text("enter the Http url"),
            TextFormField(
              controller: urlController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'plz enter the url';
                }
                return null;
              },
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          UserSelectionScreen(url: urlController.text),
                    ),
                  );
                },
                child: const Text('enter'))
          ],
        ),
      ),
    );
  }
}
