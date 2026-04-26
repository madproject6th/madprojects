<<<<<<< HEAD
import 'package:doctorappointment_app/ui/screen/login_screen.dart';
=======
import 'package:doctorappointment_app/ui/login_screen.dart';
>>>>>>> 264c03acb4c0243e771647d8c3f40e5c0c590a40
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: LoginScreen(),
    );
  }
}
