import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crop_image/crop_image.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DCL_Ent_Img.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';


import 'dart:ui' as ui;

import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Tools/DbTools/Db_Parcs_Img.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'package:verifplus/Widget/Widget_Tools/gPhotos.dart';

class gPhotoCrop extends StatefulWidget {
  @override
  gPhotoCropState createState() => new gPhotoCropState();
}

class gPhotoCropState extends State<gPhotoCrop> {
  String Tag = "gPhotoCrop";

  final _formKey = GlobalKey<FormState>();
  ScrollController scrollController = ScrollController();
  ScrollController scrollControllerImg = ScrollController();
  final cropController = CropController(
    aspectRatio: 1,
//    defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9),
  );
  String gPhotoCropError = "";

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
          actions: <Widget>[
            Row(
              children: [
                OutlinedButton(
                  onPressed: () async {
                    ui.Image croppedImage = await cropController.croppedBitmap();
                    final data = await croppedImage.toByteData(
                      format: ui.ImageByteFormat.png,
                    );

                    final bytes = data!.buffer.asUint8List();

                    File file = File(DbTools.gImagePath!);
                    await file.writeAsBytes(bytes);

                    if (gPhotos.wImg == 0)
                      {
                        Parc_Img wParc_Img = Parc_Img();
                        wParc_Img.Parc_Imgs_ParcsId = DbTools.gParc_Ent.ParcsId;
                        wParc_Img.Parc_Imgs_Path = DbTools.gImagePath!;
                        wParc_Img.Parc_Imgs_Type = DbTools.gParc_Img_Type;
                        wParc_Img.Parc_Imgs_Principale = 0;
                        var now = new DateTime.now();
                        var formatter = new DateFormat('dd/MM/yyyy');
                        wParc_Img.Parc_Imgs_Date= formatter.format(now);
                        wParc_Img.Parc_Imgs_Data = await base64Encode(bytes);
                        print("insertParc_Img            bytes ${bytes.length}         Parc_Imgs_Data ${wParc_Img.Parc_Imgs_Data!.length}");
                        DbTools.insertParc_Img(wParc_Img);
                        DbTools.glfParc_Imgs = await DbTools.getParc_Imgs(DbTools.gParc_Ent.ParcsId!, DbTools.gParc_Img_Type);
                      }

                    if (gPhotos.wImg == 1)
                    {
                      DCL_Ent_Img wDCL_Ent_Img = DCL_Ent_Img();
                      wDCL_Ent_Img.dCLEntImgEntID = Srv_DbTools.gDCL_Ent.DCL_EntID;
                      wDCL_Ent_Img.DCL_Ent_Img_Type = "I";
                      wDCL_Ent_Img.DCL_Ent_Img_No =  gPhotos.ImgDoc;
                      wDCL_Ent_Img.dCLEntImgData = await base64Encode(bytes);
                      Srv_DbTools.InsertUpdateDCL_Ent_Img_Srv(wDCL_Ent_Img);

                    }






                    Navigator.pop(context);
                    imageCache.clear();
                    imageCache.clearLiveImages();
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(backgroundColor: Colors.black, side: BorderSide(width: 0, color: Colors.transparent)),
                  child: Text(
                    "Ternimer",
                    textAlign: TextAlign.center,
                    style: gColors.bodyTitle1_N_W,
                  ),
                ),
              ],
            )
          ],
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

              File file = File(DbTools.gImagePath!);
              await file.writeAsBytes(bytes);



              if (gPhotos.wImg == 0)
              {
                Parc_Img wParc_Img = Parc_Img();
                wParc_Img.Parc_Imgs_ParcsId = DbTools.gParc_Ent.ParcsId;
                wParc_Img.Parc_Imgs_Path = DbTools.gImagePath!;
                wParc_Img.Parc_Imgs_Type = DbTools.gParc_Img_Type;
                wParc_Img.Parc_Imgs_Principale = 0;

                var now = new DateTime.now();
                var formatter = new DateFormat('dd/MM/yyyy');
                wParc_Img.Parc_Imgs_Date= formatter.format(now);


                print(">>>>>>>>>>>>> Parc_Imgs_Data");

                wParc_Img.Parc_Imgs_Data = await base64Encode(bytes);
                print("insertParc_Img            bytes ${bytes.length}         Parc_Imgs_Data ${wParc_Img.Parc_Imgs_Data!.length}");
                await DbTools.insertParc_Img(wParc_Img);
                DbTools.glfParc_Imgs = await DbTools.getParc_Imgs(DbTools.gParc_Ent.ParcsId!, DbTools.gParc_Img_Type);

              }

              if (gPhotos.wImg == 1)
              {
                DCL_Ent_Img wDCL_Ent_Img = DCL_Ent_Img();
                wDCL_Ent_Img.dCLEntImgEntID = Srv_DbTools.gDCL_Ent.DCL_EntID;
                wDCL_Ent_Img.DCL_Ent_Img_Type = "I";
                wDCL_Ent_Img.DCL_Ent_Img_No =  gPhotos.ImgDoc;
                wDCL_Ent_Img.dCLEntImgData = await base64Encode(bytes);
                await Srv_DbTools.InsertUpdateDCL_Ent_Img_Srv(wDCL_Ent_Img);

              }




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
