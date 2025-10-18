# Geo PhotoVault App

A smart photo vault app built with **Flutter** that automatically organizes your images by location metadata.

---

## Overview

**Geo PhotoVault** intelligently groups your photos based on where they were taken.  
It provides a seamless experience to explore, search, and manage your photo memories with a location-first approach.

---

## Key Features

- **Auto-Organization:** Automatically sorts photos into folders by **city** using embedded GPS metadata.  
- **Smart Search:** Instantly retrieve images using **place-based keywords**.  
- **Interactive Map View:** Visualize and browse all stored photos directly on an integrated **Google Maps** interface.  
- **Theme Support:** Includes **light** and **dark** modes with persistent user preferences.  
- **Privacy First:** Keeps all images stored securely within the app’s local directory.  

---

## Tech Stack

- **Framework:** Flutter  
- **Packages & APIs:**
  - [`image_picker`](https://pub.dev/packages/image_picker) : Capture or select photos  
  - [`geolocator`](https://pub.dev/packages/geolocator) : Access GPS and location metadata
  - [`path_provider`](https://pub.dev/packages/path_provider) : Local storage management
  - **Google Maps API** : Interactive map visualization  

---

## Getting Started

### Prerequisites
- Flutter SDK (v3.0+)
- Android Studio / VS Code
- Google Maps API key

### Setup Instructions
1. **Clone the repository**
   ```bash
   git clone https://github.com/dshryn/geo-photovault.git
   cd geo-photovault

2. **Install Dependencies**
   ```bash
   flutter pub get

3. Add your Google Maps API Key
  - Create a new key from Google Cloud Console
  - Update your AndroidManifest.xml and AppDelegate.swift with the API key

4. **Run App**
   ```bash
   flutter run

## Future Enhancements

- Cloud backup & sync
- AI-based photo tagging
- Biometric app lock
  

## Contributing

If you’d like to contribute, please fork the repo and submit a PR with a clear description of your feature or fix.


## License

This project is licensed under the MIT License. Kindly check the LICENSE file for details.


