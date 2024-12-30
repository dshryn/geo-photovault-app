import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:geotag/screens/camerascreen.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<Map<String, dynamic>> photos = [];
  List<Map<String, dynamic>> filteredPhotos = [];
  String searchQuery = '';
  String selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    loadImages();
  }

  Future<void> loadImages() async {
    try {
      final Directory? appDir = await getExternalStorageDirectory();
      if (appDir != null) {
        final List<FileSystemEntity> entities =
            appDir.listSync(recursive: true);

        final List<File> images = entities
            .whereType<File>()
            .where((file) => file.path.endsWith('.png'))
            .toList();

        setState(() {
          photos = images.map((image) {
            final String fileName = image.path.split('/').last;
            final String city = image.parent.path.split('/').last;

            return {
              'path': image.path,
              'location': city,
              'date': File(image.path).lastModifiedSync(),
            };
          }).toList();

          filteredPhotos = List.from(photos);
        });
      }
    } catch (e) {
      print('Error loading images: $e');
    }
  }

  void filterPhotos() {
    setState(() {
      filteredPhotos = photos.where((photo) {
        final matchesSearch = photo['location']
                .toString()
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            DateFormat.yMd().format(photo['date']).contains(searchQuery);
        if (selectedFilter == 'All') {
          return matchesSearch;
        }
        return matchesSearch && photo['location'] == selectedFilter;
      }).toList();
    });
  }

  Future<void> navigateToCamera() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CameraScreen(),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        photos.add(result);
        filterPhotos();
      });
    }
  }

  void showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String tempSearchQuery = searchQuery;
        return AlertDialog(
          title: const Text('Search Photos'),
          content: TextField(
            onChanged: (value) {
              tempSearchQuery = value;
            },
            decoration:
                const InputDecoration(hintText: 'Enter location or date'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  searchQuery = tempSearchQuery;
                });
                filterPhotos();
                Navigator.pop(context);
              },
              child: const Text('Search'),
            ),
          ],
        );
      },
    );
  }

  Widget filterDropdown() {
    final locations = ['All'] +
        photos.map((photo) => photo['location'].toString()).toSet().toList();

    return DropdownButton<String>(
      value: selectedFilter,
      items: locations
          .map((location) => DropdownMenuItem<String>(
                value: location,
                child: Text(location),
              ))
          .toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            selectedFilter = value;
          });
          filterPhotos();
        }
      },
    );
  }

  Widget makePhotoGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: filteredPhotos.length,
      itemBuilder: (context, index) {
        final photo = filteredPhotos[index];
        return GestureDetector(
          onTap: () {
            // open map of that loc
          },
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Image.file(
                    File(photo['path']),
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        photo['location'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        DateFormat.yMd().format(photo['date']),
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Gallery'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearchDialog();
            },
          ),
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: navigateToCamera,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter by:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                filterDropdown(),
              ],
            ),
          ),
          Expanded(
            child: filteredPhotos.isEmpty
                ? const Center(
                    child: Text('No photos found'),
                  )
                : makePhotoGrid(),
          ),
        ],
      ),
    );
  }
}
