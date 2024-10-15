import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_painter/image_painter.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Img.dart';




class ImagePainterTools extends StatefulWidget {
  final Uint8List wUint8List;
  final Parc_Img wParc_Img;
  const ImagePainterTools({super.key, required this.wUint8List,  required this.wParc_Img});

  @override
  _ImagePainterToolsState createState() => _ImagePainterToolsState();
}

class _ImagePainterToolsState extends State<ImagePainterTools> {
  final _imageKey = GlobalKey<ImagePainterState>();
  final _key = GlobalKey<ScaffoldState>();
  final imagePainterController = ImagePainterController();



  Future saveImage() async {
    Uint8List? wUint8List = await imagePainterController.exportImage();
    widget.wParc_Img.Parc_Imgs_Data = await base64Encode(wUint8List!);
    await DbTools.insertParc_Img(widget.wParc_Img);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {

    Uint8List byteArray = widget.wUint8List;
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: const Text("Edition Photo"),

        leading: InkWell(
          onTap: () async {
            await HapticFeedback.vibrate();
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 10, 0, 10),
            child: Image.asset("assets/images/Ico.png"),
          ),
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: saveImage,
          )
        ],
      ),
      body: ImagePainter.memory(byteArray, controller: imagePainterController)

    );
  }
}


