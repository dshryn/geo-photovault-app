import 'package:flutter/material.dart';
import 'package:geotag/screens/camerascreen.dart';
import 'package:geotag/screens/galleryscreen.dart';
import 'package:geotag/screens/homescreen.dart';
import 'package:geotag/screens/mapscreen.dart';
import 'package:geotag/screens/settingscreen.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GeoTagApp());
}

class GeoTagApp extends StatefulWidget {
  const GeoTagApp({super.key});

  @override
  State<GeoTagApp> createState() => _GeoTagAppState();
}

class _GeoTagAppState extends State<GeoTagApp> {
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _requestPermissionsAtStartup();
  }

  Future<void> _requestPermissionsAtStartup() async {
    final PermissionStatus cameraPermission = await Permission.camera.request();
    final PermissionStatus locationPermission =
        await Permission.location.request();
    final PermissionStatus storagePermission =
        await Permission.storage.request();

    if (cameraPermission.isDenied ||
        locationPermission.isDenied ||
        storagePermission.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Some permissions were denied')),
      );
    }

    if (cameraPermission.isPermanentlyDenied ||
        locationPermission.isPermanentlyDenied ||
        storagePermission.isPermanentlyDenied) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Permissions Required'),
          content: const Text(
              'Some permissions are permanently denied. Please enable them in app settings to continue.'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await openAppSettings();
              },
              child: const Text('Open Settings'),
            ),
          ],
        ),
      );
    }
  }

  void updateTheme(bool isDark) {
    setState(() {
      isDarkMode = isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GeoTag Cam',
      theme:
          ThemeData(primarySwatch: Colors.green, brightness: Brightness.light),
      darkTheme:
          ThemeData(primarySwatch: Colors.green, brightness: Brightness.dark),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/camera': (context) => const CameraScreen(),
        '/gallery': (context) => const GalleryScreen(),
        '/map': (context) => const MapScreen(),
        '/settings': (context) => SettingScreen(onThemeChanged: updateTheme),
      },
    );
  }
}
