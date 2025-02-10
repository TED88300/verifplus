import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:verifplus/Tools/DbSrv/Srv_Articles_Ebp.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DCL_Ent.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'package:verifplus/Widget/Widget_Tools/gPhotos.dart';


Uint8List blankBytes = Base64Codec().decode("R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7");



class DCL_Ent_Garantie_Dialog {
  static Future<void> Dialogs_DCL_Ent_Garantie(BuildContext context, Article_Ebp wArticle_Ebp) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => DCL_EntGarantieDialog(wArticle_Ebp: wArticle_Ebp),
    );
  }
}

//**********************************
//**********************************
//**********************************


class DCL_EntGarantieDialog extends StatefulWidget {
  final Article_Ebp? wArticle_Ebp;

  const DCL_EntGarantieDialog({Key? key, required this.wArticle_Ebp}) : super(key: key);
  @override
  _DCL_EntGarantieDialogState createState() => _DCL_EntGarantieDialogState();
}

class _DCL_EntGarantieDialogState extends State<DCL_EntGarantieDialog> {
//  String DbTools.ParamTypeOg = "";
//  List<String> subLibArray = [];

  bool ModeAjout = false;
  String wParamType = "";
  String wParamTypeOg = DbTools.ParamTypeOg;

  bool isZoom1 = false;
  bool isZoom2 = false;
  bool isZoom3 = false;


  final JustifController = TextEditingController();

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
    print("_TypeOrgDialog initState");

    JustifController.text = widget.wArticle_Ebp!.DCL_Det_Garantie;
  }

  void onSetState() async {
    print("Parent onMaj() Relaod()");
    Reload();
  }

  @override
  Widget build(BuildContext context) {
    double heightPos = 70;
    double wHeightPied = 105;
    double wLeft = 0;
    double wHeightBtnValider = 50;
    double wLabelWidth = 120;

    double wHeightDet2 = 502;
    double wWidth = 520;
    double wHeightTitre = 220;

    double wHeight = wHeightTitre + wHeightDet2 + wHeightPied - 30;

    print(" B U I L D  ${widget.wArticle_Ebp!.wImageG1.height}");
    print(" B U I L D  ${widget.wArticle_Ebp!.wImageG2.height}");
    print(" B U I L D  ${widget.wArticle_Ebp!.wImageG3.height}");

    return SimpleDialog(
      insetPadding: EdgeInsets.all(60),
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
      surfaceTintColor: Colors.transparent,
      backgroundColor: gColors.white,
      shadowColor: gColors.transparent,
      children: [
        Stack(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              color: Colors.transparent,
              height: wHeight,
              width: wWidth,
            ),

////////////
// ENTETE
////////////
            Positioned(
              top: 0,
              left: 0,
              child: Material(
                elevation: 0,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                child: Container(
                  height: wHeightTitre - 2,
                  width: wWidth,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
                  child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: wWidth,
                            height: 116,
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  width: 100,
                                  height: 100,
                                  child: DbTools.gImage,
                                ),
                                Container(
                                  height: 100,
                                  padding: const EdgeInsets.fromLTRB(0, 7, 0, 0),
                                  width: wWidth - 120,
                                  child: Text(
                                    "${DbTools.gTitre}",
                                    maxLines: 3,
                                    style: gColors.bodyTitle1_B_G22,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                              color: Colors.yellowAccent,
                              height: 82,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  gColors.wLigne(),
                                  Container(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/images/DCL_Warning.svg",
                                        height: 60,
                                        width: 60,
                                      ),
                                      Container(width: 5),
                                      Text(
                                        "Justifier passage en garantie !",
                                        style: gColors.bodyTitle1_B_G24,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: 10,
                                  ),
                                  gColors.wLigne(),
                                ],
                              )),
                        ],
                      )),
                ),
              ),
            ),

///////////
// PIED
///////////
            Positioned(
              top: wHeightTitre + wHeightDet2 - 30,
              left: wLeft,
              child: Container(
                  child: Container(
                width: wWidth,
                height: wHeightPied,
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                decoration: BoxDecoration(
                  color: gColors.LinearGradient3,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: gColors.LinearGradient4,
                      height: 1,
                    ),
                    Container(
                      height: 18,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: gColors.primaryRed,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Container(
                            width: 160,
                            height: wHeightBtnValider,
                            padding: const EdgeInsets.fromLTRB(0, 11, 0, 0),
                            child: Text(
                              "Annuler",
                              style: gColors.bodyTitle1_B_W24,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: gColors.primaryGreen,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              )),
                          child: Container(
                            width: 160,
                            height: wHeightBtnValider,
                            padding: const EdgeInsets.fromLTRB(0, 11, 0, 0),
                            child: Text(
                              "Valider",
                              style: gColors.bodyTitle1_B_W24,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          onPressed: () async {



                            widget.wArticle_Ebp!.DCL_Det_Garantie = JustifController.text;

                            print(" GARANTIE VALIDER aDCL_Det.DCL_Det_Garantie ${widget.wArticle_Ebp!.DCL_Det_Garantie}");



                            Navigator.pop(context);
                          },
                        )
                      ],
                    )
                  ],
                ),
              )),
            ),
////////////
// CONTENT
////////////
            // Content

            Positioned(
              top: wHeightTitre - 2,
              left: wLeft,
              child: Container(
                height: wHeightDet2 - 13,
                width: wWidth,
                color: gColors.white,
                padding: const EdgeInsets.fromLTRB(30, 30, 30, 10),
                child: isZoom1 || isZoom2 || isZoom3
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Photo2(context),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  width: 100,
                                  height: 100,
                                  padding: widget.wArticle_Ebp!.wImageG1.height! > 1 ? EdgeInsets.zero : EdgeInsets.fromLTRB(10, 14, 10, 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                  ),
                                  child: GestureDetector(
                                    onTap: () async {
                                      if (widget.wArticle_Ebp!.wImageG1.height! > 1) {
                                        isZoom1 = true;
                                        setState(() {});
                                      } else {
                                        DbTools.gImagePath = "";
                                        await Navigator.push(context, MaterialPageRoute(builder: (ontext) => gPhotos_Gen()));
                                        print(" gImagePath ${DbTools.gImagePath}");
                                        if (DbTools.gImagePath != "") {
                                          print(" Add ${DbTools.gImagePath}");
                                          widget.wArticle_Ebp!.DCL_Det_Path1 = DbTools.gImageByte;
                                          widget.wArticle_Ebp!.wImageG1 = Image.memory(
                                            DbTools.gImageByte,
                                            fit: BoxFit.scaleDown,
                                            height: 400,
                                            width: 400,
                                          );
                                        }

                                        setState(() {});
                                      }
                                    },
                                    child: widget.wArticle_Ebp!.wImageG1.height! > 1
                                        ? Container(
                                            child: ClipRRect(borderRadius: BorderRadius.circular(12.0), child: widget.wArticle_Ebp!.wImageG1),
                                          )
                                        : SvgPicture.asset(
                                            "assets/images/Icon_Photo.svg",
                                            width: 100,
                                            height: 100,
                                          ),
                                  )),
                              Container(
                                  width: 100,
                                  height: 100,
                                  padding: widget.wArticle_Ebp!.wImageG2.height! > 1 ? EdgeInsets.zero : EdgeInsets.fromLTRB(10, 14, 10, 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                  ),
                                  child: GestureDetector(
                                    onTap: () async {
                                      if (widget.wArticle_Ebp!.wImageG2.height! > 1) {
                                        isZoom2 = true;
                                        setState(() {});
                                      } else {
                                        DbTools.gImagePath = "";
                                        await Navigator.push(context, MaterialPageRoute(builder: (ontext) => gPhotos_Gen()));
                                        print(" gImagePath ${DbTools.gImagePath}");
                                        if (DbTools.gImagePath != "") {
                                          print(" Add ${DbTools.gImagePath}");
                                          widget.wArticle_Ebp!.DCL_Det_Path2 = DbTools.gImageByte;
                                          widget.wArticle_Ebp!.wImageG2 = Image.memory(
                                            DbTools.gImageByte,
                                            fit: BoxFit.scaleDown,
                                            height: 400,
                                            width: 400,
                                          );
                                          setState(() {});
                                        }
                                      }
                                    },
                                    child: widget.wArticle_Ebp!.wImageG2.height! > 1
                                        ? Container(
                                            child: ClipRRect(borderRadius: BorderRadius.circular(12.0), child: widget.wArticle_Ebp!.wImageG2),
                                          )
                                        : SvgPicture.asset(
                                            "assets/images/Icon_Photo.svg",
                                            width: 100,
                                            height: 100,
                                          ),
                                  )),
                              Container(
                                  width: 100,
                                  height: 100,
                                  padding: widget.wArticle_Ebp!.wImageG3.height! > 1 ? EdgeInsets.zero : EdgeInsets.fromLTRB(10, 14, 10, 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                  ),
                                  child: GestureDetector(
                                    onTap: () async {
                                      if (widget.wArticle_Ebp!.wImageG3.height! > 1) {
                                        isZoom3 = true;
                                        setState(() {});
                                      } else {
                                        DbTools.gImagePath = "";
                                        await Navigator.push(context, MaterialPageRoute(builder: (ontext) => gPhotos_Gen()));
                                        print(" gImagePath ${DbTools.gImagePath}");
                                        if (DbTools.gImagePath != "") {
                                          print(" Add ${DbTools.gImagePath}");
                                          widget.wArticle_Ebp!.DCL_Det_Path3 = DbTools.gImageByte;
                                          widget.wArticle_Ebp!.wImageG3 = Image.memory(
                                            DbTools.gImageByte,
                                            fit: BoxFit.scaleDown,
                                            height: 400,
                                            width: 400,
                                          );
                                          setState(() {});
                                        }
                                      }
                                    },
                                    child: widget.wArticle_Ebp!.wImageG3.height! > 1
                                        ? Container(
                                            child: ClipRRect(borderRadius: BorderRadius.circular(12.0), child: widget.wArticle_Ebp!.wImageG3),
                                          )
                                        : SvgPicture.asset(
                                            "assets/images/Icon_Photo.svg",
                                            width: 100,
                                            height: 100,
                                          ),
                                  )),
                            ],
                          ),
                          Container(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  width: wWidth - 60,
                                  height: 292,
                                  padding: const EdgeInsets.fromLTRB(10, 14, 10, 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                  ),
                                  child: TextField(
                                    keyboardType: TextInputType.multiline,
                                    controller: JustifController,
                                    autofocus: false,
                                    maxLines: 13,
                                    minLines: 13,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                    ),
                                  )),
                            ],
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget Photo2(BuildContext context) {
    Image wImage = widget.wArticle_Ebp!.wImageG1;
    if (isZoom2) wImage = widget.wArticle_Ebp!.wImageG2;
    if (isZoom3) wImage = widget.wArticle_Ebp!.wImageG3;

    return Container(
      width: 530,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Column(
            children: [
              Container(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  width: 440,
                  height: 440,
                  child: GestureDetector(
                    onTap: () async {
                      isZoom1 = false;
                      isZoom2 = false;
                      isZoom3 = false;
                      setState(() {});
                    },
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            height: 16,
                          ),
                          wImage,
                          Container(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
          Positioned(
              top: 0,
              right: 0,
              child: InkWell(
                  child: Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: Image.asset(
                      "assets/images/ico5b.png",
                      fit: BoxFit.contain,
                      height: 50,
                    ),
                  ),
                  onTap: () async {
                    if (isZoom1)
                      {
                        widget.wArticle_Ebp!.wImageG1 = Image.memory(blankBytes, height: 1,);
                      }
                    if (isZoom2)
                    {
                      widget.wArticle_Ebp!.wImageG2 = Image.memory(blankBytes, height: 1,);
                    }
                    if (isZoom3)
                    {
                      widget.wArticle_Ebp!.wImageG3 = Image.memory(blankBytes, height: 1,);
                    }


                    isZoom1 = false;
                    isZoom2 = false;
                    isZoom3 = false;
                    setState(() {});

                  })),
        ],
      ),
    );
  }

  //*********************
  //*********************
  //*********************

  ScrollController scrollController = ScrollController(initialScrollOffset: 0);

  void _scrollToBottom(double index) {
    print("scrollController.position.maxScrollExtent ${scrollController.position.maxScrollExtent}");
    if (scrollController.hasClients) {
      double ii = 27.0 * (index);

      scrollController.animateTo(ii, //scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 1300),
          curve: Curves.elasticOut);
    } else {
      Timer(Duration(milliseconds: 1400), () => _scrollToBottom(index));
    }
  }

  Widget Liste(BuildContext context) {
    List<String> lDCL_Ent = [
      "Tous les types de document",
    ];
    print("elementCount ${Srv_DbTools.ListDCL_Ent.length} ");
    double index = 0;

    for (int i = 0; i < Srv_DbTools.ListDCL_Ent.length; i++) {
      DCL_Ent wDCL_Ent = Srv_DbTools.ListDCL_Ent[i];

      if (lDCL_Ent.indexOf(wDCL_Ent.DCL_Ent_Type!) == -1) {
        lDCL_Ent.add(wDCL_Ent.DCL_Ent_Type!);
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom(index));

    return Column(
      children: [
        Container(
          height: 370,
          width: 530,
          decoration: BoxDecoration(
            color: gColors.white,
            border: Border.all(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(12.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    shrinkWrap: true,
                    itemCount: lDCL_Ent.length,
                    itemBuilder: (context, index) {
                      final item = lDCL_Ent[index];
                      return InkWell(
                          onTap: () async {
                            await HapticFeedback.vibrate();
                            print("scrollController index $index ${scrollController.position}");
                            Srv_DbTools.gSelDCL_Ent = item;
                            Navigator.of(context).pop();
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                color: (item.compareTo(Srv_DbTools.gSelDCL_Ent) == 0) ? gColors.primaryGreen : Colors.transparent,
                                border: Border.all(
                                  color: (item.compareTo(Srv_DbTools.gSelDCL_Ent) == 0) ? gColors.primaryGreen : Colors.transparent,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12.0),
                                ),
                              ),
                              padding: EdgeInsets.fromLTRB(10, 15, 10, 5), // TED
                              height: 45,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item,
                                      textAlign: TextAlign.center,
                                      style: gColors.bodyTitle1_B_Gr.copyWith(
                                        color: (item.compareTo(Srv_DbTools.gSelDCL_Ent) == 0) ? gColors.white : gColors.primary,
                                      ))
                                ],
                              )));
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  //***************************
  //***************************
  //***************************
}
