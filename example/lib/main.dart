import 'package:flutter/material.dart';
import 'package:show_toast/show_toast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.blue)),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  void _showMessage(BuildContext context, ToastType type) {
    context.showToastMessage(
      message: 'This is a toast',
      type: type,
      alignment: .top,
      inset: EdgeInsets.only(top: 70),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            FilledButton(
              onPressed: () => _showMessage(context, .success),
              child: Text('Show success toast'),
            ),
            FilledButton(
              onPressed: () => _showMessage(context, .neutral),
              child: Text('Show neutral toast'),
            ),
            FilledButton(
              onPressed: () => _showMessage(context, .warning),
              child: Text('Show warning toast'),
            ),
          ],
        ),
      ),
    );
  }
}
