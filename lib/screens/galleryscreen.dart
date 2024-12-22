import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

    //sample
    photos = [
      {
        'path': 'assets/images/vellore.webp',
        'location': 'Vellore, TN',
        'date': DateTime(2024, 12, 15),
      },
      {
        'path': 'assets/images/pune.webp',
        'location': 'Pune, MH',
        'date': DateTime(2024, 12, 16),
      },
      {
        'path': 'assets/images/kolkata.webp',
        'location': 'Kolkata, WB',
        'date': DateTime(2024, 12, 17),
      },
      {
        'path': 'assets/images/pune2.jpeg',
        'location': 'Pune, MH',
        'date': DateTime(2024, 12, 21),
      },
    ];
    filteredPhotos = List.from(photos);
  }

  // filter
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

  // Widget buildFilterDropdown() {
  //   final locations = ['All'] +
  //       photos.map((photo) => photo['location'].toString()).toSet().toList();

  //   return DropdownButton<String>(
  //     value: selectedFilter,
  //     items: locations
  //         .map((location) => DropdownMenuItem<String>(
  //               value: location,
  //               child: Text(location),
  //             ))
  //         .toList(),
  //     onChanged: (value) {
  //       if (value != null) {
  //         setState(() {
  //           selectedFilter = value;
  //         });
  //         filterPhotos();
  //       }
  //     },
  //   );
  // }

  Widget buildPhotoGrid() {
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
            // opne map
          },
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Image.asset(
                    photo['path'],
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
              // search
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter by:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                // buildFilterDropdown(),
              ],
            ),
          ),
          Expanded(
            child: filteredPhotos.isEmpty
                ? const Center(
                    child: Text('No photos found'),
                  )
                : buildPhotoGrid(),
          ),
        ],
      ),
    );
  }
}
