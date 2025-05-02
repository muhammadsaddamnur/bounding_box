import 'dart:developer';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:bounding_box/bounding_box.dart';

void main() {
  runApp(const MyApp());
}

class BoxItem {
  final int id;
  final BoundingBoxController controller;

  BoxItem({required this.id, required this.controller});
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> logs = [];

  // Unique ID generator
  int _nextId = 0;
  int? selectedId;

  // List of BoxItem wrappers
  List<BoxItem> items = [];

  // JSON input controller for dialog
  final TextEditingController _jsonInputController = TextEditingController();

  // Initial JSON data
  List jsonFile = [
    {
      "position": {"dx": 457.53515625, "dy": 101.7265625},
      "size": {"width": 150, "height": 150},
      "rotation": 0,
      "enable": false,
      "enable_rotate": true,
      "enable_move": true,
      "handle_resize_size": null,
      "handle_rotate_size": null,
      "handle_move_size": null,
      "handle_resize_background_color": null,
      "handle_resize_stroke_color": null,
      "handle_rotate_background_color": null,
      "handle_rotate_stroke_color": null,
      "handle_move_background_color": null,
      "handle_move_stroke_color": null,
      "stroke_color": null,
      "stroke_width": null,
      "handle_resize_stroke_width": null,
      "handle_rotate_stroke_width": null,
      "handle_move_stroke_width": null,
      "handle_position": null,
    },
    {
      "position": {"dx": 500, "dy": 500},
      "size": {"width": 150, "height": 150},
      "rotation": 0,
      "enable": false,
      "enable_rotate": true,
      "enable_move": true,
      "handle_resize_size": null,
      "handle_rotate_size": null,
      "handle_move_size": null,
      "handle_resize_background_color": null,
      "handle_resize_stroke_color": null,
      "handle_rotate_background_color": null,
      "handle_rotate_stroke_color": null,
      "handle_move_background_color": null,
      "handle_move_stroke_color": null,
      "stroke_color": null,
      "stroke_width": null,
      "handle_resize_stroke_width": null,
      "handle_rotate_stroke_width": null,
      "handle_move_stroke_width": null,
      "handle_position": null,
    },
  ];

  @override
  void initState() {
    super.initState();
    // Load initial items from JSON
    for (var j in jsonFile) {
      final controller = BoundingBoxController.fromJson(j);
      items.add(BoxItem(id: _nextId++, controller: controller));
    }
  }

  void _addItem() {
    final controller = BoundingBoxController(
      position: const Offset(100, 100),
      size: const Size(150, 150),
    );
    setState(() {
      items.add(BoxItem(id: _nextId++, controller: controller));
    });
  }

  void _deleteSelected({bool all = false}) {
    setState(() {
      if (all) {
        items.clear();
        selectedId = null;
      } else if (selectedId != null) {
        items.removeWhere((it) => it.id == selectedId);
        selectedId = null;
      }
      // Reset enable flags
      for (var it in items) {
        it.controller.update(newEnable: false);
      }
    });
  }

  bool get hasSelection {
    return selectedId != null && items.any((it) => it.id == selectedId);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: GestureDetector(
          onTap: () {
            // Deselect on background tap
            setState(() {
              selectedId = null;
              for (var it in items) {
                it.controller.update(newEnable: false);
              }
            });
          },
          child: Row(
            children: [
              // Sidebar
              Container(
                color: Colors.blue,
                width: 200,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Selected ID: ${selectedId ?? "None"}'),
                    ),
                    buildButton('Add Item', _addItem),
                    buildButton('Delete', () => _deleteSelected()),
                    buildButton('Delete All', () => _deleteSelected(all: true)),
                    buildButton('Get Property', () {
                      if (hasSelection) {
                        final it = items.firstWhere(
                          (it) => it.id == selectedId,
                        );
                        logs.add(
                          jsonEncode([it.controller.toJson()]).toString(),
                        );
                        setState(() {});
                      }
                    }),
                    buildButton('toJson', () {
                      if (items.isNotEmpty) {
                        final List<String> jj =
                            items
                                .map((it) => jsonEncode(it.controller.toJson()))
                                .toList();
                        logs.add(jj.toString());
                        setState(() {});
                      }
                    }),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.white,
                        child: TextField(
                          controller: _jsonInputController,
                          maxLines: 5,
                        ),
                      ),
                    ),
                    buildButton('From JSON', () {
                      try {
                        final data = jsonDecode(_jsonInputController.text);
                        if (data is List) {
                          final newItems = <BoxItem>[];
                          for (var entry in data) {
                            if (entry is Map<String, dynamic>) {
                              final ctrl = BoundingBoxController.fromJson(
                                entry,
                              );
                              newItems.add(
                                BoxItem(id: _nextId++, controller: ctrl),
                              );
                            }
                          }
                          setState(() {
                            items = newItems;
                            selectedId = null;
                          });
                        }
                      } catch (e) {
                        logs.add(e.toString());
                        setState(() {});
                      }
                    }),
                  ],
                ),
              ),

              // Canvas & Logs
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            for (final item in items)
                              (() {
                                final id = item.id;
                                final ctrl = item.controller;
                                return BoundingBoxOverlay(
                                  key: ValueKey(id),
                                  controller: ctrl,
                                  onTap: () {
                                    setState(() {
                                      selectedId = id;
                                      for (var it in items) {
                                        it.controller.update(
                                          newEnable: it.id == id,
                                        );
                                      }
                                    });
                                  },
                                  builder: (size, position, rotation) {
                                    return Container(
                                      width: size.width,
                                      height: size.height,
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.5),
                                        border: Border.all(
                                          color:
                                              ctrl.enable
                                                  ? Colors.red
                                                  : Colors.transparent,
                                          width: 2,
                                        ),
                                      ),
                                      child: Center(child: Text('Box $id')),
                                    );
                                  },
                                );
                              })(),
                          ],
                        ),
                      ),
                      // Logs panel
                      Container(
                        height: 200,
                        color: Colors.black,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  logs.clear();
                                });
                              },
                              child: const Text(
                                'Clear',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListView.builder(
                                  itemCount: logs.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: SelectableText(
                                        logs[index],
                                        style: const TextStyle(
                                          color: Colors.amber,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Utility for sidebar buttons
  Widget buildButton(String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ButtonStyle(
          fixedSize: MaterialStateProperty.all(const Size(150, 30)),
        ),
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}
