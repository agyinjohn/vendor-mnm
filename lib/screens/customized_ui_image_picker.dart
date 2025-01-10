import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mnm_vendor/screens/upload_product_screen.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import 'package:page_transition/page_transition.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';

class MultipleImagePicker extends StatefulWidget {
  const MultipleImagePicker({super.key});
  static const routeName = '/image-picker-ui';

  @override
  _MultipleImagePickerState createState() => _MultipleImagePickerState();
}

class _MultipleImagePickerState extends State<MultipleImagePicker> {
  List<AssetEntity> mediaList = [];
  ValueNotifier<List<AssetEntity>> selectedMedia = ValueNotifier([]);
  bool isLoading = false;
  int currentPage = 0;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    requestPermissionAndLoadImages();
  }

  Future<void> requestPermissionAndLoadImages() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      await loadImages();
    } else {
      print('Permission denied');
    }
  }

  Future<void> loadImages() async {
    if (!hasMore || isLoading) return;

    setState(() {
      isLoading = true;
    });

    final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
    );

    if (albums.isNotEmpty) {
      final List<AssetEntity> images =
          await albums[0].getAssetListPaged(size: 50, page: currentPage);

      setState(() {
        mediaList.addAll(images);
        hasMore = images.length == 50; // Check if more images are available
        currentPage++;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  void toggleSelection(AssetEntity media) {
    selectedMedia.value = List.of(selectedMedia.value); // Clone list
    if (selectedMedia.value.contains(media)) {
      selectedMedia.value.remove(media);
    } else {
      selectedMedia.value.add(media);
    }
    selectedMedia.notifyListeners();
  }

  Widget buildImageThumbnail(AssetEntity media, Size size) {
    return FutureBuilder<Uint8List?>(
      future: media.thumbnailDataWithSize(const ThumbnailSize(200, 200)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return ValueListenableBuilder<List<AssetEntity>>(
            valueListenable: selectedMedia,
            builder: (context, selectedList, _) {
              bool isSelected = selectedList.contains(media);
              return GestureDetector(
                onTap: () => toggleSelection(media),
                onLongPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PhotoView(
                        imageProvider: MemoryImage(snapshot.data!),
                      ),
                    ),
                  );
                },
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.memory(snapshot.data!, fit: BoxFit.cover),
                    if (isSelected)
                      Container(color: Colors.blue.withOpacity(0.5)),
                    if (isSelected)
                      const Positioned(
                        top: 8,
                        right: 8,
                        child: Icon(Icons.check_circle, color: Colors.white),
                      ),
                  ],
                ),
              );
            },
          );
        }
        return const Center(
            child: SizedBox(
          height: 100,
          width: 100,
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ScrollController scrollController = ScrollController();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !isLoading) {
        loadImages();
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
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
              Navigator.pop(context, selectedMedia.value);
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              controller: scrollController,
              itemCount: mediaList.length + (hasMore ? 1 : 0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: (size.width / 120).floor(),
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemBuilder: (context, index) {
                if (index == mediaList.length) {
                  return const Center(child: NutsActivityIndicator());
                }
                final media = mediaList[index];
                return buildImageThumbnail(media, size);
              },
            ),
          ),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: NutsActivityIndicator(),
            ),
        ],
      ),
    );
  }
}
