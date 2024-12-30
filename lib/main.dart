import 'package:flutter/material.dart';
import 'package:geotag/screens/camerascreen.dart';
import 'package:geotag/screens/galleryscreen.dart';
import 'package:geotag/screens/homescreen.dart';
import 'package:geotag/screens/mapscreen.dart';
import 'package:geotag/screens/settingscreen.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _requestPermissions();
  runApp(const GeoTagApp());
}

Future<void> _requestPermissions() async {
  if (await Permission.camera.isDenied) {
    await Permission.camera.request();
  }

  if (await Permission.location.isDenied) {
    await Permission.location.request();
  }

  if (await Permission.storage.isDenied) {
    await Permission.storage.request();
  }

  if (await Permission.camera.isPermanentlyDenied ||
      await Permission.location.isPermanentlyDenied ||
      await Permission.storage.isPermanentlyDenied) {
    openAppSettings();
  }
}

class GeoTagApp extends StatelessWidget {
  const GeoTagApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GeoTag Cam',
      theme: ThemeData(primarySwatch: Colors.green),
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
