import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Img.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'package:verifplus/main.dart';

class Client_Groupe_Parc_Inter_Obs_Photos extends StatefulWidget {
  @override
  Client_Groupe_Parc_Inter_Obs_PhotosState createState() =>
      Client_Groupe_Parc_Inter_Obs_PhotosState();
}

class Client_Groupe_Parc_Inter_Obs_PhotosState
    extends State<Client_Groupe_Parc_Inter_Obs_Photos> {
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
    initLib();
    super.initState();

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
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

    print("@@@@@@@@@@@@@@@@@n Client_Site_Parc_Obs_Photos build");

    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
//          "Client : ${DbTools.gClient.Clients_Nom} (${DbTools.gClient.Clients_Cp}) / ${DbTools.gSite.Sites_Nom} (${DbTools.gSite.Sites_Cp})",
          "Client : XXXXX",
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
                            print("_controller.value.aspectRatio ${_controller.value.aspectRatio}");
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
  //        "Client : ${DbTools.gClient.Clients_Nom} (${DbTools.gClient.Clients_Cp}) / ${DbTools.gSite.Sites_Nom} (${DbTools.gSite.Sites_Cp})",
          "Client :xxxxx",
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
          Parc_Img wParc_Img = Parc_Img();

          wParc_Img.Parc_Imgs_ParcsId = DbTools.gParc_Ent.ParcsId;
          wParc_Img.Parc_Imgs_Path = imagePath;
          wParc_Img.Parc_Imgs_Type = 99;
          wParc_Img.Parc_Imgs_Data = "";

          DbTools.insertParc_Img(wParc_Img);
          DbTools.gImagePath = imagePath;
          DbTools.glfParc_Imgs = await DbTools.getParc_Imgs(DbTools.gParc_Ent.ParcsId!, 99);
        //  print("glfParc_Imgs lenght ${DbTools.glfParc_Imgs.length}");

          Navigator.pop(context);
          Navigator.pop(context);
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
