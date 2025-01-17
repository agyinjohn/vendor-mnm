import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mnm_vendor/app_colors.dart';
import 'package:mnm_vendor/utils/store_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/selected_store_notifier.dart';

class ImagePreviewScreen extends StatefulWidget {
  final File imageFile;
  final String storeId;
  final WidgetRef ref;
  const ImagePreviewScreen(
      {super.key,
      required this.ref,
      required this.imageFile,
      required this.storeId});

  @override
  State<ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  bool isUploading = false;

  Future<void> _uploadImage(File image, String storeId, WidgetRef ref) async {
    setState(() {
      isUploading = true;
    });
    print(storeId);
    SharedPreferences pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    try {
      final fileName = image.path.split('/').last;
      final imageData = base64Encode(await image.readAsBytes());

      // API URL (replace with your actual API URL)
      const String apiUrl = '${AppColors.baseURL}/update-store';

      // Prepare the request payload
      final payload = {
        "storeId": storeId,
        "images": [
          {
            "action": "add",
            "fileName": fileName,
            "data": imageData,
          }
        ],
      };

      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print('Image uploaded successfully');

        // Fetch stores again and notify the provider
        await ref.read(storeProvider.notifier).fetchStores('$token', context);
        await ref
            .read(selectedStoreProvider.notifier)
            .loadSelectedStore(ref.read(storeProvider));

        // Pop back to the StoreDetailsPage
        Navigator.pop(context);
      } else {
        // Show error message
        _showError('Failed to upload image: ${response.body}');
      }
    } catch (e) {
      _showError('Error uploading image: $e');
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview Image'),
        actions: [
          if (!isUploading)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () =>
                  _uploadImage(widget.imageFile, widget.storeId, widget.ref),
            ),
        ],
      ),
      body: Center(
        child: isUploading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.file(widget.imageFile),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Cancel and go back to StoreDetailsPage
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.cancel),
                    label: const Text('Cancel'),
                  ),
                ],
              ),
      ),
    );
  }
}
