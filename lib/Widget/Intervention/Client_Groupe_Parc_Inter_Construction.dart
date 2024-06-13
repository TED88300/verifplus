import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Widget/Widget_Tools/ImagePainterTools.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';


class Client_Groupe_Parc_Inter_Construction extends StatefulWidget {
  @override
  Client_Groupe_Parc_Inter_ConstructionState createState() => Client_Groupe_Parc_Inter_ConstructionState();
}

class Client_Groupe_Parc_Inter_ConstructionState extends State<Client_Groupe_Parc_Inter_Construction> {

  @override
  void initLib() async {


    setState(() {});
  }

  void initState() {
    initLib();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body:
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Icon(
                Icons.construction,
                color: Colors.yellow,
                size: 500,
              ),



            ],
          ),
    );
  }
}

class DisplayImageScreen extends StatelessWidget {
  final String imagePath;
  const DisplayImageScreen({super.key, required this.imagePath});
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;


    final imgFile =  File(imagePath);


    Uint8List fileBytes = imgFile.readAsBytesSync();


    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
//          "Client : ${DbTools.gClient.Clients_Nom} (${DbTools.gClient.Clients_Cp}) / ${DbTools.gSite.Sites_Nom} (${DbTools.gSite.Sites_Cp})",
          "Client : XXXXXX XXXXXX XXXXXX XXXX ",
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
                      child: //Image.file(File(imagePath)),
                      Image.memory(
                        fileBytes,

                      ),
                      // this is my CameraPreview
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  child: const Icon(
                    Icons.delete,
                    color: gColors.secondary,
                  ),
                  onPressed: () async {
                    DbTools.gImagePath = "";
                    Navigator.pop(context);
                  },
                ),

                ElevatedButton(
                  child: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                   /* await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ImagePainterTools(
                          imagePath: DbTools.gImagePath!,
                        ),
                      ),
                    );
*/
                    Navigator.pop(context);
                  },
                ),



                ElevatedButton(
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
