import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_painter/image_painter.dart';
import 'package:open_file/open_file.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';


class ImagePainterTools extends StatefulWidget {
  final String imagePath;
  const ImagePainterTools({super.key, required this.imagePath});

  @override
  _ImagePainterToolsState createState() => _ImagePainterToolsState();
}

class _ImagePainterToolsState extends State<ImagePainterTools> {
  final _imageKey = GlobalKey<ImagePainterState>();
  final _key = GlobalKey<ScaffoldState>();

  Future saveImage() async {
    final image = await _imageKey.currentState!.exportImage();



    DbTools.gImageEdtFile = File(widget.imagePath);
    print("writeAsBytesSync wWidget > ${widget.imagePath}");
    DbTools.gImageEdtFile.writeAsBytesSync(image!, flush: true);
    print("writeAsBytesSync wWidget >");






    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.grey[700],
        padding: const EdgeInsets.only(left: 10),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Image sauvée.", style: TextStyle(color: Colors.white)),
            TextButton(
              onPressed: () => OpenFile.open(widget.imagePath),
              child: Text(
                "Open",
                style: TextStyle(
                  color: Colors.blue[200],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    File imgFile = new File(widget.imagePath);
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: const Text("Image Painter"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: saveImage,
          )
        ],
      ),
      body: ImagePainter.file(
        imgFile,
        key: _imageKey,
        scalable: true,
        initialStrokeWidth: 4,
        initialColor: Colors.green,
        initialPaintMode: PaintMode.freeStyle,
      ),
    );
  }
}
