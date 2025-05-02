import 'package:bounding_box/bounding_box.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<TypeToolItem> texts = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: TypeTool(),
    );
  }
}

class TypeToolItem {
  TextEditingController? controller;
  FocusNode? focusNode;
  BoundingBoxController? boundingBoxController;

  TypeToolItem({this.controller, this.focusNode, this.boundingBoxController});
}

class TypeTool extends StatefulWidget {
  const TypeTool({super.key, this.typeToolItems});

  final List<TypeToolItem>? typeToolItems;
  @override
  State<TypeTool> createState() => _TypeToolState();
}

class _TypeToolState extends State<TypeTool> {
  final style = const TextStyle(fontSize: 20);

  int? selectedTextIndex;
  List<TypeToolItem> typeToolItems = [];
  double heightText = 20;
  double sizeText = 200;
  bool isEnabled = false;

  @override
  void initState() {
    typeToolItems = widget.typeToolItems ?? [];
    super.initState();
  }

  void _addText(Offset position) {
    setState(() {
      typeToolItems.add(
        TypeToolItem(
          controller: TextEditingController(),
          focusNode: FocusNode(),
          boundingBoxController: BoundingBoxController(
            position: Offset(position.dx, position.dy),
            size: Size(300, 100),
            enable: true,
          ),
        ),
      );

      selectedTextIndex = typeToolItems.length - 1;

      Future.delayed(Duration.zero, () {
        typeToolItems.last.focusNode!.requestFocus();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTapDown: (details) {
        _addText(details.localPosition);
        isEnabled = !isEnabled;
        setState(() {});
      },
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            for (int i = 0; i < typeToolItems.length; i++)
              BoundingBoxOverlay(
                builder: (size, position, rotation) {
                  return Container(
                    color: Colors.transparent,
                    width: size.width,
                    height: size.height,
                    child: EditableText(
                      controller: typeToolItems[i].controller!,
                      focusNode: typeToolItems[i].focusNode!,
                      style: const TextStyle(fontSize: 20, color: Colors.black),
                      cursorColor: Colors.blue,
                      backgroundCursorColor: Colors.white,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      onChanged: (val) {},
                    ),
                  );
                },
                controller: typeToolItems[i].boundingBoxController,
              ),
          ],
        ),
      ),
    );
  }
}
