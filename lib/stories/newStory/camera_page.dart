import 'dart:io';
import 'package:camera/camera.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:vocal/stories/newStory/edit_image_screen.dart';
import 'package:vocal/stories/newStory/text_status_page.dart';

List<CameraDescription> cameras = [];

class CameraScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CameraHome();
  }
}

class CameraHome extends StatefulWidget {
  @override
  _CameraHomeState createState() => _CameraHomeState();
}

class _CameraHomeState extends State<CameraHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  CameraController controller;
  int _cameraIndex = 0;
  bool isShowGallery = true;
  Future<List<String>> _images;
  PanelController _panelController;
  String videoPath;

  // Permissions
  bool isPermissionsGranted = false;
  List<Permission> permissionsNeeded = [
    Permission.camera,
    Permission.microphone,
    Permission.storage,
  ];

  @override
  void initState() {
    // SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
    initScreen();
    _panelController = new PanelController();
  }

  void initScreen() async {
    if (await allPermissionsGranted()) {
      setState(() {
        isPermissionsGranted = true;
      });
      startCamera();
    } else {
      requestPermission();
    }
  }

  void startCamera() {
    _initCamera(_cameraIndex);
    _getGalleryImages();
  }

  Future<bool> allPermissionsGranted() async {
    bool resVideo = await Permission.camera.isGranted;
    bool resAudio = await Permission.microphone.isGranted;
    bool resStorage = await Permission.storage.isGranted;
    return resVideo && resAudio && resStorage;
  }

  void requestPermission() async {
    Map<Permission, PermissionStatus> statuses =
        await permissionsNeeded.request();
    if (statuses.values.every((status) => status == PermissionStatus.granted)) {
      // Either the permission was already granted before or the user just granted it.
      setState(() {
        isPermissionsGranted = true;
      });
      startCamera();
    } else {
      print("Permission not granted");
    }
  }

  void refreshGallery() {
    _getGalleryImages();
  }

  void _getGalleryImages() async {
    _images =
        ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DCIM)
            .then((path) {
      List<String> paths = new List<String>();
      Directory dir2 = new Directory(path);
      // execute an action on each entry
      dir2.listSync(recursive: true).forEach((f) {
        if (f.path.contains('.jpg')) {
          paths.add(f.path);
        }
      });
      // Order files based on last modified
      // TODO: This is not good for many files. Need to find more efficient method.
      paths.sort((a, b) {
        File fileA = File(a);
        File fileB = File(b);
        return fileB.lastModifiedSync().compareTo(fileA.lastModifiedSync());
      });
      return paths;
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    _disposeCamera();
    super.dispose();
  }

  _disposeCamera() async {
    if (controller != null) {
      await controller.dispose();
    }
  }

  _initCamera(int index) async {
    // if (controller != null) {
    //   await controller.dispose();
    // }
    controller = CameraController(cameras[index], ResolutionPreset.high);

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        print('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
      await controller.lockCaptureOrientation();
    } on CameraException catch (e) {
      print(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return Center(
        child: Text(
          '',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          setState(() {
            // _minHeight = 0;
            isShowGallery = !isShowGallery;
          });
        },
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: CameraPreview(controller),
        ),
      );
    }
  }

  double _opacity = 0.0;
  double _minHeight = 210.0;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        color: Colors.black,
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            SlidingUpPanel(
              controller: _panelController,
              maxHeight: MediaQuery.of(context).size.height,
              minHeight: _minHeight,
              panel: Opacity(
                opacity: _opacity,
                child: Scaffold(
                  appBar: CupertinoNavigationBar(
                    backgroundColor: colorScheme.onPrimary,
                    automaticallyImplyLeading: false,
                    middle: new Icon(
                      CupertinoIcons.minus,
                      color: colorScheme.onSecondary,
                    ),
                  ),
                  body: Container(
                    color: colorScheme.onSurface,
                    child: FutureBuilder<List<String>>(
                        future: _images,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<String>> snapshot) {
                          if (!isPermissionsGranted) {
                            return Center(
                              child: Text('Permission not granted'),
                            );
                          }
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                              return Center(
                                child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.grey),
                                ),
                              );
                            case ConnectionState.active:
                            case ConnectionState.waiting:
                              return Center(
                                child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.grey),
                                ),
                              );
                            case ConnectionState.done:
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text('Error: ${snapshot.error}'),
                                );
                              }
                              if (snapshot.data.length <= 0) return Container();
                              return CustomScrollView(
                                slivers: <Widget>[
                                  // SliverPersistentHeader(
                                  //   pinned: true,
                                  //   floating: false,
                                  //   delegate:
                                  //       _SliverAppBarDelegate(text: 'RECENTLY'),
                                  // ),
                                  SliverGrid(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      mainAxisSpacing: 2.0,
                                      crossAxisSpacing: 2.0,
                                    ),
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                        return GalleryItemThumbnail(
                                          heroId: 'itemPanel-$index',
                                          height: 150,
                                          resource: snapshot.data[index],
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      CropImageScreen(
                                                    id: "itemPanel-$index",
                                                    resource:
                                                        "${snapshot.data[index]}",
                                                  ),
                                                ));
                                            print("${snapshot.data[index]}");
                                          },
                                        );
                                      },
                                      childCount: snapshot.data.length,
                                    ),
                                  )
                                ],
                              );
                          }
                          return null;
                        }),
                  ),
                ),
              ),
              color: Color.fromARGB(0, 0, 0, 0),
              collapsed: isShowGallery ? _buildCollapsedPanel() : Container(),
              body: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 2.0,
                  ),
                  color: Colors.black,
                ),
                child: new Column(
                  children: [
                    Expanded(child: _cameraPreviewWidget()),
                    new Container(
                      height: size.height * 0.2,
                      color: colorScheme.onPrimary,
                    )
                  ],
                ),
              ),
              onPanelSlide: (double pos) {
                setState(() {
                  _opacity = pos;
                });
              },
            ),
            Opacity(
                opacity: 1 - _opacity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          new CupertinoButton(child: Icon(CupertinoIcons.back, color: colorScheme.primary,), onPressed: (){
                            Navigator.of(context).pop();
                          }, padding: EdgeInsets.all(5), color: colorScheme.onSurface,),
                          new CupertinoButton(child: Icon(CupertinoIcons.textbox, color: colorScheme.primary,), onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => TextStatusPage(),));
                          }, padding: EdgeInsets.all(5), color: colorScheme.onSurface,)
                        ],
                      ),
                    ),
                    _buildCameraControls(),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  void _toggleCamera() {
    setState(() {
      if (_cameraIndex == 0)
        _cameraIndex = 1;
      else
        _cameraIndex = 0;
    });
    _initCamera(_cameraIndex);
  }

  Widget _buildCollapsedPanel() {
    return Container(
      child: Column(
        children: <Widget>[
          Icon(
            Icons.keyboard_arrow_up,
            color: Colors.white,
          ),
          _buildGalleryItems(),
        ],
      ),
    );
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Future<String> _takePicture() async {
    if (!controller.value.isInitialized) {
      print("Error: camera is not initialized");
    }
//    final Directory extDir = await getApplicationDocumentsDirectory();
//     final String dirPath = await ExtStorage.getExternalStoragePublicDirectory(
//         ExtStorage.DIRECTORY_DCIM);
//     print("DCIM $dirPath");
//     //await Directory(dirPath).create(recursive: true);
//     final String filePath = '$dirPath/.thumbnails/${timestamp()}.jpg';
//
//     if (controller.value.isTakingPicture) {
//       return null;
//     }

    String filePath = "";

    try {
      XFile picture = await controller.takePicture();
      filePath = picture.path;
      print("Picture ${picture.path}");
    } on CameraException catch (e) {
      // TODO: Can't use this here.
      print("Error: ${e.description}");
    }
    return filePath;
  }

  void onTakePictureButtonPressed() {
    _takePicture().then((String filePath) {
      if (mounted) {
        setState(() {});
        if (filePath != null) {
          print('Picture saved to $filePath');
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CropImageScreen(
                  id: "item-0",
                  resource: "$filePath",
                ),
              ));
        }
      }
    });
  }

  Widget _buildCameraControls() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(15),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            icon: Icon(CupertinoIcons.textbox),
            color: Colors.white,
            highlightColor: Colors.green,
            splashColor: Colors.red,
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => TextStatusPage(),));
            },
          ),
          GestureDetector(
              child: Icon(
                Icons.panorama_fish_eye,
                size: 70.0,
                color: Colors.white,
              ),
              onTap: isPermissionsGranted
                  ? () {
                      onTakePictureButtonPressed();
                    }
                  : null),
          IconButton(
            icon: Icon(Icons.switch_camera),
            color: Colors.white,
            highlightColor: Colors.green,
            splashColor: Colors.red,
            onPressed: isPermissionsGranted ? _toggleCamera : null,
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryItems() {
    return Container(
      height: 80.0,
      child: FutureBuilder<List<String>>(
          future: _images,
          builder:
              (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            if (!isPermissionsGranted) {
              return Center(
                child: Text(
                  'Permission not granted',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              );
            }
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey),
                  ),
                );
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey),
                  ),
                );
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                if (snapshot.data.length <= 0) return Container();
                List<String> displayedData = snapshot.data.sublist(0, 10);
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 1.0),
                  itemCount: displayedData.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, i) {
                    //print(snapshot.data[i]);
                    return GalleryItemThumbnail(
                      heroId: 'item-$i',
                      margin: const EdgeInsets.symmetric(horizontal: 1.0),
                      height: 81,
                      resource: displayedData[i],
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CropImageScreen(
                                id: "item-$i",
                                resource: "${displayedData[i]}",
                              ),
                            ));
                      },
                    );
                  },
                );
            }
            return null;
          }),
    );
  }
}

class GalleryItemThumbnail extends StatelessWidget {
  GalleryItemThumbnail({
    this.heroId,
    this.resource,
    this.onTap,
    this.height,
    this.margin,
  });

  final String heroId;
  final double height;
  final String resource;
  final GestureTapCallback onTap;
  final margin;

  @override
  Widget build(BuildContext context) {
    //print('gallery: img-$id');
    return Container(
      margin: margin,
      color: Color.fromRGBO(255, 255, 255, 0.05),
      child: GestureDetector(
        onTap: onTap,
        child: ClipRect(
          child: Align(
            alignment: Alignment.topCenter,
            child: Hero(
              tag: heroId,
              child: Image.file(
                new File(resource),
                width: height,
                height: height,
                cacheWidth: height.ceil(),
                cacheHeight: height.ceil(),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
