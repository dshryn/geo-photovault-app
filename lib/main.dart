import 'package:flutter/material.dart';
import 'package:geotag/screens/camerascreen.dart';
import 'package:geotag/screens/galleryscreen.dart';
import 'package:geotag/screens/homescreen.dart';
import 'package:geotag/screens/mapscreen.dart';
import 'package:geotag/screens/settingscreen.dart';

void main() {
  runApp(const GeoTagApp());
}

class GeoTagApp extends StatelessWidget {
  const GeoTagApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GeoTag Cam',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/camera': (context) => const CameraScreen(),
        '/gallery': (context) => const GalleryScreen(),
        '/map': (context) => const MapScreen(),
        '/settings': (context) => const SettingScreen(),
      },
    );
  }
}
