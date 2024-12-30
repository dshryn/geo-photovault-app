import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isProcessing = false;

  Future<void> _captureAndSave() async {
    try {
      setState(() {
        _isProcessing = true;
      });

      // take pic
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image == null) {
        setState(() {
          _isProcessing = false;
        });
        return;
      }

      // get loc
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];

      String city = place.locality ?? "Unknown City";
      String state = place.administrativeArea ?? "Unknown State";

      // watermark and save
      final watermarkedImage =
          await _addWatermark(File(image.path), city, state, position);

      final savedPath = await _saveImageToFolder(watermarkedImage, city);

      setState(() {
        _isProcessing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
          'Image saved in $savedPath',
        )),
      );

      // update gallery screen
      Navigator.of(context).pop(savedPath);
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<File> _addWatermark(
      File imageFile, String city, String state, Position position) async {
    img.Image? image = img.decodeImage(imageFile.readAsBytesSync());
    if (image == null) {
      throw Exception("Unable to decode image");
    }

    final watermarkText = "City: $city, State: $state\n"
        "Lat: ${position.latitude}, Lon: ${position.longitude}";

    img.drawString(image, img.arial_24, 10, 10, watermarkText);

    // save new file
    final tempDir = await getTemporaryDirectory();
    final watermarkedPath =
        '${tempDir.path}/watermarked_${DateTime.now().toIso8601String()}.png';
    File(watermarkedPath).writeAsBytesSync(img.encodePng(image));

    return File(watermarkedPath);
  }

  Future<String> _saveImageToFolder(File image, String city) async {
    final directory = await getExternalStorageDirectory();
    final cityFolder = Directory('${directory!.path}/GeoTagPhotos/$city');
    if (!cityFolder.existsSync()) {
      cityFolder.createSync(recursive: true);
    }
    final filePath =
        '${cityFolder.path}/${DateTime.now().toIso8601String()}.png';
    image.copySync(filePath);

    // refresh gallery
    try {
      const MethodChannel('com.example.geotag/gallery')
          .invokeMethod('refreshGallery', filePath);
    } catch (e) {
      print("Error refreshing gallery: $e");
    }

    return filePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera'),
      ),
      body: Center(
        child: _isProcessing
            ? const CircularProgressIndicator()
            : ElevatedButton.icon(
                onPressed: _captureAndSave,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Capture'),
              ),
      ),
    );
  }
}
