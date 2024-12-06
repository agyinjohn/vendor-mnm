import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mnm_vendor/screens/upload_product_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:permission_handler/permission_handler.dart';

class MultipleImagePicker extends StatefulWidget {
  const MultipleImagePicker({super.key});
  static const routeName = '/image-picker-ui';
  @override
  _MultipleImagePickerState createState() => _MultipleImagePickerState();
}

class _MultipleImagePickerState extends State<MultipleImagePicker> {
  List<AssetEntity> mediaList = [];
  ValueNotifier<List<AssetEntity>> selectedMedia = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    requestPermissionAndLoadImages();
  }

  // Request permission and load images from the gallery
  Future<void> requestPermissionAndLoadImages() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      await loadImages();
    } else {
      print('Permission denied');
    }
  }

  // Load images from the gallery
  Future<void> loadImages() async {
    final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
    );

    if (albums.isNotEmpty) {
      final List<AssetEntity> images =
          await albums[0].getAssetListPaged(size: 1000, page: 0);
      setState(() {
        mediaList = images;
      });
    }
  }

  // Toggle selection of images
  void toggleSelection(AssetEntity media) {
    selectedMedia.value =
        List.of(selectedMedia.value); // Clone list to trigger ValueNotifier
    if (selectedMedia.value.contains(media)) {
      selectedMedia.value.remove(media);
    } else {
      selectedMedia.value.add(media);
    }
    selectedMedia.notifyListeners();
  }

  // Thumbnail display with selection indicator
  Widget buildImageThumbnail(AssetEntity media, Size size) {
    return FutureBuilder<Uint8List?>(
      future: media.thumbnailData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return ValueListenableBuilder<List<AssetEntity>>(
            valueListenable: selectedMedia,
            builder: (context, selectedList, _) {
              return Stack(
                children: [
                  Container(
                    height: 300,
                    width: size.width / 3,
                    color: Colors.blue,
                    child: Image.memory(snapshot.data!, fit: BoxFit.cover),
                  ),
                  if (selectedList.contains(media))
                    const Positioned(
                      top: 8,
                      right: 8,
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.blue,
                      ),
                    )
                ],
              );
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios)),
        title: ValueListenableBuilder<List<AssetEntity>>(
          valueListenable: selectedMedia,
          builder: (context, selectedList, _) {
            return Text('${selectedList.length} selected');
          },
        ),
        actions: [
          IconButton(
            icon: const Text(
              'Done',
              style: TextStyle(color: Colors.blue),
            ),
            onPressed: () {
              // Handle the selected images here
              Navigator.push(
                  context,
                  PageTransition(
                      child: UploadProductScreen(
                        selectedImages: selectedMedia.value,
                      ),
                      type: PageTransitionType.leftToRight));
            },
          )
        ],
      ),
      body: GridView.builder(
        itemCount: mediaList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Display 3 images per row
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemBuilder: (context, index) {
          final media = mediaList[index];
          return GestureDetector(
            onTap: () => toggleSelection(media),
            child: buildImageThumbnail(media, size),
          );
        },
      ),
    );
  }
}
