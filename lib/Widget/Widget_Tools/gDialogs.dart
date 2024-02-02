import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Widget/Widget_Tools/ImagePainterTools.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'package:verifplus/Widget/Widget_Tools/gPhotos.dart';

class gDialogs {
  gDialogs();

  static Future<void> Dialog_QrCode(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => QrCodeDialog(),
    );
  }

  static Future<void> Dialog_Photo(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => PhotoDialog(),
    );
  }




}

//**********************************
//**********************************
//**********************************

class QrCodeDialog extends StatefulWidget {
  @override
  _QrCodeDialogState createState() => _QrCodeDialogState();
}

class _QrCodeDialogState extends State<QrCodeDialog> {
  @override
  void initState() {
    QrcValue = DbTools.gParc_Ent.Parcs_QRCode!;
    print("_QrCodeDialog  initState");
  }

  @override
  Widget build(BuildContext context) {
    Widget Ctrl = Container();
    Ctrl = Qrc(context);

    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24.0))),
      backgroundColor: gColors.white,
      title: Container(
          color: gColors.white,
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
          child: Column(
            children: [
              Text(
                "QR Code",
                textAlign: TextAlign.center,
                style: gColors.bodyTitle1_B_G_20,
              ),
              Text(
                "Scanner l'étiquette QR Code",
                textAlign: TextAlign.center,
                style: gColors.bodyTitle1_N_Gr,
              ),
              Container(
                height: 8,
              ),
            ],
          )),
      contentPadding: EdgeInsets.zero,
      content: Container(
          color: gColors.greyLight,
          height: 140,
          child: Column(
            children: [
              Container(
                color: gColors.black,
                height: 1,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 30,
                        ),
                        Ctrl,
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                color: gColors.black,
                height: 1,
              ),
            ],
          )),
      actions: <Widget>[
        Container(
          height: 8,
        ),
      ],
    );
  }

  //**********************************
  //**********************************
  //**********************************

  String ErrorQrc = "";
  String QrcValue = "";
  Widget Qrc(BuildContext context) {
    return InkWell(
      onTap: () async {
        await HapticFeedback.vibrate();
        var result = await BarcodeScanner.scan();
        print("result.type ${result.type}");
        print("result.rawContent ${result.rawContent}");
        print("result.format ${result.format}");

        QrcValue = "";
        ErrorQrc = "Erreur de lecture ou de QR Code";
        if (result.type.toString().compareTo("Barcode") == 0) {
          if (result.format.toString().compareTo("qr") == 0) {
            if (result.rawContent.toString().startsWith("M")) {
              if (result.rawContent.toString().endsWith("F")) {
                QrcValue = result.rawContent;
                ErrorQrc = "";
              }
            }
          }
        }

        setState(() {});
      },
      child: Container(
          width: 350,
//              color: Colors.amberAccent,
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.qr_code),
                  Container(
                    width: 20,
                  ),
                  Text(
                    "Code:  ${QrcValue}",
                    style: gColors.bodyTitle1_B_Gr,
                  ),
                ],
              ),
              Container(
                height: 20,
              ),
              Text(
                "${ErrorQrc}",
                style: gColors.bodyTitle1_B_Gr.copyWith(
                  color: gColors.primaryRed,
                ),
              ),
              Valider(context),
            ],
          )),
    );
  }

  //**********************************
  //**********************************
  //**********************************

  Widget Valider(BuildContext context) {
    return Container(
      width: 450,
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
//          Text(widget.param_Saisie.Param_Saisie_Controle),
          Container(
            color: gColors.primary,
            width: 8,
          ),
          new ElevatedButton(
            onPressed: () async {
              await HapticFeedback.vibrate();

              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: gColors.primaryRed,
            ),
            child: Text('Annuler', style: gColors.bodyTitle1_B_W),
          ),
          Container(
            color: gColors.primary,
            width: 8,
          ),
          new ElevatedButton(
            onPressed: () async {
              await HapticFeedback.vibrate();
              DbTools.gParc_Ent.Parcs_QRCode = QrcValue;
              print("DbTools.gParc_Ent ${DbTools.gParc_Ent.ParcsId} ${DbTools.gParc_Ent.Parcs_QRCode}");
              print(" updateParc_Ent D");
              await DbTools.updateParc_Ent(DbTools.gParc_Ent);

              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: gColors.primaryGreen,
                side: const BorderSide(
                  width: 1.0,
                  color: gColors.primaryGreen,
                )),
            child: Text('Valider', style: gColors.bodyTitle1_B_W),
          ),
        ],
      ),
    );
  }
}

//**********************************
//**********************************
//**********************************

class PhotoDialog extends StatefulWidget {

  @override
  _PhotoDialogState createState() => _PhotoDialogState();
}

class _PhotoDialogState extends State<PhotoDialog> {
  List<Widget> imgList = [];

  @override
  void initLib() async {
    imgList.clear();
    DbTools.glfParc_Imgs.forEach((element) {
      Widget wWidget = Container(
        child: Image.file(
          File(element.Parc_Imgs_Path!),
          width: 200,
          height: 300,
        ),
      );
      imgList.add(wWidget);
    });



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
    print("build  ${imgList.length}");

    Widget Ctrl = Container();
    Ctrl = Photo(context);

    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24.0))),
      backgroundColor: gColors.white,
      title: Container(
          color: gColors.white,
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
          child: Column(
            children: [
              Text( "Photos Organe",
                textAlign: TextAlign.center,
                style: gColors.bodyTitle1_B_G_20,
              ),
              Container(
                height: 8,
              ),
            ],
          )),
      contentPadding: EdgeInsets.zero,
      content: Container(
          color: gColors.greyLight,
          height: 540,
          child: Column(
            children: [
              Container(
                color: gColors.black,
                height: 1,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 30,
                        ),
                        Ctrl,
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                color: gColors.black,
                height: 1,
              ),
            ],
          )),
      actions: <Widget>[
        Container(
          height: 8,
        ),
      ],
    );
  }

  Widget Photo(BuildContext context) {

    print("imgList.length ${imgList.length}");


    return Container(
      width: 470,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Container(
                  child: ElevatedButton(
                onPressed: () async {
                      DbTools.gImagePath = "";
                      await Navigator.push(context, MaterialPageRoute(builder: (context) => gPhotos()));

                      print("gImagePath ${DbTools.gImagePath}");
                      if (DbTools.gImagePath != "") {
                        print("Add ${DbTools.gImagePath}");
                        Widget wWidget = Container(
                          child: Image.file(
                                File(DbTools.gImagePath!),
                                width: 200,
                                height: 300,
                            ),
                          );

                      setState(() {
                        imgList.add(wWidget);
                        print("Add photo ${imgList.length}");
                        print("setState");
                      });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: gColors.white,
                  padding: const EdgeInsets.all(12.0),
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: gColors.secondary,
                ),
              )),
            ],
          ),


          Container(
            width: 460,
            height: 416,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: imgList.length, // number of items in your list
                itemBuilder: (BuildContext context, int Itemindex) {

                  return GestureDetector(
                      //You need to make my child interactive
                      onTap: () async {
                        print("Itemindex idx $Itemindex len ${DbTools.glfParc_Imgs.length}");

                        DbTools.gImagePath = DbTools.glfParc_Imgs[Itemindex].Parc_Imgs_Path;
                        //final wimgFile = File(DbTools.glfParc_Imgs[Itemindex].Parc_Imgs_Path!);
                        print("DbTools.gImagePath ${DbTools.gImagePath}");

                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DisplayImageScreen(
                              imagePath: DbTools.glfParc_Imgs[Itemindex].Parc_Imgs_Path!,
                            ),
                          ),
                        );

                        if (DbTools.gImagePath == "") {
                          if (DbTools.glfParc_Imgs[Itemindex].Parc_Imgs_Type == null) DbTools.glfParc_Imgs[Itemindex].Parc_Imgs_Type = 0;
                          print("DbTools.glfParc_Imgs[Itemindex].Parc_Imgs_Type ${DbTools.glfParc_Imgs[Itemindex].Parc_Imgs_Type}");
                          await DbTools.deleteParc_Img(DbTools.glfParc_Imgs[Itemindex].Parc_Imgid!, DbTools.glfParc_Imgs[Itemindex].Parc_Imgs_Type!);
                          await DbTools.glfParc_Imgs.removeAt(Itemindex);
                          await imgList.removeAt(Itemindex);
                        } else {
                          final imgFile =  File(DbTools.glfParc_Imgs[Itemindex].Parc_Imgs_Path!);
                          print("Change wWidget A ${await imgFile.length()}");

                          Uint8List fileBytes = imgFile.readAsBytesSync();
                          Widget wWidget = Container(
                            child: Image.memory(
                              fileBytes,
                              width: 200,
                              height: 100,
                            ),
                          );
                          print("Change wWidget > ${DbTools.glfParc_Imgs[Itemindex].Parc_Imgs_Path!}");
                          imgList[Itemindex] = wWidget;
                          print("Change wWidget <");
                          setState(() {});
                        }

                        print("setState après click");
                        setState(() {});
                      },
                      child: imgList[Itemindex]);
                }),
          ),


          ValiderPhoto(context),
        ],
      ),
    );
  }

  //**********************************
  //**********************************
  //**********************************

  Widget ValiderPhoto(BuildContext context) {
    return Container(
      width: 450,
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
//          Text(widget.param_Saisie.Param_Saisie_Controle),
          Container(
            color: gColors.primary,
            width: 8,
          ),
          new ElevatedButton(
            onPressed: () async {
              await HapticFeedback.vibrate();

              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: gColors.primaryRed,
            ),
            child: Text('Annuler', style: gColors.bodyTitle1_B_W),
          ),
          Container(
            color: gColors.primary,
            width: 8,
          ),
          new ElevatedButton(
            onPressed: () async {
              await HapticFeedback.vibrate();

              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: gColors.primaryGreen,
                side: const BorderSide(
                  width: 1.0,
                  color: gColors.primaryGreen,
                )),
            child: Text('Valider', style: gColors.bodyTitle1_B_W),
          ),
        ],
      ),
    );
  }
}

//**********************************
//**********************************
//**********************************

class DisplayImageScreen extends StatelessWidget {
  final String imagePath;
  const DisplayImageScreen({super.key, required this.imagePath});
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;

    final imgFile = File(imagePath);

    Uint8List fileBytes = imgFile.readAsBytesSync();

    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          "Photo Organe gDialog",
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
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ImagePainterTools(
                          imagePath: DbTools.gImagePath!,
                        ),
                      ),
                    );

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
