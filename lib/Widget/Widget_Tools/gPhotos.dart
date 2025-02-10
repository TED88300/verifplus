import 'dart:io';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:camera/camera.dart';
import 'package:crop_image/crop_image.dart';
import 'package:flutter/material.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'package:verifplus/Widget/Widget_Tools/gPhotoCrop.dart';
import 'package:verifplus/main.dart';
import 'dart:ui' as ui;

class gPhotos extends StatefulWidget {

  static int wImg = 0;
  static int ImgDoc = 0;

  @override
  gPhotosState createState() =>
      gPhotosState();
}

class gPhotosState
    extends State<gPhotos> {
  late CameraController _controller;

  late Future<void> _initializeControllerFuture;

  void Reload() async {
    setState(() {});
  }

  @override
  void initLib() async {
    Reload();
  }

  @override
  void initState() {
    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();

    initLib();
    super.initState();

  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;

    print("@@@@@@@@@@@@@@@@@n gPhotos build");

    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          "Photo",
          maxLines: 1,
        ),
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(5, 10, 0, 10),
          child: Image.asset("assets/images/Ico.png"),
        ),
        backgroundColor: gColors.primary,
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: Colors.black,
              width: size,
              height: size,
              child: ClipRect(
                child: OverflowBox(
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Container(
                      color: Colors.black,
                      width: size,
                      height: size * 1.5,
                      child: FutureBuilder<void>(
                        future: _initializeControllerFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            print(" _controller.value.aspectRatio ${_controller.value.aspectRatio}");
                            return CameraPreview(_controller);
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        },
                      ),
                      // this is my CameraPreview
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            final image = await _controller.takePicture();
            if (!mounted) return;
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  imagePath: image.path,
                ),
              ),
            );
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  const DisplayPictureScreen({super.key, required this.imagePath});


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          "Photo Organe gPhotos",
          maxLines: 1,
        ),
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(5, 10, 0, 10),
          child: Image.asset("assets/images/Ico.png"),
        ),
        backgroundColor: gColors.primary,
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: Colors.white,
              width: size,
              height: size,
              child: ClipRect(
                child: OverflowBox(
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Container(
                      color: Colors.black,
                      width: size,
                      height: size * 1.5,
                      child: Image.file(File(imagePath)),

                      // this is my CameraPreview
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          DbTools.gImagePath = imagePath;

//          print(">>>>>>>>>>>>>>>>>>>>>>>>>>>> E3_New");
          await Navigator.of(context).push(MaterialPageRoute(builder: (context) => gPhotoCrop()));
//          print("<<<<<<<<<<<<<<<<<<<<<<<<<<<< E3_New");



        },
        child: const Icon(Icons.check),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


class gPhotos_Gen extends StatefulWidget {
  @override
  gPhotos_GenState createState() =>
      gPhotos_GenState();
}

class gPhotos_GenState
    extends State<gPhotos_Gen> {
  late CameraController _controller;

  late Future<void> _initializeControllerFuture;

  void Reload() async {
    setState(() {});
  }

  @override
  void initLib() async {
    Reload();
  }

  @override
  void initState() {
    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();

    initLib();
    super.initState();

  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;

    print("@@@@@@@@@@@@@@@@@n gPhotos_Gen build");

    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          "Photo",
          maxLines: 1,
        ),
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(5, 10, 0, 10),
          child: Image.asset("assets/images/Ico.png"),
        ),
        backgroundColor: gColors.primary,
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: Colors.black,
              width: size,
              height: size,
              child: ClipRect(
                child: OverflowBox(
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Container(
                      color: Colors.black,
                      width: size,
                      height: size * 1.5,
                      child: FutureBuilder<void>(
                        future: _initializeControllerFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            print(" _controller.value.aspectRatio ${_controller.value.aspectRatio}");
                            return CameraPreview(_controller);
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        },
                      ),
                      // this is my CameraPreview
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            final image = await _controller.takePicture();
            if (!mounted) return;
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen_Gen(
                  imagePath: image.path,
                ),
              ),
            );
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

class DisplayPictureScreen_Gen extends StatelessWidget {
  final String imagePath;
  const DisplayPictureScreen_Gen({super.key, required this.imagePath});


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          "Photo Organe gPhotos",
          maxLines: 1,
        ),
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(5, 10, 0, 10),
          child: Image.asset("assets/images/Ico.png"),
        ),
        backgroundColor: gColors.primary,
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: Colors.white,
              width: size,
              height: size,
              child: ClipRect(
                child: OverflowBox(
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Container(
                      color: Colors.black,
                      width: size,
                      height: size * 1.5,
                      child: Image.file(File(imagePath)),

                      // this is my CameraPreview
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          DbTools.gImagePath = imagePath;

//          print(">>>>>>>>>>>>>>>>>>>>>>>>>>>> E3_New");
          await Navigator.of(context).push(MaterialPageRoute(builder: (context) => gPhotoCrop_Gen()));
//          print("<<<<<<<<<<<<<<<<<<<<<<<<<<<< E3_New");



        },
        child: const Icon(Icons.check),
      ),
    );
  }
}

class gPhotoCrop_Gen extends StatefulWidget {
  @override
  gPhotoCrop_GenState createState() => new gPhotoCrop_GenState();
}

class gPhotoCrop_GenState extends State<gPhotoCrop_Gen> {
  String Tag = "gPhotoCrop_Gen";

  final _formKey = GlobalKey<FormState>();
  ScrollController scrollController = ScrollController();
  ScrollController scrollControllerImg = ScrollController();
  final cropController = CropController(
    aspectRatio: 1,
  );
  String gPhotoCrop_GenError = "";

  int IndexFilter = 0;
  int LenghtFilter = 5;

  int IndexImage = 0;
  int LenghtImage = 5;

  double width = 190;
  void initLib() async {}
  double h = 100;
  double w = 160;
  late Image image;
  late Image imageStd;
  void relaodImage() {
    int ligmod = LenghtImage % 3;
    double lig2 = LenghtImage / 3;
    int lig = lig2.toInt() + ligmod;
  }

  void initState() {
    super.initState();
//    image = gimage;
    //  imageStd = gimage;

    image = Image.file(
      File(DbTools.gImagePath!),
      height: 160,
      width: 160,
      fit: BoxFit.cover,
    );
    imageStd = Image.file(
      File(DbTools.gImagePath!),
      height: 160,
      width: 160,
      fit: BoxFit.cover,
    );
  }

  @override
  void dispose() {

    scrollController.dispose();
    scrollControllerImg.dispose();
    cropController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width / 3 - 10;

    relaodImage();



    print("width $width");

    return Container(
      child: Scaffold(
        backgroundColor: gColors.black,
        appBar: AppBar(
          backgroundColor: gColors.black,
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Crop de l'image",
                style: gColors.bodyTitle1_N_W,
                textAlign: TextAlign.center,
              )
            ],
          ),



          leading: IconButton(
            icon: Icon(Icons.cancel, color: gColors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          iconTheme: IconThemeData(
            color: gColors.black, //change your color here
          ),
//        centerTitle: false,
          elevation: 0,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: gColors.fillColor,
              height: 2,
            ),
            Container(
              height: 20,
            ),
            Container(
              height: MediaQuery.of(context).size.height -110,
              child:
              Center(
                child: CropImage(
                  controller: cropController,
                  image: image,
                ),
              ),
            )

          ],
        ),
        floatingActionButton: new FloatingActionButton(
            elevation: 0.0,
            child: new Icon(Icons.check),
            onPressed: () async {
              ui.Image croppedImage = await cropController.croppedBitmap();

              final data = await croppedImage.toByteData(
                format: ui.ImageByteFormat.png,
              );
              final bytes = data!.buffer.asUint8List();

              DbTools.gImageByte = bytes;

              File file = File(DbTools.gImagePath!);
              await file.writeAsBytes(bytes);




              Navigator.pop(context);
              imageCache.clear();
              imageCache.clearLiveImages();
              Navigator.pop(context);
              Navigator.pop(context);
            }),
      ),
    );
  }

//********************************
//********************************
//********************************
}
