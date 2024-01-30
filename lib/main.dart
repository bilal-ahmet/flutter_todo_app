import 'package:flutter/material.dart';
import 'package:flutter_todo_app/model/task_model.dart';
import 'package:flutter_todo_app/pages/home_page.dart';
import 'package:hive_flutter/adapters.dart';

void main() async{ 
  // tunApp'ten önce çalışması istenilen dosylar olduğu için aşağıdaki kod yazılır.
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  // TaskAdapter(), build_runner ile oluşturulan task_model.g sınıfında bulunmaktadır.
  Hive.registerAdapter(TaskAdapter());
  
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black)
          ),
        ),
      title: 'Material App',
      home: const HomePage()
    );
  }
}