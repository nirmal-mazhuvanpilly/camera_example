import 'package:flutter/material.dart';
import 'package:sample_camera_project/opencamera.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeCamera(),
    );
  }
}

class HomeCamera extends StatelessWidget {
  const HomeCamera({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const OpenCamera(),
                      settings: const RouteSettings(name: "OpenCamera")));
                },
                child: const Text("Open Camera")),
            TextButton(
                onPressed: () async {
                },
                child: const Text("Open Camera")),
          ],
        ),
      ),
    );
  }
}
