import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:group_button/group_button.dart';
import 'package:hand_signature/signature.dart';
import 'package:intl/intl.dart';
import 'package:verifplus/Tools/DbSrv/Srv_DbTools.dart';
import 'package:verifplus/Tools/DbTools/DbTools.dart';
import 'package:verifplus/Widget/Widget_Tools/gColors.dart';
import 'package:verifplus/Widget/Widget_Tools/gObj.dart';

class DCL_Det_Sign extends StatefulWidget {
  const DCL_Det_Sign({super.key});

  @override
  DCL_Det_SignState createState() => DCL_Det_SignState();
}

class DCL_Det_SignState extends State<DCL_Det_Sign> with SingleTickerProviderStateMixin {
  final groupButtonController = GroupButtonController();

  final controlTech = HandSignatureControl(
    threshold: 0.01,
    smoothRatio: 0.65,
    velocityRange: 2.0,
  );
  ValueNotifier<ByteData?> rawImageFitTech = ValueNotifier<ByteData?>(null);

  TextEditingController ctrlTech = TextEditingController();

  void Reload() async {
    setState(() {});
  }

  @override
  Future initLib() async {
    Reload();
  }

  @override
  void initState() {
    super.initState();

    initLib();
  }

  @override
  Widget build(BuildContext context) {
    String wTitre2 = "${Srv_DbTools.gDCL_Ent.DCL_Ent_GroupeNom} / ${Srv_DbTools.gDCL_Ent.DCL_Ent_SiteNom} / ${Srv_DbTools.gDCL_Ent.DCL_Ent_ZoneNom}";
    if (Srv_DbTools.gDCL_Ent.DCL_Ent_GroupeNom == Srv_DbTools.gDCL_Ent.DCL_Ent_SiteNom) wTitre2 = "";

    double wHeight = MediaQuery.of(context).size.height - 184;

    double wWidth = MediaQuery.of(context).size.width;

    return SimpleDialog(insetPadding: const EdgeInsets.fromLTRB(0, 185, 0, 0), titlePadding: EdgeInsets.zero, contentPadding: EdgeInsets.zero, surfaceTintColor: Colors.transparent, backgroundColor: gColors.white, shadowColor: Colors.transparent, children: [
      Container(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          height: wHeight,
          width: wWidth,
          color: gColors.LinearGradient3,
          child: Column(
            children: [
              gColors.ombre(),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      signAgent(),
//                      signTech(),
                    ],
                  ),
                ),
              )
            ],
          )),
    ]);
  }

  Widget signAgent() {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 25),
          height: 300,
          decoration: BoxDecoration(
            color: gColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: gColors.LinearGradient5,
              width: 1.5,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          height: 40,
          decoration: BoxDecoration(
            color: gColors.primaryGreen,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            border: Border.all(
              color: gColors.primaryGreen,
              width: 1.5,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                padding: EdgeInsets.only(left: 0, top: 10),
                height: 40,
                child: Text(
                  "Agent",
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: gColors.bodyTitle1_B_W,
                )),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                margin: EdgeInsets.only(top: 50),
                child: Text(
                  "Monsieur ${Srv_DbTools.gUserLogin.User_Nom} ${Srv_DbTools.gUserLogin.User_Prenom} - ${Srv_DbTools.gUserLogin.User_Fonction}",
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: gColors.bodyTitle1_B_Gr,
                )),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(left: 0, top: 80),
              height: 281,
              child: _buildVueSignTech(),
            ),
          ],
        ),
      ],
    );
  }

  Widget signTech() {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          height: 350,
          decoration: BoxDecoration(
            color: gColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: gColors.LinearGradient5,
              width: 1.5,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          height: 40,
          decoration: BoxDecoration(
            color: gColors.backgroundColor,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            border: Border.all(
              color: gColors.backgroundColor,
              width: 1.5,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                padding: EdgeInsets.only(left: 0, top: 10),
                height: 40,
                child: Text(
                  "Tech",
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: gColors.bodyTitle1_B_W,
                )),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                margin: EdgeInsets.only(top: 50),
                child: Text(
                  "Monsieur DUPONT François - RAF",
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: gColors.bodyTitle1_B_Gr,
                )),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(left: 0, top: 80),
              height: 281,
              child: _buildVueSignTech(),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                margin: EdgeInsets.only(top: 300),
                child: Text(
                  "Bon pour accord, CGV, signé le ${DateFormat('dd/MM/yyyy').format(DateTime.now())}",
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: gColors.bodyTitle1_B_Gr,
                )),
          ],
        ),
      ],
    );
  }

  //*********************************************************
  //*********************************************************
  //*********************************************************

  Widget _buildVueSignTech() {
    return InkWell(
      onTap: () async {
        await showDialog(
          barrierColor: const Color(0xDD000000),
          context: context,
          builder: (BuildContext context) => AlertDialog(
            titlePadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),
            backgroundColor: gColors.transparent,
            content: DCLParamDialog_SignTech(
              wTitre: "Signature Agent",
              wNote: "",
              ViewTech: _buildScaledImageViewTech(),
            ),
          ),
        );
        setState(() {});
      },
      child: Container(
          color: Colors.black12,
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  _buildScaledImageViewTech(),
                ],
              ),
              gColors.wLigne(),
            ],
          )),
    );
  }

  Widget _buildScaledImageViewTech() {
    return Container(
      width: 250,
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(),
        color: Colors.white30,
      ),
      child: Srv_DbTools.gDCL_Ent.DCL_Signature_Tech!.length == 0
          ? Container(
              color: Colors.white,
              child: const Center(
                child: Text('Vide'),
              ),
            )
          : Container(
              padding: const EdgeInsets.all(0.0),
              color: Colors.white,
              child: Image.memory(Srv_DbTools.gDCL_Ent.DCL_Signature_Tech!),
            ),
    );
  }
  //*********************************************************
  //*********************************************************
  //*********************************************************
}

class DCLParamDialog_SignTech extends StatefulWidget {
  final String wTitre;
  final String wNote;
  final Widget ViewTech;
  DCLParamDialog_SignTech({Key? key, required this.wTitre, required this.wNote, required this.ViewTech}) : super(key: key);

  @override
  _DCLParamDialog_SignTechState createState() => _DCLParamDialog_SignTechState();
}

class _DCLParamDialog_SignTechState extends State<DCLParamDialog_SignTech> {
  final controlTech = HandSignatureControl(
    threshold: 0.01,
    smoothRatio: 0.65,
    velocityRange: 2.0,
  );

  ValueNotifier<ByteData?> rawImageFitTech = ValueNotifier<ByteData?>(null);

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
  }

  @override
  Widget build(BuildContext context) {
    print(" Srv_DbTools.SelDCL_DateDeb ${Srv_DbTools.SelDCL_DateDeb}");

    double wWidth = 650;
    double wHeight = 1024;
    double wHeightDet = 585;
    double wHeightDet2 = 610;

    double wHeightBtn = 45;

    double wHeightBtnValider = 40;

    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      height: MediaQuery.of(context).size.height - 100,
      decoration: BoxDecoration(
        color: gColors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          // Titre

          Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              color: Colors.transparent,
              child: Column(
                children: [
                  Container(
                      child: Container(
                    width: wWidth,
                    height: 90,
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    padding: const EdgeInsets.fromLTRB(0, 35, 0, 0),
                    decoration: BoxDecoration(
                      color: gColors.primaryGreen,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: wWidth,
                          child: Text(
                            widget.wTitre,
                            style: gColors.bodyTitle1_B_Wr,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 40),
                          child: Text(
                            "Monsieur ${Srv_DbTools.gUserLogin.User_Nom} ${Srv_DbTools.gUserLogin.User_Prenom} - ${Srv_DbTools.gUserLogin.User_Fonction}",
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            style: gColors.bodyTitle1_B_Gr,
                          )),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text(
                            "${Srv_DbTools.gUserLogin.User_Tel} / ${Srv_DbTools.gUserLogin.User_Mail}",
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            style: gColors.bodyTitle1_N_Gr,
                          )),
                    ],
                  ),
                ],
              )),

          Positioned(
            top: 370,
            child: Container(
              width: 560,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width: 400,
                      height: 200,
                      child: DottedBorder(
                        dashPattern: [6, 4],
                        strokeWidth: 2,
                        strokeCap: StrokeCap.round,
                        borderType: BorderType.RRect,
                        color: gColors.primaryGreen,
                        radius: Radius.circular(2),
                        child: Center(
                          child: AspectRatio(
                            aspectRatio: 2.0,
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  constraints: const BoxConstraints.expand(),
                                  color: Colors.white,
                                  child: HandSignature(
                                    control: controlTech,
                                    type: SignatureDrawType.shape,
                                  ),
                                ),
                                CustomPaint(
                                  painter: DebugSignaturePainterCP(
                                    control: controlTech,
                                    cp: false,
                                    cpStart: false,
                                    cpEnd: false,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),

          Positioned(
              top: 370,
              child: Container(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                width: 475,
                child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
                  SvgPicture.asset(
                    "assets/images/DCL_Adr.svg",
                    height: 25,
                    width: 25,
                    color: gColors.primaryGreen,
                  ),
                ]),
              )),

          Positioned(
              top: 600,
              child: Container(
                width: 560,
                child:
                Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                  widget.ViewTech,
                ]),
              )),

// PIED
          Positioned(
            top: MediaQuery.of(context).size.height - 190,
            child: Container(
              width: 560,
              height: 90,
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              decoration: BoxDecoration(
                color: gColors.LinearGradient3,
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: gColors.black,
                    height: 1,
                  ),
                  Container(
                    height: 22,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: gColors.primaryRed,
                        ),
                        child: Container(
                          width: 100,
                          height: wHeightBtnValider,
                          padding: const EdgeInsets.fromLTRB(0, 7, 0, 0),
                          child: Text(
                            "Annuler",
                            style: gColors.bodyTitle1_B_W24,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        onPressed: () async {
                          // DCL_Param_Dialog.wSel = "";
                          Navigator.pop(context);
                        },
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: gColors.primaryOrange,
                        ),
                        child: Container(
                          width: 100,
                          height: wHeightBtnValider,
                          padding: const EdgeInsets.fromLTRB(0, 7, 0, 0),
                          child: Text(
                            "Effacer",
                            style: gColors.bodyTitle1_B_W24,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        onPressed: () async {
                          controlTech.clear();
                        },
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: gColors.primaryGreen,
                            side: const BorderSide(
                              width: 1.0,
                              color: gColors.primaryGreen,
                            )),
                        child: Container(
                          width: 100,
                          height: wHeightBtnValider,
                          padding: const EdgeInsets.fromLTRB(0, 7, 0, 0),
                          child: Text(
                            "Valider",
                            style: gColors.bodyTitle1_B_W24,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        onPressed: () async {
                          rawImageFitTech.value = await controlTech.toImage(
                            color: Colors.black,
                            background: Colors.white,
                            fit: true,
                          );

                          if (rawImageFitTech.value != null) {
                            Srv_DbTools.gDCL_Ent.DCL_Signature_Tech = rawImageFitTech.value!.buffer.asUint8List();
                          }
                          var now = DateTime.now();
                          var formatter = DateFormat('dd/MM/yyyy');
                          String formattedDate = formatter.format(now);
                          Srv_DbTools.gDCL_Ent.DCL_Signataire_Date = formattedDate;
                          Srv_DbTools.setDCL_Ent(Srv_DbTools.gDCL_Ent);

                          Navigator.pop(context);
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
