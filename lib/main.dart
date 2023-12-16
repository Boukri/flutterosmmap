import 'package:dev_fast_map_app/map_screen.dart';
import 'package:flutter/material.dart';

void main() {
   WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(
      title: "Flutter loves map",
      home: MapScreen(),
    ),
  );
}
