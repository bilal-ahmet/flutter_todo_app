import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/data/local_storage.dart';
import 'package:flutter_todo_app/model/task_model.dart';
import 'package:flutter_todo_app/pages/home_page.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';

final locator = GetIt.instance;

void setup() {
  // <LocalStorage>, denmesindeki sebep başka bir zaman depolama değiştiği zaman sadece (HiveLOcalStorage) kısmı değişecek
  locator.registerSingleton<LocalStorage>(HiveLocalStorage());
}

Future<void> setupHive() async {
  await Hive.initFlutter();

  // TaskAdapter(), build_runner ile oluşturulan task_model.g sınıfında bulunmaktadır.
  Hive.registerAdapter(TaskAdapter());

  var taskBox = await Hive.openBox<Task>("tasks");

  for (var task in taskBox.values) {
    if (task.createdAt.day != DateTime.now().day) {
      taskBox.delete(task.id);
    }
  }
}

void main() async {
  // tunApp'ten önce çalışması istenilen dosylar olduğu için aşağıdaki kod yazılır.
  WidgetsFlutterBinding.ensureInitialized();
  
  await setupHive();
  setup();
  
  runApp(
    EasyLocalization(
        supportedLocales: [Locale('en', 'US'), Locale('tr', 'TR')],
        path:
            'assets/translation', // <-- change the path of the translation files
        fallbackLocale: Locale('en', 'US'),
        child: MyApp()),
  );
  await EasyLocalization.ensureInitialized();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.blue,
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black)),
        ),
        title: 'Material App',
        home: const HomePage());
  }
}
