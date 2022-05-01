import 'package:flutter/material.dart';
import 'package:github_page/models/user_model.dart';
import 'package:github_page/pages/first_page.dart';
import 'package:github_page/pages/profile_page.dart';
import 'package:github_page/services/hive_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox(HiveService.DB_NAME);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Github',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        HomePage.id: (context) => const HomePage(),
        ProfilePage.id: (context) => ProfilePage(user: User(username: '', name: '', profileImage: ''))
      },
    );
  }
}