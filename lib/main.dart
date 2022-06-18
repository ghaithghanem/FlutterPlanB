import 'package:flutter/material.dart';
import 'signin.dart';
import 'sandwich.dart';
import 'detail_info.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        "/": (BuildContext context) {
          return const Signin();
        },
        "/sandwich": (BuildContext context) {
          return const Sandwich();
        },
        "/detail_info": (BuildContext context) {
          return const ProductDetails();
        }
      },

    );
  }
}

