import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  String? imagePath = 'No image selected';

  Future<void> openCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      final file = File(image.path);

      final directory = await getApplicationDocumentsDirectory();
      final galleryPath = "${directory.path}/gallery";
      await Directory(galleryPath).create(recursive: true);
      final savedImagePath =
          "$galleryPath/${DateTime.now().millisecondsSinceEpoch}.jpg";
      final savedImage = await file.copy(savedImagePath);
      await savedImage.writeAsBytes(await file.readAsBytes());

      setState(() {
        imagePath = savedImagePath;
      });
    }
  }

  void showImageSourceSelection() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
      ),
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30.0)),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  elevation: 8,
                  child: SizedBox(
                    height: 50,
                    child: GestureDetector(
                      onTap: () {
                        pickImageFromGallery();
                        Navigator.pop(context);
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image),
                          SizedBox(width: 8),
                          Text(
                            'Browse Gallery',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('OR'),
                const SizedBox(height: 16),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  elevation: 8,
                  child: SizedBox(
                    height: 50,
                    child: GestureDetector(
                      onTap: () {
                        openCamera();
                        Navigator.pop(context);
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt_outlined),
                          SizedBox(width: 8),
                          Text(
                            'Use a Camera',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> pickImageFromGallery() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final file = File(pickedImage.path);

      setState(() {
        imagePath = file.path;
      });
    } else {}
  }

  void saveImageToGallery() async {
    if (imagePath != null) {
      final file = File(imagePath!);
      final result = await ImageGallerySaver.saveFile(file.path);
      print('Image saved to gallery: $result');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image saved to gallery'),
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      throw 'No image selected';
    }
  }

  void sendImageToWhatsApp() async {
    if (imagePath != null) {
      final file = File(imagePath!);
      await Share.shareFiles([file.path], text: '');
    } else {
      throw 'No image selected';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              width: 250,
              height: 350,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              child: imagePath != null
                  ? Image.file(
                      File(imagePath!),
                      fit: BoxFit.cover,
                    )
                  : const Center(
                      child: Text('No image selected'),
                    ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 150,
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
            ),
            child: TextButton(
              onPressed: () {
                showImageSourceSelection();
              },
              child: const Center(
                child: Text('Capture'),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 150,
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
            ),
            child: TextButton(
              onPressed: () {
                sendImageToWhatsApp();
              },
              child: const Center(
                child: Text('Sent to WhatsApp'),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 150,
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
            ),
            child: TextButton(
              onPressed: () {
                saveImageToGallery();
              },
              child: const Center(
                child: Text('Save to Gallery'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
