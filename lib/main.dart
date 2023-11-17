import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Pro.dart';
import 'cart_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => CartProvider(),
        child: Builder(builder: (BuildContext context) {
          return MaterialApp(
            title: 'Learning Flutter',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(fontFamily: 'Kanit'),
            home: const ProductList(),
          );
        }));
  }
}
