import 'package:bounding_box/bounding_box.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: BoundingBox(
        initialSize: const Size(150, 150),
        initialPosition: const Offset(150, 200),
        // enable: false,
        builder: (size, position, rotation) {
          return Container(
            width: size.width,
            height: size.height,
            color: Colors.orange,
            alignment: Alignment.center,
            child: const Text("Drag / Resize / Rotate"),
          );
        },
      ),
    );
  }
}
