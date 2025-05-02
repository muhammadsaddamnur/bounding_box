import 'package:flutter/material.dart';
import 'package:bounding_box/bounding_box.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            BoundingBoxOverlay(
              controller: BoundingBoxController(
                position: Offset(100, 100),
                size: Size(100, 100),
                enable: true,
              ),
              builder: (size, position, rotation) {
                return Container(
                  width: size.width,
                  height: size.height,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.5),
                    border: Border.all(width: 2),
                  ),
                  child: Center(child: Text('Box')),
                );
              },
            ),
            BoundingBoxOverlay(
              controller: BoundingBoxController(
                position: Offset(200, 200),
                size: Size(100, 100),
                enable: false,
              ),
              builder: (size, position, rotation) {
                return Container(
                  width: size.width,
                  height: size.height,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.5),
                    border: Border.all(width: 2),
                  ),
                  child: Center(child: Text('Box')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
