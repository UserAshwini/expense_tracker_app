import 'package:flutter/material.dart';
import 'screens/home/views/home_screen.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Expense Tracker",
      theme: ThemeData(
        colorScheme: ColorScheme.light(
            background: Colors.grey.shade100,
            onBackground: Colors.black,
            primary: const Color(0xffFF8066),
            secondary: const Color(0xffC34A36),
            tertiary: const Color(0xff4B4453),
            outline: Colors.grey.shade400),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
